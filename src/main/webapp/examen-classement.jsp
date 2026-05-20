<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<jsp:include page="fragments/head.jsp">
    <jsp:param name="pageTitle" value="Classement — ExamQCM"/>
</jsp:include>
<jsp:include page="fragments/navbar.jsp"/>

<%
    List<String[]> classement = (List<String[]>) request.getAttribute("classement");
%>

<!-- En-tête -->
<div class="app-panel mb-4 anim-fade-in">
    <div class="app-panel-header">
        <div style="display:flex;align-items:center;gap:0.75rem;">
            <div class="panel-icon" style="background:rgba(245,158,11,0.12);color:var(--app-gold);">
                <i class="bi bi-trophy-fill"></i>
            </div>
            <div>
                <h1 class="h5 mb-0" style="font-weight:800;">Classement des étudiants</h1>
                <span class="app-stat-pill mt-1 d-inline-flex" style="background:rgba(245,158,11,0.1);border-color:rgba(245,158,11,0.2);color:#b45309;">
                    <i class="bi bi-bar-chart-fill"></i>
                    <%= classement != null ? classement.size() : 0 %> résultat(s)
                </span>
            </div>
        </div>
    </div>

    <!-- Podium Top 3 -->
    <% if (classement != null && classement.size() >= 1) { %>
    <div class="app-panel-body">
        <p class="section-title"><i class="bi bi-stars"></i> Podium</p>
        <div class="podium-section">
            <%
                String[][] top = new String[3][];
                for (int pi=0; pi<Math.min(3, classement.size()); pi++) {
                    top[pi] = classement.get(pi);
                }
                // Ordre : 2e, 1er, 3e
                int[] order = {1, 0, 2};
                String[] podiumClass = {"podium-2","podium-1","podium-3"};
                String[] rankLabels  = {"2","1","3"};
                for (int pi=0; pi<3; pi++) {
                    int ri = order[pi];
                    if (top[ri] == null) continue;
                    String pName  = top[ri][2]; // Nom et prénoms
                    String pNote  = top[ri][4];
                    String pInit  = (pName != null && pName.length()>0) ? pName.substring(0,1).toUpperCase() : "?";
            %>
            <div class="podium-item <%=podiumClass[pi]%>">
                <% if (ri == 0) { %><div class="podium-crown">👑</div><% } %>
                <div class="podium-avatar"><%=pInit%></div>
                <div class="podium-name"><%=pName%></div>
                <div class="podium-note"><%=pNote%>/10</div>
                <div class="podium-block"><%=rankLabels[pi]%></div>
            </div>
            <% } %>
        </div>
    </div>
    <% } %>
</div>

<!-- Tableau complet -->
<div class="app-panel anim-fade-in anim-delay-1">
    <div class="app-panel-header">
        <div style="display:flex;align-items:center;gap:0.6rem;">
            <i class="bi bi-table" style="color:var(--app-primary);"></i>
            <span style="font-weight:700;font-size:0.95rem;">Classement complet</span>
        </div>
    </div>
    <div class="app-panel-body p-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead>
                <tr>
                    <th style="width:60px;">Rang</th>
                    <th>Nom et prénoms</th>
                    <th>N° étudiant</th>
                    <th>N° examen</th>
                    <th>Année univ.</th>
                    <th>Note</th>
                </tr>
                </thead>
                <tbody>
                <%
                    if (classement != null && !classement.isEmpty()) {
                        int rang = 1;
                        for (String[] row : classement) {
                            String rangClass = rang==1?"rang-1":rang==2?"rang-2":rang==3?"rang-3":"rang-other";
                            double noteNum = 0;
                            try { noteNum = Double.parseDouble(row[4]); } catch(Exception ignored) {}
                            String noteBadge = noteNum>=5?"badge-note-high":(noteNum>=3?"badge-note-mid":"badge-note-low");
                            int barWidth = (int)(noteNum * 10);
                            String nom = row[2];
                            String init = (nom!=null&&nom.length()>0)?nom.substring(0,1).toUpperCase():"?";
                %>
                <tr>
                    <td>
                        <span class="rang-badge <%=rangClass%>"><%=rang%></span>
                    </td>
                    <td>
                        <div style="display:flex;align-items:center;gap:0.65rem;">
                            <div class="avatar-initials" style="width:32px;height:32px;font-size:0.75rem;"><%=init%></div>
                            <span style="font-weight:600;font-size:0.875rem;"><%=nom%></span>
                        </div>
                    </td>
                    <td><code style="background:var(--app-surface-2);padding:0.2em 0.5em;border-radius:6px;font-size:0.8rem;"><%=row[1]%></code></td>
                    <td style="font-size:0.85rem;color:var(--app-muted);"><%=row[0]%></td>
                    <td>
                        <span style="background:var(--app-surface-2);padding:0.2em 0.6em;border-radius:6px;font-size:0.8rem;font-weight:500;"><%=row[3]%></span>
                    </td>
                    <td>
                        <div class="note-bar-wrap">
                            <div class="note-bar">
                                <div class="note-bar-fill" style="width:<%=barWidth%>%"></div>
                            </div>
                            <span class="badge <%=noteBadge%> px-2 py-1"><%=row[4]%>/10</span>
                        </div>
                    </td>
                </tr>
                <%      rang++; }
                    } else { %>
                <tr>
                    <td colspan="6" class="text-center py-5">
                        <div style="display:flex;flex-direction:column;align-items:center;gap:0.75rem;color:var(--app-muted);">
                            <i class="bi bi-trophy" style="font-size:2.5rem;opacity:0.3;"></i>
                            <span style="font-size:0.9rem;">Aucune note disponible pour le classement.</span>
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
