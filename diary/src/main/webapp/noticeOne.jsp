<%@ page language="java" contentType="text/html; charset=UTF-8"    pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import = "vo.*" %>
<%
	request.setCharacterEncoding("utf-8");	

	//만약 받아오는 값이 null이면 조건문
	if(request.getParameter("noticeNo") == null){
		//널값이면 리스트로 다시 돌아가라
		response.sendRedirect("./noticeList.jsp");	
		return;		//지금 진행하는 코드를 강제로 종료하는 명령어 이 상황에서는 else를 안 쓸 수 있어서 깔끔하다.
	}

	//form으로부터 값이 넘어오기에 여기서 페이지 실행하면 안된다. null인데 바꾸려고 하니까 에러난다.
	//재요청을 jsp에서는 리다이렉션
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	

	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");	
	
	//쿼리를 직접 치기 번거로우니 String으로 만들어준다.
	String sql = "select notice_no as noticeNo, notice_title as noticeTitle, notice_content as noticeContent, notice_writer as noticeWriter, createdate, updatedate from notice where notice_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	//?가 있으면 미완성된 문장이기 때문에 동작이 안된다. 완성하기 위해서는 숫자를 문자로 변경해서 완성해야 한다.
	stmt.setInt(1, noticeNo);
	//System.out.println(stmt + " <--stmt");

	ResultSet re = stmt.executeQuery();
	
	//만일 값을 하나만 가져오는 경우에는 굳이 배열로 가져올 필요 없이 하나만 가져와도 동일한 결과다. 
	Notice notice = new Notice();
	if (re.next()){
		notice = new Notice();		//여기 말고 밖에서 이 문장을 선언해주면 에러 수정이 어려워진다. if안에 들어왔는지 안 들어왔는지 확인을 위해 여기에 선언한다.
		notice.noticeNo = re.getInt("noticeNo");
		notice.noticeTitle = re.getString("noticeTitle");
		notice.noticeContent = re.getString("noticeContent");
		notice.noticeWriter = re.getString("noticeWriter");
		notice.createdate = re.getString("createdate");
		notice.updatedate = re.getString("updatedate");	
	}
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지 상세</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
	a{
		/* 링크의 라인 없애기  */
		text-decoration: none;
	}
	a:link { 	/* 방문한 적 없는 글자색  */
		color:#4C4C4C; 
	}
	a:visited { /* 방문한 글자색  */
		color:#747474;
	}
	.p2 {/* 본문 폰트 좌정렬*/
		font-family: "Lucida Console", "Courier New", monospace;
		text-align: left;
	}
	.p3 {/* 본문 폰트*/
		font-family: "Lucida Console", "Courier New", monospace;
		text-align: center;
	}
	h1{	/*제목 폰트*/
		font-family: 'Black Han Sans', sans-serif;
		text-align: center;
	}
	h2 {/* h2 왼쪽정렬 */
		text-align: left;
	}
</style>
</head>
<body>
<div class="container">	
	<div align="left">
		<a href="./form.jsp">	&nbsp;
			<!-- 집모양 아이콘 -->
			<svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-house" viewBox="0 0 16 16">
 				<path d="M8.707 1.5a1 1 0 0 0-1.414 0L.646 8.146a.5.5 0 0 0 .708.708L2 8.207V13.5A1.5 1.5 0 0 0 3.5 15h9a1.5 1.5 0 0 0 1.5-1.5V8.207l.646.647a.5.5 0 0 0 .708-.708L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293L8.707 1.5ZM13 7.207V13.5a.5.5 0 0 1-.5.5h-9a.5.5 0 0 1-.5-.5V7.207l5-5 5 5Z"/>
			</svg>
		</a>
		&nbsp;&nbsp;
		<a href="./noticeList.jsp" >&nbsp;공지 리스트&nbsp;</a> 
		<a href="./scheduleList.jsp">&nbsp;일정 리스트&nbsp;</a>
	</div>
	<div align="center">
		<h1>공지 상세</h1>
	</div>
	
	<div class="container-fluid, p2" >

	<%	//이 페이지의 경우 배열로 여러개를 가져오는게 아니라 단 하나의 값만 가져오기 때문에 굳이 for문을 사용하지 않고 단일값 선언으로 해도 된다.
		//for( Notice n : noticeList){
	%>		
			<table class="table table-bordered">
				<tr>
					<td>notice_no</td>
					<td><%=notice.noticeNo%></td>
				</tr>
				<tr>
					<td>notice_title</td>
					<td><%=notice.noticeTitle %></td>
				</tr>
				<tr>
					<td>notice_content</td>
					<td><%=notice.noticeContent %></td>
				</tr>
				<tr>
					<td>notice_writer</td>
					<td><%=notice.noticeWriter %></td>
				</tr>
				<tr>
					<td>creatdate</td>
					<td><%=notice.createdate %></td>
				</tr>
				<tr>
					<td>updatedate</td>
					<td><%=notice.updatedate %></td>
				</tr>	
					
			</table>				
		<%
			//}
		%>
	</div>	
	<div>
		&nbsp;<a href="./updateNoticeForm.jsp?noticeNo=<%=notice.noticeNo%>">&nbsp;수정&nbsp;</a>
		&nbsp;<a href="./deleteNoticeForm.jsp?noticeNo=<%=notice.noticeNo%>">&nbsp;삭제&nbsp;</a>
	</div>
</div>
</body>
</html>