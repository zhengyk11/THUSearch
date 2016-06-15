<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
    request.setCharacterEncoding("utf-8");
    response.setCharacterEncoding("utf-8");
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>THU Search Engine</title>
    <link type="text/css" href="css/speech-input.css" rel="stylesheet"/>
    <link type="text/css" href="css/thu-search.css" rel="stylesheet"/>
    <script type="text/javascript" src="js/speech.js"></script>

</head>
<body>
<div class="search-layer1">
    <a href="<%=basePath%>THUSearch.jsp">
        <img src="<%=basePath%>image/thu.png" alt="logo" class="search-logo" />
    </a>

    <form id="form1" name="form1" method="get" action="servlet/THUServer">
        <div class="si-wrapper">

            <input id="index_input" type="text" class="si-input" placeholder=""
                   style="    width: 440px;
                              margin: 10px;
                              height: 40px;
                              font-family: arial;
                              font-size: 12pt;
                              color: #444;"
                   name="query" size="50" >

            <button class="search-button" type="submit" style="display: none" name="Submit">THU Search</button>
            <button onclick="startDictation(this,event)" style="margin: 10px ">
                <img style="height: 30px;width: auto;padding-top:5px;padding-bottom:5px;vertical-align: middle;" src="image/micro.png">
            </button>
        </div>
        <%--<input class="search-input" name="query" type="text" size="50" />--%>

        <button class="search-button" type="submit" name="Submit">THU Search</button>
    </form>

</div>

</body>
</html>
