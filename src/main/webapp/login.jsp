<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Connexion — ExamQCM</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/app.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/forms.css">
    <script>
        (function () {
            try {
                var t = localStorage.getItem("questionnaire-theme") || "light";
                document.documentElement.setAttribute("data-theme", t);
                document.documentElement.setAttribute("data-bs-theme", t);
            } catch (e) {}
        })();
    </script>
    <script defer src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script defer src="${pageContext.request.contextPath}/js/theme.js"></script>
</head>
<body class="app-body">

<div class="login-wrapper">
    <!-- Orbes décoratifs -->
    <div class="login-orb login-orb-1"></div>
    <div class="login-orb login-orb-2"></div>

    <div class="login-container">
        <div class="login-card">
            <!-- En-tête -->
            <div class="login-card-header">
                <div class="login-logo-wrap">
                    <i class="bi bi-mortarboard-fill"></i>
                </div>
                <h1 class="login-title">ExamQCM</h1>
                <p class="login-subtitle">Plateforme universitaire d'examens en ligne</p>
            </div>

            <!-- Corps -->
            <div class="login-card-body">
                <%
                    String error        = request.getParameter("error");
                    String unauthorized = request.getParameter("unauthorized");
                    String success      = request.getParameter("success");
                %>

                <% if ("true".equals(success)) { %>
                <div class="login-alert login-alert-success">
                    <i class="bi bi-check-circle-fill" style="flex-shrink:0;font-size:1.1rem;"></i>
                    <div><strong>Inscription réussie !</strong><br>Vous pouvez maintenant vous connecter.</div>
                </div>
                <% } %>

                <% if ("true".equals(error)) { %>
                <div class="login-alert login-alert-error">
                    <i class="bi bi-exclamation-triangle-fill" style="flex-shrink:0;font-size:1.1rem;"></i>
                    <div><strong>Erreur de connexion :</strong><br>Identifiant ou mot de passe incorrect.</div>
                </div>
                <% } %>

                <% if ("unauthorized".equals(unauthorized) || "unauthorized".equals(error)) { %>
                <div class="login-alert login-alert-error">
                    <i class="bi bi-shield-exclamation" style="flex-shrink:0;font-size:1.1rem;"></i>
                    <div><strong>Accès refusé :</strong><br>Vous devez être connecté pour accéder à cette page.</div>
                </div>
                <% } %>

                <p style="font-size:0.875rem;font-weight:600;color:var(--app-muted);margin-bottom:1.25rem;text-align:center;">
                    Connexion à votre compte
                </p>

                <form action="login" method="post">
                    <!-- Email -->
                    <div class="mb-3">
                        <label for="email" class="form-label">
                            <i class="bi bi-envelope-fill" style="color:var(--app-primary);"></i> Adresse email
                        </label>
                        <div class="input-group-modern">
                            <i class="bi bi-envelope input-icon"></i>
                            <input type="email" class="form-control" id="email" name="email"
                                   placeholder="votre@email.com" required autofocus>
                        </div>
                    </div>

                    <!-- Mot de passe -->
                    <div class="mb-4">
                        <label for="password" class="form-label">
                            <i class="bi bi-lock-fill" style="color:var(--app-primary);"></i> Mot de passe
                        </label>
                        <div class="input-group-modern">
                            <i class="bi bi-lock input-icon"></i>
                            <input type="password" class="form-control" id="password" name="password"
                                   placeholder="••••••••" required>
                        </div>
                    </div>

                    <button type="submit" class="btn-login mb-1">
                        <i class="bi bi-box-arrow-in-right"></i> Se connecter
                    </button>
                </form>

                <div class="login-divider">ou</div>

                <a href="register.jsp" class="btn-register">
                    <i class="bi bi-person-plus-fill"></i> Créer un compte
                </a>
            </div>
        </div>

        <!-- Version thème -->
        <div class="text-center mt-3">
            <button id="themeToggle" class="btn btn-sm"
                    style="background:rgba(255,255,255,0.15);border:1px solid rgba(255,255,255,0.3);color:#fff;border-radius:0.5rem;font-size:0.8rem;padding:0.35rem 0.85rem;">
                <i class="bi bi-moon-stars-fill" id="themeIcon"></i>
                <span id="themeLabel">Mode sombre</span>
            </button>
        </div>
    </div>
</div>

</body>
</html>