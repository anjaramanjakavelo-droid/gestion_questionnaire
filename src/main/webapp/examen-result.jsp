<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="model.Qcm" %>
<jsp:include page="fragments/head.jsp">
    <jsp:param name="pageTitle" value="Résultat de l'examen — ExamQCM"/>
</jsp:include>
<jsp:include page="fragments/navbar.jsp"/>

<%
    double noteVal = 0;
    try {
        Object noteObj = request.getAttribute("note");
        if (noteObj != null) noteVal = Double.parseDouble(String.valueOf(noteObj));
    } catch (Exception ignored) {}
    String scoreClass = noteVal >= 5 ? "score-high" : (noteVal >= 3 ? "score-mid" : "score-low");
    String scoreMsg   = noteVal >= 5 ? "Félicitations !" : (noteVal >= 3 ? "Pas mal !" : "Courage !");
    String scoreSub   = noteVal >= 5 ? "Vous avez réussi l'examen." : (noteVal >= 3 ? "Vous pouvez faire mieux." : "Continuez à vous entraîner.");
    String scoreIcon  = noteVal >= 5 ? "bi-trophy-fill" : (noteVal >= 3 ? "bi-emoji-neutral-fill" : "bi-emoji-frown-fill");
    List<Qcm> questions = (List<Qcm>) request.getAttribute("questions");
    Map<Integer,Integer> reponsesEtudiant = (Map<Integer,Integer>) request.getAttribute("reponsesEtudiant");
%>

<div class="app-panel mb-4 anim-fade-in">
    <div class="app-panel-body">
        <div class="result-hero">
            <div class="result-score-ring <%=scoreClass%>">
                <span class="result-score-value">${note}</span>
                <span class="result-score-total">/10</span>
            </div>
            <p class="result-msg">
                <i class="bi <%=scoreIcon%>"></i> <%=scoreMsg%>
            </p>
            <p class="result-sub"><%=scoreSub%></p>
            <div class="d-flex gap-2 justify-content-center mt-3">
                <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-app-primary">
                    <i class="bi bi-house-fill"></i> Retour à l'accueil
                </a>
                <a href="${pageContext.request.contextPath}/examen?action=classement" class="btn btn-app-outline">
                    <i class="bi bi-trophy-fill"></i> Voir le classement
                </a>
            </div>
        </div>
    </div>
</div>

<!-- Détail des réponses -->
<div class="app-panel anim-fade-in anim-delay-1">
    <div class="app-panel-header">
        <div style="display:flex;align-items:center;gap:0.6rem;">
            <i class="bi bi-list-check" style="color:var(--app-primary);font-size:1.1rem;"></i>
            <span style="font-weight:700;font-size:0.95rem;">Détail des réponses</span>
        </div>
    </div>
    <div class="app-panel-body">
        <%
            int qi = 1;
            if (questions != null) {
                for (Qcm q : questions) {
                    int repEtu = 0;
                    if (reponsesEtudiant != null && reponsesEtudiant.get(q.getNumQuest()) != null) {
                        repEtu = reponsesEtudiant.get(q.getNumQuest());
                    }
                    boolean correct = (repEtu == q.getBonneReponse());
                    String cardClass = correct ? "correct" : "incorrect";
                    String[] repLabels = {"A","B","C","D"};
                    String repEtuLabel = (repEtu >= 1 && repEtu <= 4) ? repLabels[repEtu-1] : String.valueOf(repEtu);
                    String repBonneLabel = (q.getBonneReponse() >= 1 && q.getBonneReponse() <= 4) ? repLabels[q.getBonneReponse()-1] : String.valueOf(q.getBonneReponse());
                    String[] reps = {q.getReponse1(), q.getReponse2(), q.getReponse3(), q.getReponse4()};
                    String repEtuText = (repEtu >= 1 && repEtu <= 4 && reps[repEtu-1] != null) ? reps[repEtu-1] : "—";
                    String repBonneText = (q.getBonneReponse() >= 1 && q.getBonneReponse() <= 4 && reps[q.getBonneReponse()-1] != null) ? reps[q.getBonneReponse()-1] : "—";
        %>
        <div class="answer-detail-card <%=cardClass%>">
            <div style="display:flex;align-items:flex-start;gap:0.75rem;margin-bottom:0.6rem;">
                <span class="question-num"><%=qi++%></span>
                <div style="flex:1;">
                    <p style="font-weight:600;font-size:0.875rem;margin-bottom:0.5rem;color:var(--app-text);"><%=q.getQuestion()%></p>
                    <div style="display:flex;flex-wrap:wrap;gap:1.5rem;font-size:0.82rem;">
                        <div>
                            <span style="font-weight:600;color:var(--app-muted);">Votre réponse :</span>
                            <span style="font-weight:700;color:<%=correct?"#059669":"#dc2626"%>;">
                                <%=repEtuLabel%> — <%=repEtuText%>
                            </span>
                            <span class="answer-badge <%=cardClass%>">
                                <i class="bi bi-<%=correct?"check-lg":"x-lg"%>"></i>
                                <%=correct?"Correct":"Incorrect"%>
                            </span>
                        </div>
                        <% if (!correct) { %>
                        <div>
                            <span style="font-weight:600;color:var(--app-muted);">Bonne réponse :</span>
                            <span style="font-weight:700;color:#059669;"><%=repBonneLabel%> — <%=repBonneText%></span>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
        <% } } %>
    </div>
</div>

<jsp:include page="fragments/footer.jsp"/>
