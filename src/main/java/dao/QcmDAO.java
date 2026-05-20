package dao;

import model.Qcm;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class QcmDAO {

    private static final String INSERT_SQL =
            "INSERT INTO qcm(question, reponse1, reponse2, reponse3, reponse4, bonne_reponse) VALUES (?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_SQL =
            "UPDATE qcm SET question=?, reponse1=?, reponse2=?, reponse3=?, reponse4=?, bonne_reponse=? WHERE num_quest=?";
    private static final String DELETE_SQL =
            "DELETE FROM qcm WHERE num_quest=?";
    private static final String FIND_BY_ID_SQL =
            "SELECT * FROM qcm WHERE num_quest=?";
    private static final String FIND_ALL_SQL =
            "SELECT * FROM qcm ORDER BY num_quest";
    private static final String COUNT_SQL =
            "SELECT COUNT(*) FROM qcm";
    private static final String RANDOM_SQL =
            "SELECT * FROM qcm ORDER BY RAND() LIMIT ?";

    public void create(Qcm q) throws SQLException {
        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(INSERT_SQL)) {
            ps.setString(1, q.getQuestion());
            ps.setString(2, q.getReponse1());
            ps.setString(3, q.getReponse2());
            ps.setString(4, q.getReponse3());
            ps.setString(5, q.getReponse4());
            ps.setInt(6, q.getBonneReponse());
            ps.executeUpdate();
        }
    }

    public void update(Qcm q) throws SQLException {
        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(UPDATE_SQL)) {
            ps.setString(1, q.getQuestion());
            ps.setString(2, q.getReponse1());
            ps.setString(3, q.getReponse2());
            ps.setString(4, q.getReponse3());
            ps.setString(5, q.getReponse4());
            ps.setInt(6, q.getBonneReponse());
            ps.setInt(7, q.getNumQuest());
            ps.executeUpdate();
        }
    }

    public void delete(int numQuest) throws SQLException {
        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(DELETE_SQL)) {
            ps.setInt(1, numQuest);
            ps.executeUpdate();
        }
    }

    public Qcm findById(int numQuest) throws SQLException {
        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(FIND_BY_ID_SQL)) {
            ps.setInt(1, numQuest);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
                return null;
            }
        }
    }

    public List<Qcm> findAll() throws SQLException {
        List<Qcm> list = new ArrayList<>();
        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(FIND_ALL_SQL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(map(rs));
            }
        }
        return list;
    }

    public int count() throws SQLException {
        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(COUNT_SQL);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public List<Qcm> pickRandom(int nb) throws SQLException {
        List<Qcm> list = new ArrayList<>();
        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(RANDOM_SQL)) {
            ps.setInt(1, nb);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        }
        return list;
    }

    private Qcm map(ResultSet rs) throws SQLException {
        Qcm q = new Qcm();
        q.setNumQuest(rs.getInt("num_quest"));
        q.setQuestion(rs.getString("question"));
        q.setReponse1(rs.getString("reponse1"));
        q.setReponse2(rs.getString("reponse2"));
        q.setReponse3(rs.getString("reponse3"));
        q.setReponse4(rs.getString("reponse4"));
        q.setBonneReponse(rs.getInt("bonne_reponse"));
        return q;
    }
}

