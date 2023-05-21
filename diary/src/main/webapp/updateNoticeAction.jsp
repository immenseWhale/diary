<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import="java.net.URLEncoder" %>
<%
	//인코딩 처리	
	request.setCharacterEncoding("utf-8");		

	//가장 먼저 봐야하는 noticeNo가 유효한지 본다.
	if(request.getParameter("noticeNo")==null){
		response.sendRedirect("./noticeList.jsp");
		return;
	}

	//리다이렉트를 위한 메시지 변수 선언
	String msg = null;
	
	//null이거나 공백이면 반환하는 조건문
	//or 연산의 경우 앞에게 틀리면 뒤에건 조건이 맞는지 검사하지도 않는다.
	//각각 받아온 값의 null과 "" 를 통으로 검사하는게 아니라 하나하나 자세하게 검사하겠다.
	if(request.getParameter("noticeTitle") == null		
		||request.getParameter("noticeTitle").equals("")){
			msg = "noticeTitle is required";		
	}
	else if(request.getParameter("noticeContent") == null
		||request.getParameter("noticeContent").equals("")){
			msg = "noticeContent is required";
	}
	else if(request.getParameter("noticePw") == null
			||request.getParameter("noticePw").equals("")){
			msg = "noticePw is required";
	}
	
	//위 if else문 유효성 검사에 뭔가 걸렸다면 msg에 값이 들어가 있을거다. 그렇다면 폼으로보내버리겠다. 
	if(msg != null){
		//잘못 된 경로로 들어온 경우 메시지를 하나 보여주겠다.													
		response.sendRedirect("./updateNoticeForm.jsp?noticeNo="+request.getParameter("noticeNo")+"&msg="+msg);
		return;	//코드진행 종료
	}

	//noticeNo는 인트로 값을 변환하면서 넣어주고 나머지는 String으로 받아온다.
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	String noticePw = request.getParameter("noticePw");
	String noticeTitle = request.getParameter("noticeTitle");
	String noticeContent = request.getParameter("noticeContent");

	
	//값을 제대로 받아왔는지 변수에 들어갔는지 확인
	System.out.println("noticeNo-updateNoticeAction.jsp-->" + noticeNo);
	System.out.println("noticePw-updateNoticeAction.jsp-->" + noticePw);
	System.out.println("noticeTitle-updateNoticeAction.jsp-->" + noticeTitle);
	System.out.println("noticeContent-updateNoticeAction.jsp-->" + noticeContent);
	
	//DB 호출
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	//DB 디버깅 코드
	//System.out.println("updateNoticeAction.jsp 접속성공 "+conn);		
	
	
	//수정하는 sql 구문
	String sql = "UPDATE notice SET  notice_title=?, notice_content=?, updatedate=now() where notice_no=? and notice_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sql);	
	
	stmt.setString(1, noticeTitle);
	stmt.setString(2, noticeContent);
	stmt.setInt(3, noticeNo);
	stmt.setString(4, noticePw);
	System.out.println("stmt-updateNoticeAction.jsp--->" + stmt);	
	
	//만약 바뀐 행이 하나도 없다면 수정된게 아니다. 비밀번호가 틀렸을거다.
	int row = stmt.executeUpdate();
	System.out.println("row-updateNoticeAction.jsp-->" + row);
	
	if(row == 0){//비밀번호가 틀려서 삭제 못했을 거다 -> 삭제 행이 0행이다.
		//실패하면 다시 폼										&msg는 아마 주소에 덧붙임인듯 하다.
		response.sendRedirect("./updateNoticeForm.jsp?noticeNo="+noticeNo+"&msg=Incorrect noticePw");
		System.out.println("수정불가");		
	}else if(row==1){//성공했으니 확인 페이지로 간다. 몇번째 페이지인지 필요하니까 noticeNo를 붙여준다.
		response.sendRedirect("./noticeOne.jsp?noticeNo="+noticeNo);
		System.out.println("수정성공");
	}else{
		//update문 실행을 취소(rollback)해야한다. 아직 배우지 않았다.
		System.out.println("error row 값 " + row +"다");
	}
	
%>