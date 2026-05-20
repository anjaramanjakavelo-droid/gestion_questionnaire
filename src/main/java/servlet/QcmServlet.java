package servlet;

import dao.QcmDAO;
import model.Qcm;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/qcm")
public class QcmServlet extends HttpServlet {

    private final QcmDAO qcmDAO = new QcmDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "new":
                    response.sendRedirect(request.getContextPath() + "/qcm?openModal=1");
                    break;
                case "edit":
                    editForm(request, response);
                    break;
                case "delete":
                    deleteQcm(request, response);
                    break;
                default:
                    listQcm(request, response);
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
            if ("save".equals(action)) {
                saveQcm(request, response);
            } else {
                listQcm(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void listQcm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<Qcm> list = qcmDAO.findAll();
        request.setAttribute("qcms", list);
        request.getRequestDispatcher("/qcm-list.jsp").forward(request, response);
    }

    private void showForm(HttpServletRequest request, HttpServletResponse response, Qcm q)
            throws ServletException, IOException {
        request.setAttribute("qcm", q);
        request.getRequestDispatcher("/qcm-form.jsp").forward(request, response);
    }

    private void editForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/qcm");
            return;
        }
        int id = Integer.parseInt(idStr);
        if (qcmDAO.findById(id) == null) {
            response.sendRedirect(request.getContextPath() + "/qcm");
            return;
        }
        response.sendRedirect(request.getContextPath() + "/qcm?editId=" + id);
    }

    private void saveQcm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String idStr = request.getParameter("numQuest");
        String question = request.getParameter("question");
        String r1 = request.getParameter("reponse1");
        String r2 = request.getParameter("reponse2");
        String r3 = request.getParameter("reponse3");
        String r4 = request.getParameter("reponse4");
        int bonne = Integer.parseInt(request.getParameter("bonneReponse"));

        Qcm q = new Qcm();
        q.setQuestion(question);
        q.setReponse1(r1);
        q.setReponse2(r2);
        q.setReponse3(r3);
        q.setReponse4(r4);
        q.setBonneReponse(bonne);

        if (idStr == null || idStr.isEmpty()) {
            qcmDAO.create(q);
            response.sendRedirect(request.getContextPath() + "/qcm?status=added");
        } else {
            q.setNumQuest(Integer.parseInt(idStr));
            qcmDAO.update(q);
            response.sendRedirect(request.getContextPath() + "/qcm?status=updated");
        }
    }

    private void deleteQcm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            int id = Integer.parseInt(idStr);
            qcmDAO.delete(id);
        }
        response.sendRedirect(request.getContextPath() + "/qcm?status=deleted");
    }
}

