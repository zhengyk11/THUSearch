<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
    request.setCharacterEncoding("utf-8");
    response.setCharacterEncoding("utf-8");
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
    String currentQuery=(String) request.getAttribute("currentQuery");
    int currentPage=(Integer) request.getAttribute("currentPage");
    String[] titles=(String[]) request.getAttribute("imgTags");
    String[] urlPaths=(String[]) request.getAttribute("imgPaths");
    String[] contents = (String[]) request.getAttribute("contents");
    int totalNum = (int) request.getAttribute("totalNum");
    long times = (long) request.getAttribute("times");
    String suggest = (String)request.getAttribute("suggest");
    System.out.println("totalNum="+totalNum);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=currentQuery.length()>8?currentQuery.substring(0,8)+"...":currentQuery%>_THU Search</title>
    <script type="text/javascript" src="<%=basePath%>js/speech.js"></script>
    <link type="text/css" href="<%=basePath%>css/thu-show.css" rel="stylesheet"/>
    <link type="text/css" href="<%=basePath%>css/speech-input.css" rel="stylesheet"/>
</head>

<body>
<div class="show-layer1">

    <form id="form1" name="form1" method="get" action="THUServer" >
        <a href="<%=basePath%>THUSearch.jsp" style="color: white">
            <img class="show-logo" src="<%=basePath%>image/thu1.png"/>
        </a>
        <label>
            <%--<input class="show-input" name="query" value="<%=currentQuery%>" type="text" size="70" />--%>
                <div class="si-wrapper">

                    <input id="index_input" value="<%=currentQuery%>" type="text" class="si-input" placeholder=""
                           style="width: 440px;
                              margin: 10px;margin-left: 0px;
                              height: 40px;
                              font-family: arial;
                              padding-left: 5px;
                              font-size: 12pt;
                              color: #444;"
                           name="query" size="50" >

                    <button class="search-button" type="submit" style="display: none" name="Submit">THU Search</button>
                    <button onclick="startDictation(this,event)" style="vertical-align: middle;margin: 10px ">
                        <img class="show-speech" src="<%=basePath%>image/micro.png">
                    </button>
                </div>
        </label>
        <label>
            <button class="show-button" type="submit" name="Submit">THU Search</button>
        </label>
    </form>
</div>

<div id="Layer2">
    <div class="show-result" id="result-div">
        <a class="num-and-time">THU Search Engine为您找到相关结果约<%=totalNum%>个结果,耗时<%=times%>毫秒</a>
        <%if(suggest != null){%>
        <p class="show-spell">您是不是在找：
            <a style="color: #dd4b39" href="<%=basePath%>servlet/THUServer?query=<%=suggest%>&Submit=">
                <%=suggest%>
            </a>
        </p>
        <%}%>
        <hr class="show-line">
        <%--<br>--%>
        <Table class="show-table">
            <%
                if(titles!=null && titles.length>0){
                    for(int i=0;i<titles.length;i++){
                        if(urlPaths[i].endsWith("index.html")){
                            urlPaths[i] = urlPaths[i].substring(0, urlPaths[i].length()-10);
                        }
            %>
            <p>
                <tr>
                    <a class="show-title" href="http://<%=urlPaths[i]%>" target="_blank">
                        <%=(currentPage-1)*10+i+1%>. <%=titles[i].length()>100 ? titles[i].substring(0,100):titles[i] %>
                    </a>
                </tr>
                <p><tr>
                    <a class="show-content"><%=contents[i] == null|contents[i].length()<1 ? "":contents[i]+"..."%></a>
                </tr></p>
                <tr>
                    <a class="show-url" href="http://<%=urlPaths[i]%>" target="_blank"><%=urlPaths[i].length()>70?urlPaths[i].substring(0,60)+"...":urlPaths[i]%></a>
                </tr>
            </p>
            <%}}else{%>
            <p><tr><h3>no such result</h3></tr></p>
            <%}; %>
        </Table>
        <hr class="show-line">
    </div>

    <div class="show-page">
        <p>
            <%if(currentPage>1){ %>
            <a href="THUServer?query=<%=currentQuery%>&page=<%=currentPage-1%>">上一页</a>
            <%}; %>
            <%for (int i=Math.max(1,currentPage-5);i<currentPage;i++){%>
            <a href="THUServer?query=<%=currentQuery%>&page=<%=i%>"><%=i%></a>
            <%}; %>
            <strong><%=currentPage%></strong>
            <%for (int i=currentPage+1;i<=Math.min(currentPage+5, (totalNum-1)/10+1);i++){ %>
            <a href="THUServer?query=<%=currentQuery%>&page=<%=i%>"><%=i%></a>
            <%}; %>
            <a href="THUServer?query=<%=currentQuery%>&page=<%=currentPage+1 <= ((totalNum-1)/10+1)?currentPage+1:((totalNum-1)/10+1)%>">下一页</a>
        </p>
    </div>
</div>
</body>


<style>

</style>
