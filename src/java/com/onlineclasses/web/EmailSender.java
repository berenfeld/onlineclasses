/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.web;

import com.onlineclasses.db.DB;
import com.onlineclasses.entities.Email;
import com.onlineclasses.entities.User;
import java.util.List;
import org.apache.commons.mail.DefaultAuthenticator;
import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.SimpleEmail;

/**
 *
 * @author me
 */
public class EmailSender extends BaseTask {

    public EmailSender() {
        super("email sender");
    }

    protected void runTask() throws Exception {
        List<Email> emails = DB.getAllEmails();
        for (Email email : emails) {
            sendEmail(email);
        }
    }

    private void sendEmail(Email emailToSend) throws Exception {

        SimpleEmail email = new SimpleEmail();

        email.setHostName(Config.get("mail.host"));
        email.setSmtpPort(Config.getInt("mail.port"));
        email.setAuthenticator(new DefaultAuthenticator(Config.get("mail.user"), Config.get("mail.password")));
        email.setSSLOnConnect(false);
        email.setFrom(Config.get("mail.from"));
        email.setSubject(emailToSend.subject);
        email.setMsg(emailToSend.message);
        email.addTo(emailToSend.to);
        try {
            Utils.info("sending email " + emailToSend.id + " to " + emailToSend.to);
            email.send();
        } catch (Exception ex) {
            Utils.info("failed sending email " + emailToSend.id + " to " + emailToSend.to);
            Utils.exception(ex);
            return;
        }
        if (1 != DB.deleteEmail(emailToSend) ) {
            Utils.warning("failed to delete email id " + emailToSend.id + " to " + emailToSend.to);
        }
    }

    public static void addEmail(String to, String subject, String message) throws Exception 
    {
        Email email = new Email();
        email.to = to;
        email.subject = subject;
        email.message = message;
        
        if (1 != DB.addEmail(email) ) {
            Utils.warning("failed to add email id " + email.id + " to " + email.to);
        }
        
        TasksManager.runNow(TasksManager.TASK_EMAIL);
    }
}
