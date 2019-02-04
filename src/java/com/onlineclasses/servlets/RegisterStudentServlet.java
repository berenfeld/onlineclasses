package com.onlineclasses.servlets;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import com.onlineclasses.db.DB;
import com.onlineclasses.entities.BasicResponse;
import com.onlineclasses.entities.City;
import com.onlineclasses.entities.FacebookUser;
import com.onlineclasses.entities.Feedback;
import com.onlineclasses.entities.GoogleUser;
import com.onlineclasses.entities.Institute;
import com.onlineclasses.entities.LearningTopic;
import com.onlineclasses.entities.LoginResponse;
import com.onlineclasses.entities.Student;
import com.onlineclasses.entities.Subject;
import com.onlineclasses.entities.Topic;
import com.onlineclasses.entities.User;
import com.onlineclasses.servlets.entities.RegisterStudentRequest;
import com.onlineclasses.utils.CLabels;
import com.onlineclasses.utils.Config;
import com.onlineclasses.utils.EmailSender;
import com.onlineclasses.utils.Labels;
import com.onlineclasses.utils.TasksManager;
import com.onlineclasses.utils.Utils;
import java.io.File;
import java.sql.SQLClientInfoException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/servlets/register_student"})
public class RegisterStudentServlet extends BaseServlet {

    @Override
    protected BasicResponse handleRequest(String requestString, HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        RegisterStudentRequest registerStudentRequest = Utils.gson().fromJson(requestString, RegisterStudentRequest.class);

        String userEmail;
        if (Utils.isNotEmpty(registerStudentRequest.google_id_token)) {
            GoogleUser googleUser = GoogleIdTokenServlet.userFromGoogleToken(registerStudentRequest.google_id_token);
            if (googleUser == null) {
                Utils.warning("failed to get user from google id token");
                return new BasicResponse(-1, "user was not found");
            }

            userEmail = googleUser.email;

        } else if (Utils.isNotEmpty(registerStudentRequest.facebook_access_token)) {
            FacebookUser facebookUser = FacebookAccessTokenServlet.userFromFacebookAccessToken(registerStudentRequest.facebook_access_token);
            if (facebookUser == null) {
                Utils.warning("failed to get user from facebook access token");
                return new BasicResponse(-1, "user was not found");
            }

            userEmail = facebookUser.email;
        } else {
            Utils.warning("no google id in login request");
            return new BasicResponse(-1, "no google id");
        }
        return registerStudent(userEmail, registerStudentRequest, request);
    }
    
    public static BasicResponse registerStudent(String userEmail, RegisterStudentRequest registerStudentRequest, HttpServletRequest request) throws Exception
    {
        User user = DB.getUserByEmail(userEmail);
        if (user != null) {
            Utils.warning("user " + user.display_name + " with email " + user.email + " already registered");
            return new BasicResponse(-1, Labels.get("start_learning.response.email_exist"));
        }
        
        Student registeringStudent = new Student();
        registeringStudent.email = userEmail;
        registeringStudent.display_name = registerStudentRequest.display_name;
        registeringStudent.image_url = registerStudentRequest.image_url;
        registeringStudent.first_name = registerStudentRequest.first_name;
        registeringStudent.last_name = registerStudentRequest.last_name;
        registeringStudent.gender = registerStudentRequest.gender;        
        registeringStudent.phone_area = registerStudentRequest.phone_area;
        registeringStudent.phone_number = registerStudentRequest.phone_number;
        registeringStudent.day_of_birth = registerStudentRequest.day_of_birth;
        registeringStudent.registered = new Date();
        registeringStudent.emails_enabled = true;
        registeringStudent.degree_type = registerStudentRequest.degree_type;

        if (registerStudentRequest.institute_id != 0) {
            registeringStudent.institute = DB.get(registerStudentRequest.institute_id, Institute.class);
        } else {
            registeringStudent.institute_name = registerStudentRequest.institute_name;
        }

        if (registerStudentRequest.subject_id != 0) {
            registeringStudent.subject = DB.get(registerStudentRequest.subject_id, Subject.class);
        } else {
            registeringStudent.subject_name = registerStudentRequest.subject_name;
        }
        
        if (registerStudentRequest.city_id != 0) {
            registeringStudent.city = DB.get(registerStudentRequest.city_id, City.class);
        }

        if (DB.add(registeringStudent) != 1) {
            Utils.warning("Could not add user " + registeringStudent.display_name);
            return new BasicResponse(-1, "user is already registered");
        }
        
        List<String> topicsList = new ArrayList();
        for (int topicId : registerStudentRequest.learning_topics) {
            LearningTopic learningTopic = new LearningTopic();
            learningTopic.student = registeringStudent;
            learningTopic.topic = DB.get(topicId, Topic.class);
            if (DB.add(learningTopic) != 1) {
                Utils.warning("Could not add learning topic " + learningTopic + " to student " + registeringStudent);
                return new BasicResponse(-1, Labels.get("start_teaching.response.system_error"));
            }
            topicsList.add(learningTopic.topic.name);
        }

        BaseServlet.loginUser(request, registeringStudent);

        Utils.info("student " + registeringStudent.display_name + " email " + registeringStudent.email + " registered");

        sendEmail(registeringStudent, topicsList);

        if (!Utils.isEmpty(registerStudentRequest.feedback)) {
            Feedback feedback = new Feedback();
            feedback.from = registerStudentRequest.display_name;
            feedback.email = registerStudentRequest.email;
            feedback.message = registerStudentRequest.feedback;
            DB.add(feedback);
            Utils.info("new feedback : " + feedback);
        }

        
        LoginResponse loginResponse = new LoginResponse(registeringStudent);
        loginResponse.student_register = true;
        return loginResponse;
    }
    
    private static void sendEmail(Student registeringStudent, List<String> topicsList) throws Exception {
        String email_name = Config.get("mail.emails.path") + File.separator
                + Config.get("website.language") + File.separator + "register_student.html";

        String emailContent = Utils.getStringFromInputStream(email_name);

        String yes = CLabels.get("language.yes");
        String no = CLabels.get("language.no");

        emailContent = emailContent.replaceAll("<% registeredStudent %>", registeringStudent.display_name);
        emailContent = emailContent.replaceAll("<% websiteUrl %>", Config.get("website.url"));
        emailContent = emailContent.replaceAll("<% websiteShortName %>", Labels.get("website.name"));
        emailContent = emailContent.replaceAll("<% findTeachersUrl %>", Config.get("website.url") + "/find_teachers");
        emailContent = emailContent.replaceAll("<% studentDisplayName %>", registeringStudent.display_name);
        emailContent = emailContent.replaceAll("<% studentEmail %>", registeringStudent.email);
        emailContent = emailContent.replaceAll("<% studentFullName %>", registeringStudent.first_name + " " + registeringStudent.last_name);
        emailContent = emailContent.replaceAll("<% studentPhone %>", registeringStudent.phone_area + "-" + registeringStudent.phone_number);
        String cityName = "";
        if ( registeringStudent.city != null ) {
            cityName = registeringStudent.city.name;
        }
        emailContent = emailContent.replaceAll("<% studentCity %>", cityName);
        emailContent = emailContent.replaceAll("<% studentGender %>", CLabels.get(registeringStudent.gender == User.GENDER_MALE
                ? "language.male" : "language.female"));
        String dayOfBirth = "";
        if ( registeringStudent.day_of_birth != null) {
            dayOfBirth = Utils.formatDateWithFullYear(registeringStudent.day_of_birth);
        }
        emailContent = emailContent.replaceAll("<% studentDayOfBirth %>", dayOfBirth);
        emailContent = emailContent.replaceAll("<% studentLearningTopics %>", Utils.mergeList(topicsList, "<br/>"));
        emailContent = emailContent.replaceAll("<% StudentProfileUrl %>", Config.get("website.url") + "/student_profile");

        EmailSender.addEmail(registeringStudent.email, Labels.get("emails.register_student.title"), emailContent);
        TasksManager.runNow(EmailSender.EMAIL_SENDER_NAME);
    }

}
