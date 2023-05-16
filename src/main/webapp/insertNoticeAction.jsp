<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.Connection"%>
<%@ page import = "java.sql.DriverManager" %>
<%@page import="java.sql.PreparedStatement"%>

<%
	//post방식 인코딩 처리	
	request.setCharacterEncoding("utf-8");

	//validation(요청 파라미터값 유효성 검사)	
	//받아온 값이 null 혹은 ""라면 분기문
	if(request.getParameter("noticeTitle")== null 
		||request.getParameter("noticeContent")== null 
		||request.getParameter("noticeWriter")== null 
		||request.getParameter("noticePw")== null 
		
		||request.getParameter("noticeTitle").equals("")
		||request.getParameter("noticeContent").equals("")
		||request.getParameter("noticeWriter").equals("")
		||request.getParameter("noticePw").equals("")
	){//다시 입력폼으로 돌아간다
		response.sendRedirect("./insertNoticeForm.jsp");
		return;
	}
	//null이 아니니까 변수로 받아두는게 편하다.
	String noticeTitle = request.getParameter("noticeTitle");
	String noticeContent = request.getParameter("noticeContent");
	String noticeWriter = request.getParameter("noticeWriter");
	String noticePw = request.getParameter("noticePw");	

	
	
	//값들을 DB 테이블에 입력
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	//자주 변동될 수 있는 값들은 변수 선언을 해서 사용하는게 좋다.
	String sql = "insert into notice(notice_title, notice_content, notice_writer, notice_pw, createdate, updatedate) values(?,?,?,?,now(),now())";
	//PreparedStatement에 문자열 쿼리를 넣어줄 때 값말고 ?로 대신할 수 있다.
	PreparedStatement stmt = conn.prepareStatement(sql);	
	// ?값에 순서대로 넣어준다. 
	stmt.setString(1, noticeTitle);
	stmt.setString(2, noticeContent);
	stmt.setString(3, noticeWriter);
	stmt.setString(4, noticePw);
	//꼭 커밋해준다. 디버깅 할 때 필요하다.
	int row = stmt.executeUpdate(); //디버깅. 1(ex:2)이면 1행(ex:2행) 입력 성공, 0 이면 입력된 행이 없다.
	System.out.println(row);
	//conn.setAutoCommit(true);		//오토커밋 기능은 켜두면 알아서 커밋이 된다. false로 하면 꼭꼭 커밋 명령어 넣는다.
	//conn.commit();
		
	//  redirection
	response.sendRedirect(".noticeList.jsp");
	//이동시킬 뿐 끝내는 명령어는 아니다. 사용자는 저쪽 페이지로 넘어가지만 서버는 운영하고 있을 수 있다.	
	

%>