<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    model.Utilisateur utilisateur = (model.Utilisateur) session.getAttribute("utilisateur");
    if (utilisateur == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    String prenom = utilisateur.getEmail() != null ? utilisateur.getEmail().split("@")[0] : "Utilisateur";
    String role   = utilisateur.getRole() != null ? utilisateur.getRole() : "";
%>
<jsp:include page="fragments/head.jsp">
    <jsp:param name="pageTitle" value="Accueil — ExamQCM"/>
</jsp:include>
<jsp:include page="fragments/navbar.jsp"/>

<!-- Hero section -->
<div class="welcome-hero mb-4 anim-fade-in">
    <div style="position:relative;z-index:1;">
        <div style="display:flex;align-items:center;gap:0.75rem;margin-bottom:0.5rem;">
            <span style="background:rgba(255,255,255,0.2);padding:0.25em 0.85em;border-radius:999px;font-size:0.78rem;font-weight:700;letter-spacing:0.06em;">
                <%= "ADMIN".equals(role) ? "👤 ADMINISTRATEUR" : "🎓 ÉTUDIANT" %>
            </span>
        </div>
        <h1 class="h2 mb-2">Bienvenue, <em style="font-style:normal;color:#fde68a;"><%=prenom%></em> !</h1>
        <p class="lead mb-0">
            <% if ("ADMIN".equals(role)) { %>
            Gérez les étudiants, les questions QCM et consultez les résultats de la plateforme.
            <% } else { %>
            Passez vos examens, consultez vos résultats et votre classement.
            <% } %>
        </p>
    </div>
</div>

<% if ("ADMIN".equals(role)) { %>
<!-- Accès rapides Admin -->
<p class="section-title anim-fade-in anim-delay-1">
    <i class="bi bi-grid-fill"></i> Modules d'administration
</p>
<div class="row g-3 mb-4">
    <div class="col-md-4 col-sm-6 anim-fade-in anim-delay-1">
        <a href="${pageContext.request.contextPath}/etudiants" class="quick-action-card qa-primary">
            <div class="quick-action-icon">
                <i class="bi bi-people-fill"></i>
            </div>
            <div class="quick-action-label">Étudiants</div>
            <div class="quick-action-sub">Liste, recherche, ajout, modification et suppression des étudiants inscrits.</div>
        </a>
    </div>
    <div class="col-md-4 col-sm-6 anim-fade-in anim-delay-2">
        <a href="${pageContext.request.contextPath}/qcm" class="quick-action-card qa-violet">
            <div class="quick-action-icon">
                <i class="bi bi-question-circle-fill"></i>
            </div>
            <div class="quick-action-label">Banque QCM</div>
            <div class="quick-action-sub">Gérez les questions, réponses et les bonnes réponses de la banque QCM.</div>
        </a>
    </div>
    <div class="col-md-4 col-sm-6 anim-fade-in anim-delay-3">
        <a href="${pageContext.request.contextPath}/examen?action=classement" class="quick-action-card qa-gold">
            <div class="quick-action-icon">
                <i class="bi bi-trophy-fill"></i>
            </div>
            <div class="quick-action-label">Classement</div>
            <div class="quick-action-sub">Consultez le classement général et les résultats de tous les examens.</div>
        </a>
    </div>
    <div class="col-md-4 col-sm-6 anim-fade-in anim-delay-1">
        <a href="${pageContext.request.contextPath}/examen?action=notes" class="quick-action-card qa-success">
            <div class="quick-action-icon">
                <i class="bi bi-journal-check"></i>
            </div>
            <div class="quick-action-label">Notes</div>
            <div class="quick-action-sub">Visualisez toutes les notes enregistrées avec les années universitaires.</div>
        </a>
    </div>
</div>

<% } else if ("ETUDIANT".equals(role)) { %>
<!-- Accès rapides Étudiant -->
<p class="section-title anim-fade-in anim-delay-1">
    <i class="bi bi-grid-fill"></i> Mes modules
</p>
<div class="row g-3 mb-4">
    <div class="col-md-6 anim-fade-in anim-delay-1">
        <a href="${pageContext.request.contextPath}/examen" class="quick-action-card qa-primary">
            <div class="quick-action-icon">
                <i class="bi bi-file-earmark-text-fill"></i>
            </div>
            <div class="quick-action-label">Passer un Examen</div>
            <div class="quick-action-sub">Accédez aux examens QCM disponibles pour votre année académique et passez-les en ligne.</div>
        </a>
    </div>
    <div class="col-md-6 anim-fade-in anim-delay-2">
        <a href="${pageContext.request.contextPath}/examen?action=classement" class="quick-action-card qa-gold">
            <div class="quick-action-icon">
                <i class="bi bi-trophy-fill"></i>
            </div>
            <div class="quick-action-label">Classement</div>
            <div class="quick-action-sub">Consultez votre position dans le classement général et comparez vos résultats.</div>
        </a>
    </div>
</div>
<% } %>

<!-- Info ergonomique -->
<div class="app-panel anim-fade-in anim-delay-2" style="border-left:4px solid var(--app-primary);">
    <div class="app-panel-body" style="display:flex;align-items:flex-start;gap:1rem;">
        <div style="width:40px;height:40px;border-radius:12px;background:var(--app-primary-light);
                    display:flex;align-items:center;justify-content:center;font-size:1.2rem;color:var(--app-primary);flex-shrink:0;">
            <i class="bi bi-info-circle-fill"></i>
        </div>
        <div>
            <p class="mb-1" style="font-weight:700;font-size:0.9rem;color:var(--app-text);">Aide rapide</p>
            <% if ("ADMIN".equals(role)) { %>
            <p class="mb-0" style="font-size:0.83rem;color:var(--app-muted);">
                En tant qu'administrateur, vous pouvez gérer les étudiants, la banque de questions et consulter tous les résultats d'examen depuis les modules ci-dessus.
            </p>
            <% } else { %>
            <p class="mb-0" style="font-size:0.83rem;color:var(--app-muted);">
                Pour passer un examen, cliquez sur <strong>Passer un Examen</strong>, saisissez votre numéro étudiant et l'année universitaire. Les résultats seront disponibles immédiatement après soumission.
            </p>
            <% } %>
        </div>
    </div>
</div>

<jsp:include page="fragments/footer.jsp"/>
