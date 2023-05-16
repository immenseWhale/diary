<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%
	//인코딩 처리	
	request.setCharacterEncoding("utf-8");		

	//가장 먼저 봐야하는 scheduleNo이 유효한지 본다.
	if(request.getParameter("scheduleNo")==null){
		response.sendRedirect("./scheduleList.jsp");
		return;
	}
	
	
	//리다이렉트를 위한 메시지 변수 선언
	String msg = null;
		
	//null이거나 공백이면 반환하는 조건문
	//or 연산의 경우 앞에게 틀리면 뒤에건 조건이 맞는지 검사하지도 않는다.
	//각각 받아온 값의 null과 "" 를 통으로 검사하는게 아니라 하나하나 자세하게 검사하겠다.
	if(request.getParameter("schedulePw") == null		
		||request.getParameter("schedulePw").equals(""))
	{
			msg = "PWError";		
	}
	else if(request.getParameter("scheduleDate") == null
		||request.getParameter("scheduleDate").equals(""))
	{
			msg = "DateError";
	}
	else if(request.getParameter("scheduleMemo") == null
			||request.getParameter("scheduleMemo").equals(""))
	{
			msg = "MeMoError";
	}
	else if(request.getParameter("scheduleTime") == null
			||request.getParameter("scheduleTime").equals(""))
	{
			msg = "TimeError";
	}
	else if(request.getParameter("scheduleColor") == null
			||request.getParameter("scheduleColor").equals(""))
	{
			msg = "ColorError";
	}
	
	//위 if else문 유효성 검사에 뭔가 걸렸다면 msg에 값이 들어가 있을거다. 그렇다면 폼으로보내버리겠다. 
	if(msg != null){
			//잘못 된 경로로 들어온 경우 메시지를 하나 보여주겠다.													
		response.sendRedirect("./updatescheduleForm.jsp?scheduleNo="+request.getParameter("scheduleNo")+"&msg="+msg);
		return;	
	}	
	
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	String schedulePw = request.getParameter("schedulePw");
	String scheduleDate = request.getParameter("scheduleDate");
	String scheduleTime = request.getParameter("scheduleTime");
	String scheduleMemo = request.getParameter("scheduleMemo");
	String scheduleColor = request.getParameter("scheduleColor");
	System.out.println("updatescheduleAction scheduleNo--->"+ scheduleNo);
	System.out.println("updatescheduleAction scheduleTime--->"+ scheduleTime);
	System.out.println("updatescheduleAction schedulePw--->"+ schedulePw);
	System.out.println("updatescheduleAction scheduleDate--->"+ scheduleDate);
	System.out.println("updatescheduleAction scheduleMemo--->"+ scheduleMemo);
	System.out.println("updatescheduleAction scheduleColor--->"+ scheduleColor);
	
	
	//DB 호출
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	//DB 디버깅 코드
	//System.out.println("updatescheduleAction.jsp 접속성공 "+conn);		
	
	
	//수정하는 sql 구문
	String sql = "UPDATE schedule SET schedule_date=?, schedule_time=?, schedule_memo=?, schedule_color=?, updatedate=now() where schedule_no=? and schedule_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sql);	
	
	stmt.setString(1, scheduleDate);
	stmt.setString(2, scheduleTime);
	stmt.setString(3, scheduleMemo);
	stmt.setString(4, scheduleColor);
	stmt.setInt(5, scheduleNo);
	stmt.setString(6, schedulePw);
	
	System.out.println("updatescheduleAction param scheduleNo ->"+ stmt );
	

	//만약 바뀐 행이 하나도 없다면 수정된게 아니다. 비밀번호가 틀렸을거다.
	int row = stmt.executeUpdate();
	System.out.println("row-updatescheduleAction.jsp-->" + row);
	
	
	// 성공해서 확인 페이지로 가기 위한 날짜 분해
	String y = scheduleDate.substring(0,4);
	int m = Integer.parseInt(scheduleDate.substring(5,7))-1 ;
	String d = scheduleDate.substring(8);
	
	System.out.println(y + " <-- insertscheduleeAction y");
	System.out.println(m + " <-- insertscheduleeAction m");
	System.out.println(d + " <-- insertscheduleeAction d");	
	
	if(row == 0){//비밀번호가 틀려서 삭제 못했을 거다 -> 삭제 행이 0행이다.
		//실패하면 다시 폼										&msg는 아마 주소에 덧붙임인듯 하다.
		response.sendRedirect("./updateScheduleForm.jsp?scheduleNo="+scheduleNo+"&msg=incorrect schedulePw");
		System.out.println("수정불가");		
	}else if(row==1){//성공했으니 확인 페이지로 간다. 몇번째 페이지인지 필요하니까 날짜를 잘라서 그 날짜로 가게 해준다.
		response.sendRedirect("./scheduleListByDate.jsp?y="+y+"&m="+m+"&d="+d);
		System.out.println("수정성공");
	}else{
		//update문 실행을 취소(rollback)해야한다. 아직 배우지 않았다.
		System.out.println("error row 값 " + row +"다");
	}
	
	
%>