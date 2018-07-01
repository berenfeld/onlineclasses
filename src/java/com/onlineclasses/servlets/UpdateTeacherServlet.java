package com.onlineclasses.servlets;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import com.onlineclasses.db.DB;
import com.onlineclasses.entities.AvailableTime;
import com.onlineclasses.entities.BasicResponse;
import com.onlineclasses.entities.Feedback;
import com.onlineclasses.entities.Institute;
import com.onlineclasses.entities.Subject;
import com.onlineclasses.entities.Teacher;
import com.onlineclasses.entities.TeachingTopic;
import com.onlineclasses.entities.Topic;
import com.onlineclasses.entities.User;
import com.onlineclasses.servlets.entities.UpdateTeacherRequest;
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

@WebServlet(urlPatterns = {"/servlets/update_teacher"})
public class UpdateTeacherServlet extends BaseServlet {

    @Override
    protected BasicResponse handleRequest(String requestString, HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        UpdateTeacherRequest updateTeacherRequest = Utils.gson().fromJson(requestString, UpdateTeacherRequest.class);

        Teacher teacher = (Teacher) BaseServlet.getUser(request);
        if (teacher == null) {
            Utils.warning("not logged in");
            return new BasicResponse(-1, "not logged in");
        }
        
        teacher.skype_name = updateTeacherRequest.skype_name;
        teacher.phone_number = updateTeacherRequest.phone_number;
        teacher.phone_area = updateTeacherRequest.phone_area;
        teacher.moto = updateTeacherRequest.moto;
        teacher.show_phone = updateTeacherRequest.show_phone;
        teacher.show_email = updateTeacherRequest.show_email;
        teacher.show_skype = updateTeacherRequest.show_skype;
        teacher.registered = new Date();
        teacher.degree_type = updateTeacherRequest.degree_type;
        teacher.show_degree = updateTeacherRequest.show_degree;
        teacher.price_per_hour = updateTeacherRequest.price_per_hour;
        teacher.image_url = updateTeacherRequest.image_url;
                
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

        if (0 == DB.deleteTeacherTeachingTopics(teacher)) {
            Utils.warning("no previous teaching topics, or could not delete teaching topics of teacher " + teacher);
        }

        List<String> topicsList = new ArrayList();
        for (int topicId : updateTeacherRequest.teaching_topics) {
            TeachingTopic teachingTopic = new TeachingTopic();
            teachingTopic.teacher = teacher;
            teachingTopic.topic = DB.get(topicId, Topic.class);
            if (DB.add(teachingTopic) != 1) {
                Utils.warning("Could not add teaching topic " + teachingTopic + " to teacher " + teacher);
            }
            topicsList.add(teachingTopic.topic.name);
        }

        if (0 == DB.deleteTeacherAvailableTime(teacher)) {
            Utils.warning("could not delete available time of teacher " + teacher);
        }

        List<String> dayNamesLong = Utils.toList(CLabels.get("website.days.long"));
        List<String> availableTimeList = new ArrayList();
        for (AvailableTime avilableTime : updateTeacherRequest.available_times) {
            avilableTime.teacher = teacher;
            if (DB.add(avilableTime) != 1) {
                Utils.warning("Could not add available time " + avilableTime + " to teacher " + teacher);
            }
            availableTimeList.add(dayNamesLong.get(avilableTime.day - 1) + " "
                    + Utils.formatTime(avilableTime.start_hour, avilableTime.start_minute) + " - "
                    + Utils.formatTime(avilableTime.end_hour, avilableTime.end_minute));
        }

        Utils.info("teacher " + teacher.display_name + " email " + teacher.email + " update profile");

        sendEmail(teacher, topicsList, availableTimeList);

        if (!Utils.isEmpty(updateTeacherRequest.feedback)) {
            Feedback feedback = new Feedback();
            feedback.from = teacher.display_name;
            feedback.email = teacher.email;
            feedback.message = updateTeacherRequest.feedback;
            DB.add(feedback);
            Utils.info("new feedback : " + feedback);
        }

        return new BasicResponse(0, "");
    }

    private void sendEmail(Teacher registeringTeacher, List<String> topicsList, List<String> availableTimeList) throws Exception {
        String email_name = Config.get("mail.emails.path") + File.separator
                + Config.get("website.language") + File.separator + "update_teacher.html";

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

        EmailSender.addEmail(registeringTeacher.email, Labels.get("emails.register_teacher.title"), emailContent);
        TasksManager.runNow(TasksManager.TASK_EMAIL);
    }

}
