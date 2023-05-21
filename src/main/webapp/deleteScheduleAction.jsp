<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	//요청값 유효성 검사	널값이면 안되니까 리스트로 돌려보낸다.
	if(request.getParameter("scheduleNo") == null
		||request.getParameter("schedulePw") == null
		
		//공백이면 안받는다.
		||request.getParameter("scheduleNo").equals("")
		||request.getParameter("schedulePw").equals(""))
	{
		response.sendRedirect("./scheduleList.jsp");
		return;	//코드진행 종료
	}

	String msg = null;	//에러 메시지를 위한 변수 초기화
	
	//scheduleNo는 인트로, schedulePw는 스트링으로 받아온다.
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	String schedulePw = request.getParameter("schedulePw");
	//값을 제대로 받아왔는지 변수에 들어갔는지 확인
	System.out.println("scheduleNo-deletescheduleAction.jsp-->" + scheduleNo);
	System.out.println("schedulePw-deletescheduleAction.jsp-->" + schedulePw);
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	//DB 디버깅 코드
	System.out.println("updatescheduleAction.jsp 접속성공 "+conn);	
	
	
	//날짜 불러오는 sql 구문 
	//정확하게 프라이머리값으로 불러오는데 왜 wrong row position이 뜨는지??
	String sql2 = "select schedule_date from schedule where schedule_no=? ";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	stmt2.setInt(1, scheduleNo);
	ResultSet rs = stmt2.executeQuery();
	rs.next();
	//변수에 날짜 넣기
	String scheduleDate = rs.getString("schedule_date");
	System.out.println("stmt2-deletescheduleAction.jsp-->" + scheduleDate+ stmt2);

	//날짜 분해
	String y = scheduleDate.substring(0,4);
	int m = Integer.parseInt(scheduleDate.substring(5,7))-1 ;
	String d = scheduleDate.substring(8);	
	System.out.println(y + " <-- deletescheduleeAction y");
	System.out.println(m + " <-- deletescheduleeAction m");
	System.out.println(d + " <-- deletescheduleeAction d");
	
	
	//삭제하는 sql 구문
	String sql1 = "delete from schedule where schedule_no=? and schedule_pw=?";
	PreparedStatement stmt1 = conn.prepareStatement(sql1);
	//sql 구문 ?에 들어갈 값 2개
	stmt1.setInt(1, scheduleNo);
	stmt1.setString(2, schedulePw);
	System.out.println("stmt1-deletescheduleAction.jsp-->" + stmt1);	
	
	
	int row = stmt1.executeUpdate();
	System.out.println("row-deleteSchdulAction.jsp-->" + row);
	if(row == 0) {	//비밀번호가 틀려서 삭제 못했을 거다 -> 삭제 행이 0행이다.
		response.sendRedirect("./deledteScheduleForm.jsp?scheduleNo="+scheduleNo+"&msg=incorrect schedulePw");
		System.out.println("비밀번호 틀렸다");
		
	}else{
		//2023년 4월 24일 스케줄 목록 페이지scheduleListByDate.jsp?y=2023&m=3&d=24로 돌아가고 싶다.
		response.sendRedirect("./scheduleListByDate.jsp?y="+y+"&m="+m+"&d="+d);
		System.out.println("삭제 성공");
	}

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>