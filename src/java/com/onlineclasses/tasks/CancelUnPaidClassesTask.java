/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.tasks;

import com.onlineclasses.db.DB;
import com.onlineclasses.entities.Email;
import com.onlineclasses.entities.OClass;
import com.onlineclasses.entities.Student;
import com.onlineclasses.entities.Teacher;
import com.onlineclasses.entities.User;
import com.onlineclasses.utils.BaseTask;
import com.onlineclasses.utils.Config;
import com.onlineclasses.utils.EmailSender;
import com.onlineclasses.utils.Labels;
import com.onlineclasses.utils.TasksManager;
import com.onlineclasses.utils.Utils;
import java.io.File;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.HtmlEmail;

/**
 *
 * @author me
 */
public class CancelUnPaidClassesTask extends BaseTask {

    public static final String CANCEL_UNPAID_CLASSES_TASK_NAME = "cancel_unpaid_classes";

    public CancelUnPaidClassesTask() {
        super(CANCEL_UNPAID_CLASSES_TASK_NAME);
    }

    @Override
    protected void runTask() throws Exception {
        List<OClass> classesToCancel = DB.getUnpaidScheduledClasses();
        for (OClass oclass : classesToCancel) {
            Date now = new Date();
            if ( oclass.start_date.getTime() < now.getTime()) {
                cancelClass(oclass);
            }
        }
    }    

    private void cancelClass(OClass oClass) throws Exception
    {
        oClass.status = OClass.STATUS_CANCELCED;
        DB.update(oClass);
        sendEmail(oClass, "no payment");
        Utils.info("class " + oClass + " canceled. no payment");
    }

    private void sendEmail(OClass oClass, String cancelReason) throws Exception {

        String email_name = Config.get("mail.emails.path") + File.separator
                + Config.get("website.language") + File.separator + "class_canceled.html";
        Utils.info("sending email " + email_name);

        Teacher teacher = DB.get(oClass.teacher.id, Teacher.class);
        Student student = DB.get(oClass.student.id, Student.class);

        String emailContent = Utils.getStringFromInputStream(email_name);

        String cancelingUser = Config.get("website.admin_name");
        emailContent = emailContent.replaceAll("<% cancelingUser %>", cancelingUser);
        emailContent = emailContent.replaceAll("<% studentName %>", student.display_name);
        emailContent = emailContent.replaceAll("<% teacherName %>", teacher.display_name);
        emailContent = emailContent.replaceAll("<% cancelReason %>", cancelReason);
        emailContent = emailContent.replaceAll("<% classSubject %>", oClass.subject);
        emailContent = emailContent.replaceAll("<% findTeachersUrl %>", Config.get("website.url") + "/find_teachers");

        List<User> to = Arrays.asList(student, teacher);
        EmailSender.addEmail(to, Labels.get("emails.class_canceled.title"), emailContent);
        TasksManager.runNow(EmailSender.EMAIL_SENDER_NAME);        
    }

    public static void addEmail(String to, String subject, String message) throws Exception {
        Email email = new Email();
        email.to = to;
        email.subject = subject;
        email.message = message;

        if (1 != DB.add(email)) {
            Utils.warning("failed to add email id " + email.id + " to " + email.to);
        }

        Utils.info("sending email " + email.subject + " to " + email.to + " text : " + email.message);
    }

    public static void addEmail(List<User> tos, String subject, String message) throws Exception {
        for (User to : tos) {
            if ((to instanceof Student) && (!((Student) to).emails_enabled)) {
                Utils.warning("not sending email to email disabled user " + to);
                continue;
            }
            addEmail(to.email, subject, message);
        }

    }
 
}
