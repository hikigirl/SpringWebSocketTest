<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<link rel="stylesheet" href="http://bit.ly/3WJ5ilK" />
	<style>
		html, body {
			padding: 0 !important;
			margin: 0 !important;
			background-color: #FFF !important; 
			display: block;
			overflow: hidden;
		}
		
		body > div {
			margin: 0; 
			padding: 0; 
		}
	
		#main {
			width: 400px;
			height: 510px;
			margin: 3px;
			display: grid;
			grid-template-rows: repeat(12, 1fr);
		}
		
		/* #header {
		
		} */
		
		#header > h2 {		
			margin: 0px;
			margin-bottom: 10px;
			padding: 5px;
		}
	
		#list {
			border: 1px solid var(--border-color);
			box-sizing: content-box;
			padding: .5rem;
			grid-row-start: 2;
			grid-row-end: 12;
			font-size: 14px;
			overflow: auto;
		}
		
		#msg {
			margin-top: 3px;
		}
		
		#list .item {
			font-size: 14px;
			margin: 15px 0;
		}
		
		#list .item > div:first-child {
			display: flex;
		}
		
		#list .item.me > div:first-child {
			justify-content: flex-end;
		}
		
		#list .item.other > div:first-child {
			justify-content: flex-end;
			flex-direction: row-reverse;
		}
		
		#list .item > div:first-child > div:first-child {
			font-size: 10px;
			color: #777;
			margin: 3px 5px;
		}
		
		#list .item > div:first-child > div:nth-child(2) {
			border: 1px solid var(--border-color);
			display: inline-block;
			min-width: 100px;
			max-width: 250px;
			text-align: left;
			padding: 3px 7px;
		}
		
		#list .state.item > div:first-child > div:nth-child(2) {
			background-color: #EEE;
		}
		
		#list .item > div:last-child {
			font-size: 10px;
			color: #777;
			margin-top: 5px;
		}
		
		#list .me {
			text-align: right;
		}
		
		#list .other {
			text-align: left;
		}
		
		#list .msg.me.item > div:first-child > div:nth-child(2) {
			background-color: rgba(255, 99, 71, .2);
		}
		
		#list .msg.other.item > div:first-child > div:nth-child(2) {
			background-color: rgba(100, 149, 237, .2);
		}
		
		#list .secret.me.item > div:first-child > div:nth-child(2) {
			background-color: gold;
		}
		
		#list .secret.other.item > div:first-child > div:nth-child(2) {
			background-color: gold;
		}
		
		#list .msg img {
			width: 150px;
		}
	</style>
</head>
<body>
	<!-- chat.jsp -->
	<div id="main">
		<div id="header">
			<h2>WebSocket <small></small></h2>
		</div>
		<div id="list"></div>
		<input type="text" name="" id="msg" placeholder="대화 내용을 입력하세요.">
	</div>
	<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
	<!-- 날짜 라이브러리(Day.js) -->
	<script src="https://cdn.jsdelivr.net/npm/dayjs@1.11.18/dayjs.min.js"></script>
	<script>
		/*
			클라이언트 <- (전송) -> 서버
			메시지 형식(= 프로토콜(통신 시의 약속) 설계)
			- JSON 형식(= 문자열)

			- code: 상태코드
				- 1: 새로운 사용자 입장
				- 2: 기존 유저가 나감(접속해제)
				- 3: (전역) 메세지 전달
				- 4: (귓속말) 메세지 전달
				- 5: (전역) 이모티콘 전달(서버 참조 방식)
			- sender: 보낸 사람(1명)
			- receiver: 받는 사람(전역(null) 또는 귓속말(유저명))
			- content: 메세지 내용
			- regdate: 발송 날짜, 시간

		*/ 
		let username; //대화명
		let ws; //소켓
		const url = 'ws://localhost:8080/socket/chatserver.do';
		//const url = 'ws://192.168.10.30/:8080/socket/chatserver.do';

		//이 대화창이 처음 실행될 때 => 단톡방에 참여하는 순간
		function connect(name) {
			username = name;
			$('#header small').text(name);
			//서버 접속하기(+ 소켓 생성)
			ws = new WebSocket(url);
			console.log('[LOG] 서버와 접속을 시도합니다.');

			//소켓 이벤트 추가
			ws.onopen = evt => {
				console.log('[LOG] 서버와 접속되었습니다. (접속자: ' + name + ')');
				//내가 누군지를 서버에게 알려주자 -> 다른 사람들도 알게 된다.
				//- 내 이름을 서버에게 전송
				//ws.send('강아지');
				const message = {
					code: '1',
					sender: name,
					receiver: '',
					content:'',
					regdate: dayjs().format('YYYY-MM-DD HH:mm:ss')
				};
				console.log(JSON.stringify(message));
				ws.send(JSON.stringify(message));

				//클라이언트 -> 전송 -> 서버
				//message 객체를 JSON으로 변환 필요
				//ws.send(문자열);

			};
			ws.onclose = evt => {
				console.log('[LOG] 서버와 접속이 끊겼습니다.');
			};
			ws.onmessage = evt => {
				console.log('[LOG] 서버로부터 메세지를 받았습니다.');
				console.log(evt.data);
				//json 문자열 -> 매핑 -> javascript object
				let message = JSON.parse(evt.data);
				if (message.code == '1') {
					print('', `[\${message.sender}]님이 들어왔습니다.`, 'other', 'state', message.regdate);
				} else if (message.code == '2') {
					print('', `[\${message.sender}]님이 나갔습니다.`, 'other', 'state', message.regdate);
				} else if (message.code == '3') {
					print(message.sender, message.content, 'other', 'msg', message.regdate);
				} else if (message.code == '4') {
					print(message.sender, message.content, 'other', 'secret', message.regdate);
				}
				scrollList();
			};
			
			ws.onerror = evt => {
				console.log('[LOG] 오류 발생');
			};

		}

		//창을 닫을 때 발생하는 이벤트
		$(window).on('beforeunload', ()=>{
			//opener.document.title = '창닫음';
			$(opener.document).find('.in').prop('disabled', false);
			$(opener.document).find('#name').val('').prop('readOnly', false).focus();
			disconnect();
		});
		
		function print(name, msg, side, state, time) {
			
			let temp = `
			<div class="item \${state} \${side}">
				<div>
					<div>\${name}</div>
					<div>\${msg}</div>
				</div>
				<div>\${time}</div>
			</div>		
			`;
			
			$('#list').append(temp);
			
		}
		
		function disconnect() {
			// 현재 사용자 나가기
			// - 서버에게 나간다는 메세지 보내기
			const message = {
					code: '2',
					sender: username,
					receiver: '',
					content:'',
					regdate: dayjs().format('YYYY-MM-DD HH:mm:ss')
			};
			ws.send(JSON.stringify(message)); //서버에게 나간다는 메세지 전송
			ws.close(); //소켓 닫기 + 대화방 나가기
		}
		
		//F5와 Ctrl + R 작동 막기
		window.onkeydown = () => {
			if (event.keyCode == 116 || (event.ctrlKey && event.keyCode ==82)) {
				event.preventDefault();
				return false;
			}
		};
		//우클릭 막기
		window.oncontextmenu = () => {
			event.preventDefault();
			return false;
		};
		
		//대화 전송하기(enter키로 전송)
		$('#msg').keydown(evt => {
			if(evt.keyCode==13){

				const regex = /^\/\S{1,}/;
				//console.log(regex.test($(evt.target).val()));
				
				if(regex.test($(evt.target).val())) {
					//귓속말
					const message = {
						code: '4',
						sender: username,
						receiver: $(event.target).val().split(' ')[0].substr(1),
						content: $(event.target).val().substr($(event.target).val().indexOf(' ') + 1),
						regdate: dayjs().format('YYYY-MM-DD HH:mm:ss')
					};
					ws.send(JSON.stringify(message));
					
					print(message.sender, message.content, 'me', 'secret', message.regdate);
					
					$(evt.target).val('').focus();
					scrollList();
				} else {
					//일반 텍스트 메세지
					const message = {
						code: '3',
						sender: username,
						receiver: '',
						content: $(evt.target).val(),
						regdate: dayjs().format('YYYY-MM-DD HH:mm:ss')
					};
					ws.send(JSON.stringify(message));
					
					print(message.sender, message.content, 'me', 'msg', message.regdate);
					
					$(evt.target).val('').focus();
					scrollList();
				}
				
			}
		});
		//대화창 자동스크롤
		function scrollList() {
			$('#list').scrollTop($('#list')[0].scrollHeight + 300);
		}
		
	</script>
</body>
</html>