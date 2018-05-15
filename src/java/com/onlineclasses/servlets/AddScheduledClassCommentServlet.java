package com.onlineclasses.servlets;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import com.onlineclasses.db.DB;
import com.onlineclasses.entities.BasicResponse;
import com.onlineclasses.entities.ScheduledClass;
import com.onlineclasses.entities.ScheduledClassComment;
import com.onlineclasses.entities.Student;
import com.onlineclasses.entities.Teacher;
import com.onlineclasses.entities.User;
import com.onlineclasses.servlets.entities.AddClassCommentRequest;
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

@WebServlet(urlPatterns = {"/servlets/add_class_comment"})
public class AddScheduledClassCommentServlet extends ServletBase {

    @Override
    protected BasicResponse handleRequest(String requestString, HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        AddClassCommentRequest addClassCommentRequest = Utils.gson().fromJson(requestString, AddClassCommentRequest.class);

        User user = getUser(request);
        if (user == null ) {
            Utils.warning("guest can'f add comment on scheduled class id " + addClassCommentRequest.scheduled_class_id);
            return new BasicResponse(-1, "guest can't add comment");
        }
        
        Utils.info(user + " add comment " + addClassCommentRequest.comment + " on class id " + addClassCommentRequest.scheduled_class_id);

        ScheduledClass scheduledClass  = DB.getScheduledClass(addClassCommentRequest.scheduled_class_id);
        if ( scheduledClass == null ) {
            Utils.warning("can'f find scheduled class id " + addClassCommentRequest.scheduled_class_id);
            return new BasicResponse(-1, "scheduled class not found");
        }
       
        ScheduledClassComment scheduledClassComment = new ScheduledClassComment();
        scheduledClassComment.comment = addClassCommentRequest.comment;
        scheduledClassComment.scheduled_class = scheduledClass;
        
        if ( user.equals(scheduledClass.student) ) {
            scheduledClassComment.student = (Student)user;            
        } else if ( user.equals(scheduledClass.teacher) ) {
            scheduledClassComment.teacher = (Teacher)user;            
        } else {
            Utils.warning(user + "can'f add comment on scheduled class id " + addClassCommentRequest.scheduled_class_id + ", not student not teacher");
            return new BasicResponse(-1, "not student not teacher");
        }
                       
        scheduledClassComment.added = new Date();
        if ( 1 != DB.add(scheduledClassComment) ) {
            Utils.warning("failed to add scheduled class comment");
            return new BasicResponse(-1, "failed to add comment");
        }
        
        Calendar classStart = Calendar.getInstance();
        classStart.setTime(scheduledClass.start_date);
        
        sendEmail(user, scheduledClass, classStart, scheduledClassComment.comment );
        
        return new BasicResponse(0, "");
    }
    
     private void sendEmail(User commentator, ScheduledClass scheduledClass, Calendar classStart, String comment) throws Exception {
        String email_name = Config.get("mail.emails.path") + File.separator
                + Config.get("website.language") + File.separator + "scheduled_class_added_comment.html";
        Utils.info("sending email " + email_name);

        String emailContent = Utils.getStringFromInputStream(getServletContext(), email_name);

        emailContent = emailContent.replaceAll("<% commentator %>", commentator.display_name);
        emailContent = emailContent.replaceAll("<% comment %>", comment);
        emailContent = emailContent.replaceAll("<% classDay %>", Utils.dayNameLong(classStart.get(Calendar.DAY_OF_WEEK)) + " " + new SimpleDateFormat("dd/MM/YYYY").format(scheduledClass.start_date));
        emailContent = emailContent.replaceAll("<% classTime %>", new SimpleDateFormat("HH:mm").format(scheduledClass.start_date));
        emailContent = emailContent.replaceAll("<% scheduledClassLink %>", Config.get("website.url") + "/scheduled_class?id=" + scheduledClass.id);
        emailContent = emailContent.replaceAll("<% gotoClass %>", Labels.get("emails.new_scheduled_class.goto_class"));
        emailContent = emailContent.replaceAll("<% classSubject %>", scheduledClass.subject);

        List<User> to = Arrays.asList(scheduledClass.student, scheduledClass.teacher);
        EmailSender.addEmail(to, Labels.get("emails.scheduled_class_added_comment.title"), emailContent);
        TasksManager.runNow(TasksManager.TASK_EMAIL);
    }

}
