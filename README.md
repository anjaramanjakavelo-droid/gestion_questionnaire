# 📚 Plateforme de Gestion des Examens QCM

Application web de gestion d'étudiants, de questionnaires QCM et d'examens universitaires développée avec **Java JSP/Servlet**, **Apache Tomcat** et **MySQL**.

L'application permet aux administrateurs de gérer les étudiants et les questions, tandis que les étudiants peuvent passer des examens QCM et consulter leur classement.

---

## 🚀 Technologies utilisées

* **Java JDK 21**
* **JSP (JavaServer Pages)**
* **Servlet**
* **JDBC**
* **Apache Tomcat 9**
* **MySQL**
* **Bootstrap 5**
* **HTML5 / CSS3**
* **JavaScript**
* **Eclipse IDE**
* Architecture **MVC (Model - View - Controller)**

---

## ✨ Fonctionnalités

### 🔐 Authentification et gestion des rôles

L'application possède deux rôles :

#### 👨‍💼 ADMIN

L'administrateur peut :

* Se connecter à la plateforme
* Gérer les étudiants
* Ajouter un étudiant
* Modifier un étudiant
* Supprimer un étudiant
* Consulter la liste des étudiants
* Rechercher un étudiant par numéro ou par nom
* Consulter les effectifs par niveau
* Gérer les questions QCM
* Ajouter une question
* Modifier une question
* Supprimer une question
* Consulter les examens et les notes
* Consulter le classement

#### 👨‍🎓 ETUDIANT

L'étudiant peut :

* Se connecter à la plateforme
* Passer un examen QCM
* Répondre aux questions proposées
* Obtenir une note sur 10
* Consulter le classement

### 🏆 Classement

Le classement permet d'afficher les étudiants par ordre de mérite en fonction de leurs résultats.

Cette partie est accessible aux utilisateurs autorisés ainsi qu'aux visiteurs selon la configuration de l'application.

---

## 📝 Gestion des examens

Lorsqu'un étudiant passe un examen :

1. L'application sélectionne aléatoirement **10 questions** dans la table `qcm`.
2. L'étudiant répond aux questions.
3. Les réponses sont évaluées automatiquement.
4. Une note sur **10** est calculée.
5. Le résultat est enregistré dans la table `examen`.
6. Un étudiant ne peut passer qu'un seul examen pour une même année universitaire.

### Exemple

Un étudiant peut passer :

* Examen 2025-2026 ✅
* Examen 2026-2027 ✅

Mais il ne peut pas passer deux fois :

* Examen 2025-2026 ❌

---

# 🗄️ Base de données

La base de données utilisée par l'application s'appelle :

`examen`

## Tables principales

### ETUDIANT

| Champ        | Type        | Description                   |
| ------------ | ----------- | ----------------------------- |
| num_etudiant | VARCHAR(20) | Identifiant de l'étudiant     |
| nom          | VARCHAR     | Nom                           |
| prenoms      | VARCHAR     | Prénoms                       |
| niveau       | VARCHAR     | Niveau : L1, L2, L3, M1 ou M2 |
| adr_email    | VARCHAR     | Adresse email                 |

### QCM

| Champ         | Type | Description                |
| ------------- | ---- | -------------------------- |
| num_quest     | INT  | Identifiant de la question |
| question      | TEXT | Question                   |
| reponse1      | TEXT | Première réponse           |
| reponse2      | TEXT | Deuxième réponse           |
| reponse3      | TEXT | Troisième réponse          |
| reponse4      | TEXT | Quatrième réponse          |
| bonne_reponse | INT  | Réponse correcte           |

### EXAMEN

| Champ        | Type        | Description                   |
| ------------ | ----------- | ----------------------------- |
| num_exam     | INT         | Identifiant de l'examen       |
| num_etudiant | VARCHAR(20) | Étudiant ayant passé l'examen |
| annee_univ   | VARCHAR(9)  | Année universitaire           |
| note         | INT         | Note obtenue sur 10           |

### UTILISATEUR

| Champ        | Type        | Description             |
| ------------ | ----------- | ----------------------- |
| id_user      | INT         | Identifiant utilisateur |
| username     | VARCHAR     | Nom d'utilisateur       |
| mot_de_passe | VARCHAR     | Mot de passe            |
| role         | VARCHAR     | ADMIN ou ETUDIANT       |
| email        | VARCHAR     | Email de connexion      |
| num_etudiant | VARCHAR(20) | Numéro étudiant associé |

---

# 🏗️ Architecture du projet

L'application respecte une architecture **MVC**.

```text
src/
├── main/
│   ├── java/
│   │   ├── model/
│   │   │   ├── Etudiant.java
│   │   │   ├── QCM.java
│   │   │   ├── Examen.java
│   │   │   └── Utilisateur.java
│   │   │
│   │   ├── dao/
│   │   │   ├── DBConnection.java
│   │   │   ├── EtudiantDAO.java
│   │   │   ├── QCMDAO.java
│   │   │   ├── ExamenDAO.java
│   │   │   └── UtilisateurDAO.java
│   │   │
│   │   └── servlet/
│   │       ├── LoginServlet.java
│   │       ├── LogoutServlet.java
│   │       ├── AuthFilter.java
│   │       ├── EtudiantServlet.java
│   │       ├── QCMServlet.java
│   │       └── ExamenServlet.java
│   │
│   └── webapp/
│       ├── css/
│       ├── js/
│       ├── images/
│       ├── fragments/
│       ├── login.jsp
│       ├── etudiants.jsp
│       ├── qcm.jsp
│       ├── examen.jsp
│       ├── classement.jsp
│       └── WEB-INF/
│           └── web.xml
```

---

# 🧩 Architecture MVC

### Model

Les classes du dossier `model` représentent les données de l'application.

Exemples :

* `Etudiant`
* `QCM`
* `Examen`
* `Utilisateur`

### DAO

Les DAO permettent de communiquer avec MySQL.

Ils contiennent notamment les opérations :

* INSERT
* SELECT
* UPDATE
* DELETE

### Servlet

Les Servlets jouent le rôle de **contrôleurs**.

Elles :

* reçoivent les requêtes HTTP
* récupèrent les données des formulaires
* appellent les DAO
* appliquent la logique de l'application
* redirigent vers les JSP

### JSP

Les JSP représentent la **vue**.

Elles servent principalement à :

* afficher les données
* afficher les formulaires
* présenter les résultats
* interagir avec l'utilisateur

---

# 🔒 Sécurité et autorisation

L'application utilise :

* `HttpSession` pour gérer les utilisateurs connectés
* `AuthFilter` pour contrôler l'accès aux pages
* `@WebFilter` pour intercepter les requêtes
* Gestion des rôles `ADMIN` et `ETUDIANT`

Les pages d'administration sont protégées et accessibles uniquement aux administrateurs.

---

# ⚙️ Installation

## 1. Prérequis

Installer :

* JDK 21
* Eclipse IDE
* Apache Tomcat 9
* XAMPP
* MySQL

---

## 2. Créer la base de données

Lancer **XAMPP** puis démarrer :

* Apache
* MySQL

Ouvrir phpMyAdmin et créer la base :

```sql
CREATE DATABASE examen;
```

Importer ensuite le script SQL fourni avec le projet.

---

## 3. Configurer la connexion MySQL

Modifier les informations de connexion dans :

```text
DBConnection.java
```

Exemple :

```java
private static final String URL =
    "jdbc:mysql://localhost:3306/examen";

private static final String USER =
    "root";

private static final String PASSWORD =
    "";
```

Adapter le mot de passe selon la configuration MySQL.

---

## 4. Ajouter MySQL Connector/J

Le projet nécessite **MySQL Connector/J**.

Ajouter le fichier `.jar` dans :

```text
src/main/webapp/WEB-INF/lib/
```

ou dans le Build Path du projet.

---

## 5. Configurer Tomcat

Dans Eclipse :

```text
Window
→ Preferences
→ Server
→ Runtime Environments
```

Ajouter **Apache Tomcat 9**.

Sélectionner le JDK utilisé par Tomcat.

---

## 6. Lancer l'application

Dans Eclipse :

```text
Servers
→ Tomcat v9.0
→ Start
```

Puis accéder à :

```text
http://localhost:8081/exemplaire/
```

Le port peut être différent selon la configuration de Tomcat.

---

# 👤 Compte administrateur de test

Un compte administrateur peut être créé avec :

```text
Email    : admin@gmail.com
Password : admin123
Role     : ADMIN
```

⚠️ Ce compte est uniquement destiné aux tests du projet.

---

# 📌 Règles métier principales

* Le niveau d'un étudiant doit être parmi :

  * L1
  * L2
  * L3
  * M1
  * M2

* Une année universitaire utilise le format :

```text
2025-2026
```

* Un examen contient 10 questions sélectionnées aléatoirement.
* La note finale est calculée sur 10.
* Un étudiant ne peut passer qu'un seul examen pour une même année universitaire.
* Les étudiants sont classés selon leurs résultats.

---

# 🎨 Interface utilisateur

L'application utilise **Bootstrap 5** afin de fournir une interface :

* responsive
* moderne
* cohérente
* adaptée aux ordinateurs et appareils mobiles

L'interface respecte également les principes d'ergonomie des interfaces web, notamment les critères de **Bastien et Scapin** :

* Guidage
* Charge de travail
* Contrôle explicite
* Adaptabilité
* Gestion des erreurs
* Homogénéité / cohérence
* Signifiance des codes et dénominations
* Compatibilité

---

# 📂 Gestion des ressources

Les ressources statiques sont organisées dans :

```text
src/main/webapp/
```

Exemple :

```text
webapp/
├── css/
├── js/
├── images/
└── fragments/
```

Les images utilisées par l'application sont placées dans :

```text
webapp/images/
```

---

# 🎯 Objectif du projet

Ce projet a pour objectif de mettre en pratique le développement d'une application web Java en utilisant :

* JSP
* Servlet
* JDBC
* MySQL
* MVC
* Authentification
* Gestion des rôles
* CRUD
* Gestion des examens
* Requêtes SQL
* Sessions
* Filtres
* Interface web responsive

---

# 👨‍💻 Projet universitaire

**Projet : Gestion des Questionnaires / Examens QCM**

Application développée dans le cadre de la formation en informatique.
