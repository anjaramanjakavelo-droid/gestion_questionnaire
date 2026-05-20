package util;

import java.nio.charset.StandardCharsets;
import java.util.Properties;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class EmailUtil {

    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String SMTP_TIMEOUT_MS = "15000";

    private static final String SMTP_USER = "amiamnjk@gmail.com";
    private static final String SMTP_PASSWORD = resolvePassword();

    private EmailUtil() {
        // Utility class
    }

    public static void envoyerNote(String destinataire, String sujet, String contenu) {
        String safeDestinataire = destinataire == null ? "" : destinataire.trim();
        if (safeDestinataire.isEmpty()) {
            throw new IllegalArgumentException("Destinataire email manquant.");
        }

        Properties props = new Properties();
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.connectiontimeout", SMTP_TIMEOUT_MS);
        props.put("mail.smtp.timeout", SMTP_TIMEOUT_MS);
        props.put("mail.smtp.writetimeout", SMTP_TIMEOUT_MS);

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_USER, SMTP_PASSWORD);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SMTP_USER));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(safeDestinataire, false));
            message.setSubject(safeLine(sujet), StandardCharsets.UTF_8.name());
            message.setText(contenu == null ? "" : contenu, StandardCharsets.UTF_8.name());
            Transport.send(message);
        } catch (MessagingException e) {
            throw new RuntimeException("Erreur SMTP lors de l'envoi de l'email.", e);
        }
    }

    private static String safeLine(String value) {
        if (value == null || value.trim().isEmpty()) {
            return "(Sans objet)";
        }
        return value.replace('\r', ' ').replace('\n', ' ');
    }

    private static String resolvePassword() {
        String fromEnv = System.getenv("SMTP_PASSWORD");
        if (fromEnv != null && !fromEnv.trim().isEmpty()) {
            return fromEnv.trim();
        }
        return "oiiwuzzxhccljlil";
    }
}