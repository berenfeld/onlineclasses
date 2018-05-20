package com.onlineclasses.servlets;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import com.onlineclasses.db.DB;
import com.onlineclasses.entities.BasicResponse;
import com.onlineclasses.entities.OClass;
import com.onlineclasses.entities.ClassComment;
import com.onlineclasses.entities.Student;
import com.onlineclasses.entities.Teacher;
import com.onlineclasses.entities.User;
import com.onlineclasses.servlets.entities.AddClassCommentRequest;
import com.onlineclasses.servlets.entities.CancelClassRequest;
import com.onlineclasses.utils.Config;
import com.onlineclasses.utils.EmailSender;
import com.onlineclasses.utils.Labels;
import com.onlineclasses.utils.TasksManager;
import com.onlineclasses.utils.Utils;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/servlets/cancel_class"})
public class CancelClassServlet extends ServletBase {

    @Override
    protected BasicResponse handleRequest(String requestString, HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        CancelClassRequest cancelClassRequest = Utils.gson().fromJson(requestString, CancelClassRequest.class);

        User user = getUser(request);
        if (user == null ) {
            Utils.warning("guest can'f cancel scheduled class id " + cancelClassRequest.scheduled_class_id);
            return new BasicResponse(-1, "guest can't cancel class");
        }
        
        Utils.info(user + " cancel class " +  cancelClassRequest.scheduled_class_id + " comment " + cancelClassRequest.comment);

        OClass scheduledClass  = DB.getScheduledClass(cancelClassRequest.scheduled_class_id);
        if ( scheduledClass == null ) {
            Utils.warning("can'd find scheduled class id " + cancelClassRequest.scheduled_class_id);
            return new BasicResponse(-1, "scheduled class not found");
        }
       
        Student student = null;
        Teacher teacher = null;
        if ( user.equals(scheduledClass.student) ) {
            student = (Student)user;            
        } else if ( user.equals(scheduledClass.teacher) ) {
            teacher = (Teacher)user;            
        } else {
            Utils.warning(user + "can'd cancel on scheduled class id " + cancelClassRequest.scheduled_class_id + ", not student not teacher");
            return new BasicResponse(-1, "not student not teacher");
        }
              
        ClassComment scheduledClassComment = new ClassComment();
        scheduledClassComment.scheduled_class = scheduledClass;
        scheduledClassComment.student = student;
        scheduledClassComment.teacher = teacher;
        scheduledClassComment.comment = "Class canceled. Reason : "+ cancelClassRequest.comment;
        scheduledClassComment.added = new Date();
        DB.add(scheduledClassComment);
        
        DB.updateClassStatus(scheduledClass, OClass.STATUS_CANCELCED);
                
        sendEmail(user, scheduledClass, scheduledClassComment.comment );
        
        return new BasicResponse(0, "");
    }
    
     private void sendEmail(User user, OClass scheduledClass, String comment) throws Exception {
        String email_name = Config.get("mail.emails.path") + File.separator
                + Config.get("website.language") + File.separator + "class_canceled.html";
        Utils.info("sending email " + email_name);

        Teacher teacher = DB.get(scheduledClass.teacher.id, Teacher.class);
        Student student = DB.get(scheduledClass.student.id, Student.class);
        
        String emailContent = Utils.getStringFromInputStream(getServletContext(), email_name);

        emailContent = emailContent.replaceAll("<% cancelingUser %>", user.display_name);
        emailContent = emailContent.replaceAll("<% studentName %>", student.display_name);
        emailContent = emailContent.replaceAll("<% teacherName %>", teacher.display_name);
        emailContent = emailContent.replaceAll("<% cancelReason %>", comment);
        emailContent = emailContent.replaceAll("<% classSubject %>", scheduledClass.subject);
        emailContent = emailContent.replaceAll("<% findTeachersUrl %>", Config.get("website.url") +"/find_teachers");        

        
        List<User> to = Arrays.asList(student, teacher);
        EmailSender.addEmail(to, Labels.get("emails.class_canceled.title"), emailContent);
        TasksManager.runNow(TasksManager.TASK_EMAIL);
    }

}
