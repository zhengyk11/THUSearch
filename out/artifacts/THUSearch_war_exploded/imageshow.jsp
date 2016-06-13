<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
request.setCharacterEncoding("utf-8");
response.setCharacterEncoding("utf-8");
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
//String imagePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+"/";
//System.out.println("basePath:"+basePath);
//System.out.println("imagePath:"+imagePath);
String queryString = (String) request.getAttribute("currentQuery");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=queryString.length()>8?queryString.substring(0,8)+"...":queryString%>_THU Search</title>
<style type="text/css">
<!--
#Layer1 {
	position:absolute;
	left:28px;
	top:26px;
	width:649px;
	height:32px;
	z-index:1;
}
#Layer2 {
	position:absolute;
	left:29px;
	top:82px;
	width:648px;
	height:602px;
	z-index:2;
}
#Layer3 {
	position:absolute;
	left:28px;
	top:697px;
	width:652px;
	height:67px;
	z-index:3;
}
-->
</style>
</head>

<body>
<%
	String currentQuery=(String) request.getAttribute("currentQuery");
	int currentPage=(Integer) request.getAttribute("currentPage");
%>

<%--<div style="width: 120px;padding-left: 125px;">

    &lt;%&ndash;<img src="image/thu.PNG" style="padding-left: 5px;padding-top: 5px;height: 32px;width: 110px" alt="logo"/>&ndash;%&gt;
</div>--%>

<div style="width: 1000px;padding-left: 0px;">
  <form id="form1" name="form1" method="get" action="THUServer">
      <label>
      <img src="<%=basePath%>image/thu1.png" alt="thu" style="width:145px;height:50px;vertical-align:middle;padding-right: 5px" />
      </label>
      <label>
      <input style="width: 440px;margin: 10px;margin-left: 0px;height: 35px;font-family: arial;font-size: 10pt;color: #444;" name="query" value="<%=currentQuery%>" type="text" size="70" />
    </label>
    <label>
    <button style="-webkit-appearance: none;font-family: arial;
    color: #444;
    background-color: #f5f5f5;
    border: 1px #e4e4e4;
    font-weight: bold;
    margin: 5px 0px;
    font-size: 9pt;
    padding: 12px;" type="submit" name="Submit">THU Search</button>
    </label>
  </form>
</div>
<%
    String[] titles=(String[]) request.getAttribute("imgTags");
    String[] urlPaths=(String[]) request.getAttribute("imgPaths");
    String[] contents = (String[]) request.getAttribute("contents");
    int totalNum = (int) request.getAttribute("totalNum");
    long times = (long) request.getAttribute("times");
    System.out.println("totalNum="+totalNum);
%>

<div id="Layer2" style="top: 80px; height: 585px;">
  <div style="width: 540px;padding-left: 135px;padding-top: 5px;" id="imagediv">
	  <a style="font-size: 13px;color: #999;">THU Search Engine为您找到相关结果约<%=totalNum%>个结果,耗时<%=times%>毫秒</a>
  <br>
  <Table style="left: 0px; width: 594px;padding-top: 5px;">
  <%
  	if(titles!=null && titles.length>0){
  		for(int i=0;i<titles.length;i++){%>
      <p>
  		<tr><h3><a style="color: -webkit-link;text-decoration: underline;cursor: auto;" href="http://<%=urlPaths[i]%>" target="_blank"><%=(currentPage-1)*10+i+1%>. <%=titles[i].length()>100 ? titles[i].substring(0,100):titles[i] %></a></h3></tr>
		<tr><p style="margin: 0;padding: 0;list-style: none;font-size: 13px;color: #666;padding-bottom: 5px"><%=contents[i] == null ? "":contents[i]+"..."%></p></tr>
        <tr><a href="http://<%=urlPaths[i]%>" target="_blank" style="text-decoration: none; color: #008000;font-size: 13px;"><%=urlPaths[i].length()>70?urlPaths[i].substring(0,60)+"...":urlPaths[i]%></a></tr>
      </p>
  		<%}; %>
  	<%}else{ %>
  		<p><tr><h3>no such result</h3></tr></p>
  	<%}; %>
  </Table>
  </div>
  <div style="padding-left: 140px;padding-bottom: 35px;">
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


<!--<div id="Layer3" style="top: 839px; left: 27px;">
	
</div>-->



</body>
