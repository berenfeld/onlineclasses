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
import com.onlineclasses.servlets.entities.InviteStudentRequest;
import com.onlineclasses.utils.Config;
import com.onlineclasses.utils.EmailSender;
import com.onlineclasses.utils.Labels;
import com.onlineclasses.utils.TasksManager;
import com.onlineclasses.utils.Utils;
import java.io.File;
import java.util.Date;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/servlets/add_class_comment"})
public class AddClassCommentServlet extends ServletBase {

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
        scheduledClass.student = DB.getStudent(scheduledClass.student.id);
        scheduledClass.teacher = DB.getTeacher(scheduledClass.teacher.id);
        
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
        DB.add(scheduledClassComment);
          
        return new BasicResponse(0, "");
    }

}
