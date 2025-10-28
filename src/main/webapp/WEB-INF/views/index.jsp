<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<link rel="stylesheet" href="http://bit.ly/3WJ5ilK" />
</head>
<body>
	<!-- index.jsp -->
	<h1>WebSocket <small>chat</small></h1>
	<div>
		<div class="group">
			<label>대화명</label>
			<input type="text" id="name" class="short" name="name" autofocus>
		</div>
	</div>
	<div style = "margin-top: 10px;">
		<button type="button" class="in">참여하기</button>
		<hr />
		<button type="button" class="in" data-name="강아지">참여하기(강아지)</button>
		<button type="button" class="in" data-name="고양이">참여하기(고양이)</button>
		<button type="button" class="in" data-name="병아리">참여하기(병아리)</button>
	</div>
	<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
	<script>
		let name; //대화명
		$('.in').click(()=>{
			const child = window.open('/socket/chat.do', 'chat', 'width=406, height=518');
			
			name = $(event.target).data('name');
			if (name== null|| name=='') {
				name = $('#name').val();
			} else {
				$('#name').val(name);
			}
			//참여 후
			$('#name').prop('readOnly', true);
			$('.in').prop('disabled', true);
			
			//name = $('#name').val();
			
			//자식창의 DOM을 모두 로딩한 후에 발생
			child.onload = () => {
				child.connect(name);
			};
		});

	</script>
</body>
</html>