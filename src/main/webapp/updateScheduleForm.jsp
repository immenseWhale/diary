<%@ page language="java" contentType="text/html; charset=UTF-8"    pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<
<%

	request.setCharacterEncoding("utf-8");	

	//만약 scheduleNo 값이 null이면 scheduleList로 보내겠다. (어차피 리스트바이데이트는 리스트로 보낸다.)
	if(request.getParameter("scheduleNo") == null){
		response.sendRedirect("./scheduleList.jsp");
		return;	//코드진행 종료
	}
	//scheduleNo 에 받아온 값을 인트로 변환해 넣어준다.
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	//System.out.println( "updatescheduleForm scheduleNo -->" + scheduleNo);
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");	
	
	//수정을 바라는 스케줄 항목의 내용을 다  가져온다.
	String sql = "select schedule_no scheduleNo, schedule_date scheduleDate, schedule_time scheduleTime, schedule_memo scheduleMemo, schedule_color scheduleColor, createdate, updatedate from schedule where schedule_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);	
	stmt.setInt(1, scheduleNo);
	//System.out.println("updatescheduleForm param scheduleNo ->"+ stmt );

	ResultSet rs = stmt.executeQuery();
	
	//배열로 값 넣어주기
	ArrayList<Schedule> scheduleList = new ArrayList<>();
	while(rs.next()){
		Schedule s = new Schedule();
		s.scheduleNo = rs.getInt("scheduleNo");
		s.scheduleTime = rs.getString("scheduleTime");	
		s.scheduleMemo = rs.getString("schedulememo");	
		s.scheduleDate = rs.getString("scheduleDate");
		s.scheduleColor = rs.getString("scheduleColor");
		s.createdate = rs.getString("createdate");
		s.updatedate = rs.getString("updatedate");
		scheduleList.add(s);
	}

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>updatescheduleForm</title>
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
			<svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-house" viewBox="0 0 16 16">
 				<path d="M8.707 1.5a1 1 0 0 0-1.414 0L.646 8.146a.5.5 0 0 0 .708.708L2 8.207V13.5A1.5 1.5 0 0 0 3.5 15h9a1.5 1.5 0 0 0 1.5-1.5V8.207l.646.647a.5.5 0 0 0 .708-.708L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293L8.707 1.5ZM13 7.207V13.5a.5.5 0 0 1-.5.5h-9a.5.5 0 0 1-.5-.5V7.207l5-5 5 5Z"/>
			</svg>
		</a>
		&nbsp;&nbsp;
		<a href="./noticeList.jsp" >&nbsp;공지 리스트&nbsp;</a> 
		<a href="./scheduleList.jsp">&nbsp;일정 리스트&nbsp;</a>
	</div>
	
	<div align="center">
		<h1>수정 폼</h1>
	</div>
	
	<div>
		<%	//mgs 값이 오면
			if (request.getParameter("msg") != null){
		%>
				<div style="color: red">
					<h4>&nbsp;&nbsp;<%=request.getParameter("msg") %>.
				</div>
		<%				
			}		
		%>
	</div>
	<div class="container, p2">		
		<form action="./updateScheduleAction.jsp" method="post">		
		<table class="table table-bordered ">
		<%
			for( Schedule s : scheduleList){ 
		%>
			<tr>
				<td><!-- where절에 필요하니까 넘겨야한다 -->
					schedule_no
				</td>
				<td>
					<input type="number" name="scheduleNo" value="<%=s.scheduleNo %>" readonly="readonly">					
				</td>
			</tr>
			<tr>
				<td><!--비밀번호도 필요하니까 넘긴다-->
					schedule_pw
				</td>
				<td><!-- 넘겨서 일치하는가 비교 -->
					<input type="password" name="schedulePw">					
				</td>
			</tr>		
			<tr>
				<td><!-- 수정 가능하니까 넘겨야 한다 -->
					schedule_date
				</td>
				<td>
					<input type="date" name="scheduleDate" value="<%=s.scheduleDate %>" >					
				</td>
			</tr>
			<tr>
				<td><!-- 수정 가능하니까 넘겨야 한다 -->
					schedule_time
				</td>
				<td>
					<input type="time" name="scheduleTime" value="<%=s.scheduleTime %>" >					
				</td>
			</tr>
			<tr>
				<td>
					schedule_memo
				</td>
				<td><!-- 수정 가능하니까 넘겨야 한다 -->
					<textarea rows="5" cols="80" name="scheduleMemo">
						<%=s.scheduleMemo %>	
					</textarea>				
				</td>
			</tr>
			<tr>
				<td>
					schedule_color
				</td>
				<td>
					<input type="color" name="scheduleColor" value="<%=s.scheduleColor %>" >					
				</td>
			</tr>
			<tr>
				<td>
					createdate
				</td>
				<td><!-- 수정 불가능하니까 그냥 값만 보여줘도 된다. -->
					<%=s.createdate %>				
				</td>
			</tr>
			<tr>
				<td>
					updatedate
				</td>
				<td><!-- 수정 불가능하니까 그냥 값만 보여줘도 된다. -->
					<%=s.updatedate %>				
				</td>
			</tr>
		<%
			}
		%>	
	</table>
	<button type="submit">전송</button>
	</form>
	</div>
</div>
</body>
</html>