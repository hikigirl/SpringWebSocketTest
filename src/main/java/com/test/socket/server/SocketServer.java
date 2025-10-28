package com.test.socket.server;

import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.server.ServerEndpoint;

//종단점(IP주소+포트번호) 생성 + 서버에게 부여
@ServerEndpoint("/server.do")
public class SocketServer {
	//여러가지 이벤트 구현
	//클라이언트가 연결 요청을 했을 때 발생 + 연결 요청은 자동으로 수락
	// - 이 이벤트가 발생했다면 이미 클라이언트와 연결이 성공된 상태
	@OnOpen
	public void handleOpen(){
		System.out.println("[LOG] 클라이언트와 접속되었습니다.");
	}
	
	//연결 종료
	@OnClose
	public void handleClose(){
		System.out.println("[LOG] 클라이언트와 연결 해제되었습니다.");
	}
	
	//클라이언트가 메세지를 전송 -> 서버가 수신할 때 발생
	@OnMessage
	public String handleMessage(String msg) {
		System.out.println("[LOG] 클라이언트가 보낸 메세지: " + msg);
		return msg; //클라이언트에게 전송 -> echo
	}
	
	//에러 발생 시
	@OnError
	public void handleError(Throwable e) {
		System.out.println("[LOG] 에러 발생: " + e.getMessage());
	}
}
