import net.paoding.analysis.analyzer.PaodingAnalyzer;
import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.IndexWriterConfig;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import java.io.File;
import java.io.IOException;

import static org.apache.lucene.util.Version.LUCENE_35;

public class THUIndexer {
    private Analyzer analyzer = null;
    private IndexWriter indexWriter = null;
    //private float averageLength = 1.0f;

    public THUIndexer(String indexDir){
        try{
            analyzer = new PaodingAnalyzer();
            IndexWriterConfig iwc = new IndexWriterConfig(LUCENE_35, analyzer);
            Directory dir = FSDirectory.open(new File(indexDir));
            indexWriter = new IndexWriter(dir,iwc);
            //indexWriter.setSimilarity(new SimpleSimilarity());
        }catch(IOException e){
            e.printStackTrace();
        }
    }

    /*public void saveGlobals(String filename){
        try{
            PrintWriter pw = new PrintWriter(new File(filename));
            pw.println(averageLength);
            pw.close();
        }catch(IOException e){
            e.printStackTrace();
        }
    }*/


    public void indexSpecialFile(String filename){
        try{
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            DocumentBuilder db = dbf.newDocumentBuilder();
            org.w3c.dom.Document doc = db.parse(new File(filename));
            NodeList nodeList = doc.getElementsByTagName("doc");
            int num = nodeList.getLength();

            for(int i = 0;i < num;i++){

                Node node = nodeList.item(i);
                NamedNodeMap map = node.getAttributes();

                Node title = map.getNamedItem("title");
                Node url = map.getNamedItem("url");
                Node h1 = map.getNamedItem("h1");
                Node pr = map.getNamedItem("pr");
                Node content = map.getNamedItem("docContent");
                Node anchor = map.getNamedItem("anchor");
                Node strong = map.getNamedItem("strong");


                Field titleField = new Field( "title", title.getNodeValue(), Field.Store.YES, Field.Index.ANALYZED);
                Field urlField = new Field( "url", url.getNodeValue(),Field.Store.YES, Field.Index.NO);
                Field h1Field = new Field( "h1", h1.getNodeValue(),Field.Store.YES, Field.Index.ANALYZED);
                Field prField = new Field( "pr", pr.getNodeValue(),Field.Store.YES, Field.Index.NO);
                Field contentField = new Field( "content" ,content.getNodeValue(),Field.Store.YES, Field.Index.ANALYZED);
                Field anchorField = new Field( "anchor" , anchor.getNodeValue(),Field.Store.YES, Field.Index.ANALYZED);
                Field strongField  =   new  Field( "strong" , strong.getNodeValue() ,Field.Store.YES, Field.Index.ANALYZED);
                //averageLength += title.getNodeValue().length();

                Document document = new  Document();

                document.add(titleField);
                document.add(urlField);
                document.add(h1Field);
                document.add(prField);
                document.add(contentField);
                document.add(anchorField);
                document.add(strongField);

                indexWriter.addDocument(document);

                if(i%10000==0){
                    System.out.println("process "+i);
                }
            }
            //averageLength /= indexWriter.numDocs();
            //System.out.println("average length = "+averageLength);
            System.out.println("total "+indexWriter.numDocs()+" documents");
            indexWriter.close();
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    public static void main(String[] args) {
        THUIndexer indexer=new THUIndexer("forIndex/index");
        indexer.indexSpecialFile("input/new_data.xml");
        //indexer.saveGlobals("forIndex/global.txt");
    }
}
