<%@ page language="java" contentType="text/html; charset=UTF-8"    pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import = "vo.*" %>
<%

	request.setCharacterEncoding("utf-8");

	// y, m, d 값이 null or "" --> redirection scheduleList.jsp로 
	if(request.getParameter("y")== null 
	|| request.getParameter("m")==null
	|| request.getParameter("d")==null
	
	|| request.getParameter("y")== ""
	|| request.getParameter("m")== ""
	|| request.getParameter("d")== ""	
	)	{
		response.sendRedirect("./scheduleList.jsp");
		return;
	}
	
	int y = Integer.parseInt(request.getParameter("y"));
	//여기서 처리하기로하고 값 그대로 전달받았으니까 여기서 +1(java API에서 12월은 11이고 mariaDB에서 12월은 12)
	int m = Integer.parseInt(request.getParameter("m"))+1;		
	int d = Integer.parseInt(request.getParameter("d"));
	
	//System.out.println("y--->" + y);
	//System.out.println("m--->" + m);
	//System.out.println("d--->" + d);

	//10일 이하의 날짜도 정상 출력하기 위한 10일 이전에 문자열 넣어주는 분기문
	String strM = m+"";
	String strD = d+"";
	if(m<10){
		strM= "0"+strM;
	}
	if(d<10){
		strD ="0"+strD;
	}
	
	
	//일정 리스트 받아오기
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");	
	//DB에서 targetdate 목차와 날짜 시간 메모 컬러를 가져온다. 시간은 오름차순으로 정렬.
	String sql = "select schedule_no scheduleNo, schedule_date scheduleDate, schedule_time scheduleTime, schedule_memo scheduleMemo, schedule_color scheduleColor from schedule where schedule_date=? order by schedule_time asc";
	PreparedStatement stmt = conn.prepareStatement(sql); 
	stmt.setString(1, y+"-"+strM+"-"+strD);
	
	ResultSet rs = stmt.executeQuery();
	//디버깅
	//System.out.println("쿼리실행성공 "+rs);
	
	//ArrayList에 값 받아넣기
	ArrayList<Schedule> scheduleList = new ArrayList<>();
	while(rs.next()){
		Schedule s = new Schedule();
		s.scheduleNo = rs.getInt("scheduleNo");
		s.scheduleMemo = rs.getString("scheduleMemo");	//다섯글자만 가져온 memo
		s.scheduleDate = rs.getString("scheduleDate");
		s.scheduleTime = rs.getString("scheduleTime");
		s.scheduleColor = rs.getString("scheduleColor");
		scheduleList.add(s);
	}
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>schedule List</title>
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
	.box {
		margin: auto;
		width: 90%;
		border: 0px  #000000;
		align-content: center;
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
		&nbsp;&nbsp;<!-- 테이블 박스 넘어가서 간격 조정 -->
		<a href="./noticeList.jsp" >&nbsp;공지 리스트&nbsp;</a> 
		<a href="./scheduleList.jsp">&nbsp;일정 리스트&nbsp;</a>
	</div>
	
	<br>	
	<div class="container">	
		<h1><%=y %>년 <%=m %>월 <%=d %>일 스케줄 목록</h1>
	</div>
	<br>
	<div class="p2">
		<table class="table table-bordered ">
			<thead>
				<tr>
					<th>schedule_date</th>
					<th>schedule_time</th>
					<th>schedule_memo</th>
					<th>&nbsp;수&nbsp;&nbsp;정&nbsp;</th>
					<th>&nbsp;삭&nbsp;&nbsp;제&nbsp;</th>			
				</tr>
			</thead>
			
			<tbody>
			<%
				//다음 문장이 있을 때까지 출력
				for( Schedule s : scheduleList){
			%>				
				<tr>
					<td>
						<div style="color:<%=s.scheduleColor%>">
							<%=s.scheduleDate%>
						</div>
					</td>				
					<td>						
						<div style="color:<%=s.scheduleColor%>">
							<%=s.scheduleTime%>
						</div>
					</td>
					<td>						
						<div style="color:<%=s.scheduleColor%>">
							<a href="./scheduleOne.jsp?scheduleNo=<%=s.scheduleNo%>">
								<%=s.scheduleMemo%>
							</a>
						</div>
					</td>
					<td>
						<a href="./updateScheduleForm.jsp?scheduleNo=<%=s.scheduleNo%>">
							<div class="box, p3" style="color:<%=s.scheduleColor%>">수정</div>
						</a>
					</td>
					<td>
						<a href="./deledteScheduleForm.jsp?scheduleNo=<%=s.scheduleNo%>">
							<div class="box, p3" style="color:<%=s.scheduleColor%>">삭제</div>
						</a>
					</td>
				</tr>
			<%		
				}
			%>					
			</tbody>
		</table>
	</div>
	
	<br><br>
	
	<div align="center">
		<h1>스케줄 입력</h1>
	</div>
	
	<div>
	<%	//mgs 값이 오면
		if (request.getParameter("msg") != null){
	%>
			<div style="color: red">
				<h4>&nbsp;&nbsp;<%=request.getParameter("msg") %>.</h4>
			</div>
	<%				
		}		
	%>
	</div>
	
	<form action="./insertScheduleAction.jsp" method="post">
		<table class="table table-bordered ">
			<tr>
				<th>schedule_date</th>
				<td>
					<input type="date" name = "scheduleDate" value="<%=y %>-<%=strM %>-<%=strD %>" readonly="readonly">
					<input type="hidden" name="y" value="<%=y %>">
					<input type="hidden" name="m" value="<%=strM %>">
					<input type="hidden" name="d" value="<%=strD %>">
				</td>
			</tr>
			<tr>
				<th>schedule_pw</th>
				<td>
					<input type="password" name="schedulePw">
				</td>
			</tr>
			<tr>
				<th>schedule_time</th>
				<td>
					<input type="time" name = "scheduleTime">
				</td>
			</tr>
			<tr>
				<th>schedule_color</th>
				<td>
					<input type="color" name="scheduleColor">
				</td>
			</tr>
			<tr>
				<th>schedule_memo</th>
				<td>
					<textarea rows="3" cols="80" name="scheduleMemo"></textarea>
				</td>
			</tr>
		</table>
		<button type="submit">전송</button>
	</form>
</div>
</body>
</html>