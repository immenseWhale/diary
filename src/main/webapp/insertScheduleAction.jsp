<%@ page language="java" contentType="text/html; charset=UTF-8"    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	//값을 똑바로 입력하지 않으면 form에 msg로 메시지를 보내기 위한 변수 선언
	String msg = null;

	//유효성 검사
	if(request.getParameter("scheduleDate") == null||
	request.getParameter("schedulePw") == null||
	request.getParameter("scheduleTime") == null||
	request.getParameter("scheduleColor") == null||
	request.getParameter("scheduleMemo") == null||	
	
	request.getParameter("scheduleDate").equals("")||
	request.getParameter("schedulePw").equals("")||
	request.getParameter("scheduleTime").equals("")||
	request.getParameter("scheduleColor").equals("")||
	request.getParameter("scheduleMemo").equals("")	){
			msg = "Do not allow spaces.";
			System.out.println("입력값 부족");
	}
	//위 유효성 검사에 뭔가 걸렸다면 msg에 값이 들어가 있을거다. 그렇다면 폼으로보내버리겠다. 
	if(msg != null){
		//잘못 된 경로로 들어온 경우 메시지를 하나 보여주겠다.
		//이 부분을 어떻게해야 http://localhost/diascheduleListByDatery/scheduleListByDate.jsp?y=2023&m=4&d=4 이런식으로 보내줄 수 있을까?
		response.sendRedirect("./scheduleListByDate.jsp?y=" + request.getParameter("y") + "&m=" + request.getParameter("m") + "&d=" + request.getParameter("d") + "&msg=" + msg);
		return;	
	}	
	
	//scheduleListByDate 에서 값을 받아온다.
	String scheduleDate = request.getParameter("scheduleDate");
	String scheduleTime = request.getParameter("scheduleTime");
	String scheduleColor = request.getParameter("scheduleColor");
	String scheduleMemo = request.getParameter("scheduleMemo");
	String schedulePw = request.getParameter("schedulePw");
	//디버깅
	System.out.println("scheduleDate--->" + scheduleDate);
	System.out.println("scheduleTime--->" + scheduleTime);
	System.out.println("scheduleColor--->" + scheduleColor);
	System.out.println("scheduleMemo--->" + scheduleMemo);
	System.out.println("schedulePw--->" + schedulePw);	
	
	
	// 서버 연결 + DB에 업데이트 입력하는 부분
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");	
	String sql = "insert into schedule (schedule_date, schedule_time, schedule_memo, schedule_color, schedule_pw, createdate,updatedate) values(?,?,?,?,?,now(), now())";
	PreparedStatement stmt = conn.prepareStatement(sql); 
	stmt.setString(1, scheduleDate);
	stmt.setString(2, scheduleTime);
	stmt.setString(3, scheduleMemo );
	stmt.setString(4, scheduleColor);
	stmt.setString(5, schedulePw);
	
	/* stmt가 두번 실행되서 입력이 두번씩 됐다.
	ResultSet rs = stmt.executeQuery();
	//디버깅
	int row = stmt.executeUpdate(); //디버깅. 1(ex:2)이면 1행(ex:2행) 입력 성공, 0 이면 입력된 행이 없다.
	if (row == 1){
		System.out.println("정상 입력 성공 ----> "+row);
		
	}else{
		System.out.println("입력 실패 ----> "+row);
	}
	*/
	int result = stmt.executeUpdate();
	if (result == 1) {
	    System.out.println("정상 입력 성공 ----> " + result);
	} else {
	    System.out.println("입력 실패 ----> " + result);
	}


	//날짜 출력형식에 맞춰 자르기
	String y = scheduleDate.substring(0,4);
	int m = Integer.parseInt(scheduleDate.substring(5,7))-1;
	//숫자 하나만 적으면 그 숫자부터 뒤까지 다 출력
	String d = scheduleDate.substring(8);
	//디버깅
	System.out.println("y--->" + y);
	System.out.println("m--->" + m);
	System.out.println("d--->" + d);
	
	System.out.println("scheduleTime--->" + scheduleTime);

	
	//뭐가 됐든 다시 리스트바이데이트로 보내준다.
	response.sendRedirect("./scheduleListByDate.jsp?y="+y+"&m="+m+"&d="+d);
	
	
%>