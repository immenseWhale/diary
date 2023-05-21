<%@ page language="java" contentType="text/html; charset=UTF-8"    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지 입력 폼 insertNoiceForm</title>
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
	.p3 {/* 본문 폰트*/
		font-family: "Lucida Console", "Courier New", monospace;
		text-align: center;
	}
	.p2 {/* 본문 폰트 좌정렬*/
		font-family: "Lucida Console", "Courier New", monospace;
		text-align: left;
	}
	h1{	/*제목 폰트*/
		font-family: 'Black Han Sans', sans-serif;
		text-align: center;
	}
	h2 {/* h2 왼쪽정렬 */
		text-align: left;
	}
	
	.grid-container {
		/* 그리드를 나누겠다. */
		display: grid;	
		grid-template-columns: auto auto auto auto;
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
		<h1>공지 입력</h1>
	</div>
	
	<div class="container-fluid, p2">
		<form action="./insertNoticeAction.jsp" method="post">
	
			<table class="table table-bordered ">
				<tr>
					<td>notice_title</td>
					<td>
						<input type="text" name="noticeTitle">
					</td>
				</tr>
				<tr>
					<td>notice_content</td>
					<td>
						<textarea rows="5" cols="80" name="noticeContent"></textarea>
					</td>
				</tr>
				<tr>
					<td>notice_writer</td>
					<td>
						<input type="text" name="noticeWriter">
					</td>
				</tr>
				<tr>
					<td>notice_pw</td>
					<td>
						<input type="password" name="noticePw">
					</td>
				</tr>
			</table>
			<div>
				<button type="submit">입력</button>
			</div>
		</form>
	</div>
</div>
</body>
</html>