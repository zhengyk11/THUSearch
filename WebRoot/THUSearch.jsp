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

</head>
<body>
<div class="search-layer1">
    <a href="<%=basePath%>THUSearch.jsp">
        <img src="<%=basePath%>image/thu.png" alt="logo" class="search-logo" />
    </a>

    <form id="form1" name="form1" method="get" action="servlet/THUServer">
        <div class="si-wrapper">

            <script>
                function inputDealer() {
                    if (event.keyCode == 13) {
                        form1.submit();
                    }
                }
            </script>

            <input id="index_input" type="text" onkeypress="inputDealer()" class="si-input" placeholder=""
                   style="    width: 450px;
                              margin: 10px;
                              height: 40px;
                              font-family: arial;
                              font-size: 12pt;
                              color: #444;"
                   name="query" size="50" >

            <button class="si-btn" style="margin: 10px;">
                speech input
                <span class="si-mic"></span>
                <span class="si-holder"></span>
            </button>
        </div>

        <%--<input class="search-input" name="query" type="text" size="50" />--%>

        <button class="search-button" type="submit" name="Submit">THU Search</button>
    </form>

</div>
<script type="text/javascript" src="js/speech-input.js"></script>
</body>
</html>
