package dao;

import model.Examen;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ExamenDAO {

    private static final String INSERT_SQL =
            "INSERT INTO examen(num_etudiant, annee_univ, note) VALUES (?, ?, ?)";
    private static final String FIND_ALL_SQL =
            "SELECT * FROM examen ORDER BY annee_univ DESC, note DESC";
    private static final String FIND_BY_ETUDIANT_SQL =
            "SELECT * FROM examen WHERE num_etudiant=? ORDER BY annee_univ DESC";
    private static final String CLASSEMENT_SQL =
            "SELECT e.num_exam, e.num_etudiant, e.annee_univ, e.note, et.nom, et.prenoms " +
                    "FROM examen e JOIN etudiant et ON e.num_etudiant = et.num_etudiant " +
                    "ORDER BY e.note DESC";

    public void create(Examen ex) throws SQLException {
        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(INSERT_SQL)) {
            ps.setString(1, ex.getNumEtudiant());
            ps.setString(2, ex.getAnneeUniv());
            ps.setInt(3, ex.getNote());
            ps.executeUpdate();
        }
    }

    public List<Examen> findAll() throws SQLException {
        List<Examen> list = new ArrayList<>();
        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(FIND_ALL_SQL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(map(rs));
            }
        }
        return list;
    }

    public List<Examen> findByEtudiant(String numEtudiant) throws SQLException {
        List<Examen> list = new ArrayList<>();
        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(FIND_BY_ETUDIANT_SQL)) {
            ps.setString(1, numEtudiant);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        }
        return list;
    }

    public boolean existsByEtudiantAndAnneeUniv(String numEtudiant, String anneeUniv) throws SQLException {
        String sql = "SELECT COUNT(*) FROM examen WHERE num_etudiant=? AND annee_univ=?";
        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, numEtudiant);
            ps.setString(2, anneeUniv);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public List<String[]> classement() throws SQLException {
        List<String[]> list = new ArrayList<>();
        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(CLASSEMENT_SQL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String[] row = new String[5];
                row[0] = rs.getString("num_exam");
                row[1] = rs.getString("num_etudiant");
                row[2] = rs.getString("nom") + " " + rs.getString("prenoms");
                row[3] = rs.getString("annee_univ");
                row[4] = String.valueOf(rs.getInt("note"));
                list.add(row);
            }
        }
        return list;
    }

    private Examen map(ResultSet rs) throws SQLException {
        Examen e = new Examen();
        e.setNumExam(rs.getInt("num_exam"));
        e.setNumEtudiant(rs.getString("num_etudiant"));
        e.setAnneeUniv(rs.getString("annee_univ"));
        e.setNote(rs.getInt("note"));
        return e;
    }
}

