package com.brainbackdoor;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;

import java.io.IOException;

@WebFilter("/*")
public class CharacterEncodingFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        request.getServletContext().log("doFilter() 호출");
        response.setCharacterEncoding("UTF-8");
        chain.doFilter(request, response);

        String responseContent = response.getCharacterEncoding();
        System.out.println("responseContent = " + responseContent);
    }
}
