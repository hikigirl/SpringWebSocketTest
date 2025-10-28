package com.test.socket.server;

import java.util.ArrayList;
import java.util.List;

import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

import com.google.gson.Gson;
import com.test.socket.domain.Message;

import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

@ServerEndpoint("/chatserver.do")
public class ChatServer {
	//현재 서버에 접속한 모든 클라이언트들
	private static List<User> sessionList;
	static {
		sessionList = new ArrayList<User>();
	}
	//내부 클래스
	@NoArgsConstructor @AllArgsConstructor
	class User {
		public String name;
		public Session session;
	}
	
	@OnOpen
	public void handleOpen(Session session) { //javax.websocket.session 클래스
		System.out.println("[LOG] 클라이언트와 접속되었습니다.");
		User user = new User(null, session);
		sessionList.add(user);
		System.out.println(sessionList);
	}
	@OnClose
	public void handleClose() {
		System.out.println("[LOG] 클라이언트와 접속이 끊겼습니다.");
	}
	@OnMessage
	public void handleMessage(String message, Session session) {
		
		System.out.println("[LOG] 클라이언트가 보낸 메세지: " + message);
		//문자열 -> 파싱+매핑 ->Message(DTO) 객체
		//Gson 활용
		Gson gson = new Gson();
		Message mdto = gson.fromJson(message, Message.class);
		
		System.out.println("[LOG] 클라이언트가 보낸 메세지 파싱: " + mdto);
		
		if(mdto.getCode().equals("1")) {
			//접속한 유저
			User user = null;
			for (User s: sessionList) {
				if(s.session == session){
					user = s;
					break;
				}
			}
			user.name = mdto.getSender();
			//System.out.println(sessionList);
			//나머지 유저들에게 알려주기
			for (User s : sessionList) {
				if(s.session != session) {
					//broadcast
					//각각의 연결된 소켓으로 메세지 전달
					try {
						s.session.getBasicRemote().sendText(message); //상태코드 1번 메세지
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
		} else if (mdto.getCode().equals("2")) {
			//유저가 나갔을 때
			User user = null;
			for (User s :sessionList) {
				if(s.session == session) {
					user = s;
				}
			}
			sessionList.remove(user);
			
			//broadcast
			for (User s :sessionList) {
				try {
					s.session.getBasicRemote().sendText(message); //상태코드 2번 메세지
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		} else if (mdto.getCode().equals("3")) {
			//누군가가 전역 메세지를 전송했을 때 => 모든 사람에게 전달
			for (User s :sessionList) {
				if(s.session!=session) {
					try {
						s.session.getBasicRemote().sendText(message); //상태코드 3번 메세지
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
		} else if (mdto.getCode().equals("4")) {
			//귓속말
			for (User s :sessionList) {
				if(s.name.equals(mdto.getReceiver())) {
					try {
						s.session.getBasicRemote().sendText(message); //상태코드 4번 메세지
					} catch (Exception e) {
						e.printStackTrace();
					}
					break;
				}
			}
		}
		
	}
	@OnError
	public void handleError(Throwable e) {
		System.out.println("[LOG] 에러 발생: " + e.getMessage());
	}
	
}
