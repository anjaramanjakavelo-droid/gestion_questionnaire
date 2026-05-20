<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Examen" %>
<jsp:include page="fragments/head.jsp">
    <jsp:param name="pageTitle" value="Notes — ExamQCM"/>
</jsp:include>
<jsp:include page="fragments/navbar.jsp"/>

<div class="app-panel anim-fade-in">
    <div class="app-panel-header">
        <div style="display:flex;align-items:center;gap:0.75rem;">
            <div class="panel-icon" style="background:rgba(6,214,160,0.1);color:var(--app-accent);">
                <i class="bi bi-journal-check"></i>
            </div>
            <div>
                <h1 class="h5 mb-0" style="font-weight:800;">Liste des notes</h1>
                <span class="app-stat-pill mt-1 d-inline-flex" style="background:rgba(6,214,160,0.1);border-color:rgba(6,214,160,0.2);color:#059669;">
                    <i class="bi bi-graph-up"></i>
                    Résultats d'examens
                </span>
            </div>
        </div>
    </div>
    <div class="app-panel-body p-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead>
                <tr>
                    <th style="width:60px;">#</th>
                    <th>N° étudiant</th>
                    <th>Année universitaire</th>
                    <th>Note</th>
                </tr>
                </thead>
                <tbody>
                <%
                    List<Examen> examens = (List<Examen>) request.getAttribute("examens");
                    if (examens != null && !examens.isEmpty()) {
                        int rowNum = 1;
                        for (Examen ex : examens) {
                            double noteVal = 0;
                            try { noteVal = Double.parseDouble(String.valueOf(ex.getNote())); } catch(Exception ignored) {}
                            String noteBadge = noteVal>=5?"badge-note-high":(noteVal>=3?"badge-note-mid":"badge-note-low");
                            int barW = (int)(noteVal*10);
                %>
                <tr>
                    <td>
                        <span style="display:inline-flex;align-items:center;justify-content:center;
                                     width:26px;height:26px;border-radius:7px;
                                     background:var(--app-surface-2);color:var(--app-muted);
                                     font-size:0.78rem;font-weight:700;"><%=rowNum++%></span>
                    </td>
                    <td>
                        <code style="background:var(--app-surface-2);padding:0.2em 0.5em;border-radius:6px;font-size:0.82rem;"><%=ex.getNumEtudiant()%></code>
                    </td>
                    <td>
                        <span style="background:var(--app-primary-light);color:var(--app-primary);
                                     padding:0.2em 0.7em;border-radius:6px;font-size:0.82rem;font-weight:600;">
                            <i class="bi bi-calendar-event" style="font-size:0.75rem;"></i> <%=ex.getAnneeUniv()%>
                        </span>
                    </td>
                    <td>
                        <div class="note-bar-wrap">
                            <div class="note-bar">
                                <div class="note-bar-fill" style="width:<%=barW%>%"></div>
                            </div>
                            <span class="badge <%=noteBadge%> px-2 py-1"><%=ex.getNote()%>/10</span>
                        </div>
                    </td>
                </tr>
                <% } } else { %>
                <tr>
                    <td colspan="4" class="text-center py-5">
                        <div style="display:flex;flex-direction:column;align-items:center;gap:0.75rem;color:var(--app-muted);">
                            <i class="bi bi-journal-x" style="font-size:2.5rem;opacity:0.3;"></i>
                            <span style="font-size:0.9rem;">Aucune note enregistrée.</span>
                        </div>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="fragments/footer.jsp"/>
