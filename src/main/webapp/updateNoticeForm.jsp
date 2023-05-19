<%@ page language="java" contentType="text/html; charset=UTF-8"    pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<%	//뷰가 있는지 없는지를 먼저 판단한다. -> 쿼리를 호출하는지 안하는지 판단한다 MVC 패턴을 이용한 제작에서 필요한 판단.
	
	//요청값 유효성 검사	널값이면 안되니까 리스트로 돌려보낸다.
	//이상한 경로로 들어오면 값이 null이나 공백일테니 반환시킨다.
	if(request.getParameter("noticeNo") == null){
		response.sendRedirect("./noticeList.jsp");
		return;	//코드진행 종료
	}

	//noticeNo 제대로 받아왔는지 디버깅 
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	System.out.println( "updateNoticeForm param noticeNo ->" + noticeNo);
		

	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");	
	
	//noticeOne과 쿼리가 거의 비슷하다. 수정할 수 있는 부분만 보여주는 경우도 있다.
	String sql = "select notice_no as noticeNo, notice_title as noticeTitle, notice_content as noticeContent, notice_writer as noticeWriter, createdate, updatedate from notice where notice_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	//?가 있으면 미완성된 문장이기 때문에 동작이 안된다. 완성하기 위해서는 숫자를 문자로 변경해서 완성해야 한다.
	stmt.setInt(1, noticeNo);
	System.out.println("updateNoticeForm param noticeNo ->"+ stmt );
	ResultSet re = stmt.executeQuery();
	
	ArrayList<Notice> noticeList = new ArrayList<>();
	while(re.next()){
		Notice n = new Notice();
		n.noticeNo = re.getInt("noticeNo");
		n.noticeTitle = re.getString("noticeTitle");
		n.noticeContent = re.getString("noticeContent");
		n.noticeWriter = re.getString("noticeWriter");
		n.createdate = re.getString("createdate");
		n.updatedate = re.getString("updatedate");
		
		noticeList.add(n);
	}
	
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>updateNoticeForm.jsp</title>
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
		<h1> 공지 수정 </h1>
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
	
	<div class="container-fluid, p2" >
	<form action="./updateNoticeAction.jsp" method="post">
		<table class="table table-bordered ">
		<%
			//만약 다음 값이 있다면 실행해라
			for( Notice n : noticeList){ 
		%>
			<tr>
				<td><!-- where절에 필요하니까 넘겨야한다 -->
					notice_no
				</td>
				<td>
					<input type="number" name="noticeNo" value="<%=noticeNo %>" readonly="readonly">					
				</td>
			</tr>
			<tr>
				<td><!--비밀번호도 필요하니까 넘긴다-->
					notice_pw
				</td>
				<td><!-- 넘겨서 일치하는가 비교 -->
					<input type="password" name="noticePw">					
				</td>
			</tr>		
			<tr>
				<td><!-- 수정 가능하니까 넘겨야 한다 -->
					notice_title
				</td>
				<td>
					<input type="text" name="noticeTitle" value="<%=n.noticeTitle %>" >					
				</td>
			</tr>
			<tr>
				<td>
					notice_content
				</td>
				<td><!-- 수정 가능하니까 넘겨야 한다 -->
					<textarea rows="5" cols="80" name="noticeContent">
						<%=n.noticeContent %>	
					</textarea>				
				</td>
			</tr>
			<tr>
				<td>
					notice_writer
				</td>
				<td><!-- 수정 불가능하니까 그냥 값만 보여줘도 된다. -->
					<%=n.noticeWriter%>				
				</td>
			</tr>
			<tr>
				<td>
					createdate
				</td>
				<td><!-- 수정 불가능하니까 그냥 값만 보여줘도 된다. -->
					<%=n.createdate %>				
				</td>
			</tr>
			<tr>
				<td>
					updatedate
				</td>
				<td><!-- 수정 불가능하니까 그냥 값만 보여줘도 된다. -->
					<%=n.updatedate %>				
				</td>
			</tr>		
		</table>
		<%
			}
		%>
		<button type="submit">전송</button>
	</form>
	</div>
</body>
</html>