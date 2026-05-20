<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Qcm" %>
<%
    boolean openModal  = "1".equals(request.getParameter("openModal"));
    String status      = request.getParameter("status");
    String editIdParam = request.getParameter("editId");
    int editId = 0;
    if (editIdParam != null && !editIdParam.isEmpty()) {
        try { editId = Integer.parseInt(editIdParam); } catch (NumberFormatException ignored) {}
    }
    Qcm editQcm = null;
    @SuppressWarnings("unchecked")
    List<Qcm> qcmsForEdit = (List<Qcm>) request.getAttribute("qcms");
    if (editId > 0 && qcmsForEdit != null) {
        for (Qcm item : qcmsForEdit) {
            if (item.getNumQuest() == editId) { editQcm = item; break; }
        }
    }
%>
<jsp:include page="fragments/head.jsp">
    <jsp:param name="pageTitle" value="Questions QCM — ExamQCM"/>
</jsp:include>
<jsp:include page="fragments/navbar.jsp"/>

<%
    String statusMessage = null;
    String statusType = "success";
    if ("added".equals(status))   statusMessage = "Question ajoutée avec succès.";
    else if ("updated".equals(status)) statusMessage = "Question modifiée avec succès.";
    else if ("deleted".equals(status)) statusMessage = "Question supprimée avec succès.";
%>
<% if (statusMessage != null) { %>
<div class="position-fixed top-0 end-0 p-3" style="z-index:1090;margin-top:80px;">
    <div id="actionStatusAlert" class="alert alert-success app-toast-alert shadow-lg" style="min-width:320px;" role="alert">
        <i class="bi bi-check-circle-fill" style="font-size:1.1rem;flex-shrink:0;"></i>
        <span><%=statusMessage%></span>
    </div>
</div>
<% } %>

<div class="app-panel mb-3 anim-fade-in">
    <div class="app-panel-header">
        <div style="display:flex;align-items:center;gap:0.75rem;">
            <div class="panel-icon" style="background:rgba(124,58,237,0.1);color:var(--app-violet);">
                <i class="bi bi-question-circle-fill"></i>
            </div>
            <div>
                <h1 class="h5 mb-0" style="font-weight:800;">Questions QCM</h1>
                <span class="app-stat-pill mt-1 d-inline-flex" style="background:rgba(124,58,237,0.1);border-color:rgba(124,58,237,0.2);color:var(--app-violet);">
                    <i class="bi bi-collection-fill"></i>
                    Banque de questions
                </span>
            </div>
        </div>
        <button type="button" class="btn btn-app-primary" data-bs-toggle="modal" data-bs-target="#modalQcmAjout">
            <i class="bi bi-plus-lg"></i> Nouvelle question
        </button>
    </div>
    <div class="app-panel-body p-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead>
                <tr>
                    <th style="width:50px;">#</th>
                    <th>Question</th>
                    <th>Réponses</th>
                    <th style="width:90px;text-align:center;">Bonne rép.</th>
                    <th class="text-end" style="width:90px;">Actions</th>
                </tr>
                </thead>
                <tbody>
                <%
                    List<Qcm> qcms = (List<Qcm>) request.getAttribute("qcms");
                    if (qcms != null && !qcms.isEmpty()) {
                        String[] repColors = {"rgba(67,97,238,0.1)","rgba(6,214,160,0.1)","rgba(249,115,22,0.1)","rgba(124,58,237,0.1)"};
                        String[] repTextColors = {"#4361ee","#059669","#c2410c","#7c3aed"};
                        for (Qcm q : qcms) {
                            int br = q.getBonneReponse();
                %>
                <tr>
                    <td>
                        <span style="display:inline-flex;align-items:center;justify-content:center;width:28px;height:28px;
                                     border-radius:8px;background:var(--app-primary-light);color:var(--app-primary);
                                     font-weight:700;font-size:0.8rem;"><%=q.getNumQuest()%></span>
                    </td>
                    <td style="max-width:280px;">
                        <span style="font-size:0.875rem;font-weight:500;color:var(--app-text);"><%=q.getQuestion()%></span>
                    </td>
                    <td>
                        <div style="display:flex;flex-direction:column;gap:0.3rem;">
                            <% String[] reps = {q.getReponse1(), q.getReponse2(), q.getReponse3(), q.getReponse4()};
                               String[] lets = {"A","B","C","D"};
                               for (int ri=0; ri<4; ri++) {
                                   if (reps[ri] == null || reps[ri].isEmpty()) continue;
                                   boolean isBonne = (ri+1 == br);
                            %>
                            <div style="display:flex;align-items:center;gap:0.4rem;">
                                <span style="display:inline-flex;align-items:center;justify-content:center;
                                             width:20px;height:20px;border-radius:5px;font-size:0.7rem;font-weight:700;flex-shrink:0;
                                             background:<%=repColors[ri]%>;color:<%=repTextColors[ri]%>;"><%=lets[ri]%></span>
                                <span style="font-size:0.8rem;color:var(--app-text);
                                             <%=isBonne ? "font-weight:700;" : ""%>"><%=reps[ri]%>
                                    <%if(isBonne){%><i class="bi bi-check-circle-fill" style="color:var(--app-accent);font-size:0.75rem;"></i><%}%>
                                </span>
                            </div>
                            <% } %>
                        </div>
                    </td>
                    <td style="text-align:center;">
                        <span style="display:inline-flex;align-items:center;justify-content:center;
                                     width:28px;height:28px;border-radius:8px;
                                     background:rgba(6,214,160,0.12);color:#059669;
                                     font-weight:800;font-size:0.85rem;"><%=br%></span>
                    </td>
                    <td class="text-end">
                        <div style="display:flex;gap:0.4rem;justify-content:flex-end;">
                            <a href="${pageContext.request.contextPath}/qcm?action=edit&amp;id=<%=q.getNumQuest()%>"
                               class="btn btn-icon btn-app-outline" title="Modifier">
                                <i class="bi bi-pencil-fill"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/qcm?action=delete&amp;id=<%=q.getNumQuest()%>"
                               class="btn btn-icon btn-outline-danger"
                               data-delete-url="${pageContext.request.contextPath}/qcm?action=delete&amp;id=<%=q.getNumQuest()%>"
                               data-delete-label="la question n°<%=q.getNumQuest()%>"
                               onclick="return openDeleteModal(this);" title="Supprimer">
                                <i class="bi bi-trash-fill"></i>
                            </a>
                        </div>
                    </td>
                </tr>
                <% } } else { %>
                <tr>
                    <td colspan="5" class="text-center py-5">
                        <div style="display:flex;flex-direction:column;align-items:center;gap:0.75rem;color:var(--app-muted);">
                            <i class="bi bi-inbox" style="font-size:2.5rem;opacity:0.4;"></i>
                            <span style="font-size:0.9rem;">Aucune question trouvée.</span>
                        </div>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal Ajout QCM -->
<div class="modal fade" id="modalQcmAjout" tabindex="-1" aria-labelledby="modalQcmAjoutLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <div style="display:flex;align-items:center;gap:0.6rem;">
                    <div style="width:32px;height:32px;border-radius:9px;background:rgba(124,58,237,0.1);color:var(--app-violet);display:flex;align-items:center;justify-content:center;">
                        <i class="bi bi-plus-circle-fill"></i>
                    </div>
                    <h2 class="modal-title h5 mb-0" id="modalQcmAjoutLabel">Nouvelle question QCM</h2>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fermer"></button>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/qcm">
                <input type="hidden" name="action" value="save"/>
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label"><i class="bi bi-chat-square-text" style="color:var(--app-violet);"></i> Question</label>
                            <textarea name="question" class="form-control" rows="3" required placeholder="Saisissez la question ici…"></textarea>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label"><span style="display:inline-flex;align-items:center;justify-content:center;width:18px;height:18px;border-radius:4px;background:rgba(67,97,238,0.1);color:#4361ee;font-size:0.65rem;font-weight:700;margin-right:4px;">A</span> Réponse 1</label>
                            <input type="text" name="reponse1" class="form-control" required placeholder="Réponse A">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label"><span style="display:inline-flex;align-items:center;justify-content:center;width:18px;height:18px;border-radius:4px;background:rgba(6,214,160,0.1);color:#059669;font-size:0.65rem;font-weight:700;margin-right:4px;">B</span> Réponse 2</label>
                            <input type="text" name="reponse2" class="form-control" required placeholder="Réponse B">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label"><span style="display:inline-flex;align-items:center;justify-content:center;width:18px;height:18px;border-radius:4px;background:rgba(249,115,22,0.1);color:#c2410c;font-size:0.65rem;font-weight:700;margin-right:4px;">C</span> Réponse 3</label>
                            <input type="text" name="reponse3" class="form-control" placeholder="Réponse C (optionnel)">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label"><span style="display:inline-flex;align-items:center;justify-content:center;width:18px;height:18px;border-radius:4px;background:rgba(124,58,237,0.1);color:#7c3aed;font-size:0.65rem;font-weight:700;margin-right:4px;">D</span> Réponse 4</label>
                            <input type="text" name="reponse4" class="form-control" placeholder="Réponse D (optionnel)">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label"><i class="bi bi-check-circle-fill" style="color:var(--app-accent);"></i> Bonne réponse (1 à 4)</label>
                            <select name="bonneReponse" class="form-select" required>
                                <% for (int i=1; i<=4; i++) { %><option value="<%=i%>"><%=i%></option><% } %>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal"><i class="bi bi-x"></i> Annuler</button>
                    <button type="submit" class="btn btn-app-primary"><i class="bi bi-floppy-fill"></i> Enregistrer</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal Modifier QCM -->
<div class="modal fade" id="modalQcmEdit" tabindex="-1" aria-labelledby="modalQcmEditLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <div style="display:flex;align-items:center;gap:0.6rem;">
                    <div style="width:32px;height:32px;border-radius:9px;background:rgba(67,97,238,0.1);color:var(--app-primary);display:flex;align-items:center;justify-content:center;">
                        <i class="bi bi-pencil-fill"></i>
                    </div>
                    <h2 class="modal-title h5 mb-0" id="modalQcmEditLabel">Modifier la question</h2>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fermer"></button>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/qcm">
                <input type="hidden" name="action" value="save"/>
                <input type="hidden" name="numQuest" value="<%=editQcm == null ? "" : String.valueOf(editQcm.getNumQuest())%>">
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label"><i class="bi bi-chat-square-text" style="color:var(--app-violet);"></i> Question</label>
                            <textarea name="question" class="form-control" rows="3" required><%=editQcm == null || editQcm.getQuestion() == null ? "" : editQcm.getQuestion()%></textarea>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Réponse 1</label>
                            <input type="text" name="reponse1" class="form-control" value="<%=editQcm==null||editQcm.getReponse1()==null?"":editQcm.getReponse1()%>" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Réponse 2</label>
                            <input type="text" name="reponse2" class="form-control" value="<%=editQcm==null||editQcm.getReponse2()==null?"":editQcm.getReponse2()%>" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Réponse 3</label>
                            <input type="text" name="reponse3" class="form-control" value="<%=editQcm==null||editQcm.getReponse3()==null?"":editQcm.getReponse3()%>">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Réponse 4</label>
                            <input type="text" name="reponse4" class="form-control" value="<%=editQcm==null||editQcm.getReponse4()==null?"":editQcm.getReponse4()%>">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label"><i class="bi bi-check-circle-fill" style="color:var(--app-accent);"></i> Bonne réponse (1 à 4)</label>
                            <select name="bonneReponse" class="form-select" required>
                                <% for (int i=1; i<=4; i++) {
                                    String sel = (editQcm != null && editQcm.getBonneReponse() == i) ? "selected" : ""; %>
                                <option value="<%=i%>" <%=sel%>><%=i%></option>
                                <% } %>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <a href="<%=editQcm==null?"#":(request.getContextPath()+"/qcm?action=delete&id="+editQcm.getNumQuest())%>"
                       class="btn btn-outline-danger"
                       data-delete-url="<%=editQcm==null?"#":(request.getContextPath()+"/qcm?action=delete&id="+editQcm.getNumQuest())%>"
                       data-delete-label="cette question"
                       onclick="return openDeleteModal(this);">
                        <i class="bi bi-trash-fill"></i> Supprimer
                    </a>
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal"><i class="bi bi-x"></i> Annuler</button>
                    <button type="submit" class="btn btn-app-primary"><i class="bi bi-floppy-fill"></i> Enregistrer</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal Suppression -->
<div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <div style="display:flex;align-items:center;gap:0.6rem;">
                    <div style="width:32px;height:32px;border-radius:9px;background:rgba(239,68,68,0.1);color:#ef4444;display:flex;align-items:center;justify-content:center;">
                        <i class="bi bi-trash-fill"></i>
                    </div>
                    <h2 class="modal-title h5 mb-0" id="deleteConfirmModalLabel">Confirmer la suppression</h2>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fermer"></button>
            </div>
            <div class="modal-body">
                <p class="mb-0" id="deleteConfirmText" style="font-size:0.9rem;">Voulez-vous vraiment supprimer cet élément ?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal"><i class="bi bi-x"></i> Annuler</button>
                <a href="#" class="btn btn-danger" id="deleteConfirmAction"><i class="bi bi-trash-fill"></i> Supprimer</a>
            </div>
        </div>
    </div>
</div>

<% if (openModal) { %>
<script>document.addEventListener('DOMContentLoaded',function(){var e=document.getElementById('modalQcmAjout');if(e&&window.bootstrap)bootstrap.Modal.getOrCreateInstance(e).show();});</script>
<% } %>
<% if (editQcm != null) { %>
<script>document.addEventListener('DOMContentLoaded',function(){var e=document.getElementById('modalQcmEdit');if(e&&window.bootstrap)bootstrap.Modal.getOrCreateInstance(e).show();});</script>
<% } %>

<script>
    (function(){var a=document.getElementById('actionStatusAlert');if(!a)return;setTimeout(function(){a.style.transition='opacity 0.4s';a.style.opacity='0';setTimeout(function(){if(a.parentElement)a.parentElement.remove();},400);},3500);})();
    function openDeleteModal(btn){var m=document.getElementById('deleteConfirmModal'),ac=document.getElementById('deleteConfirmAction'),tx=document.getElementById('deleteConfirmText');if(!m||!ac||!tx||!window.bootstrap)return true;ac.setAttribute('href',btn.getAttribute('data-delete-url'));tx.textContent='Voulez-vous vraiment supprimer '+(btn.getAttribute('data-delete-label')||'cet élément')+' ?';bootstrap.Modal.getOrCreateInstance(m).show();return false;}
</script>

<jsp:include page="fragments/footer.jsp"/>
