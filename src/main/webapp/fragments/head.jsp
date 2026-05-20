<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><%= request.getParameter("pageTitle") != null && !request.getParameter("pageTitle").isEmpty()
            ? request.getParameter("pageTitle") : "Plateforme d'examen" %></title>
    <!-- Google Fonts : Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <!-- App CSS -->
    <link href="${pageContext.request.contextPath}/css/app.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/dashboard.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/forms.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/examen.css" rel="stylesheet">
    <script>
        (function () {
            try {
                var t = localStorage.getItem("questionnaire-theme") || "light";
                document.documentElement.setAttribute("data-theme", t);
                document.documentElement.setAttribute("data-bs-theme", t);
            } catch (e) { /* ignore */ }
        })();
    </script>
    <script defer src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script defer src="${pageContext.request.contextPath}/js/theme.js"></script>
</head>
<body class="app-body">
