<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String ctx = request.getContextPath();
    String uri = request.getRequestURI();
    if (uri == null) { uri = ""; }
    String examAction = request.getParameter("action");
    if (examAction == null) { examAction = ""; }
    boolean navEtud       = uri.contains("/etudiant");
    boolean navQcm        = uri.contains("/qcm");
    boolean navNotes      = "notes".equals(examAction);
    boolean navClassement = "classement".equals(examAction);
    boolean navExamenFlow = uri.contains("/examen") && !navNotes && !navClassement;
    boolean navHome       = uri.endsWith("/index.jsp") || uri.endsWith("/");

    boolean loggedIn = false;
    String userEmail = "";
    String userInitials = "";
    String role = "";
    if (session != null) {
        model.Utilisateur utilisateur = (model.Utilisateur) session.getAttribute("utilisateur");
        if (utilisateur != null) {
            loggedIn = true;
            userEmail = utilisateur.getEmail();
            role = utilisateur.getRole();
            if (userEmail != null && userEmail.length() > 0) {
                userInitials = userEmail.substring(0, 1).toUpperCase();
                if (userEmail.contains("@")) {
                    userInitials = userEmail.substring(0, 1).toUpperCase();
                }
            }
        }
    }
%>
<nav class="navbar navbar-expand-lg navbar-dark app-navbar">
    <div class="container-fluid app-shell">
        <a class="navbar-brand" href="<%=ctx%>/index.jsp">
            <span class="navbar-brand-icon"><i class="bi bi-mortarboard-fill"></i></span>
            <span><span class="navbar-brand-accent">Exam</span>QCM</span>
        </a>
        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Menu">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <% if (loggedIn) { %>
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <% if ("ADMIN".equals(role)) { %>
                        <li class="nav-item">
                            <a class="nav-link <%= navHome ? "active" : "" %>" href="<%=ctx%>/index.jsp">
                                <i class="bi bi-house"></i> Accueil
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <%= navEtud ? "active" : "" %>" href="<%=ctx%>/etudiants">
                                <i class="bi bi-people-fill"></i> Étudiants
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <%= navQcm ? "active" : "" %>" href="<%=ctx%>/qcm">
                                <i class="bi bi-question-circle-fill"></i> QCM
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <%= navClassement ? "active" : "" %>" href="<%=ctx%>/examen?action=classement">
                                <i class="bi bi-trophy-fill"></i> Classement
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <%= navNotes ? "active" : "" %>" href="<%=ctx%>/examen?action=notes">
                                <i class="bi bi-journal-check"></i> Notes
                            </a>
                        </li>
                    <% } else { %>
                        <li class="nav-item">
                            <a class="nav-link <%= navHome ? "active" : "" %>" href="<%=ctx%>/index.jsp">
                                <i class="bi bi-house"></i> Accueil
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <%= navExamenFlow ? "active" : "" %>" href="<%=ctx%>/examen">
                                <i class="bi bi-file-earmark-text-fill"></i> Examen
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <%= navClassement ? "active" : "" %>" href="<%=ctx%>/examen?action=classement">
                                <i class="bi bi-trophy-fill"></i> Classement
                            </a>
                        </li>
                    <% } %>
                </ul>

                <ul class="navbar-nav ms-auto">
                    <!-- User dropdown -->
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle d-flex align-items-center text-white text-decoration-none" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <div style="width:34px;height:34px;border-radius:50%;background:rgba(255,255,255,0.2);
                                        display:flex;align-items:center;justify-content:center;
                                        font-weight:700;font-size:0.85rem;color:#fff;flex-shrink:0;">
                                <%=userInitials%>
                            </div>
                            <div class="ms-2">
                                <div style="font-size:0.75rem;color:rgba(255,255,255,0.7);line-height:1;">Connecté en tant que</div>
                                <div style="font-size:0.8rem;font-weight:700;color:#fff;line-height:1.3;">
                                    <span style="background:rgba(255,255,255,0.2);padding:0.1em 0.5em;border-radius:999px;font-size:0.7rem;"><%=role%></span>
                                </div>
                            </div>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <!-- Thème -->
                            <li>
                                <button class="dropdown-item" id="themeToggle" type="button">
                                    <i class="bi bi-moon-stars-fill me-2"></i> Changer de thème
                                </button>
                            </li>
                            <!-- Déconnexion -->
                            <li>
                                <a class="dropdown-item" href="<%=ctx%>/logout">
                                    <i class="bi bi-box-arrow-right me-2"></i> Déconnexion
                                </a>
                            </li>
                        </ul>
                    </li>
                </ul>
            <% } else { %>
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link btn btn-sm ms-2" style="background:rgba(255,255,255,0.2);border-radius:0.5rem;color:#fff!important;"
                           href="<%=ctx%>/login.jsp">
                            <i class="bi bi-box-arrow-in-right"></i> Connexion
                        </a>
                    </li>
                </ul>
            <% } %>
        </div>
    </div>
</nav>
<main class="app-main">
<div class="app-shell py-4">
