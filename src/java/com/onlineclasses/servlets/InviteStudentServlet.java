package com.onlineclasses.servlets;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import com.onlineclasses.entities.BasicResponse;
import com.onlineclasses.servlets.entities.InviteStudentRequest;
import com.onlineclasses.utils.Config;
import com.onlineclasses.utils.EmailSender;
import com.onlineclasses.utils.Labels;
import com.onlineclasses.utils.TasksManager;
import com.onlineclasses.utils.Utils;
import java.io.File;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/servlets/invite_student"})
public class InviteStudentServlet extends ServletBase {

    @Override
    protected BasicResponse handleRequest(String requestString, HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        InviteStudentRequest inviteStudentRequest = Utils.gson().fromJson(requestString, InviteStudentRequest.class);

        Utils.info("invite student " + inviteStudentRequest.student_name + " email " + inviteStudentRequest.student_email + " from "
                + ServletBase.getUser(request));

        String email_name = Config.get("mail.emails.path") + File.separator
                + Config.get("website.language") + File.separator + "invite_student.html";
        
        String emailContent = Utils.getStringFromInputStream(getServletContext(), email_name);
           
        emailContent = emailContent.replaceAll("<% invitedStudent %>", inviteStudentRequest.student_name);
        emailContent = emailContent.replaceAll("<% websiteUrl %>", Config.get("website.url"));
        emailContent = emailContent.replaceAll("<% websiteShortName %>", Labels.get("website.name"));
        emailContent = emailContent.replaceAll("<% findTeachersUrl %>", Config.get("website.url") +"/find_teachers");
        emailContent = emailContent.replaceAll("<% registerStudentUrl %>", Config.get("website.url") +"/start_learning");

        EmailSender.addEmail(inviteStudentRequest.student_email, Labels.get("emails.invite_student.title"), emailContent);
        TasksManager.runNow(TasksManager.TASK_EMAIL);
        return new BasicResponse(0, "");
    }

}
