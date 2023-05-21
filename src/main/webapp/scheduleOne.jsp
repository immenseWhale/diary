<%@ page language="java" contentType="text/html; charset=UTF-8"    pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<%
	request.setCharacterEncoding("utf-8");	
	
	//만약 scheduleNo 값이 null이면 scheduleList로 보내겠다. 
	if(request.getParameter("scheduleNo") == null){
		response.sendRedirect("./scheduleList.jsp");
		return;	
	}
	//scheduleNo 에 받아온 값을 인트로 변환해 넣어준다.
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	System.out.println( "scheduleOne scheduleNo -->" + scheduleNo);
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");	
	
	//개별 상세페이지니까 모든걸 다 가져온다.
	String sql = "select schedule_no scheduleNo, schedule_date scheduleDate, schedule_time scheduleTime, schedule_memo scheduleMemo, schedule_color scheduleColor, createdate, updatedate from schedule where schedule_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);	
	stmt.setInt(1, scheduleNo);
	System.out.println("scheduleOne param scheduleNo ->"+ stmt );
	
	ResultSet rs = stmt.executeQuery();
	
	//만일 값을 하나만 가져오는 경우에는 굳이 배열로 가져올 필요 없이 하나만 가져와도 동일한 결과다. 
	Schedule schedule = new Schedule();
	if (rs.next()){
		schedule = new Schedule();		//여기 말고 밖에서 이 문장을 선언해주면 에러 수정이 어려워진다. if안에 들어왔는지 안 들어왔는지 확인을 위해 여기에 선언한다.
		schedule.scheduleNo = rs.getInt("scheduleNo");
		schedule.scheduleMemo = rs.getString("scheduleMemo");
		schedule.scheduleDate = rs.getString("scheduleDate");
		schedule.scheduleTime = rs.getString("scheduleTime");
		schedule.scheduleColor = rs.getString("scheduleColor");
		schedule.createdate = rs.getString("createdate");
		schedule.updatedate = rs.getString("updatedate");	
	}
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>scheduleOne</title>
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
		<h1>일정 상세</h1>
	</div>
	
	<div class="container-fluid, p2" >
		<table class="table table-bordered">
			<tr>
				<td>no</td>
				<td><%=schedule.scheduleNo%></td>
			</tr>
			<tr>
				<td>scheduleDate</td>
				<td><%=schedule.scheduleDate %></td>
			</tr>
			<tr>
				<td>scheduleTime</td>
				<td><%=schedule.scheduleTime %></td>
			</tr>
			<tr>
				<td>scheduleColor</td>
				<td><%=schedule.scheduleColor %></td>
			</tr>
			<tr>
				<td>scheduleMemo</td>
				<td><%=schedule.scheduleMemo %></td>
			</tr>
			<tr>
				<td>creatdate</td>
				<td><%=schedule.createdate %></td>
			</tr>
			<tr>
				<td>updatedate</td>
				<td><%=schedule.updatedate %></td>
			</tr>					
		</table>
	</div>
	<div>
		<a href="./updateScheduleForm.jsp?scheduleNo=<%=schedule.scheduleNo%>">
			&nbsp;수정&nbsp;
		</a>

		<a href="./deledteScheduleForm.jsp?scheduleNo=<%=schedule.scheduleNo%>">
			&nbsp;삭제&nbsp;
		</a>
	</div>
</div>
</body>
</html>