package dao;

import model.Utilisateur;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UtilisateurDAO {

    private static final String INSERT_SQL =
            "INSERT INTO utilisateur(username, mot_de_passe, role, email) VALUES (?, ?, ?, ?)";
    private static final String UPDATE_SQL =
            "UPDATE utilisateur SET mot_de_passe=?, role=?, email=? WHERE id_user=?";
    private static final String DELETE_SQL =
            "DELETE FROM utilisateur WHERE id_user=?";
    private static final String FIND_BY_ID_SQL =
            "SELECT * FROM utilisateur WHERE id_user=?";
    private static final String FIND_BY_USERNAME_SQL =
            "SELECT * FROM utilisateur WHERE username=?";
    private static final String FIND_BY_EMAIL_SQL =
            "SELECT * FROM utilisateur WHERE email=?";

    public void create(Utilisateur u) throws SQLException {
        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(INSERT_SQL)) {
            ps.setString(1, u.getUsername());
            ps.setString(2, u.getMotDePasse());
            ps.setString(3, u.getRole());
            ps.setString(4, u.getEmail());
            ps.executeUpdate();
        }
    }

    public void update(Utilisateur u) throws SQLException {
        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(UPDATE_SQL)) {
            ps.setString(1, u.getMotDePasse());
            ps.setString(2, u.getRole());
            ps.setString(3, u.getEmail());
            ps.setInt(4, u.getIdUser());
            ps.executeUpdate();
        }
    }

    public void delete(int idUser) throws SQLException {
        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(DELETE_SQL)) {
            ps.setInt(1, idUser);
            ps.executeUpdate();
        }
    }

    public Utilisateur findById(int idUser) throws SQLException {
        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(FIND_BY_ID_SQL)) {
            ps.setInt(1, idUser);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
                return null;
            }
        }
    }

    public Utilisateur findByUsername(String username) throws SQLException {
        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(FIND_BY_USERNAME_SQL)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
                return null;
            }
        }
    }

public Utilisateur findByEmail(String email) throws SQLException {
    String sql = "SELECT * FROM utilisateur WHERE email = ?";

    System.out.println("🔍 QUERY: " + sql);
    System.out.println("   Paramètre email: [" + email + "]");

    try (Connection cn = DBConnection.getConnection();
         PreparedStatement ps = cn.prepareStatement(sql)) {

        ps.setString(1, email != null ? email.trim() : null);

        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                System.out.println("   ✓ Utilisateur trouvé !");
                Utilisateur user = map(rs);
                System.out.println("   Email en BD: [" + user.getEmail() + "]");
                System.out.println("   Rôle: " + user.getRole());
                return user;
            } else {
                System.out.println("   ❌ Aucun résultat pour email: [" + email + "]");
                return null;
            }
        }
    }
}

    private Utilisateur map(ResultSet rs) throws SQLException {
        Utilisateur u = new Utilisateur();
        u.setIdUser(rs.getInt("id_user"));
        
        // Trim all string values to remove spaces
        String username = rs.getString("username");
        String motDePasse = rs.getString("mot_de_passe");
        String role = rs.getString("role");
        String email = rs.getString("email");
        
        u.setUsername(username != null ? username.trim() : null);
        u.setMotDePasse(motDePasse != null ? motDePasse.trim() : null);
        u.setRole(role != null ? role.trim() : null);
        u.setEmail(email != null ? email.trim() : null);
        
        // num_etudiant is optional (not all users have it)
        try {
            String numEtudiant = rs.getString("num_etudiant");
            u.setNumEtudiant(numEtudiant != null ? numEtudiant.trim() : null);
        } catch (SQLException e) {
            // Column doesn't exist, set as null
            u.setNumEtudiant(null);
        }
        
        return u;
    }
}