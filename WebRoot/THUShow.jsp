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
</head>

<body>
<div class="show-layer1">

    <form id="form1" name="form1" method="get" action="THUServer" >
        <a href="<%=basePath%>THUSearch.jsp" style="color: white">
            <img class="show-logo" src="<%=basePath%>image/thu1.png"/>
        </a>
        <label>
            <input class="show-input" name="query" value="<%=currentQuery%>" type="text" size="70" />
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
            %>
            <p style="padding-bottom: 1px">
                <tr>
                    <a class="show-title" href="http://<%=urlPaths[i]%>" target="_blank">
                        <%=(currentPage-1)*10+i+1%>. <%=titles[i].length()>100 ? titles[i].substring(0,100):titles[i] %>
                    </a>
                </tr>
                <p><tr>
                    <a class="show-content"><%=contents[i] == null ? "":contents[i]+"..."%></a>
                </tr></p>
                <tr>
                    <a class="show-url" href="http://<%=urlPaths[i]%>" target="_blank"><%=urlPaths[i].length()>70?urlPaths[i].substring(0,60)+"...":urlPaths[i]%></a>
                </tr>
            </p>
            <%}}else{%>
            <p><tr><h3>no such result</h3></tr></p>
            <%}; %>
        </Table>
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
    #Layer2 {
        position:absolute;
        left:29px;
        top:80px;
        width:648px;
        height:585px;
        z-index:2;
    }

    .show-layer1 {
        width: 1000px;
        padding-left: 0px;
    }

    .show-logo {
        width: 145px;
        height: 50px;
        vertical-align: middle;
        padding-right: 5px;
    }

    .show-input {
        width: 440px;
        margin: 10px;
        margin-left: 0px;
        height: 36px;
        font-family: arial;
        font-size: 10pt;
        color: #444;
    }

    .show-button {
        -webkit-appearance: none;
        font-family: arial;
        color: #444;
        background-color: #f5f5f5;
        border: 1px #e4e4e4;
        font-weight: bold;
        margin: 5px 0px;
        font-size: 9pt;
        padding: 13px;
    }

    .show-result {
        width: 540px;
        padding-left: 135px;
        padding-top: 5px;
    }

    .num-and-time {
        font-size: 13px;
        color: #999;
    }

    .show-spell {
        font-size: 18px;
        color: #222;
    }

    .show-line {
        margin: 0 -8px 16px -8px;background-color: rgba(0,0,0,0.07);border-width: 0;color: rgba(0,0,0,0.07);
        height: 1px;margin-top: 22px;display: block; -webkit-margin-before: 0.5em;-webkit-margin-after: 0.5em;-webkit-margin-start: auto;
        -webkit-margin-end: auto;border-style: inset;
    }

    .show-title {
        color: -webkit-link;
        text-decoration: underline;
        cursor: auto;
    }

    .show-content {
        margin: 0;padding: 0;list-style: none;font-size: 13px;color: #666;padding-bottom: 1px;
    }

    .show-url {
        text-decoration: none; color: #008000;font-size: 13px;
    }

    .show-table {
        left: 0px; width: 594px;padding-top: 5px;
    }

    .show-page {
        padding-left: 140px;padding-bottom: 35px;
    }
</style>
