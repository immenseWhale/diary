<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- DB 접속 정보를 가지고 있는 페이지 import  -->
<%@ page import = "java.sql.* " %>
<%@ page import = "java.util.* " %>
<%@ page import = "vo.* "%>
<%
	//요청 분석currentPage
	//현재 페이지
	int currentPage = 1;
	//페이지가 넘어와서 응답값이 null이 아니라면
	if(request.getParameter("currentPage") != null) {
		//currentPage에 응답값 currentPage을 넣어준다.
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	//System.out.println(currentPage + " <--currentPage");
	
	//페이지당 출력할 행의 수	
	int rowPerPage = 10;
	
	//시작 행 번호	
	int startRow = (currentPage-1)*rowPerPage;		//1페이지 일 때만 startRow가 0이다
	/*	알고리즘 찾는 과정
		currentPage StartRow(rowPerPage가 10일 때)
		1			0	<-- (currentPage-1)*rowPerPage
		2			10
		3			20
		4			30
	*/
%>

<%
	//DB연결 설정
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");	
	//인정을 안 받아도 들어갈 수 있는거면 RDBMS가 아니다. 계정 정보를 넣는다.
	PreparedStatement stmt = conn.prepareStatement("select notice_no as noticeNo, notice_title as noticeTitle, createdate from notice order by createdate desc limit ?, ?"); // 
	stmt.setInt(1, startRow);
	stmt.setInt(2, rowPerPage);
	//System.out.println(stmt + " <-- stmt");
	//출력할 공지 데이터
	ResultSet rs = stmt.executeQuery();	
	//rs를 일반적인 타입(자바 배열 or 기본API 자료구조타입)으로 바꾸겠다.
	//ResultSet -> AllayList<Notice>로 바꾼다.
	ArrayList<Notice> noticeList = new ArrayList<Notice>();
	while(rs.next()){
		Notice n = new Notice();
		n.noticeNo= rs.getInt("noticeNo");
		n.noticeTitle = rs.getString("noticeTitle");
		n.createdate = rs.getString("createdate");
		noticeList.add(n);	//다 넣었으면 배열 추가
	}
	
	
	//마지막 페이지
	//select count(*) from notice
	PreparedStatement stmt2 = conn.prepareStatement("select count(*) from notice");
	ResultSet rs2 = stmt2.executeQuery();
	int totalRow = 0; // SELECT COUNT(*) FROM notice;
	if(rs2.next()) {
		totalRow = rs2.getInt("count(*)");
	}
	int lastPage = totalRow / rowPerPage;
	if(totalRow % rowPerPage != 0) {
		lastPage = lastPage + 1;
	}
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>form</title>
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
	
	<div align="center" c>
		<h1>공지사항 리스트</h1>
	</div>
	
	<div>
		<a href="./insertNoticeForm.jsp">
			<h4>&nbsp;공지입력</h4>
		</a>
	</div>
	
	<div class="container, p2">	
		<table class="table table-bordered ">
			<tr>
				<th><h4>notice_title</h4></th>
				<th><h4>createdate</h4></th>			
			</tr>
			
		<%
			//notice 사이즈만큼 반복되는 배열로 re.next를 대신한다.
			for(Notice n : noticeList){
		%>				
			<tr>
				<td>
					<!-- 현재 받아온 변수 rs  -->
					<!-- notice.jsp로 가는 링크. 제목은 중복될 수 있으니 noticeNo를 기준삼는다. -->
					<!-- noticeOne.jsp 첫 줄은 requestParameter가 있어여 한다. -->
					<a href="./noticeOne.jsp?noticeNo=<%=n.noticeNo%>">
						<%=n.noticeTitle%>
					</a>
				</td>	
				<td><!-- subString은 몇글자 받아올지 String을 자르는 함수  -->
					<%=n.createdate.substring(0,10)%>
				</td>
			</tr>
		<%		
			}
		%>			
		</table>
		<div class="p3">		
		<%
			if(currentPage > 1) {
		%>
				<a href="./noticeList.jsp?currentPage=<%=currentPage-1%>">이전</a>
		<%		
			}
		%>
				<%=currentPage%>
		<%	
			if(currentPage < lastPage) {	
		%>
				<a href="./noticeList.jsp?currentPage=<%=currentPage+1%>">다음</a>
		<%
			}
		%>
		</div>
	</div>
</div>
</body>
</html>