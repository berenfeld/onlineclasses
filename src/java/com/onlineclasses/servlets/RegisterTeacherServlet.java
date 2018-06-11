package com.onlineclasses.servlets;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import com.onlineclasses.db.DB;
import com.onlineclasses.entities.AvailableTime;
import com.onlineclasses.entities.BasicResponse;
import com.onlineclasses.entities.City;
import com.onlineclasses.entities.GoogleUser;
import com.onlineclasses.entities.Institute;
import com.onlineclasses.entities.Subject;
import com.onlineclasses.entities.Teacher;
import com.onlineclasses.entities.TeachingTopic;
import com.onlineclasses.entities.Topic;
import com.onlineclasses.entities.User;
import com.onlineclasses.servlets.entities.RegisterTeacherRequest;
import com.onlineclasses.utils.Utils;
import java.util.Date;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/servlets/register_teacher"})
public class RegisterTeacherServlet extends BaseServlet {

    @Override
    protected BasicResponse handleRequest(String requestString, HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        RegisterTeacherRequest registerTeacherRequest = Utils.gson().fromJson(requestString, RegisterTeacherRequest.class);

        if (Utils.isEmpty(registerTeacherRequest.google_id_token)) {
            Utils.warning("no google id in login request");
            return new BasicResponse(-1, "no google id");
        }
        GoogleUser googleUser = GoogleIdTokenServlet.userFromGoogleToken(registerTeacherRequest.google_id_token);
        if (googleUser == null) {
            Utils.warning("failed to get user from google id token");
            return new BasicResponse(-1, "user was not found");
        }

        User user = DB.getUserByEmail(googleUser.email);
        if (user != null) {
            Utils.warning("user " + user.display_name + " email " + user.email + " already registered");
            return new BasicResponse(-1, "user is already registered");
        }

        Teacher registeringTeacher = new Teacher();
        registeringTeacher.email = googleUser.email;
        registeringTeacher.display_name = registerTeacherRequest.display_name;
        registeringTeacher.image_url = googleUser.image_url;
        registeringTeacher.first_name = registerTeacherRequest.first_name;
        registeringTeacher.last_name = registerTeacherRequest.last_name;
        registeringTeacher.gender = registerTeacherRequest.gender;
        registeringTeacher.phone_area = registerTeacherRequest.phone_area;
        registeringTeacher.phone_number = registerTeacherRequest.phone_number;
        registeringTeacher.day_of_birth = registerTeacherRequest.day_of_birth;
        registeringTeacher.skype_name = registerTeacherRequest.skype_name;
        registeringTeacher.moto = registerTeacherRequest.moto;
        registeringTeacher.show_phone = registerTeacherRequest.show_phone;
        registeringTeacher.show_email = registerTeacherRequest.show_email;
        registeringTeacher.show_skype = registerTeacherRequest.show_skype;
        registeringTeacher.registered = new Date();
        registeringTeacher.degree_type = registerTeacherRequest.degree_type;
        registeringTeacher.show_degree = registerTeacherRequest.show_degree;
        registeringTeacher.paypal_email = registerTeacherRequest.paypal_email;
        registeringTeacher.price_per_hour = registerTeacherRequest.price_per_hour;

        if (registerTeacherRequest.institute_id != 0) {
            registeringTeacher.institute = DB.get(registerTeacherRequest.institute_id, Institute.class);
        } else {
            registeringTeacher.institute_name = registerTeacherRequest.institute_name;
        }

        if (registerTeacherRequest.subject_id != 0) {
            registeringTeacher.subject = DB.get(registerTeacherRequest.subject_id, Subject.class);
        } else {
            registeringTeacher.subject_name = registerTeacherRequest.subject_name;
        }

        if (registerTeacherRequest.city_id != 0) {
            registeringTeacher.city = DB.get(registerTeacherRequest.city_id, City.class);
        }
        
        if (DB.add(registeringTeacher) != 1) {
            Utils.warning("Could not add user " + registeringTeacher.display_name);
            return new BasicResponse(-1, "user is already registered");
        }

        for (int topicId : registerTeacherRequest.teaching_topics) {
            TeachingTopic teachingTopic = new TeachingTopic();
            teachingTopic.teacher = registeringTeacher;
            teachingTopic.topic = DB.get(topicId, Topic.class);
            if (DB.add(teachingTopic) != 1) {
                Utils.warning("Could not add teaching topic " + teachingTopic + " to teacher " + registeringTeacher );
            }
        }

        for (AvailableTime avilableTime : registerTeacherRequest.available_times) {
            avilableTime.teacher = registeringTeacher;
            if (DB.add(avilableTime) != 1) {
                Utils.warning("Could not add available time " + avilableTime + " to teacher " + registeringTeacher );
            }
        }
                
        BaseServlet.loginUser(request, registeringTeacher);
        Utils.info("teacher " + registeringTeacher.display_name + " email " + registeringTeacher.email + " registered");

        // TODO send email
        return new BasicResponse(0, "");
    }

}
