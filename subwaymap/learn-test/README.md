<p align="center">
    <img width="200px;" src="https://raw.githubusercontent.com/brainbackdoor/infra-workshop/main/images/main_logo.png"/>
</p>

<h2 align="middle">인프라공방</h2>
<p align="middle">학습 테스트를 위한 저장소</p>
<p align="middle">

<p align="center">
  <img src="https://img.shields.io/badge/language-java-red.svg?style=flat-square"/>
  <img src="https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat-square"/>
</p>

<br>

## 💡 Introduction

학습 테스트를 위한 예제 코드입니다.
- HTTP Cache, gzip 등
- Servlet
- Thread

<br>

## 1. HTTP Cache, gzip 실습

HomeControllerTest 테스트 메소드를 모두 통과시켜 본다.

- 미션1: Cache-Control: no-cache, private 설정을 해본다.
- 미션2: gzip 설정을 해본다.
- 미션3: ETag 설정을 해본다.
- 미션4: 캐시 무효화 설정을 해본다.
- 미션5: Cache-Control: no-store, no-cache, must-revalidate 설정을 해본다.

<br>
<br>

## 2. Servlet 실습

ServletTest와FilterTest 클래스의 모든 테스트를 통과시킨다.

### A. 서블릿 학습 테스트
  - SharedCounterServlet, LocalCounterServlet 클래스를 열어보고 어떤 차이점이 있는지 확인한다.
  - init, service, destroy 메서드가 각각 언제 실행되는지 콘솔 로그에서 확인한다.
  - 직접 톰캣 서버를 띄워보고 싶다면 ServletApp 클래스의 main 메서드를 실행한다. 
    - 웹 브라우저에서 localhost:8080/shared-counter 경로에 접근 가능한지 확인한다.


### B. 필터 학습 테스트
  - doFilter 메서드는 어느 시점에 실행될까? 콘솔 로그에서 확인한다.
  - 왜 인코딩을 따로 설정해줘야 할까?
    - [ServletResponse](https://docs.oracle.com/javaee/7/api/javax/servlet/ServletResponse.html)
    - 위 링크에서 character encoding에 대한 설명을 참고한다.

<br>
<br>

## 3. Thread 실습

ThreadTest와 ThreadPoolsTest 클래스의 모든 테스트를 통과시킨다.

- 미션1: 동기화를 이용해서 쓰레드 간섭을 해결한다.
- 미션2: synchronized 예약어를 사용하지 않고 Thread safe하게 구성한다.
- 미션3: newFixedThreadPool와 newCachedThreadPool의 차이를 구분하고 테스트를 통과시킨다.
