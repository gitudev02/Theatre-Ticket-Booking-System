package com.theatre.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();

        // Public pages that don't require authentication
        boolean isPublicPage = requestURI.endsWith("login.jsp") ||
                requestURI.endsWith("register.jsp") ||
                requestURI.endsWith("index.jsp") ||
                requestURI.contains("/login") ||
                requestURI.contains("/register") ||
                requestURI.contains("/css/") ||
                requestURI.contains("/js/") ||
                requestURI.contains("/images/") ||
                requestURI.equals(contextPath + "/");

        // Check if user is logged in
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);

        // Admin pages check
        boolean isAdminPage = requestURI.contains("/admin/");
        boolean isAdmin = false;

        if (isLoggedIn && session.getAttribute("role") != null) {
            isAdmin = session.getAttribute("role").equals("admin");
        }

        if (isPublicPage || isLoggedIn) {
            // If trying to access admin page but not admin, redirect
            if (isAdminPage && !isAdmin) {
                httpResponse.sendRedirect(contextPath + "/movieList");
                return;
            }
            chain.doFilter(request, response);
        } else {
            // Redirect to login page
            httpResponse.sendRedirect(contextPath + "/login.jsp");
        }
    }

    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}