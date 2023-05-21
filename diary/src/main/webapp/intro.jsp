<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>들어가며</title>
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
		<a href="./schedulList.jsp">&nbsp;일정 리스트&nbsp;</a>
	</div>
	
	<textarea class="form-control col-sm-5" rows="5" style="size: 100%">
		이 웹페이지는 IT 국비지원 수업 KDT 클라우드 활용 자바개발자 양성과정 3주차에 만들었습니다.
	
		주요 기능
		이클립스를 사용한 다이나믹 웹 페이지를 이용하여 달력과 일정관리, 공지 리스트를 만들었습니다.
		maria DB와 연결하여 CRUD 기능을 수행할 수 있습니다.
		
		
		홈에서는 공지 리스트 중 최근 목록 일부와 오늘의 일정을 나타냅니다.
		공지나 일정을 클릭하면 상세 내용으로 넘어갑니다.
		
		
		상단 목록 중 공지 리스트를 클릭하면 더 많은 공지 리스트와 공지입력을 할 수 있는 페이지로 넘어갑니다.
		각 일정을 클릭하면 상세 내용으로 넘어가고, 수정과 삭제를 할 수 있습니다.
		
		수정페이지에서는 공란을 허용하지 않습니다. 만일 빈 값으로 수정하려 한다면 오류 메시지가 나타납니다.
		
		
		
		상단 목록 중 일정 리스트에서는 달력을 보여줍니다.
		달력에서는 간략한 일정 내용을 미리 지정한 컬러로 보여주어 무슨 일정이 있는지 한 눈에 보기 쉽게 표현합니다.
		오늘 날짜는 칸을 색깔로 채우고 날짜 또한 다르게 나타내어 오늘이 며칠인지 알기 쉽게 보여줍니다.
		
		날짜를 클릭하면 그 날의 스케줄 목록과 스케줄 입력을 할 수 있는 페이지가 한번에 나타납니다.
		이 페이지에서도 스케줄 메모를 클릭하면 일정 상세로 넘어가 수정과 삭제를 할 수 있게 해줍니다.
	</textarea>
</div>
</body>
</html>