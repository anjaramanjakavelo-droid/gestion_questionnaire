package servlet;

import dao.EtudiantDAO;
import model.Etudiant;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@WebServlet("/etudiants")
public class EtudiantServlet extends HttpServlet {

    private final EtudiantDAO etudiantDAO = new EtudiantDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "new":
                    response.sendRedirect(request.getContextPath() + "/etudiants?openModal=1");
                    break;
                case "edit":
                    editForm(request, response);
                    break;
                case "delete":
                    deleteEtudiant(request, response);
                    break;
                case "search":
                    searchEtudiant(request, response);
                    break;
                case "niveau":
                    listByNiveau(request, response);
                    break;
                default:
                    listEtudiants(request, response);
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
        if (action == null) action = "save";

        try {
            switch (action) {
                case "save":
                    saveEtudiant(request, response);
                    break;
                case "search":
                    searchEtudiant(request, response);
                    break;
                case "niveau":
                    listByNiveau(request, response);
                    break;
                default:
                    listEtudiants(request, response);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void listEtudiants(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<Etudiant> list = etudiantDAO.findAll();
        request.setAttribute("etudiants", list);
        Map<String, Integer> effectifs = etudiantDAO.countGroupByNiveau();
        request.setAttribute("effectifsParNiveau", effectifs);
        request.setAttribute("effectifTotal", list.size());
        request.getRequestDispatcher("/etudiant-list.jsp").forward(request, response);
    }

    private void showForm(HttpServletRequest request, HttpServletResponse response, Etudiant e)
            throws ServletException, IOException {
        request.setAttribute("etudiant", e);
        request.getRequestDispatcher("/etudiant-form.jsp").forward(request, response);
    }

    private void editForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String num = request.getParameter("num");
        if (num == null || num.isEmpty() || etudiantDAO.findById(num) == null) {
            response.sendRedirect(request.getContextPath() + "/etudiants");
            return;
        }
        response.sendRedirect(request.getContextPath() + "/etudiants?editNum=" + num);
    }

    private void saveEtudiant(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String num = request.getParameter("numEtudiant");
        String originalNum = request.getParameter("originalNumEtudiant");
        String nom = request.getParameter("nom");
        String prenoms = request.getParameter("prenoms");
        String niveau = request.getParameter("niveau");
        String email = request.getParameter("adrEmail");

        Etudiant e = new Etudiant(num, nom, prenoms, niveau, email);

        // En mode edition, on met a jour la fiche cible ; en mode ajout, on refuse les doublons.
        if (originalNum != null && !originalNum.isEmpty()) {
            Etudiant existantEdition = etudiantDAO.findById(originalNum);
            if (existantEdition == null) {
                response.sendRedirect(request.getContextPath() + "/etudiants");
                return;
            }
            e.setNumEtudiant(originalNum);
            etudiantDAO.update(e);
            response.sendRedirect(request.getContextPath() + "/etudiants?status=updated");
            return;
        }

        Etudiant existant = etudiantDAO.findById(num);
        if (existant == null) {
            etudiantDAO.create(e);
            response.sendRedirect(request.getContextPath() + "/etudiants?status=added");
        } else {
            response.sendRedirect(request.getContextPath() + "/etudiants?status=duplicate&openModal=1");
        }
    }

    private void deleteEtudiant(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String num = request.getParameter("num");
        if (num != null && !num.isEmpty()) {
            etudiantDAO.delete(num);
        }
        response.sendRedirect(request.getContextPath() + "/etudiants?status=deleted");
    }

    private void searchEtudiant(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<Etudiant> list = etudiantDAO.search(keyword == null ? "" : keyword);
        request.setAttribute("etudiants", list);
        request.setAttribute("keyword", keyword);
        Map<String, Integer> effectifs = etudiantDAO.countGroupByNiveau();
        request.setAttribute("effectifsParNiveau", effectifs);
        int totalInscrits = 0;
        for (int v : effectifs.values()) {
            totalInscrits += v;
        }
        request.setAttribute("effectifTotal", totalInscrits);
        request.getRequestDispatcher("/etudiant-list.jsp").forward(request, response);
    }

    private void listByNiveau(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String niveau = request.getParameter("niveau");
        if (niveau == null || niveau.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/etudiants");
            return;
        }
        List<Etudiant> list = etudiantDAO.listByNiveau(niveau);
        int effectif = etudiantDAO.countByNiveau(niveau);
        request.setAttribute("etudiants", list);
        request.setAttribute("niveau", niveau);
        request.setAttribute("effectif", effectif);
        request.getRequestDispatcher("/etudiant-niveau.jsp").forward(request, response);
    }
}

