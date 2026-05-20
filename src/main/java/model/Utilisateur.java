package model;

public class Utilisateur {

    private int idUser;
    private String username;
    private String motDePasse;
    private String role;
    private String email;
    private String numEtudiant;

    public Utilisateur() {
    }

    public Utilisateur(int idUser, String username, String motDePasse, String role, String email, String numEtudiant) {
        this.idUser = idUser;
        this.username = username;
        this.motDePasse = motDePasse;
        this.role = role;
        this.email = email;
        this.numEtudiant = numEtudiant;
    }

    public int getIdUser() {
        return idUser;
    }

    public void setIdUser(int idUser) {
        this.idUser = idUser;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getMotDePasse() {
        return motDePasse;
    }

    public void setMotDePasse(String motDePasse) {
        this.motDePasse = motDePasse;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getNumEtudiant() {
        return numEtudiant;
    }

    public void setNumEtudiant(String numEtudiant) {
        this.numEtudiant = numEtudiant;
    }
}