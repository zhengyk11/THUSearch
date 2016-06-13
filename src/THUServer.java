import net.paoding.analysis.analyzer.PaodingAnalyzer;
import org.apache.lucene.analysis.TokenStream;
import org.apache.lucene.document.Document;
import org.apache.lucene.queryParser.MultiFieldQueryParser;
import org.apache.lucene.queryParser.ParseException;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.ScoreDoc;
import org.apache.lucene.search.TopDocs;
import org.apache.lucene.search.highlight.Formatter;
import org.apache.lucene.search.highlight.*;
import org.apache.lucene.util.Version;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.StringReader;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


public class THUServer extends HttpServlet{

    public static final int PAGE_RESULT = 10;
    public static final String indexDir = "forIndex";
    private String[] field = new String[]{"title","h1","anchor","content","strong","url"};
    //public static final String http = "http://";
    private THUSearcher search = null;

    public THUServer(){
        super();
        search = new THUSearcher(indexDir + "/index");
        //search.loadGlobals(indexDir + "/global.txt");
    }

    public ScoreDoc[] showList(ScoreDoc[] results, List<Map.Entry<Integer, Double>> infoIDs, int page){
        if(results == null || results.length < (page - 1) * PAGE_RESULT){
            return null;
        }
        int start = Math.max((page-1) * PAGE_RESULT, 0);
        int docNum = Math.min(results.length - start, PAGE_RESULT);
        ScoreDoc[] ret = new ScoreDoc[docNum];
        for(int i = 0;i < docNum;i++){
            ret[i] = results[infoIDs.get(start + i).getKey()];
        }
        return ret;
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        long t1 = System.currentTimeMillis(); // 排序前取得当前时间
        response.setContentType("text/html;charset=utf-8");
        request.setCharacterEncoding("utf-8");
        String queryString = request.getParameter("query");
        String pageString = request.getParameter("page");

        int page = 1;

        if(pageString != null){
            page=Integer.parseInt(pageString);
        }
        if(queryString == null || queryString.length() < 1){
            System.out.println("null query");
            return;
            //request.getRequestDispatcher("/Image.jsp").forward(request, response);
        }

        //if(queryString.charAt(queryString.length()-1) != '~'){
        //    queryString += "~";
        //}

        System.out.println("doGet:" + queryString);
        //System.out.println(URLDecoder.decode(queryString,"utf-8"));
        //System.out.println(URLDecoder.decode(queryString,"gb2312"));
        String[] highlightTitles=null;
        String[] highlightURLs=null;
        String[] highlightContents = null;

        /*String[] searchWords = {"Java AND Lucene", "Java NOT Lucene", "JavaOR Lucene",

                "+Java +Lucene", "+Java -Lucene"};*/


        //Query query;

        /*for(int i = 0; i < searchWords.length; i++){

            query = QueryParser.parse(searchWords[i], "title", language);

            Hits results = search.searchQuery(query);

            System.out.println(results.length() + "search results for query " +searchWords[i]);
        }*/
        Map<String , Float> boosts = new HashMap<>();
        MultiFieldQueryParser parser = null;
        String pattern = "([a-zA-Z0-9\\.\\-]+(\\:[a-zA-Z0-9\\.&amp;%\\$\\-]+)*@)?((25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])|([a-zA-Z0-9\\-]+\\.)*[a-zA-Z0-9\\-]+\\.[a-zA-Z]{2,4})(\\:[0-9]+)?(/[^/][a-zA-Z0-9\\.\\,\\?\\'\\/\\+&amp;%\\$#\\=~_\\-@]*)*$";
        Pattern r = Pattern.compile(pattern);
        Matcher m = r.matcher(queryString);
        int flag = 1;
        if(m.find()){
            flag = 1;
            boosts.clear();
            boosts.put("url", 1.0f);
            System.out.println("m.find");
            parser = new MultiFieldQueryParser(
                    Version.LUCENE_35,
                    new String[]{"url"},
                /*new StandardAnalyzer(Version.LUCENE_35),
                boosts );*/
                    new PaodingAnalyzer(),
                    boosts );
        }
        else {
            flag = 0;
            boosts.clear();
            boosts.put("title", 5.0f);
            boosts.put("content", 0.1f);
            boosts.put("strong", 0.3f);
            boosts.put("h1", 0.5f);
            boosts.put("anchor", 0.3f);
            boosts.put("url", 10.0f);
            parser = new MultiFieldQueryParser(
                    Version.LUCENE_35,
                    field,
                /*new StandardAnalyzer(Version.LUCENE_35),
                boosts );*/
                    new PaodingAnalyzer(),
                    boosts );
            //queryString += "~";
        }

        /**用MultiFieldQueryParser类实现对同一关键词的跨域搜索
         * */
        //MultiFieldQueryParser

        Query query = null;
        try {

            query = parser.parse(queryString);
            queryString = queryString.replaceAll("~","");
        } catch (ParseException e) {
            e.printStackTrace();
        }


        //创建高亮器对象：需要一些辅助类对象作为参数
        Formatter formatter = new SimpleHTMLFormatter("<span style='color:red;'>", "</span>");
        //被高亮文本前后加的标签前后缀
        Scorer scorer = null;//创建一个Scorer对象，传入一个Lucene的条件对象Query
        try {
            scorer = new QueryScorer(parser.parse(queryString.replaceAll("~|-|NOT|AND|OR|\\*|\\.|\\?|\\+|\\$|\\^|\\[|\\]|\\(|\\)|\\{|\\}|\\||\\/","")));
        } catch (ParseException e) {
            e.printStackTrace();
        }
        //正式创建高亮器对象
        Highlighter highlighter = new Highlighter(formatter, scorer);
        //设置被高亮的文本返回的摘要的文本大小
        Fragmenter fragmenter = new SimpleFragmenter(80);//默认是50个字符
        //让大小生效
        highlighter.setTextFragmenter(fragmenter);

        TopDocs results = search.searchQuery(query, 1000);//Math.abs(new Random().nextInt())%300 + 500);

        int totalNum = 0;

        if (results != null) {
            totalNum = results.scoreDocs.length;
            Map<Integer, Double> prMap = new HashMap<>();
            for(int i = 0;i < totalNum;i++){
                double s = results.scoreDocs[i].score + results.scoreDocs[i].score * 10000 * Double.parseDouble(search.getDoc(results.scoreDocs[i].doc).get("pr"));
                String url_tmp = ((String)(search.getDoc(results.scoreDocs[i].doc).get("url")));
                String title_tmp = ((String)(search.getDoc(results.scoreDocs[i].doc).get("title")));
                if(url_tmp.contains("index.html") && flag == 0){
                    s *= 2;
                }
                s *= 100/(url_tmp.length()+10)*(title_tmp.length()+10);
                results.scoreDocs[i].score = (float) s;
                prMap.put(i, s);
            }

            List<Map.Entry<Integer, Double>> infoIds = new ArrayList<>(prMap.entrySet());

            //排序
            Collections.sort(infoIds, (Comparator<Map.Entry<Integer, Double>>) (o1, o2) -> {
                //return (o2.getValue() - o1.getValue());
                return -(o1.getValue()).compareTo(o2.getValue());
            });

            //infoIds.get(i)

            ScoreDoc[] hits = showList(results.scoreDocs, infoIds, page);

            if (hits != null) {
                highlightTitles = new String[hits.length];
                highlightURLs = new String[hits.length];
                highlightContents = new String[hits.length];
                for (int i = 0; i < hits.length && i < PAGE_RESULT; i++) {
                    Document doc = search.getDoc(hits[i].doc);
                    System.out.println("doc=" + hits[i].doc + " score="
                            + hits[i].score + " url= "
                            + doc.get("url")+ " title= "+doc.get("title"));
                    //titles[i] = doc.get("title");
                    highlightURLs[i] = doc.get("url");
                    String hcontent = doc.get("content");
                    String htitle = doc.get("title");
                    /*if (hurl != null) {
                        TokenStream tokenStream = search.analyzer.tokenStream("url", new StringReader(hurl));
                        try {
                            highlightURLs[i] = highlighter.getBestFragment(tokenStream, hurl);
                        } catch (InvalidTokenOffsetsException e) {
                            e.printStackTrace();
                        }
                    }*/
                    if (hcontent != null) {
                        TokenStream tokenStream = search.analyzer.tokenStream("content", new StringReader(hcontent));
                        try {
                            highlightContents[i] = highlighter.getBestFragment(tokenStream, hcontent);
                            if(highlightContents[i] == null || highlightContents[i].length() < 10){
                                if(hcontent.length() > 80) {
                                    highlightContents[i] = hcontent.substring(0,80);
                                }else if(hcontent.length() < 2){
                                    highlightContents[i] = null;
                                }
                            }
                        } catch (InvalidTokenOffsetsException e) {
                            e.printStackTrace();
                        }
                    }
                    if (htitle != null) {
                        TokenStream tokenStream = search.analyzer.tokenStream("title", new StringReader(htitle));
                        try {
                            highlightTitles[i] = highlighter.getBestFragment(tokenStream, htitle);
                            if(highlightTitles[i] == null){
                                highlightTitles[i] = htitle;
                            }
                        } catch (InvalidTokenOffsetsException e) {
                            e.printStackTrace();
                        }
                    }
                }

            } else {
                System.out.println("page null");
            }
        }else{
            System.out.println("result null");
        }

        /*int seq=0;
        for(ScoreDoc doc : results.scoreDocs) {//获取查找的文档的属性数据
            seq++;
            int docID = doc.doc;
            Document document = search.searcher.doc(docID);
            //String str = "序号：" + seq + ",ID:" + document.get("id") + ",姓名：" + document.get("name") + "，性别：";

        }*/

        long t2 = System.currentTimeMillis(); // 排序前取得当前时间

        request.setAttribute("totalNum", totalNum);
        request.setAttribute("currentQuery",queryString);
        request.setAttribute("currentPage", page);
        request.setAttribute("imgTags", highlightTitles);
        request.setAttribute("imgPaths", highlightURLs);
        request.setAttribute("contents", highlightContents);
        request.setAttribute("times", t2-t1);
        //request.setAttribute("queryString", queryString);
        request.getRequestDispatcher("/imageshow.jsp").forward(request,
                response);

    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        this.doGet(request, response);
    }
}
