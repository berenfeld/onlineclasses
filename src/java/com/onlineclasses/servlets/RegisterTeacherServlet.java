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
import com.onlineclasses.entities.FacebookUser;
import com.onlineclasses.entities.Feedback;
import com.onlineclasses.entities.GoogleUser;
import com.onlineclasses.entities.Institute;
import com.onlineclasses.entities.Subject;
import com.onlineclasses.entities.Teacher;
import com.onlineclasses.entities.TeachingTopic;
import com.onlineclasses.entities.Topic;
import com.onlineclasses.entities.User;
import com.onlineclasses.servlets.entities.RegisterTeacherRequest;
import com.onlineclasses.utils.CConfig;
import com.onlineclasses.utils.CLabels;
import com.onlineclasses.utils.Config;
import com.onlineclasses.utils.EmailSender;
import com.onlineclasses.utils.Labels;
import com.onlineclasses.utils.TasksManager;
import com.onlineclasses.utils.Utils;
import java.io.File;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/servlets/register_teacher"})
public class RegisterTeacherServlet extends BaseServlet {

    @Override
    protected BasicResponse handleRequest(String requestString, HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        RegisterTeacherRequest registerTeacherRequest = Utils.gson().fromJson(requestString, RegisterTeacherRequest.class);

        if (registerTeacherRequest == null) {
            Utils.warning("no data in teacher register request");
            return new BasicResponse(-1, Labels.get("start_teaching.response.not_logged_in"));
        }
        
        String userEmail = null;
        if (! Utils.isEmpty(registerTeacherRequest.google_id_token)) {
            GoogleUser googleUser = GoogleIdTokenServlet.userFromGoogleToken(registerTeacherRequest.google_id_token);
            if (googleUser == null) {
                Utils.warning("failed to get user from google id token");
                return new BasicResponse(-1, Labels.get("start_teaching.response.not_logged_in"));
            }

            User user = DB.getUserByEmail(googleUser.email);
            if (user != null) {
                Utils.warning("teacher " + user.display_name + " email " + user.email + " already registered");
                return new BasicResponse(-1, Labels.get("start_teaching.response.email_exist"));
            }
            userEmail = googleUser.email;
        } else if (! Utils.isEmpty(registerTeacherRequest.facebook_access_token)) {
            FacebookUser facebookUser = FacebookAccessTokenServlet.userFromFacebookAccessToken(registerTeacherRequest.facebook_access_token);
            if (facebookUser == null) {
                Utils.warning("failed to get user from facebook access token");
                return new BasicResponse(-1, Labels.get("start_teaching.response.not_logged_in"));
            }

            User user = DB.getUserByEmail(facebookUser.email);
            if (user != null) {
                Utils.warning("teacher " + user.display_name + " email " + user.email + " already registered");
                return new BasicResponse(-1, Labels.get("start_teaching.response.email_exist"));
            }
            userEmail = facebookUser.email;
        } else {
            Utils.warning("not logged in teacher register request");
            return new BasicResponse(-1, Labels.get("start_teaching.response.not_logged_in"));
        }
            
        if (!Utils.validEmail(registerTeacherRequest.paypal_email)) {
            Utils.warning("teacher " + registerTeacherRequest.display_name + " invalid paypal email " + registerTeacherRequest.paypal_email);
            return new BasicResponse(-1, Labels.get("start_teaching.response.invalid_paypal_email"));
        }

        if ((registerTeacherRequest.day_of_birth == null)
                || (registerTeacherRequest.day_of_birth.after(Utils.xYearsFromNow(-CConfig.getInt("start_teaching.min_teacher_age"))))) {
            Utils.warning("teacher " + registerTeacherRequest.display_name + " can't register with day of birth "
                    + registerTeacherRequest.day_of_birth);
            return new BasicResponse(-1, Labels.get("start_teaching.response.teacher_under_age"));
        }

        Teacher registeringTeacher = new Teacher();
        registeringTeacher.email = userEmail;
        registeringTeacher.display_name = registerTeacherRequest.display_name;
        registeringTeacher.image_url = registerTeacherRequest.image_url;
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
        registeringTeacher.min_class_length = registerTeacherRequest.min_class_length;
        registeringTeacher.max_class_length = registerTeacherRequest.max_class_length;

        if (registeringTeacher.email.equals(Config.get("website.admin_email"))) {
            registeringTeacher.admin = true;
        }

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
            return new BasicResponse(-1, Labels.get("start_teaching.response.system_error"));
        }

        List<String> topicsList = new ArrayList();
        for (int topicId : registerTeacherRequest.teaching_topics) {
            TeachingTopic teachingTopic = new TeachingTopic();
            teachingTopic.teacher = registeringTeacher;
            teachingTopic.topic = DB.get(topicId, Topic.class);
            if (DB.add(teachingTopic) != 1) {
                Utils.warning("Could not add teaching topic " + teachingTopic + " to teacher " + registeringTeacher);
                return new BasicResponse(-1, Labels.get("start_teaching.response.system_error"));
            }
            topicsList.add(teachingTopic.topic.name);
        }

        List<String> dayNamesLong = Utils.toList(CLabels.get("website.days.long"));
        List<String> availableTimeList = new ArrayList();
        for (AvailableTime avilableTime : registerTeacherRequest.available_times) {
            avilableTime.teacher = registeringTeacher;
            if (DB.add(avilableTime) != 1) {
                Utils.warning("Could not add available time " + avilableTime + " to teacher " + registeringTeacher);
                return new BasicResponse(-1, Labels.get("start_teaching.response.system_error"));
            }
            availableTimeList.add(dayNamesLong.get(avilableTime.day - 1) + " "
                    + Utils.formatTime(avilableTime.start_hour, avilableTime.start_minute) + " - "
                    + Utils.formatTime(avilableTime.end_hour, avilableTime.end_minute));
        }

        BaseServlet.loginUser(request, registeringTeacher);
        Utils.info("teacher " + registeringTeacher.display_name + " email " + registeringTeacher.email + " registered");

        sendEmail(registeringTeacher, topicsList, availableTimeList);

        if (!Utils.isEmpty(registerTeacherRequest.feedback)) {
            Feedback feedback = new Feedback();
            feedback.from = registerTeacherRequest.display_name;
            feedback.email = registerTeacherRequest.email;
            feedback.message = registerTeacherRequest.feedback;
            DB.add(feedback);
            Utils.info("new feedback : " + feedback);
        }

        return new BasicResponse(0, "");
    }

    private void sendEmail(Teacher registeringTeacher, List<String> topicsList, List<String> availableTimeList) throws Exception {
        String email_name = Config.get("mail.emails.path") + File.separator
                + Config.get("website.language") + File.separator + "register_teacher.html";

        String emailContent = Utils.getStringFromInputStream(getServletContext(), email_name);

        String yes = CLabels.get("language.yes");
        String no = CLabels.get("language.no");

        emailContent = emailContent.replaceAll("<% registeredTeacher %>", registeringTeacher.display_name);
        emailContent = emailContent.replaceAll("<% websiteUrl %>", Config.get("website.url"));
        emailContent = emailContent.replaceAll("<% websiteShortName %>", Labels.get("website.name"));
        emailContent = emailContent.replaceAll("<% findTeachersUrl %>", Config.get("website.url") + "/find_teachers");
        emailContent = emailContent.replaceAll("<% teacherDisplayName %>", registeringTeacher.display_name);
        emailContent = emailContent.replaceAll("<% teacherEmail %>", registeringTeacher.email);
        emailContent = emailContent.replaceAll("<% teacherFullName %>", registeringTeacher.first_name + " " + registeringTeacher.last_name);
        emailContent = emailContent.replaceAll("<% teacherPhone %>", registeringTeacher.phone_area + "-" + registeringTeacher.phone_number);
        emailContent = emailContent.replaceAll("<% teacherCity %>", registeringTeacher.city.name);
        emailContent = emailContent.replaceAll("<% teacherGender %>", CLabels.get(registeringTeacher.gender == User.GENDER_MALE
                ? "language.male" : "language.female"));
        emailContent = emailContent.replaceAll("<% teacherDayOfBirth %>", Utils.formatDateWithFullYear(registeringTeacher.day_of_birth));
        emailContent = emailContent.replaceAll("<% teacherSkype %>", Utils.nonNullString(registeringTeacher.skype_name));
        emailContent = emailContent.replaceAll("<% teacherMoto %>", registeringTeacher.moto);
        emailContent = emailContent.replaceAll("<% teacherShowPhone %>", registeringTeacher.show_phone ? yes : no);
        emailContent = emailContent.replaceAll("<% teacherShowEmail %>", registeringTeacher.show_email ? yes : no);
        emailContent = emailContent.replaceAll("<% teacherShowSkype %>", registeringTeacher.show_skype ? yes : no);
        emailContent = emailContent.replaceAll("<% teacherTeachingTopics %>", Utils.mergeList(topicsList, "<br/>"));
        emailContent = emailContent.replaceAll("<% teacherAvailableHours %>", Utils.mergeList(availableTimeList, "<br/>"));
        emailContent = emailContent.replaceAll("<% updateTeacherUrl %>", Config.get("website.url") + "/teacher_update");

        EmailSender.addEmail(registeringTeacher.email, Labels.get("emails.register_teacher.title"), emailContent);
        TasksManager.runNow(TasksManager.TASK_EMAIL);
    }
}
