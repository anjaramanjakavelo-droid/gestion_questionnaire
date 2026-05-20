/**
 * theme.js — Gestion du thème clair/sombre + icônes navbar
 * Plateforme ExamQCM
 */
(function () {
    'use strict';

    var STORAGE_KEY = 'questionnaire-theme';

    function getTheme() {
        try { return localStorage.getItem(STORAGE_KEY) || 'light'; }
        catch (e) { return 'light'; }
    }

    function setTheme(t) {
        try { localStorage.setItem(STORAGE_KEY, t); } catch (e) {}
        document.documentElement.setAttribute('data-theme', t);
        document.documentElement.setAttribute('data-bs-theme', t);
        updateThemeUI(t);
    }

    function updateThemeUI(t) {
        // Icône dans la navbar
        var icon  = document.getElementById('themeIcon');
        var label = document.getElementById('themeLabel');
        if (icon) {
            icon.className = t === 'dark'
                ? 'bi bi-sun-fill'
                : 'bi bi-moon-stars-fill';
        }
        if (label) {
            label.textContent = t === 'dark' ? 'Mode clair' : 'Mode sombre';
        }
    }

    function toggleTheme() {
        var current = getTheme();
        setTheme(current === 'dark' ? 'light' : 'dark');
    }

    document.addEventListener('DOMContentLoaded', function () {
        // Appliquer thème initial
        var current = getTheme();
        updateThemeUI(current);

        // Bouton toggle (peut exister plusieurs fois : navbar + login)
        document.querySelectorAll('#themeToggle').forEach(function (btn) {
            btn.addEventListener('click', function (e) {
                e.preventDefault();
                toggleTheme();
            });
        });
    });
})();
