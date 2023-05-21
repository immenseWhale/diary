<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//요청값 유효성 검사	널값이면 안되니까 리스트로 돌려보낸다.
	if(request.getParameter("noticeNo") == null){
		response.sendRedirect("./noticeList.jsp");
		return;	//코드진행 종료
	}
	
	//noticeNo 제대로 받아왔는지 디버깅 
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	System.out.println( "deleteNoticeForm param noticeNo ->" + noticeNo);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지 삭제 폼</title>
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
		<h1>공지 삭제</h1>
	</div>
	<br>
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
	<div class="p2">
		<form action="./deleteNoticeAction.jsp" method="post">
			<table class="table table-bordered ">
				<tr>
					<td>notice_no</td>
					<!-- 안보이게 넘겨주고 싶을 때 타입을 히든으로 input type="hidden" -->
					<!-- 수정 못하게 하고 싶을 때 readonly="readonly" -->
					<td>
						<input type="text" name="noticeNo" value="<%=noticeNo%>" readonly="readonly">
					</td>
				</tr>
				<tr>
					<td>비밀번호</td>
					<td><!-- jsp에서 패스워드가 동일하다면 삭제하게 할거다. -->
						<input type="password" name="noticePw">
					</td>
				</tr>
			</table>	
			<button type="submit">삭제</button>	
		</form>
	</div>
</div>
</body>
</html>