package servlet;

import dao.DBConnection;
import dao.UtilisateurDAO;
import model.Utilisateur;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/diagnostic")
public class DiagnosticServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<meta charset='UTF-8'>");
        out.println("<title>Diagnostic Base de Données</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }");
        out.println(".container { max-width: 1000px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }");
        out.println("h1 { color: #333; border-bottom: 3px solid #007bff; padding-bottom: 10px; }");
        out.println("h2 { color: #555; margin-top: 20px; }");
        out.println(".success { color: green; font-weight: bold; }");
        out.println(".error { color: red; font-weight: bold; }");
        out.println(".warning { color: orange; font-weight: bold; }");
        out.println(".info { color: blue; }");
        out.println(".table-wrapper { overflow-x: auto; margin: 20px 0; }");
        out.println("table { border-collapse: collapse; width: 100%; }");
        out.println("th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }");
        out.println("th { background-color: #007bff; color: white; }");
        out.println("tr:nth-child(even) { background-color: #f9f9f9; }");
        out.println(".code { background: #f4f4f4; padding: 10px; border-left: 4px solid #007bff; font-family: monospace; margin: 10px 0; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("<div class='container'>");
        out.println("<h1>🔍 Diagnostic Base de Données - Plateforme Examen</h1>");

        try {
            // Test 1: Connexion à la base
            out.println("<h2>1️⃣ Test de Connexion</h2>");
            Connection cn = DBConnection.getConnection();
            out.println("<p class='success'>✓ Connexion établie avec succès!</p>");
            
            // Test 2: Base de données
            out.println("<h2>2️⃣ Informations Base de Données</h2>");
            String checkDB = "SELECT DATABASE()";
            try (PreparedStatement ps = cn.prepareStatement(checkDB);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String dbName = rs.getString(1);
                    out.println("<p class='info'>Base active: <strong>" + dbName + "</strong></p>");
                } else {
                    out.println("<p class='error'>❌ Impossible de déterminer la base active</p>");
                }
            }

            // Test 3: Table utilisateur
            out.println("<h2>3️⃣ Vérification Table 'utilisateur'</h2>");
            String checkTable = "SELECT COUNT(*) as count FROM utilisateur";
            try (PreparedStatement ps = cn.prepareStatement(checkTable);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt("count");
                    if (count > 0) {
                        out.println("<p class='success'>✓ Table trouvée avec " + count + " utilisateur(s)</p>");
                    } else {
                        out.println("<p class='warning'>⚠️ Table existe mais vide (" + count + " lignes)</p>");
                    }
                } else {
                    out.println("<p class='error'>❌ Table utilisateur non trouvée</p>");
                }
            }

            // Test 4: Contenu table utilisateur
            out.println("<h2>4️⃣ Contenu Table Utilisateur</h2>");
            String selectAll = "SELECT id_user, username, mot_de_passe, role, email, num_etudiant FROM utilisateur";
            try (PreparedStatement ps = cn.prepareStatement(selectAll);
                 ResultSet rs = ps.executeQuery()) {
                
                if (rs.next()) {
                    out.println("<div class='table-wrapper'>");
                    out.println("<table>");
                    out.println("<tr>");
                    out.println("<th>ID</th>");
                    out.println("<th>Username</th>");
                    out.println("<th>Mot de Passe</th>");
                    out.println("<th>Rôle</th>");
                    out.println("<th>Email</th>");
                    out.println("<th>Num Étudiant</th>");
                    out.println("</tr>");
                    
                    do {
                        out.println("<tr>");
                        out.println("<td>" + rs.getInt("id_user") + "</td>");
                        out.println("<td>" + rs.getString("username") + "</td>");
                        out.println("<td>" + rs.getString("mot_de_passe") + "</td>");
                        out.println("<td>" + rs.getString("role") + "</td>");
                        out.println("<td>" + rs.getString("email") + "</td>");
                        out.println("<td>" + rs.getString("num_etudiant") + "</td>");
                        out.println("</tr>");
                    } while (rs.next());
                    
                    out.println("</table>");
                    out.println("</div>");
                } else {
                    out.println("<p class='error'>❌ Aucun utilisateur trouvé</p>");
                }
            }

            // Test 5: Test requête spécifique
            out.println("<h2>5️⃣ Test Recherche par Email</h2>");
            out.println("<p>Email testé: <strong>admin@gmail.com</strong></p>");
            
            UtilisateurDAO dao = new UtilisateurDAO();
            Utilisateur user = dao.findByEmail("admin@gmail.com");
            
            if (user != null) {
                out.println("<p class='success'>✓ Utilisateur trouvé!</p>");
                out.println("<p>Email: " + user.getEmail() + "</p>");
                out.println("<p>Rôle: " + user.getRole() + "</p>");
                out.println("<p>Username: " + user.getUsername() + "</p>");
            } else {
                out.println("<p class='error'>❌ Aucun utilisateur avec email admin@gmail.com</p>");
            }

            // Test 6: Aide
            out.println("<h2>6️⃣ Solutions possibles</h2>");
            out.println("<p class='warning'>⚠️ Si la table est vide, exécute ce SQL:</p>");
            out.println("<div class='code'>");
            out.println("INSERT INTO utilisateur (username, mot_de_passe, role, email) <br>");
            out.println("VALUES ('admin', 'admin123', 'ADMIN', 'admin@gmail.com');<br><br>");
            out.println("INSERT INTO utilisateur (username, mot_de_passe, role, email, num_etudiant) <br>");
            out.println("VALUES ('student', 'student123', 'ETUDIANT', 'student@gmail.com', 'E001');");
            out.println("</div>");

            cn.close();

        } catch (SQLException e) {
            out.println("<p class='error'>❌ ERREUR SQL: " + e.getMessage() + "</p>");
            out.println("<div class='code'>");
            out.println("Stack trace:<br>");
            StackTraceElement[] elements = e.getStackTrace();
            for (StackTraceElement elem : elements) {
                out.println(elem.toString() + "<br>");
            }
            out.println("</div>");
        } catch (Exception e) {
            out.println("<p class='error'>❌ ERREUR: " + e.getMessage() + "</p>");
            e.printStackTrace(out);
        }

        out.println("<hr>");
        out.println("<p style='text-align: center; margin-top: 30px; color: #666;'>");
        out.println("Diagnostic généré le: " + new java.util.Date() + "<br>");
        out.println("<a href='" + request.getContextPath() + "/login.jsp' style='color: #007bff;'>← Retour au login</a>");
        out.println("</p>");
        out.println("</div>");
        out.println("</body>");
        out.println("</html>");
    }
}
