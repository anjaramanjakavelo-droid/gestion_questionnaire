package model;

public class Examen {

    private int numExam;
    private String numEtudiant;
    private String anneeUniv;
    private int note;

    public Examen() {
    }

    public Examen(int numExam, String numEtudiant, String anneeUniv, int note) {
        this.numExam = numExam;
        this.numEtudiant = numEtudiant;
        this.anneeUniv = anneeUniv;
        this.note = note;
    }

    public int getNumExam() {
        return numExam;
    }

    public void setNumExam(int numExam) {
        this.numExam = numExam;
    }

    public String getNumEtudiant() {
        return numEtudiant;
    }

    public void setNumEtudiant(String numEtudiant) {
        this.numEtudiant = numEtudiant;
    }

    public String getAnneeUniv() {
        return anneeUniv;
    }

    public void setAnneeUniv(String anneeUniv) {
        this.anneeUniv = anneeUniv;
    }

    public int getNote() {
        return note;
    }

    public void setNote(int note) {
        this.note = note;
    }
}

