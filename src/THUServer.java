import net.paoding.analysis.analyzer.PaodingAnalyzer;
import org.apache.lucene.analysis.TokenStream;
import org.apache.lucene.document.Document;
import org.apache.lucene.queryParser.MultiFieldQueryParser;
import org.apache.lucene.queryParser.ParseException;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.ScoreDoc;
import org.apache.lucene.search.TopDocs;
import org.apache.lucene.search.highlight.*;
import org.apache.lucene.util.Version;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.StringReader;
import java.util.HashMap;
import java.util.Map;


public class THUServer extends HttpServlet{

    public static final int PAGE_RESULT = 10;
    public static final String indexDir = "forIndex";
    private String[] field = new String[]{"title","h1","anchor","content","strong"};
    //public static final String http = "http://";
    private THUSearcher search = null;

    public THUServer(){
        super();
        search = new THUSearcher(indexDir + "/index");
        //search.loadGlobals(indexDir + "/global.txt");
    }

    public ScoreDoc[] showList(ScoreDoc[] results,int page){
        if(results == null || results.length < (page - 1) * PAGE_RESULT){
            return null;
        }
        int start = Math.max((page-1) * PAGE_RESULT, 0);
        int docNum = Math.min(results.length - start, PAGE_RESULT);
        ScoreDoc[] ret = new ScoreDoc[docNum];
        for(int i = 0;i < docNum;i++){
            ret[i] = results[start + i];
        }
        return ret;
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

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

        System.out.println("doGet:" + queryString);
        //System.out.println(URLDecoder.decode(queryString,"utf-8"));
        //System.out.println(URLDecoder.decode(queryString,"gb2312"));
        String[] titles=null;
        String[] urlPaths=null;
        String[] highlightContent = null;

        Map<String , Float> boosts = new HashMap<>();
        boosts.put("title", 5.0f);
        boosts.put("content", 0.1f);
        boosts.put("strong", 0.3f);
        boosts.put("h1", 0.5f);
        boosts.put("anchor", 0.3f);

        /**用MultiFieldQueryParser类实现对同一关键词的跨域搜索
         * */

        MultiFieldQueryParser parser = new MultiFieldQueryParser(
                Version.LUCENE_35,
                field,
                /*new StandardAnalyzer(Version.LUCENE_35),
                boosts );*/
                new PaodingAnalyzer(),
                boosts );

        Query query = null;
        try {
            query = parser.parse(queryString);
        } catch (ParseException e) {
            e.printStackTrace();
        }

        //创建高亮器对象：需要一些辅助类对象作为参数
        Formatter formatter = new SimpleHTMLFormatter("<mark>", "</mark>");
        //被高亮文本前后加的标签前后缀
        Scorer scorer = new QueryScorer(query);//创建一个Scorer对象，传入一个Lucene的条件对象Query
        //正式创建高亮器对象
        Highlighter highlighter = new Highlighter(formatter, scorer);
        //设置被高亮的文本返回的摘要的文本大小
        Fragmenter fragmenter = new SimpleFragmenter(80);//默认是50个字符
        //让大小生效
        highlighter.setTextFragmenter(fragmenter);

        TopDocs results = search.searchQuery(query, 100);

        int totalNum = 0;

        if (results != null) {
            ScoreDoc[] hits = showList(results.scoreDocs, page);
            totalNum = results.scoreDocs.length;
            if (hits != null) {
                titles = new String[hits.length];
                urlPaths = new String[hits.length];
                highlightContent = new String[hits.length];
                for (int i = 0; i < hits.length && i < PAGE_RESULT; i++) {
                    Document doc = search.getDoc(hits[i].doc);
                    System.out.println("doc=" + hits[i].doc + " score="
                            + hits[i].score + " url= "
                            + doc.get("url")+ " title= "+doc.get("title"));
                    titles[i] = doc.get("title");
                    urlPaths[i] = doc.get("url");
                    String hcontent = doc.get("content");
                    if (hcontent != null) {
                        TokenStream tokenStream = search.analyzer.tokenStream("content", new StringReader(hcontent));
                        try {
                            highlightContent[i] = highlighter.getBestFragment(tokenStream, hcontent);
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

        request.setAttribute("totalNum", totalNum);
        request.setAttribute("currentQuery",queryString);
        request.setAttribute("currentPage", page);
        request.setAttribute("imgTags", titles);
        request.setAttribute("imgPaths", urlPaths);
        request.setAttribute("contents", highlightContent);
        request.getRequestDispatcher("/imageshow.jsp").forward(request,
                response);

    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        this.doGet(request, response);
    }
}
