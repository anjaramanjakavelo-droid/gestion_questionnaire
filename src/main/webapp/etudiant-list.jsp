<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="model.Etudiant" %>
<%
    boolean openModal = "1".equals(request.getParameter("openModal"));
    String status = request.getParameter("status");
    String editNum = request.getParameter("editNum");
    Etudiant editEtudiant = null;
    @SuppressWarnings("unchecked")
    List<Etudiant> etudiantsForEdit = (List<Etudiant>) request.getAttribute("etudiants");
    if (editNum != null && etudiantsForEdit != null) {
        for (Etudiant item : etudiantsForEdit) {
            if (editNum.equals(item.getNumEtudiant())) { editEtudiant = item; break; }
        }
    }
%>
<jsp:include page="fragments/head.jsp">
    <jsp:param name="pageTitle" value="Étudiants — ExamQCM"/>
</jsp:include>
<jsp:include page="fragments/navbar.jsp"/>

<%
    String statusMessage = null;
    String statusType = "primary";
    String statusIcon = "bi-check-circle-fill";
    if ("added".equals(status))     { statusMessage = "Étudiant ajouté avec succès."; statusType="success"; }
    else if ("updated".equals(status)) { statusMessage = "Modification réussie."; statusType="success"; }
    else if ("deleted".equals(status)) { statusMessage = "Étudiant supprimé avec succès."; statusType="success"; statusIcon="bi-trash-fill"; }
    else if ("duplicate".equals(status)) { statusMessage = "Numéro étudiant déjà utilisé. Veuillez saisir un numéro unique."; statusType="warning"; statusIcon="bi-exclamation-triangle-fill"; }
%>
<% if (statusMessage != null) { %>
<div class="position-fixed top-0 end-0 p-3" style="z-index:1090;margin-top:80px;">
    <div id="actionStatusAlert"
         class="alert alert-<%=statusType%> app-toast-alert shadow-lg"
         style="min-width:320px;max-width:90vw;"
         role="alert">
        <i class="bi <%=statusIcon%>" style="font-size:1.1rem;flex-shrink:0;"></i>
        <span><%=statusMessage%></span>
    </div>
</div>
<% } %>

<!-- Panel Header -->
<div class="app-panel mb-4 anim-fade-in">
    <div class="app-panel-header">
        <div style="display:flex;align-items:center;gap:0.75rem;">
            <div class="panel-icon" style="background:rgba(67,97,238,0.1);color:var(--app-primary);">
                <i class="bi bi-people-fill"></i>
            </div>
            <div>
                <h1 class="h5 mb-0" style="font-weight:800;">Étudiants</h1>
                <span class="app-stat-pill mt-1 d-inline-flex">
                    <i class="bi bi-person-check"></i>
                    Effectif total : <strong class="ms-1">${effectifTotal}</strong>
                </span>
            </div>
        </div>
        <button type="button" class="btn btn-app-primary" data-bs-toggle="modal" data-bs-target="#modalEtudiantAjout">
            <i class="bi bi-plus-lg"></i> Nouvel étudiant
        </button>
    </div>
    <div class="app-panel-body">
        <!-- Recherche -->
        <form class="row g-2 align-items-end mb-4" method="get" action="${pageContext.request.contextPath}/etudiants">
            <input type="hidden" name="action" value="search"/>
            <div class="col-md-6 col-lg-5">
                <label class="form-label"><i class="bi bi-search" style="color:var(--app-primary);"></i> Recherche</label>
                <div class="input-group-modern">
                    <i class="bi bi-search input-icon"></i>
                    <input type="text" class="form-control" name="keyword"
                           placeholder="Numéro étudiant ou nom…"
                           value="${keyword != null ? keyword : ''}">
                </div>
            </div>
            <div class="col-auto">
                <button type="submit" class="btn btn-app-outline">
                    <i class="bi bi-search"></i> Rechercher
                </button>
            </div>
            <div class="col-auto">
                <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/etudiants"
                   style="border-radius:0.6rem;">
                    <i class="bi bi-x-circle"></i> Réinitialiser
                </a>
            </div>
        </form>

        <!-- Niveaux -->
        <p class="section-title"><i class="bi bi-layers-fill"></i> Par niveau</p>
        <p class="small mb-3" style="color:var(--app-muted);">
            Cliquez sur un niveau pour voir la liste détaillée et l'effectif.
        </p>
        <div class="row g-2 mb-0">
            <%
                String[] niveauxRef = {"L1", "L2", "L3", "M1", "M2"};
                String[] niveauClasses = {"niveau-l1", "niveau-l2", "niveau-l3", "niveau-m1", "niveau-m2"};
                String[] badgeClasses  = {"badge-l1",  "badge-l2",  "badge-l3",  "badge-m1",  "badge-m2"};
                String[] niveauIcons   = {"bi-1-square-fill","bi-2-square-fill","bi-3-square-fill","bi-mortarboard-fill","bi-mortarboard-fill"};
                @SuppressWarnings("unchecked")
                Map<String, Integer> effectifs = (Map<String, Integer>) request.getAttribute("effectifsParNiveau");
                for (int ni = 0; ni < niveauxRef.length; ni++) {
                    String n = niveauxRef[ni];
                    int c = (effectifs != null && effectifs.containsKey(n)) ? effectifs.get(n) : 0;
            %>
            <div class="col-6 col-md-4 col-lg-2">
                <a class="app-niveau-card <%=niveauClasses[ni]%>"
                   href="${pageContext.request.contextPath}/etudiants?action=niveau&amp;niveau=<%=n%>">
                    <div class="d-flex justify-content-between align-items-center mb-1">
                        <span class="fw-bold fs-5"><%=n%></span>
                        <span class="badge-niveau <%=badgeClasses[ni]%>"><%=c%></span>
                    </div>
                    <span class="small" style="color:var(--app-muted);">
                        <i class="bi bi-arrow-right-short"></i> Voir la liste
                    </span>
                </a>
            </div>
            <% } %>
        </div>
    </div>
</div>

<!-- Tableau -->
<div class="app-panel anim-fade-in anim-delay-1">
    <div class="app-panel-header">
        <div style="display:flex;align-items:center;gap:0.6rem;">
            <i class="bi bi-table" style="color:var(--app-primary);"></i>
            <span style="font-weight:700;font-size:0.95rem;">Liste des étudiants</span>
        </div>
    </div>
    <div class="app-panel-body p-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead>
                <tr>
                    <th>Étudiant</th>
                    <th>Numéro</th>
                    <th>Niveau</th>
                    <th>Email</th>
                    <th class="text-end">Actions</th>
                </tr>
                </thead>
                <tbody>
                <%
                    List<Etudiant> etudiants = (List<Etudiant>) request.getAttribute("etudiants");
                    if (etudiants != null && !etudiants.isEmpty()) {
                        for (Etudiant e : etudiants) {
                            String initiale = (e.getNom() != null && e.getNom().length() > 0) ? e.getNom().substring(0,1).toUpperCase() : "?";
                            String prenomInit = (e.getPrenoms() != null && e.getPrenoms().length() > 0) ? e.getPrenoms().substring(0,1).toUpperCase() : "";
                %>
                <tr>
                    <td>
                        <div style="display:flex;align-items:center;gap:0.75rem;">
                            <div class="avatar-initials"><%=initiale+prenomInit%></div>
                            <div>
                                <div style="font-weight:600;font-size:0.9rem;"><%=e.getNom()%></div>
                                <div style="font-size:0.8rem;color:var(--app-muted);"><%=e.getPrenoms()%></div>
                            </div>
                        </div>
                    </td>
                    <td><code style="background:var(--app-surface-2);padding:0.2em 0.5em;border-radius:6px;font-size:0.82rem;"><%=e.getNumEtudiant()%></code></td>
                    <td>
                        <%
                            String niv = e.getNiveau() != null ? e.getNiveau() : "";
                            String bc = "badge-l1";
                            if ("L2".equals(niv)) bc="badge-l2";
                            else if ("L3".equals(niv)) bc="badge-l3";
                            else if ("M1".equals(niv)) bc="badge-m1";
                            else if ("M2".equals(niv)) bc="badge-m2";
                        %>
                        <span class="badge-niveau <%=bc%>"><%=niv%></span>
                    </td>
                    <td style="font-size:0.875rem;color:var(--app-muted);"><%=e.getAdrEmail()%></td>
                    <td class="text-end text-nowrap">
                        <div style="display:flex;gap:0.4rem;justify-content:flex-end;">
                            <a href="${pageContext.request.contextPath}/etudiants?action=edit&amp;num=<%=e.getNumEtudiant()%>"
                               class="btn btn-icon btn-app-outline" title="Modifier">
                                <i class="bi bi-pencil-fill"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/etudiants?action=delete&amp;num=<%=e.getNumEtudiant()%>"
                               class="btn btn-icon btn-outline-danger"
                               data-delete-url="${pageContext.request.contextPath}/etudiants?action=delete&amp;num=<%=e.getNumEtudiant()%>"
                               data-delete-label="l'étudiant <%=e.getNom()%> <%=e.getPrenoms()%>"
                               onclick="return openDeleteModal(this);" title="Supprimer">
                                <i class="bi bi-trash-fill"></i>
                            </a>
                        </div>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="5" class="text-center py-5">
                        <div style="display:flex;flex-direction:column;align-items:center;gap:0.75rem;color:var(--app-muted);">
                            <i class="bi bi-inbox" style="font-size:2.5rem;opacity:0.4;"></i>
                            <span style="font-size:0.9rem;">Aucun étudiant trouvé.</span>
                        </div>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal Ajout -->
<div class="modal fade" id="modalEtudiantAjout" tabindex="-1" aria-labelledby="modalEtudiantAjoutLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <div style="display:flex;align-items:center;gap:0.6rem;">
                    <div style="width:32px;height:32px;border-radius:9px;background:rgba(67,97,238,0.1);color:var(--app-primary);display:flex;align-items:center;justify-content:center;">
                        <i class="bi bi-person-plus-fill"></i>
                    </div>
                    <h2 class="modal-title h5 mb-0" id="modalEtudiantAjoutLabel">Nouvel étudiant</h2>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fermer"></button>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/etudiants">
                <input type="hidden" name="action" value="save"/>
                <div class="modal-body">
                    <% if ("duplicate".equals(status)) { %>
                    <div class="alert alert-warning">
                        <i class="bi bi-exclamation-triangle-fill"></i>
                        Numéro étudiant existant. Veuillez saisir un numéro unique.
                    </div>
                    <% } %>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label"><i class="bi bi-hash" style="color:var(--app-primary);"></i> Numéro étudiant</label>
                            <input type="text" name="numEtudiant" class="form-control" required placeholder="ex : ETU-2025-001">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label"><i class="bi bi-layers" style="color:var(--app-primary);"></i> Niveau</label>
                            <select name="niveau" class="form-select" required>
                                <% for (String n : new String[]{"L1","L2","L3","M1","M2"}) { %>
                                <option value="<%=n%>"><%=n%></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label"><i class="bi bi-person" style="color:var(--app-primary);"></i> Nom</label>
                            <input type="text" name="nom" class="form-control" required placeholder="Nom de famille">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label"><i class="bi bi-person-badge" style="color:var(--app-primary);"></i> Prénoms</label>
                            <input type="text" name="prenoms" class="form-control" required placeholder="Prénoms">
                        </div>
                        <div class="col-12">
                            <label class="form-label"><i class="bi bi-envelope" style="color:var(--app-primary);"></i> Adresse email</label>
                            <input type="email" name="adrEmail" class="form-control" placeholder="exemple@univ.mg">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
                        <i class="bi bi-x"></i> Annuler
                    </button>
                    <button type="submit" class="btn btn-app-primary">
                        <i class="bi bi-floppy-fill"></i> Enregistrer
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal Modifier -->
<div class="modal fade" id="modalEtudiantEdit" tabindex="-1" aria-labelledby="modalEtudiantEditLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <div style="display:flex;align-items:center;gap:0.6rem;">
                    <div style="width:32px;height:32px;border-radius:9px;background:rgba(67,97,238,0.1);color:var(--app-primary);display:flex;align-items:center;justify-content:center;">
                        <i class="bi bi-pencil-fill"></i>
                    </div>
                    <h2 class="modal-title h5 mb-0" id="modalEtudiantEditLabel">Modifier l'étudiant</h2>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fermer"></button>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/etudiants">
                <input type="hidden" name="action" value="save"/>
                <input type="hidden" name="originalNumEtudiant"
                       value="<%=editEtudiant == null ? "" : editEtudiant.getNumEtudiant()%>"/>
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label"><i class="bi bi-hash" style="color:var(--app-primary);"></i> Numéro étudiant</label>
                            <input type="text" name="numEtudiant" class="form-control"
                                   value="<%=editEtudiant == null ? "" : editEtudiant.getNumEtudiant()%>" readonly required
                                   style="background:var(--app-surface-2);">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label"><i class="bi bi-layers" style="color:var(--app-primary);"></i> Niveau</label>
                            <select name="niveau" class="form-select" required>
                                <% for (String n : new String[]{"L1","L2","L3","M1","M2"}) {
                                    String sel = (editEtudiant != null && n.equals(editEtudiant.getNiveau())) ? "selected" : ""; %>
                                <option value="<%=n%>" <%=sel%>><%=n%></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label"><i class="bi bi-person" style="color:var(--app-primary);"></i> Nom</label>
                            <input type="text" name="nom" class="form-control"
                                   value="<%=editEtudiant == null ? "" : editEtudiant.getNom()%>" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label"><i class="bi bi-person-badge" style="color:var(--app-primary);"></i> Prénoms</label>
                            <input type="text" name="prenoms" class="form-control"
                                   value="<%=editEtudiant == null ? "" : editEtudiant.getPrenoms()%>" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label"><i class="bi bi-envelope" style="color:var(--app-primary);"></i> Adresse email</label>
                            <input type="email" name="adrEmail" class="form-control"
                                   value="<%=editEtudiant == null ? "" : editEtudiant.getAdrEmail()%>">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
                        <i class="bi bi-x"></i> Annuler
                    </button>
                    <button type="submit" class="btn btn-app-primary">
                        <i class="bi bi-floppy-fill"></i> Enregistrer
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal Suppression -->
<div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteConfirmModalLabel" aria-hidden="true">
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
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
                    <i class="bi bi-x"></i> Annuler
                </button>
                <a href="#" class="btn btn-danger" id="deleteConfirmAction">
                    <i class="bi bi-trash-fill"></i> Supprimer
                </a>
            </div>
        </div>
    </div>
</div>

<% if (openModal) { %>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        var el = document.getElementById('modalEtudiantAjout');
        if (el && window.bootstrap) bootstrap.Modal.getOrCreateInstance(el).show();
    });
</script>
<% } %>

<% if (editEtudiant != null) { %>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        var el = document.getElementById('modalEtudiantEdit');
        if (el && window.bootstrap) bootstrap.Modal.getOrCreateInstance(el).show();
    });
</script>
<% } %>

<script>
    (function () {
        var alertEl = document.getElementById('actionStatusAlert');
        if (!alertEl) return;
        setTimeout(function () {
            alertEl.style.transition = 'opacity 0.4s ease';
            alertEl.style.opacity = '0';
            setTimeout(function () {
                var w = alertEl.parentElement;
                if (w) w.remove();
            }, 400);
        }, 3500);
    })();

    function openDeleteModal(btn) {
        var modalEl  = document.getElementById('deleteConfirmModal');
        var actionEl = document.getElementById('deleteConfirmAction');
        var textEl   = document.getElementById('deleteConfirmText');
        if (!modalEl || !actionEl || !textEl || !window.bootstrap) return true;
        actionEl.setAttribute('href', btn.getAttribute('data-delete-url'));
        textEl.textContent = 'Voulez-vous vraiment supprimer ' + (btn.getAttribute('data-delete-label') || 'cet élément') + ' ?';
        bootstrap.Modal.getOrCreateInstance(modalEl).show();
        return false;
    }
</script>

<jsp:include page="fragments/footer.jsp"/>
