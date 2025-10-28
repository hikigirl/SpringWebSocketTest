# WebSocketTest

- new - spring legacy project - spring mvc project
- project name: `WebSocketTest`
- root package: `com.test.socket`

---

#### 자바 버전과 pom.xml 수정

- 프로젝트 우클릭 -> Project Facets -> Java 11
- properties 태그에 있는 java-version 11
- 그 아래 스프링 버전 5.0.7.RELEASE로
- 맨 아래쪽 plugin 태그 -> maven plugin 내부
  - configuration 태그 내부 source, target 내부 11로 변경
- 의존성 추가 필요
  - Lombok, WebSocket, gson

---

#### 파일, 패키지

##### src/main/java - Controller
- com.test.socket.controller
  - `SocketController.java`: jsp 띄우기 용(그냥 컨트롤러)
- com.test.socket.server
  - `SocketServer.java`: 서버

##### src/main/webapp - View
- WEB-INF/views
  - `test.jsp`: 클라이언트

---
- 1:1 통신 예시
- 서버: 스프링
- 클라이언트: 자바스크립트




<!-- 
#### MyBatis 세팅
1. pom.xml
   1. log4j -> 1.2.17
   2. Servlet -> 3.1.0
   3. JSP 2.3.3
   4. Lombok
   5. JDBC
   6. MyBatis
   7. HikariCP
2. root-context.xml
3. 기타 등등...
4. 설정이 끝나고 나면 단위테스트 필수

---

##### Swagger 세팅하기
- API 문서 자동화 + 테스트하기
  - 도움말 만들기 + Postman처럼 테스트 환경 만들기

---
#### REST API 서버 구축
- 클라이언트: 브라우저(Ajax), 모바일 앱, JavaScript Framework 등
- 요청 URI -> Restful 설계
- 요청/응답 데이터: JSON 기반
- 주 업무: tblAddress에 대한 CRUD

#### REST API 개발 -> 테스트용 클라이언트 도구 필요함
- 브라우저: 테스트 용도로 부적합
  - GET메서드 테스트는 쉽지만 POST는 jsp가 반드시 있어야 해서 불편
  - PUT, PATCH, DELETE 메서드: 테스트 불가(폼태그에는 GET, POST만 작성 가능)
- cmd창: curl 명령어(프로그램) -> 임시 테스트용
- 전문적인 REST Client Tool => Best
  - __Postman__, Insomnia, __VS Code__, __Swagger__ 등...
  - VS Code는 Rest Client라는 확장 프로그램 설치하였음. -->
