<%@ page language="java" contentType="text/html; charset=UTF-8"    pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import = "vo.*" %>
<%
	request.setCharacterEncoding("utf-8");	

	//장치 드라이브를 로딩하는 메소드. 풀네임을 문자열로 불러야한다.
	//톰캣에서 한 번만 불러오면 된다. 하지만 어떤 페이지를 첫페이지로 불러올지 모르니 일단 모든 페이지에 넣는다.
	Class.forName("org.mariadb.jdbc.Driver");		//static 메소드. new로 불러오지 않은걸 보고 알 수 있다.
	//System.out.println("드라이버 로딩 성공");	
	
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");	
	//인정을 안 받아도 들어갈 수 있는거면 RDBMS가 아니다. 계정 정보를 넣는다.
	//System.out.println("접속성공 "+conn);
	
	//prepareStaatement 가 mariadb가 볼 수 있는 진짜 쿼리로 보내준다. 문자열을 쿼리로 변경해준다.
	//최근 공지
	String sql1 = "select notice_no noticeNo, notice_title noticeTitle, createdate from notice order by createdate desc limit 0, 10;";
	PreparedStatement stmt = conn.prepareStatement(sql1);
	// 내가 입력한 모양과 실제 모양이 다를 수 있으니 꼭 디버깅 해본다. 쿼리에 ? 있으면 특히.
	//System.out.println(stmt + " <--stmt");		
	ResultSet re = stmt.executeQuery();
	
	//결과값을 ArrayList에 넣어주겠다.
	ArrayList<Notice> noticeList = new ArrayList<>();
	while(re.next()){
		Notice n = new Notice();
		n.noticeNo = re.getInt("noticeNo");
		n.noticeTitle = re.getString("noticeTitle");
		n.createdate = re.getString("createdate");
		
		noticeList.add(n);
	}
	
	
	//일정 받아오기. 메모는 일부분만 보여주고 날짜까지 보여주겠다. 시간순 오름차순 정렬
	//curdate() = sql에서 오늘 날짜 받아오는 함수
	//글자 자르는 함수 substr(schedule_memo,1,10) 1부터 10개의 글자를 받아온다 
	String sql2="select schedule_no scheduleNo, schedule_date scheduleDate, schedule_time scheduleTime, substr(schedule_memo,1,10) As schedulememo from schedule where schedule_date= curdate() order by schedule_time asc;";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);	
	//System.out.println(stmt2 + " <--stmt2");
	ResultSet rs2 = stmt2.executeQuery();
	
	ArrayList<Schedule> scheduleList = new ArrayList<>();
	while(rs2.next()){
		Schedule s = new Schedule();
		s.scheduleNo = rs2.getInt("scheduleNo");
		s.scheduleMemo = rs2.getString("schedulememo");	//다섯글자만 가져온 memo
		s.scheduleDate = rs2.getString("scheduleDate");
		s.scheduleTime = rs2.getString("scheduleTime");
		scheduleList.add(s);
	}
	


%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Horm</title>
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
		<h1>공지 상세</h1>
	</div>
	<div class="container-fluid" class="p3">
		<table class="table table-bordered ">
			<tr>
				<th>notice_title</th>
				<th>createdate</th>			
			</tr>			
		<%
			//다음 문장이 있을 때까지 출력
			for( Notice n : noticeList){
		%>				
			<tr>
				<td>
					<!-- 현재 받아온 변수 rs  -->
					<!-- notice.jsp로 가는 링크. 제목은 중복될 수 있으니 notice_no를 기준삼는다. -->
					<!-- noticeOne.jsp 첫 줄은 requestParameter가 있어여 한다. -->
					<a href="./noticeOne.jsp?noticeNo=<%=n.noticeNo%>">
						<%=n.noticeTitle%>
					</a>
				</td>				
					<!-- subString은 몇글자 받아올지 String을 자르는 함수  -->
				<td><%=n.createdate.substring(0,10)%></td>
			</tr>
		<%		
			}
		%>			
		</table>
	</div>
	
	<div align="center">
		<h1>오늘 일정</h1>
	</div>
	<div class="container-fluid, p3" >
		<table class="table table-striped" style="background-color:#FFE08C" >
			<tr>
				<th>schedule_date</th>
				<th>schedule_time</th>
				<th>schedule_memo</th>					
			</tr>
			
		<%
			//다음 문장이 있을 때까지 출력
			for( Schedule s : scheduleList){
		%>				
			<tr>						
				<td>
					<a href="./scheduleOne.jsp?scheduleNo=<%=s.scheduleNo%>">
						<%=s.scheduleDate%>					
					</a>
				</td>
				<td>
					<a href="./scheduleOne.jsp?scheduleNo=<%=s.scheduleNo%>">
						<%=s.scheduleTime%>
					</a>
				</td>
				<td>
					<a href="./scheduleOne.jsp?scheduleNo=<%=s.scheduleNo%>">
						<%=s.scheduleMemo%>
					</a>
				</td>	
			</tr>
		<%		
			}
		%>			
		</table>
	</div>
</div>
</body>
</html>