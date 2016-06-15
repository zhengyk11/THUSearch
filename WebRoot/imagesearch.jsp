<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
    request.setCharacterEncoding("utf-8");
//System.out.println(request.getCharacterEncoding());
    response.setCharacterEncoding("utf-8");
//System.out.println(response.getCharacterEncoding());top: 210px; left: 353px; width: 441px;
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
//System.out.println(path);
//System.out.println(basePath);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>THU Search Engine</title>
    <link type="text/css" href="css/speech-input.css" rel="stylesheet"/>

    <style type="text/css">
        <!--
        #Layer1 {
            position:absolute;
            left:489px;
            top:326px;
            width:404px;
            height:29px;
            z-index:1;
        }
        #Layer2 {
            position:absolute;
            left:480px;
            top:68px;
            width:446px;
            height:152px;
            z-index:2;
        }
        -->
    </style>
</head>
<body>
<div style="position: relative;
    text-align: center;
    vertical-align: middle;
    margin-top: 200px;">
    <a href="http://localhost:8080/imagesearch.jsp"><img src="<%=basePath%>image/thu.png" alt="logo" style="width:350px;height:75px;horiz-align:center;padding-bottom: 10px" /></a>


    <form id="form1" name="form1" method="get" action="servlet/THUServer">
        <div class="si-wrapper">

            <script>
                function inputDealer() {
                    if (event.keyCode == 13) {
                        form1.submit();
                    }
                }
            </script>

            <input id="index_input" type="text" onkeypress="inputDealer()" class="si-input" placeholder="" style="width: 450px;margin: 10px;height: 40px;font-family: arial;font-size: 12pt;color: #444;" name="query" size="50" >
            <button class="si-btn" style="margin: 10px;">
                speech input
                <span class="si-mic"></span>
                <span class="si-holder"></span>
            </button>
        </div>

        <%--<input style="width: 450px;margin: 10px;height: 35px;font-family: arial;font-size: 10pt;color: #444;" name="query" type="text" size="50" />
--%>
        <%--<form id="form2" name="form1" method="get" action="servlet/THUServer">
        --%>
        <button style="-webkit-appearance: none;font-family: arial;color: #444; background-color: #f5f5f5; border: 1px #e4e4e4; font-weight: bold; margin: 15px 0px; font-size: 9pt; padding: 12px;" type="submit" name="Submit">THU Search</button>
    </form>
    <%--<button style="-webkit-appearance: none;font-family: arial;
    color: #444;
    background-color: #f5f5f5;
    border: 1px #e4e4e4;
    font-weight: bold;
    margin: 25px 5px;
    font-size: 9pt;
    padding: 12px;">I'm Feeling Lucky</button>--%>


</div>
<script type="text/javascript" src="speech-input.js"></script>
</body>
</html>
