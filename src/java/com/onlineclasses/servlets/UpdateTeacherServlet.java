package com.onlineclasses.servlets;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import com.onlineclasses.db.DB;
import com.onlineclasses.entities.AvailableTime;
import com.onlineclasses.entities.BasicResponse;
import com.onlineclasses.entities.Institute;
import com.onlineclasses.entities.Subject;
import com.onlineclasses.entities.Teacher;
import com.onlineclasses.entities.TeachingTopic;
import com.onlineclasses.entities.Topic;
import com.onlineclasses.servlets.entities.UpdateTeacherRequest;
import com.onlineclasses.utils.Utils;
import java.util.Date;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/servlets/update_teacher"})
public class UpdateTeacherServlet extends BaseServlet {

    @Override
    protected BasicResponse handleRequest(String requestString, HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        UpdateTeacherRequest updateTeacherRequest = Utils.gson().fromJson(requestString, UpdateTeacherRequest.class);

        Teacher teacher = (Teacher) BaseServlet.getUser(request);
        if (teacher ==null) {
            Utils.warning("not logged in");
            return new BasicResponse(-1, "not logged in");
        }
        
        teacher.display_name = updateTeacherRequest.display_name;
        teacher.first_name = updateTeacherRequest.first_name;
        teacher.last_name = updateTeacherRequest.last_name;        
        teacher.skype_name = updateTeacherRequest.skype_name;
        teacher.moto = updateTeacherRequest.moto;
        teacher.show_phone = updateTeacherRequest.show_phone;
        teacher.show_email = updateTeacherRequest.show_email;
        teacher.show_skype = updateTeacherRequest.show_skype;
        teacher.registered = new Date();
        teacher.degree_type = updateTeacherRequest.degree_type;
        teacher.show_degree = updateTeacherRequest.show_degree;
        teacher.price_per_hour = updateTeacherRequest.price_per_hour;

        teacher.institute = null;
        teacher.institute_name = null;
        if (updateTeacherRequest.institute_id != 0) {
            teacher.institute = DB.get(updateTeacherRequest.institute_id, Institute.class);            
        } else {            
            teacher.institute_name = updateTeacherRequest.institute_name;
        }

        teacher.subject = null;
        teacher.subject_name = null;
                
        if (updateTeacherRequest.subject_id != 0) {
            teacher.subject = DB.get(updateTeacherRequest.subject_id, Subject.class);
        } else {
            teacher.subject_name = updateTeacherRequest.subject_name;
        }

        if (DB.update(teacher) != 1) {
            Utils.warning("Could not update teacher " + teacher.display_name);
            return new BasicResponse(-1, "user is already registered");
        }
        
        if ( 0 == DB.deleteTeacherTeachingTopics(teacher) ) {
            Utils.warning("no previous teaching topics, or could not delete teaching topics of teacher " + teacher);
        }

        for (int topicId : updateTeacherRequest.teaching_topics) {
            TeachingTopic teachingTopic = new TeachingTopic();
            teachingTopic.teacher = teacher;
            teachingTopic.topic = DB.get(topicId, Topic.class);
            if (DB.add(teachingTopic) != 1) {
                Utils.warning("Could not add teaching topic " + teachingTopic + " to teacher " + teacher );
            }
        }

        if ( 0 == DB.deleteTeacherAvailableTime(teacher) ) {
            Utils.warning("could not delete available time of teacher " + teacher);
        }
        
        for (AvailableTime avilableTime : updateTeacherRequest.available_times) {
            avilableTime.teacher = teacher;
            if (DB.add(avilableTime) != 1) {
                Utils.warning("Could not add available time " + avilableTime + " to teacher " + teacher );
            }
        }

        Utils.info("teacher " + teacher.display_name + " email " + teacher.email + " update profile");

        // TODO send email
        return new BasicResponse(0, "");
    }

}
