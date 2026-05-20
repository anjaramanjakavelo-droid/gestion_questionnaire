package servlet;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();

        // Allow access to login page, static resources, and logout
        if (requestURI.endsWith("/login.jsp") ||
                requestURI.contains("/login") ||
                requestURI.contains("/register") ||
                requestURI.contains("/logout") ||
                requestURI.contains("/resources/") ||
                requestURI.contains("/css/") ||
                requestURI.contains("/js/") ||
                requestURI.contains("/fragments/") ||
                requestURI.endsWith(contextPath + "/")) {
            chain.doFilter(request, response);
            return;
        }

        // Check if user is logged in
        if (session == null || session.getAttribute("utilisateur") == null) {
            // Redirect to login page with unauthorized message
            httpResponse.sendRedirect(contextPath + "/login.jsp?unauthorized=true");
            return;
        }

        // Get user role from session
        model.Utilisateur utilisateur = (model.Utilisateur) session.getAttribute("utilisateur");
        String role = utilisateur.getRole();

        // Determine page type
        boolean isAdminPage = requestURI.contains("/etudiants") || requestURI.contains("/qcm");
        boolean isExamenPage = requestURI.contains("/examen");
        boolean isRankingPage = requestURI.endsWith("/examen?action=classement") || 
                                requestURI.endsWith("/examen?action=notes") ||
                                requestURI.contains("classement") || 
                                requestURI.contains("notes");

        // Admin can access everything
        if ("ADMIN".equals(role)) {
            chain.doFilter(request, response);
            return;
        }

        // Etudiant can access exam pages and ranking pages
        if ("ETUDIANT".equals(role)) {
            if (isExamenPage || isRankingPage) {
                chain.doFilter(request, response);
                return;
            } else if (isAdminPage) {
                // Etudiant trying to access admin pages
                httpResponse.sendRedirect(contextPath + "/login.jsp?error=unauthorized");
                return;
            }
        }

        // Default: allow if no specific restriction applies
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}