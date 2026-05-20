<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Qcm" %>
<%@ page import="model.Etudiant" %>
<jsp:include page="fragments/head.jsp">
    <jsp:param name="pageTitle" value="Examen en cours — ExamQCM"/>
</jsp:include>
<jsp:include page="fragments/navbar.jsp"/>

<%
    Etudiant etu = (Etudiant) request.getAttribute("etudiant");
    List<Qcm> questions = (List<Qcm>) request.getAttribute("questions");
    int totalQ = (questions != null) ? questions.size() : 0;
    String etuName = (etu != null) ? etu.getNom() + " " + etu.getPrenoms() : "";
%>

<!-- Timer Bar -->
<div class="exam-timer-bar" id="examTimerBar">
    <div class="exam-timer" id="examTimerDisplay">
        <i class="bi bi-clock exam-timer-icon"></i>
        <span id="examTimerText">30:00</span>
    </div>
    <div class="exam-progress-wrap">
        <div class="exam-progress-label">
            <span>Progression</span>
            <span id="progressLabel">0 / <%=totalQ%> répondu(es)</span>
        </div>
        <div class="exam-progress">
            <div class="exam-progress-fill" id="examProgressFill" style="width:0%"></div>
        </div>
    </div>
    <div style="font-size:0.8rem;font-weight:600;color:var(--app-muted);display:flex;align-items:center;gap:0.5rem;">
        <i class="bi bi-person-circle" style="color:var(--app-primary);font-size:1rem;"></i>
        <%=etuName%>
    </div>
</div>

<div class="mb-4">
    <!-- Info étudiant -->
    <div class="app-panel mb-3 anim-fade-in" style="border-left:4px solid var(--app-primary);">
        <div class="app-panel-body" style="display:flex;align-items:center;gap:1rem;padding:1rem 1.5rem;">
            <div class="avatar-initials" style="width:42px;height:42px;font-size:0.9rem;">
                <%=etuName.length()>0 ? etuName.substring(0,1).toUpperCase() : "?"%>
            </div>
            <div>
                <p class="mb-0" style="font-weight:700;font-size:0.95rem;color:var(--app-text);"><%=etuName%></p>
                <p class="mb-0" style="font-size:0.8rem;color:var(--app-muted);">
                    <i class="bi bi-collection-fill" style="color:var(--app-primary);"></i>
                    <%=totalQ%> question<%=totalQ>1?"s":""%> à répondre
                </p>
            </div>
        </div>
    </div>

    <!-- Questions -->
    <form method="post" action="${pageContext.request.contextPath}/examen" id="examForm">
        <input type="hidden" name="action" value="submit"/>
        <%
            String[] labels = {"A","B","C","D"};
            int i = 1;
            if (questions != null) {
                for (Qcm q : questions) {
                    String[] reps = {q.getReponse1(), q.getReponse2(), q.getReponse3(), q.getReponse4()};
        %>
        <div class="question-card anim-fade-in" data-qnum="<%=q.getNumQuest()%>">
            <div class="question-text">
                <span class="question-num"><%=i++%></span>
                <%=q.getQuestion()%>
            </div>
            <% for (int ri=0; ri<4; ri++) {
                if (reps[ri] == null || reps[ri].isEmpty()) continue; %>
            <label class="answer-option" for="q<%=q.getNumQuest()%>r<%=(ri+1)%>">
                <input class="form-check-input exam-radio" type="radio"
                       name="q_<%=q.getNumQuest()%>" value="<%=(ri+1)%>"
                       id="q<%=q.getNumQuest()%>r<%=(ri+1)%>"
                       data-qnum="<%=q.getNumQuest()%>">
                <span class="answer-letter"><%=labels[ri]%></span>
                <span style="font-size:0.875rem;"><%=reps[ri]%></span>
            </label>
            <% } %>
        </div>
        <% } } %>

        <div class="text-center mt-4 mb-3">
            <button type="submit" class="btn-submit-exam" id="submitExamBtn">
                <i class="bi bi-send-fill"></i> Valider l'examen
            </button>
        </div>
    </form>
</div>

<script>
// ─── Timer ───
(function() {
    var totalSeconds = 30 * 60;
    var displayEl = document.getElementById('examTimerText');
    var timerEl   = document.getElementById('examTimerDisplay');

    function updateTimer() {
        var m = Math.floor(totalSeconds / 60);
        var s = totalSeconds % 60;
        displayEl.textContent = String(m).padStart(2,'0') + ':' + String(s).padStart(2,'0');
        if (totalSeconds <= 300) {
            timerEl.className = 'exam-timer warning';
        }
        if (totalSeconds <= 60) {
            timerEl.className = 'exam-timer danger';
        }
        if (totalSeconds <= 0) {
            clearInterval(iv);
            document.getElementById('examForm').submit();
        }
        totalSeconds--;
    }

    updateTimer();
    var iv = setInterval(updateTimer, 1000);
})();

// ─── Progress Bar ───
(function() {
    var radios = document.querySelectorAll('.exam-radio');
    var total  = <%=totalQ%>;
    var answered = {};

    function update() {
        var count = Object.keys(answered).length;
        var pct   = total > 0 ? (count / total * 100) : 0;
        document.getElementById('examProgressFill').style.width = pct + '%';
        document.getElementById('progressLabel').textContent = count + ' / ' + total + ' répondu(es)';
    }

    radios.forEach(function(r) {
        r.addEventListener('change', function() {
            answered[r.getAttribute('data-qnum')] = true;
            update();
        });
    });
})();
</script>

<jsp:include page="fragments/footer.jsp"/>
