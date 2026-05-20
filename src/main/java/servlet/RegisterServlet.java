package servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dao.EtudiantDAO;
import dao.UtilisateurDAO;
import model.Etudiant;
import model.Utilisateur;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String numEtudiant = request.getParameter("numEtudiant");
        String nom = request.getParameter("nom");
        String prenoms = request.getParameter("prenoms");
        String niveau = request.getParameter("niveau");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Trim all inputs
        if (numEtudiant != null) numEtudiant = numEtudiant.trim();
        if (nom != null) nom = nom.trim();
        if (prenoms != null) prenoms = prenoms.trim();
        if (niveau != null) niveau = niveau.trim();
        if (email != null) email = email.trim();
        if (password != null) password = password.trim();
        if (confirmPassword != null) confirmPassword = confirmPassword.trim();

        System.out.println("\n========== REGISTRATION ATTEMPT ==========");
        System.out.println("Num Étudiant: [" + numEtudiant + "]");
        System.out.println("Nom: [" + nom + "]");
        System.out.println("Prénoms: [" + prenoms + "]");
        System.out.println("Niveau: [" + niveau + "]");
        System.out.println("Email: [" + email + "]");

        try {
            // Validation
            if (numEtudiant == null || numEtudiant.isEmpty()) {
                System.out.println("❌ ERREUR: Numéro étudiant vide");
                response.sendRedirect(request.getContextPath() + "/register.jsp?error=empty_num");
                return;
            }
            if (email == null || email.isEmpty()) {
                System.out.println("❌ ERREUR: Email vide");
                response.sendRedirect(request.getContextPath() + "/register.jsp?error=empty_email");
                return;
            }
            if (password == null || password.isEmpty()) {
                System.out.println("❌ ERREUR: Mot de passe vide");
                response.sendRedirect(request.getContextPath() + "/register.jsp?error=empty_password");
                return;
            }
            if (!password.equals(confirmPassword)) {
                System.out.println("❌ ERREUR: Les mots de passe ne correspondent pas");
                response.sendRedirect(request.getContextPath() + "/register.jsp?error=password_mismatch");
                return;
            }

            EtudiantDAO etudiantDAO = new EtudiantDAO();
            UtilisateurDAO utilisateurDAO = new UtilisateurDAO();

            // Check if email already exists in utilisateur
            Utilisateur existingUser = utilisateurDAO.findByEmail(email);
            if (existingUser != null) {
                System.out.println("❌ ERREUR: Email déjà utilisé");
                response.sendRedirect(request.getContextPath() + "/register.jsp?error=email_exists");
                return;
            }

            // Check if student exists
            Etudiant etudiant = etudiantDAO.findById(numEtudiant);
            
            if (etudiant == null) {
                // Student doesn't exist, create it
                System.out.println("📝 Création d'un nouvel étudiant...");
                etudiant = new Etudiant(numEtudiant, nom, prenoms, niveau, email);
                etudiantDAO.create(etudiant);
                System.out.println("✓ Étudiant créé!");
            } else {
                System.out.println("✓ Étudiant trouvé, mise à jour...");
                etudiant.setNom(nom);
                etudiant.setPrenoms(prenoms);
                etudiant.setNiveau(niveau);
                etudiant.setAdrEmail(email);
                etudiantDAO.update(etudiant);
                System.out.println("✓ Étudiant mis à jour!");
            }

            // Create user account linked to student via email
            System.out.println("📝 Création du compte utilisateur...");
            Utilisateur user = new Utilisateur();
            user.setUsername(email); // Use email as username
            user.setMotDePasse(password);
            user.setRole("ETUDIANT");
            user.setEmail(email); // Email is the link between user and student
            
            utilisateurDAO.create(user);
            System.out.println("✓ Compte utilisateur créé!");
            System.out.println("✅ INSCRIPTION RÉUSSIE!");
            
            // Redirect to login with success message
            response.sendRedirect(request.getContextPath() + "/login.jsp?success=true");

        } catch (Exception e) {
            System.out.println("❌ EXCEPTION: " + e.getMessage());
            System.out.println("Type: " + e.getClass().getName());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=true");
        }
        System.out.println("========================================\n");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to register.jsp
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }
}
