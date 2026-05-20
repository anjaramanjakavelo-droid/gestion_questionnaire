<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="model.Qcm" %>
<jsp:include page="fragments/head.jsp">
    <jsp:param name="pageTitle" value="Fiche question QCM"/>
</jsp:include>
<jsp:include page="fragments/navbar.jsp"/>

<div class="app-panel">
    <div class="app-panel-header">
        <h1 class="h4 mb-0">Fiche question QCM</h1>
        <a class="btn btn-app-outline" href="${pageContext.request.contextPath}/qcm">Retour</a>
    </div>
    <div class="app-panel-body">
        <%
            Qcm q = (Qcm) request.getAttribute("qcm");
            if (q == null) {
                q = new Qcm();
            }
        %>
        <form method="post" action="${pageContext.request.contextPath}/qcm">
            <input type="hidden" name="action" value="save"/>
            <input type="hidden" name="numQuest"
                   value="<%=q.getNumQuest() == 0 ? "" : String.valueOf(q.getNumQuest())%>">

            <div class="mb-3">
                <label class="form-label">Question</label>
                <textarea name="question" class="form-control" rows="3" required><%=q.getQuestion() == null ? "" : q.getQuestion()%></textarea>
            </div>
            <div class="mb-3">
                <label class="form-label">Réponse 1</label>
                <input type="text" name="reponse1" class="form-control"
                       value="<%=q.getReponse1() == null ? "" : q.getReponse1()%>" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Réponse 2</label>
                <input type="text" name="reponse2" class="form-control"
                       value="<%=q.getReponse2() == null ? "" : q.getReponse2()%>" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Réponse 3</label>
                <input type="text" name="reponse3" class="form-control"
                       value="<%=q.getReponse3() == null ? "" : q.getReponse3()%>">
            </div>
            <div class="mb-3">
                <label class="form-label">Réponse 4</label>
                <input type="text" name="reponse4" class="form-control"
                       value="<%=q.getReponse4() == null ? "" : q.getReponse4()%>">
            </div>
            <div class="mb-3">
                <label class="form-label">Bonne réponse (1 à 4)</label>
                <select name="bonneReponse" class="form-select" required>
                    <%
                        for (int i = 1; i <= 4; i++) {
                            String selected = (q.getBonneReponse() == i) ? "selected" : "";
                    %>
                    <option value="<%=i%>" <%=selected%>><%=i%></option>
                    <% } %>
                </select>
            </div>
            <div class="d-flex gap-2 flex-wrap">
                <% if (q.getNumQuest() > 0) { %>
                <a href="${pageContext.request.contextPath}/qcm?action=delete&amp;id=<%=q.getNumQuest()%>"
                   class="btn btn-outline-danger">Supprimer</a>
                <% } else { %>
                <button type="reset" class="btn btn-outline-danger">Supprimer</button>
                <% } %>
                <a href="${pageContext.request.contextPath}/qcm" class="btn btn-outline-secondary">Annuler</a>
                <button type="submit" class="btn btn-app-primary">Enregistrer</button>
            </div>
        </form>
    </div>
</div>

<jsp:include page="fragments/footer.jsp"/>
