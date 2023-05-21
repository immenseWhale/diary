<%@ page language="java" contentType="text/html; charset=UTF-8"    pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import = "vo.*" %>
<%
	request.setCharacterEncoding("utf-8");	

	//오늘 일정 없으면 달력을 보여줄거다
	
	int targetYear = 0;
	int targetMonth = 0;
	
	// 년or월이 요청값에 넘어오지 않으면 오늘 날짜의 년/월 값으로 보여주겠다.
	if(request.getParameter("targetYear")== null || request.getParameter("targetMonth")==null){
		Calendar c = Calendar.getInstance();
		// 오늘 날짜 구하는 함수.
		targetYear = c.get(Calendar.YEAR);		//올 해 년도가 넘어온다.
		targetMonth = c.get(Calendar.MONTH);		//올 해 년도가 넘어온다.
		//알고리즘에서 계속 쓰이는 데이터들을 건드리면 안된다. 출력 할 때만 최종적으로 편하게 보이게 해준다. (달력 날짜 + 해주는 경우)
	}else{
		targetYear = Integer.parseInt(request.getParameter("targetYear"));
		targetMonth = Integer.parseInt(request.getParameter("targetMonth"));
	}
	//디버깅
	//System.out.println("targetYear--->"+targetYear);
	//System.out.println("targetMonth--->"+targetMonth);
	
	
	//마지막 날을 구하기 위해 오늘 날짜와 targetMonth 1일,마지막 일을 구하겠다.	
	//오늘 날짜
	Calendar today = Calendar.getInstance();	//캘린터 함수 호출
	int todayDate = today.get(Calendar.DATE);	//오늘 날짜
	
	Calendar firstDay = Calendar.getInstance();	//오늘(2023 4 24)
	firstDay.set(Calendar.YEAR, targetYear);	//현재 내가 보고싶은 날의 년을 넣어준다(23년)
	firstDay.set(Calendar.MONTH, targetMonth);	//현재 내가 보고싶은 날의 월을 넣어준다.(4월)
	firstDay.set(Calendar.DATE, 1);				//내가 보고 싶은 날의 첫 날을 1로 지정(1일)	

	//밑 두 항목에 달력 범위를 초과하는 12(실출력 13월)이 들어오면 달력 API가 자동으로 넘어가기에 새로 넣어준다.
	targetYear = firstDay.get(Calendar.YEAR);
	targetMonth = firstDay.get(Calendar.MONTH);		
	//System.out.println( "targetYear---->" + targetYear);
	//System.out.println( "targetMonth---->" + targetMonth);
	
	
	int firstYoil = firstDay.get(Calendar.DAY_OF_WEEK);	//4월 1일이 몇번째 요일인지 알려준다. 일요일일 때 1, 토요일일 때 7
	//1일 앞의 공백 칸의 수		이제 시작하는 사람이니까 변수를 과하게 지정해서 해석이 편하게 하는게 메모리 낭비보다 중요하다.	
	int  startBlank = firstYoil-1;		//일요일 시작이면 공백이 0이고 토요일이면 6개이기에 -1 해준다.
	
	//타겟 달(1일 있는 날짜=firstDay)의 마지막 날짜	실제로 존재하는 숫자 중 가장 큰 숫자를 달라고 하는 함수
	int lastDate = firstDay.getActualMaximum(Calendar.DATE);
	//System.out.println("lastDate------>"+lastDate);
	
	//앞의 공백수 + 뒤의 공백수 + lastDate는 7로 나누어 떨어져야 한다.
	//(stratDate + lastDate + ? ) % 7== 0; 
	int endBlank = 0;
	int totalTd = 0;
	if((startBlank +lastDate)%7 != 0){				//0으로 나누어떨어지지 않으면
		endBlank = 7 - (startBlank +lastDate)%7;	//일주일에서 나머지를 뺀 만큼 공백이 된다.
	}
	//전체 TD의 개수
	int totalTD = startBlank + lastDate + endBlank;
	//System.out.println("totalTD------>"+totalTD);	
	
	
	//스케줄 데이터 가져오기
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");	
	//스케줄 메모에서 5글자만 가져와서 scheduleMemo라고 부르겠다. 스케줄 데이터에서 일만 받아와서 scheduleDate로 저장한다.
	String sql = "select schedule_no as scheduleNo, day(schedule_date) as scheduleDate, substr(schedule_memo, 1, 5) as scheduleMemo, schedule_color as scheduleColor from schedule where year(schedule_date) = ? and month(schedule_date) = ? order by day(schedule_date) asc";
	
	PreparedStatement stmt = conn.prepareStatement(sql); 
	stmt.setInt(1,targetYear);
	stmt.setInt(2,targetMonth+1);		//자바는 0~11, mariaDB는 1~12
	//System.out.println("stmt--scheduleList------>"+stmt);
	ResultSet rs= stmt.executeQuery();
	//ResultSet -> ArrayList<schedulee>로 만들거다.
	
	ArrayList<Schedule> scheduleList = new ArrayList<>();
	while(rs.next()){
		Schedule s = new Schedule();
		s.scheduleNo = rs.getInt("scheduleNo");
		s.scheduleMemo = rs.getString("schedulememo");	//다섯글자만 가져온 memo
		s.scheduleDate = rs.getString("scheduleDate");	//일(day)만 가져왔지만 이름은 date
		s.scheduleColor = rs.getString("scheduleColor");
		scheduleList.add(s);
	}
	
	
	
	//전 월의 날짜를 구한다.
	int prevTargetYear = targetYear;
	int prevTargetMonth = targetMonth - 1;	
	//System.out.println(prevTargetYear + "<-- preTargetYear");
	//System.out.println(prevTargetMonth + "<-- preTargetMonth");
	
	// 출력하는 전월 년/월/마지막 날짜 추출
	Calendar prevMonth = Calendar.getInstance();
	prevMonth.set(Calendar.YEAR, prevTargetYear);
	prevMonth.set(Calendar.MONTH, prevTargetMonth);

	//전월의 마지막 날짜 = 달력의 날짜 호출 중 가장 큰 숫자가 마지막 날짜이다.
	int prevEndDateNum = prevMonth.getActualMaximum(Calendar.DATE);
	//System.out.println("prevEndDateNum---->" + prevEndDateNum);

	
	//다음 달 연월
	int nextTargetYear = targetYear;
	int nextTargetMonth = targetMonth + 1;
	//System.out.println(nextTargetMonth + "<-- nextTargetMonth");
	//System.out.println(nextTargetMonth + "<-- nextTargetMonth");
	
	

	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
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
	
	<!-- 위에서는 건드리지 말고 최종 출력인 여기에서 +1을 해준다. 알고리즘에서 돌아가는 숫자랑 출력 숫자가 다른걸 유념하자. -->
	<!-- 만일 위에서 새로 받아 오지 않는다면 달력 API를 불러오는게 아니라 변수를 불러와서 targetYear로하면 13월로 넘어간다. -->
	<div class="container, p2">	
		<h1 align="center">		<%=targetYear %>년 <%=targetMonth+1%>월	</h1>
	</div>
	<div class="container, p2">	
		<!-- 이전 달, 다음 날을 달력 양 끝으로 보내기 위해 테이블 생성-->
		<table style="width:100%">
			<tr>
				<td align="left">
					<a href="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth-1%>">
						&nbsp;&nbsp;&nbsp;이전 달&nbsp;
					</a>
				</td>
				<td align="right">	
					<a href="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth+1%>">
						&nbsp;다음 달&nbsp;&nbsp;&nbsp;
					</a>
				</td>
			</tr>
		</table>
	</div>
	
	
	<div class="container">	
	<table class="table table-bordered " style="table-layout:fixed">
		<thead class="p3">
			<tr>
				<th>일</th>
				<th>월</th>
				<th>화</th>
				<th>수</th>
				<th>목</th>
				<th>금</th>
				<th>토</th>
			</tr>
		</thead>
		
		<tbody class="p2">
		<tr><!-- td 수대로 돌리다가 7로 나누어 떨어지면 tr을 추가하는 방식으로 for문을 하나만 써서 구현한다. -->
			<%	// 달력날짜 찍는 for
				for(int i=0; i<totalTD; i+=1){	//될 수 있으면 조건문은 먼저 써주는게 읽기 편하다.
					int num = i - startBlank + 1;	//실제 찍는 num은 앞의 공백만큼 빼고 + 1 해줘야 한다.
					// 앞뒤 시작 날짜 입력
					int prevMonthDate = prevEndDateNum - startBlank + 1;					
					int nextMonthDate = i - lastDate - startBlank + 1;

					
					if(i !=0 && i%7 == 0){		//i가 0이 아니고 7로 나누어 떨어지면 tr을 써서 행을 추가해준다.
				%>			
						<tr></tr>
				<%
					}
					//스타일 지정을 위한 변수 선언
					String tdStyle="";		
					//0이하, 맥스데이 이후는 공백 출력		
					if(num>0 && num<=lastDate){			
						//오늘 날짜면 (오늘과 년월일이 같으면)
						if( today.get(Calendar.YEAR) == targetYear
								&&today.get(Calendar.MONTH) == targetMonth
								&&today.get(Calendar.DATE) == num){
								tdStyle="background-color:#FFE08C;";
				%>
							<td style=<%=tdStyle%>">
							<p>
								<!-- 처리하는 쪽에서 변수를 조정하기로 했기에(출력시에) 그냥 그대로 값들을 넘겨준다. -->
								<a href="./scheduleListByDate.jsp?y=<%=targetYear%>&m=<%=targetMonth%>&d=<%=num%>" style=color:white>
									<%=num %>
								</a>
								<div><!-- 일정 memo(5글자) -->
									<%
										for(Schedule s: scheduleList){
											if(num == Integer.parseInt(s.scheduleDate)){												
									%>		<!-- 컬러값으로 메모를 출력한다. -->
											<div style="color:<%=s.scheduleColor%>">
												<%=s.scheduleMemo %>											
											</div>
									<%		
											}
										}										
									%>
								</div>
							</p>
							</td>
				<%						
						//주말
						}else if (i % 7 ==0){				%>
							<td><p>
								<a href="./scheduleListByDate.jsp?y=<%=targetYear%>&m=<%=targetMonth%>&d=<%=num%>" style=color:red>
									<%=num %>	
								</a>
								<div><!-- 일정 memo(5글자) -->
									<%
										for(Schedule s: scheduleList){
											if(num == Integer.parseInt(s.scheduleDate)){												
									%>
											<div style="color:<%=s.scheduleColor%>"><%=s.scheduleMemo %></div>
									<%		//컬러값으로 메모를 출력한다.	
											}
										}										
									%>
								</div>
							</p></td>
				<%		//평일
						}else if(i % 7 != 0){
				%>
							<td><p><!-- 날짜 숫자 -->
								<a href="./scheduleListByDate.jsp?y=<%=targetYear%>&m=<%=targetMonth%>&d=<%=num%>" style=color:black >
									<%=num %>
								</a>								
								<div><!-- 일정 memo(5글자) -->
									<%
										for(Schedule s: scheduleList){
											if(num == Integer.parseInt(s.scheduleDate)){												
									%>
											<div style="color:<%=s.scheduleColor%>"><%=s.scheduleMemo %></div>
									<%		//컬러값으로 메모를 출력한다.	
											}
										}										
									%>
								</div>
							</p></td>
				<%
						}
							
					}else if(num<1){			//전달
				%>
						<td><p style="color:#BDBDBD"><%=prevMonthDate + i %></p></td>
				<%
					}else{						//다음 달
				%>					
						<td><p style="color:#BDBDBD"><%=nextMonthDate %></p></td>
				<%	
			
					}
				}	
				%>		
		</tr>
		</tbody>	
	</table>	
	</div>
</div>
</body>
</html>