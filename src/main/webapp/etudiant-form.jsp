<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="model.Etudiant" %>
<jsp:include page="fragments/head.jsp">
    <jsp:param name="pageTitle" value="Fiche étudiant"/>
</jsp:include>
<jsp:include page="fragments/navbar.jsp"/>

<div class="app-panel">
    <div class="app-panel-header">
        <h1 class="h4 mb-0">Fiche étudiant</h1>
        <a class="btn btn-app-outline" href="${pageContext.request.contextPath}/etudiants">Retour</a>
    </div>
    <div class="app-panel-body">
        <%
            Etudiant e = (Etudiant) request.getAttribute("etudiant");
            if (e == null) {
                e = new Etudiant();
            }
        %>
        <form method="post" action="${pageContext.request.contextPath}/etudiants">
            <input type="hidden" name="action" value="save"/>
            <div class="mb-3">
                <label class="form-label">Numéro étudiant</label>
                <input type="text" name="numEtudiant" class="form-control"
                       value="<%=e.getNumEtudiant() == null ? "" : e.getNumEtudiant()%>"
                        <%=e.getNumEtudiant() != null && !e.getNumEtudiant().isEmpty() ? "readonly" : ""%> required>
            </div>
            <div class="mb-3">
                <label class="form-label">Nom</label>
                <input type="text" name="nom" class="form-control"
                       value="<%=e.getNom() == null ? "" : e.getNom()%>" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Prénoms</label>
                <input type="text" name="prenoms" class="form-control"
                       value="<%=e.getPrenoms() == null ? "" : e.getPrenoms()%>" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Niveau</label>
                <select name="niveau" class="form-select" required>
                    <%
                        String[] niveaux = {"L1", "L2", "L3", "M1", "M2"};
                        for (String n : niveaux) {
                            String selected = n.equals(e.getNiveau()) ? "selected" : "";
                    %>
                    <option value="<%=n%>" <%=selected%>><%=n%></option>
                    <% } %>
                </select>
            </div>
            <div class="mb-3">
                <label class="form-label">Adresse email</label>
                <input type="email" name="adrEmail" class="form-control"
                       value="<%=e.getAdrEmail() == null ? "" : e.getAdrEmail()%>">
            </div>
            <button type="submit" class="btn btn-app-primary">Enregistrer</button>
            <a href="${pageContext.request.contextPath}/etudiants" class="btn btn-outline-secondary">Annuler</a>
        </form>
    </div>
</div>

<jsp:include page="fragments/footer.jsp"/>
