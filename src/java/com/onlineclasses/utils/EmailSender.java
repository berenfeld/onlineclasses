/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.utils;

import com.onlineclasses.db.DB;
import com.onlineclasses.entities.Email;
import com.onlineclasses.entities.Student;
import com.onlineclasses.entities.User;
import java.util.List;
import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.HtmlEmail;

/**
 *
 * @author me
 */
public class EmailSender extends BaseTask {

    public EmailSender() {
        super("email sender");
    }

    @Override
    protected void runTask() throws Exception {
        if ( ! Config.getBool("mail.enabled")) {
            Utils.warning("not sending email. email disabled");
            return;
        }
        List<Email> emails = DB.getAll(Email.class);
        for (Email email : emails) {
            sendEmail(email);
        }
    }

    private void sendEmail(Email emailToSend) throws Exception {

        Utils.info("sending email " + emailToSend.id + " to " + emailToSend.to + " title " + emailToSend.subject);

        emailToSend.message = emailToSend.message.replaceAll("<% emailTitle %>", emailToSend.subject);
        emailToSend.message = emailToSend.message.replaceAll("<% websiteURL %>", Config.get("website.url"));
        emailToSend.message = emailToSend.message.replaceAll("<% websiteName %>", Labels.get("mail.website.name"));
        emailToSend.message = emailToSend.message.replaceAll("<% adminEmail %>", Config.get("website.admin_email"));
        emailToSend.message = emailToSend.message.replaceAll("<% contactUs %>", Labels.get("emails.contact_us"));
                
        String hashString = emailToSend.to + "." + Config.get("website.secret.md5");
        String unsubscribeURL = Config.get("website.url") + "/unsubscribe?email=" + emailToSend.to + "&hash=" + hashString;
                
        emailToSend.message = emailToSend.message.replaceAll("<% unsubscribeURL %>", unsubscribeURL);

        HtmlEmail email = new HtmlEmail();

        email.setCharset(org.apache.commons.mail.EmailConstants.UTF_8);
        email.addHeader( "Content-Language", Config.get("website.html_language"));        
        email.addHeader( "List-Unsubscribe", "<mailto:" + Config.get("mail.admin") + ">, <" + unsubscribeURL + ">");
        
        email.setHostName(Config.get("mail.host"));
        email.setSmtpPort(Config.getInt("mail.port"));
        email.setFrom(Config.get("mail.from"), Config.get("mail.from.name"));
        email.addReplyTo(Config.get("mail.reply_to"));
        email.setSubject(emailToSend.subject);
        email.setHtmlMsg(emailToSend.message);
        email.addTo(emailToSend.to);
        email.addBcc(Config.get("mail.admin"));                                
        
        try {
            email.send();
        } catch (EmailException ex) {
            Utils.info("failed sending email " + emailToSend.id + " to " + emailToSend.to);
            Utils.exception(ex);
            return;
        }
        if (1 != DB.deleteEmail(emailToSend)) {
            Utils.warning("failed to delete email id " + emailToSend.id + " to " + emailToSend.to);
        }
    }

    public static void addEmail(String to, String subject, String message) throws Exception {
        Email email = new Email();
        email.to = to;
        email.subject = subject;
        email.message = message;

        if (1 != DB.addEmail(email)) {
            Utils.warning("failed to add email id " + email.id + " to " + email.to );
        }

        Utils.info("sending email " + email.subject + " to " + email.to + " text : " + email.message);
    }

    public static void addEmail(List<User> tos, String subject, String message) throws Exception {
        for (User to : tos) {
            if ( ( to instanceof Student ) && ( ! ((Student)to).emails_enabled) ) {
                Utils.warning("not sending email to email disabled user " + to );
                continue;
            }
            addEmail(to.email, subject, message);
        }    
        
    }
}
