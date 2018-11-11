package com.onlineclasses.servlets;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import com.onlineclasses.entities.BasicResponse;
import com.onlineclasses.entities.ContactRequest;
import com.onlineclasses.utils.Config;
import com.onlineclasses.utils.EmailSender;
import com.onlineclasses.utils.Labels;
import com.onlineclasses.utils.TasksManager;
import com.onlineclasses.utils.Utils;
import java.io.File;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/servlets/contact"})
public class ContactServlet extends BaseServlet {

    @Override
    protected BasicResponse handleRequest(String requestString, HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        ContactRequest contactRequest = Utils.gson().fromJson(requestString, ContactRequest.class);

        String email_name = Config.get("mail.emails.path") + File.separator
                + Config.get("website.language") + File.separator + "contact.html";
        String emailContent = Utils.getStringFromInputStream(email_name);

        emailContent = emailContent.replaceAll("<% contactName %>", contactRequest.name);
        emailContent = emailContent.replaceAll("<% contactSubject %>", contactRequest.subject);
        emailContent = emailContent.replaceAll("<% contactPhone %>", contactRequest.phone);
        emailContent = emailContent.replaceAll("<% contactEmail %>", contactRequest.email);
        emailContent = emailContent.replaceAll("<% contactMessage %>", contactRequest.message);

        EmailSender.addEmail(contactRequest.email, Labels.get("emails.contact.title"), emailContent);
        TasksManager.runNow(EmailSender.EMAIL_SENDER_NAME);
        return new BasicResponse(0, "");
    }

}
