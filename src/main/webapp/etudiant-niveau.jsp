<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Etudiant" %>
<jsp:include page="fragments/head.jsp">
    <jsp:param name="pageTitle" value="Étudiants par niveau"/>
</jsp:include>
<jsp:include page="fragments/navbar.jsp"/>

<div class="app-panel mb-3">
    <div class="app-panel-header">
        <div>
            <h1 class="h4 mb-1">Étudiants du niveau ${niveau}</h1>
            <span class="app-stat-pill">Effectif total pour ce niveau : <strong class="ms-1">${effectif}</strong></span>
        </div>
        <a class="btn btn-app-outline" href="${pageContext.request.contextPath}/etudiants">Retour à la liste</a>
    </div>
    <div class="app-panel-body p-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead>
                <tr>
                    <th>Numéro</th>
                    <th>Nom</th>
                    <th>Prénoms</th>
                    <th>Email</th>
                </tr>
                </thead>
                <tbody>
                <%
                    List<Etudiant> etudiants = (List<Etudiant>) request.getAttribute("etudiants");
                    if (etudiants != null && !etudiants.isEmpty()) {
                        for (Etudiant et : etudiants) {
                %>
                <tr>
                    <td><%=et.getNumEtudiant()%></td>
                    <td><%=et.getNom()%></td>
                    <td><%=et.getPrenoms()%></td>
                    <td><%=et.getAdrEmail()%></td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="4" class="text-center py-4 text-muted">Aucun étudiant pour ce niveau.</td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="fragments/footer.jsp"/>
