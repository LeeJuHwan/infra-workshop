package com.brainbackdoor;

import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;


@WebServlet(name = "sharedCounterServlet", urlPatterns = "/shared-counter")
public class SharedCounterServlet extends HttpServlet {

    /**
     * ❗아래 변수는 문제가 있다.
     * 서블릿의 인스턴스 변수는 다른 스레드와 공유된다.
     * 서버는 여러 스레드에서 접근 가능하므로 서블릿에서 비즈니스 로직을 처리할 때 인스턴스 변수는 사용하지 않는다.
     */
    private Integer sharedCounter;

    @Override
    public void init(final ServletConfig config) throws ServletException {
        super.init(config);
        getServletContext().log("init() 호출");
        sharedCounter = 0;
    }

    @Override
    protected void service(final HttpServletRequest request, final HttpServletResponse response) throws IOException {
        getServletContext().log("service() 호출");
        sharedCounter++;
        response.getWriter().write(String.valueOf(sharedCounter));
    }

    @Override
    public void destroy() {
        getServletContext().log("destroy() 호출");
    }
}
