package com.granite.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String path = request.getRequestURI();

        // Allow login resources
        if (path.endsWith("login.jsp") || path.endsWith("/login")
                || path.contains("/css") || path.contains("/js")) {
            chain.doFilter(req, res);
            return;
        }

        HttpSession session = request.getSession(false);
        boolean loggedIn = session != null && session.getAttribute("loggedIn") != null;

        if (loggedIn) {
            chain.doFilter(req, res);
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }
}
