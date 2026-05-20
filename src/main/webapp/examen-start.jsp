<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="model.Utilisateur, model.Etudiant, dao.EtudiantDAO" %>
<%
    Utilisateur examUser = (Utilisateur) session.getAttribute("utilisateur");
    Etudiant examEtu = null;
    if (examUser != null && examUser.getEmail() != null) {
        try {
            examEtu = new EtudiantDAO().findByEmail(examUser.getEmail());
        } catch (Exception ignored) {}
    }
    String numEtu = (examEtu != null) ? examEtu.getNumEtudiant() : "";
%>
<jsp:include page="fragments/head.jsp">
    <jsp:param name="pageTitle" value="Passer un examen — ExamQCM"/>
</jsp:include>
<jsp:include page="fragments/navbar.jsp"/>

<div class="exam-start-wrapper anim-fade-in">
    <div class="exam-start-card">
        <div class="exam-start-icon">
            <i class="bi bi-file-earmark-text-fill"></i>
        </div>
        <h1 class="exam-start-title">Démarrer l'examen</h1>
        <p class="exam-start-sub">
            Confirmez votre numéro étudiant et saisissez l'année universitaire en cours pour accéder à l'examen QCM.
            Assurez-vous d'être prêt avant de commencer.
        </p>

        <%
            String erreur = (String) request.getAttribute("erreur");
            if (erreur != null) {
        %>
        <div class="alert alert-danger mb-3" style="text-align:left;">
            <i class="bi bi-exclamation-triangle-fill" style="flex-shrink:0;"></i>
            <span><%=erreur%></span>
        </div>
        <% } %>

        <form method="post" action="${pageContext.request.contextPath}/examen" style="text-align:left;">
            <input type="hidden" name="action" value="start"/>
            <div class="mb-3">
                <label class="form-label">
                    <i class="bi bi-person-badge-fill" style="color:var(--app-primary);"></i> Numéro étudiant
                </label>
                <div class="input-group-modern">
                    <i class="bi bi-person input-icon"></i>
                    <input type="text" name="numEtudiant" class="form-control" required
                           value="<%=numEtu%>" <%=numEtu.isEmpty() ? "" : "readonly"%>>
                </div>
                <% if (!numEtu.isEmpty()) { %>
                <small class="form-text" style="color:var(--app-muted);">Numéro détecté automatiquement depuis votre compte.</small>
                <% } %>
            </div>
            <div class="mb-4">
                <label class="form-label">
                    <i class="bi bi-calendar-event-fill" style="color:var(--app-primary);"></i> Année universitaire
                </label>
                <div class="input-group-modern">
                    <i class="bi bi-calendar input-icon"></i>
                    <input type="text" name="anneeUniv" class="form-control" required placeholder="ex : 2024-2025">
                </div>
            </div>
            <button type="submit" class="btn-start-exam">
                <i class="bi bi-play-fill"></i> Commencer l'examen
            </button>
        </form>

        <div class="mt-3 pt-3" style="border-top:1px solid var(--app-border);">
            <p class="mb-0" style="font-size:0.78rem;color:var(--app-muted);display:flex;align-items:center;gap:0.5rem;">
                <i class="bi bi-info-circle"></i>
                Une fois l'examen commencé, répondez à toutes les questions avant de soumettre.
            </p>
        </div>
    </div>
</div>

<jsp:include page="fragments/footer.jsp"/>
