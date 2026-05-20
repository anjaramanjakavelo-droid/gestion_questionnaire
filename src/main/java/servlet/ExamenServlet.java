package servlet;

import dao.EtudiantDAO;
import dao.ExamenDAO;
import dao.QcmDAO;
import model.Etudiant;
import model.Examen;
import model.Qcm;
import util.EmailUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/examen")
public class ExamenServlet extends HttpServlet {

    private final QcmDAO qcmDAO = new QcmDAO();
    private final ExamenDAO examenDAO = new ExamenDAO();
    private final EtudiantDAO etudiantDAO = new EtudiantDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "startForm";

        try {
            switch (action) {
                case "startForm":
                    request.getRequestDispatcher("/examen-start.jsp").forward(request, response);
                    break;
                case "notes":
                    listNotes(request, response);
                    break;
                case "classement":
                    classement(request, response);
                    break;
                default:
                    request.getRequestDispatcher("/examen-start.jsp").forward(request, response);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) action = "start";

        try {
            switch (action) {
                case "start":
                    startExamen(request, response);
                    break;
                case "submit":
                    submitExamen(request, response);
                    break;
                default:
                    request.getRequestDispatcher("/examen-start.jsp").forward(request, response);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void startExamen(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String numEtudiant = request.getParameter("numEtudiant");
        String annee = request.getParameter("anneeUniv");

        // Vérifier que l'étudiant connecté ne peut utiliser que son propre numéro
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        model.Utilisateur utilisateur = (model.Utilisateur) session.getAttribute("utilisateur");
        if (utilisateur == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Récupérer l'étudiant lié au compte connecté via l'email
        Etudiant etuConnecte = etudiantDAO.findByEmail(utilisateur.getEmail());
        if (etuConnecte == null) {
            request.setAttribute("erreur", "Aucun étudiant trouvé pour votre compte. Contactez l'administrateur.");
            request.getRequestDispatcher("/examen-start.jsp").forward(request, response);
            return;
        }

        // Vérifier que le numéro saisi correspond à celui de l'étudiant connecté
        if (!etuConnecte.getNumEtudiant().equals(numEtudiant)) {
            request.setAttribute("erreur", "Le numéro étudiant saisi ne correspond pas à votre compte. Veuillez saisir votre propre numéro étudiant.");
            request.getRequestDispatcher("/examen-start.jsp").forward(request, response);
            return;
        }

        Etudiant etu = etudiantDAO.findById(numEtudiant);
        if (etu == null) {
            request.setAttribute("erreur", "Étudiant introuvable, veuillez vérifier le numéro.");
            request.getRequestDispatcher("/examen-start.jsp").forward(request, response);
            return;
        }

        // Check if student already has an exam for this academic year
        ExamenDAO examenDAO = new ExamenDAO();
        if (examenDAO.existsByEtudiantAndAnneeUniv(numEtudiant, annee)) {
            request.setAttribute("erreur", "Vous avez déjà passé un examen pour l'année universitaire " + annee + ". Un seul examen par année est autorisé.");
            request.getRequestDispatcher("/examen-start.jsp").forward(request, response);
            return;
        }

        List<Qcm> questions = qcmDAO.pickRandom(10);

        session.setAttribute("questions", questions);
        session.setAttribute("numEtudiant", numEtudiant);
        session.setAttribute("anneeUniv", annee);

        request.setAttribute("etudiant", etu);
        request.setAttribute("questions", questions);
        request.getRequestDispatcher("/examen-questions.jsp").forward(request, response);
    }

    @SuppressWarnings("unchecked")
    private void submitExamen(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("questions") == null) {
            response.sendRedirect(request.getContextPath() + "/examen");
            return;
        }

        List<Qcm> questions = (List<Qcm>) session.getAttribute("questions");
        String numEtudiant = (String) session.getAttribute("numEtudiant");
        String annee = (String) session.getAttribute("anneeUniv");

        int score = 0;
        Map<Integer, Integer> reponsesEtudiant = new HashMap<>();

        for (Qcm q : questions) {
            String repStr = request.getParameter("q_" + q.getNumQuest());
            int rep = 0;
            if (repStr != null && !repStr.isEmpty()) {
                rep = Integer.parseInt(repStr);
            }
            reponsesEtudiant.put(q.getNumQuest(), rep);
            if (rep == q.getBonneReponse()) {
                score++;
            }
        }

        Examen ex = new Examen();
        ex.setNumEtudiant(numEtudiant);
        ex.setAnneeUniv(annee);
        ex.setNote(score);
        examenDAO.create(ex);

        Etudiant etu = etudiantDAO.findById(numEtudiant);
        if (etu != null && etu.getAdrEmail() != null && !etu.getAdrEmail().isEmpty()) {
            String sujet = "R\u00e9sultat de votre examen";
            String contenu = "Bonjour " + etu.getNom() + " " + etu.getPrenoms()
                    + ",\n\nVotre note \u00e0 l'examen " + annee + " est : " + score + "/10.\n\nCordialement.";
            try {
                EmailUtil.envoyerNote(etu.getAdrEmail(), sujet, contenu);
            } catch (RuntimeException ignored) {
                // L'envoi mail ne doit jamais bloquer l'affichage du resultat.
            }
        }

        request.setAttribute("note", score);
        request.setAttribute("questions", questions);
        request.setAttribute("reponsesEtudiant", reponsesEtudiant);
        request.getRequestDispatcher("/examen-result.jsp").forward(request, response);
    }

    private void listNotes(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<Examen> list = examenDAO.findAll();
        request.setAttribute("examens", list);
        request.getRequestDispatcher("/examen-notes.jsp").forward(request, response);
    }

    private void classement(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        request.setAttribute("classement", examenDAO.classement());
        request.getRequestDispatcher("/examen-classement.jsp").forward(request, response);
    }
}

