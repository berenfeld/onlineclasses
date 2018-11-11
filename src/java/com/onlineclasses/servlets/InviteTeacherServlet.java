package com.onlineclasses.servlets;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import com.onlineclasses.entities.BasicResponse;
import com.onlineclasses.servlets.entities.InviteTeacherRequest;
import com.onlineclasses.utils.Config;
import com.onlineclasses.utils.EmailSender;
import com.onlineclasses.utils.Labels;
import com.onlineclasses.utils.TasksManager;
import com.onlineclasses.utils.Utils;
import java.io.File;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/servlets/invite_teacher"})
public class InviteTeacherServlet extends BaseServlet {

    @Override
    protected BasicResponse handleRequest(String requestString, HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        InviteTeacherRequest inviteTeacherRequest = Utils.gson().fromJson(requestString, InviteTeacherRequest.class);

        Utils.info("invite teacher " + inviteTeacherRequest.teacher_name + " email " + inviteTeacherRequest.teacher_email + " from "
                + BaseServlet.getUser(request));

        String email_name = Config.get("mail.emails.path") + File.separator
                + Config.get("website.language") + File.separator + "invite_teacher.html";

        String emailContent = Utils.getStringFromInputStream(email_name);

        emailContent = emailContent.replaceAll("<% invitedTeacher %>", inviteTeacherRequest.teacher_name);
        emailContent = emailContent.replaceAll("<% websiteUrl %>", Config.get("website.url"));
        emailContent = emailContent.replaceAll("<% websiteShortName %>", Labels.get("website.name"));
        emailContent = emailContent.replaceAll("<% findTeachersUrl %>", Config.get("website.url") + "/find_teachers");
        emailContent = emailContent.replaceAll("<% registerTeacherUrl %>", Config.get("website.url") + "/start_teaching");

        EmailSender.addEmail(inviteTeacherRequest.teacher_email, Labels.get("emails.invite_teacher.title"), emailContent);
        TasksManager.runNow(EmailSender.EMAIL_SENDER_NAME);
        return new BasicResponse(0, "");
    }

}
