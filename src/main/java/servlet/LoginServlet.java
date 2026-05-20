package servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import dao.UtilisateurDAO;
import model.Utilisateur;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // Trim pour éliminer les espaces
        if (email != null) email = email.trim();
        if (password != null) password = password.trim();

        System.out.println("\n========== LOGIN ATTEMPT ==========");
        System.out.println("Email reçu: [" + email + "]");
        System.out.println("Mot de passe reçu: [" + password + "]");

        UtilisateurDAO dao = new UtilisateurDAO();
        try {
            Utilisateur utilisateur = dao.findByEmail(email);
            
            if (utilisateur == null) {
                System.out.println("❌ ERREUR: Aucun utilisateur trouvé avec email: [" + email + "]");
                System.out.println("Vérifications possibles:");
                System.out.println("  1. L'email existe-t-il en base?");
                System.out.println("  2. Y a-t-il des espaces avant/après l'email?");
                System.out.println("  3. La casse est-elle correcte?");
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=true");
                return;
            }
            
            System.out.println("✓ Utilisateur trouvé!");
            System.out.println("  Email en BD: [" + utilisateur.getEmail() + "]");
            System.out.println("  Rôle: " + utilisateur.getRole());
            System.out.println("  Mot de passe en BD: [" + utilisateur.getMotDePasse() + "]");
            System.out.println("  Mot de passe saisi: [" + password + "]");
            System.out.println("  Length BD: " + (utilisateur.getMotDePasse() != null ? utilisateur.getMotDePasse().length() : "null"));
            System.out.println("  Length saisi: " + (password != null ? password.length() : "null"));
            
            // Comparaison avec trim aussi en BD
            String mdpBD = utilisateur.getMotDePasse();
            if (mdpBD != null) mdpBD = mdpBD.trim();
            
            boolean passwordMatch = mdpBD.equals(password);
            System.out.println("  Mot de passe correct? " + passwordMatch);
            
            if (passwordMatch) {
                // Authentication successful
                System.out.println("✅ AUTHENTIFICATION RÉUSSIE!");
                HttpSession session = request.getSession();
                session.setAttribute("utilisateur", utilisateur);

                // Redirect to home page
                System.out.println("➡️ Redirection vers /index.jsp");
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            } else {
                // Authentication failed
                System.out.println("❌ MOT DE PASSE INCORRECT");
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=true");
            }
        } catch (Exception e) {
            System.out.println("❌ EXCEPTION: " + e.getMessage());
            System.out.println("Type: " + e.getClass().getName());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=true");
        }
        System.out.println("===================================\n");
    }
}