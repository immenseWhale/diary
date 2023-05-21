<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%
	//요청값 유효성 검사	널값이면 안되니까 리스트로 돌려보낸다.
	if(request.getParameter("noticeNo") == null
		||request.getParameter("noticePw") == null
		
		//공백이면 안받는다.
		||request.getParameter("noticeNo").equals("")
		||request.getParameter("noticePw").equals("")
	){
		response.sendRedirect("./noticeList.jsp");
		return;	//코드진행 종료
	}
	//리다이렉트를 위한 메시지 변수 선언
	String msg = null;

	//noticeNo는 인트로 값을 변환하면서 넣어주고 pw는 String으로 받아온다.
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	String noticePw = request.getParameter("noticePw");
	
	//값을 제대로 받아왔는지 변수에 들어갔는지 확인
	System.out.println("noticeNo-deleteNoticeAction.jsp-->" + noticeNo);
	System.out.println("noticePw-deleteNoticeAction.jsp-->" + noticePw);
	
	//DB 호출
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	
	//삭제하는 sql 구문
	String sql = "delete from notice where notice_no=? and notice_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sql);	
	
	//sql 구문 ?에 들어갈 값 2개
	stmt.setInt(1, noticeNo);
	stmt.setString(2, noticePw);
	System.out.println("stmt-deleteNoticeAction.jsp-->" + stmt);

	
	//stmt.executeUpdate() => stmt 실행값
	int row = stmt.executeUpdate();
	System.out.println("row-deleteNoticeAction.jsp-->" + row);
	if(row == 0) {	//비밀번호가 틀려서 삭제 못했을 거다 -> 삭제 행이 0행이다.
		response.sendRedirect("./deleteNoticeForm.jsp?noticeNo="+noticeNo+"&msg=Incorrect noticePw");
		System.out.println("비밀번호를 틀렸습니다.");
	}else{
		response.sendRedirect("./noticeList.jsp");
		System.out.println("삭제 성공");
	}
%>