package dao;

import model.Etudiant;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class EtudiantDAO {

    private static final String INSERT_SQL =
            "INSERT INTO etudiant(num_etudiant, nom, prenoms, niveau, adr_email) VALUES (?, ?, ?, ?, ?)";
    private static final String UPDATE_SQL =
            "UPDATE etudiant SET nom=?, prenoms=?, niveau=?, adr_email=? WHERE num_etudiant=?";
    private static final String DELETE_SQL =
            "DELETE FROM etudiant WHERE num_etudiant=?";
    private static final String FIND_BY_ID_SQL =
            "SELECT * FROM etudiant WHERE num_etudiant=?";
    private static final String FIND_ALL_SQL =
            "SELECT * FROM etudiant ORDER BY nom, prenoms";
    private static final String SEARCH_SQL =
            "SELECT * FROM etudiant WHERE num_etudiant LIKE ? OR nom LIKE ? ORDER BY nom, prenoms";
    private static final String LIST_BY_NIVEAU_SQL =
            "SELECT * FROM etudiant WHERE niveau=? ORDER BY nom, prenoms";
    private static final String COUNT_BY_NIVEAU_SQL =
            "SELECT COUNT(*) FROM etudiant WHERE niveau=?";
    private static final String COUNT_GROUP_BY_NIVEAU_SQL =
            "SELECT niveau, COUNT(*) AS c FROM etudiant GROUP BY niveau ORDER BY niveau";

    public void create(Etudiant e) throws SQLException {
        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(INSERT_SQL)) {
            ps.setString(1, e.getNumEtudiant());
            ps.setString(2, e.getNom());
            ps.setString(3, e.getPrenoms());
            ps.setString(4, e.getNiveau());
            ps.setString(5, e.getAdrEmail());
            ps.executeUpdate();
        }
    }

    public void update(Etudiant e) throws SQLException {
        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(UPDATE_SQL)) {
            ps.setString(1, e.getNom());
            ps.setString(2, e.getPrenoms());
            ps.setString(3, e.getNiveau());
            ps.setString(4, e.getAdrEmail());
            ps.setString(5, e.getNumEtudiant());
            ps.executeUpdate();
        }
    }

    public void delete(String numEtudiant) throws SQLException {
        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(DELETE_SQL)) {
            ps.setString(1, numEtudiant);
            ps.executeUpdate();
        }
    }

    public Etudiant findById(String numEtudiant) throws SQLException {
        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(FIND_BY_ID_SQL)) {
            ps.setString(1, numEtudiant);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
                return null;
            }
        }
    }

    public List<Etudiant> findAll() throws SQLException {
        List<Etudiant> list = new ArrayList<>();
        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(FIND_ALL_SQL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(map(rs));
            }
        }
        return list;
    }

    public List<Etudiant> search(String keyword) throws SQLException {
        List<Etudiant> list = new ArrayList<>();
        String like = "%" + keyword + "%";
        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(SEARCH_SQL)) {
            ps.setString(1, like);
            ps.setString(2, like);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        }
        return list;
    }

    public List<Etudiant> listByNiveau(String niveau) throws SQLException {
        List<Etudiant> list = new ArrayList<>();
        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(LIST_BY_NIVEAU_SQL)) {
            ps.setString(1, niveau);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        }
        return list;
    }

    public int countByNiveau(String niveau) throws SQLException {
        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(COUNT_BY_NIVEAU_SQL)) {
            ps.setString(1, niveau);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    /**
     * Effectif par niveau (pour affichage sur la liste des etudiants).
     */
    public Map<String, Integer> countGroupByNiveau() throws SQLException {
        Map<String, Integer> map = new LinkedHashMap<>();
        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(COUNT_GROUP_BY_NIVEAU_SQL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getString("niveau"), rs.getInt("c"));
            }
        }
        return map;
    }

    public Etudiant findByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM etudiant WHERE adr_email=?";
        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        }
        return null;
    }

    private Etudiant map(ResultSet rs) throws SQLException {
        Etudiant e = new Etudiant();
        e.setNumEtudiant(rs.getString("num_etudiant"));
        e.setNom(rs.getString("nom"));
        e.setPrenoms(rs.getString("prenoms"));
        e.setNiveau(rs.getString("niveau"));
        e.setAdrEmail(rs.getString("adr_email"));
        return e;
    }
}

