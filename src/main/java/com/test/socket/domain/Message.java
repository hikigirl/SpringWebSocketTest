package com.test.socket.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter @Setter @ToString
public class Message {
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
	
	private String code;
	private String sender;
	private String receiver;
	private String content;
	private String regdate;
}
