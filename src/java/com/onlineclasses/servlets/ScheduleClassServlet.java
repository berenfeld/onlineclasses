package com.onlineclasses.servlets;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import com.onlineclasses.db.DB;
import com.onlineclasses.entities.AvailableTime;
import com.onlineclasses.entities.BasicResponse;
import com.onlineclasses.entities.OClass;
import com.onlineclasses.entities.ClassComment;
import com.onlineclasses.entities.Student;
import com.onlineclasses.entities.Teacher;
import com.onlineclasses.entities.User;
import com.onlineclasses.servlets.entities.ScheduleClassRequest;
import com.onlineclasses.servlets.entities.ScheduleClassResponse;
import com.onlineclasses.utils.CConfig;
import com.onlineclasses.utils.CLabels;
import com.onlineclasses.utils.Config;
import com.onlineclasses.utils.EmailSender;
import com.onlineclasses.utils.Labels;
import com.onlineclasses.utils.TasksManager;
import com.onlineclasses.utils.Utils;
import java.io.File;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/servlets/schedule_class"})
public class ScheduleClassServlet extends BaseServlet {

    @Override
    protected BasicResponse handleRequest(String requestString, HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        User user = BaseServlet.getUser(request);
        if (user == null) {
            Utils.warning("not logged in user can't schedule class");
            return new BasicResponse(-1, CLabels.get("schedule_class.failed_to_schedule_class_alert.not_logged_in"));
        }

        if (!(user.isStudent())) {
            Utils.warning("teacher can't schedule class");
            return new BasicResponse(-1, CLabels.get("schedule_class.failed_to_schedule_class_alert.teacher_cant_schedule_class"));
        }

        Student student = (Student) user;
        ScheduleClassRequest scheduleClassRequest = Utils.gson().fromJson(requestString, ScheduleClassRequest.class);

        Teacher teacher = DB.getTeacher(scheduleClassRequest.teacher_id);
        if (teacher == null) {
            Utils.warning("student " + student.display_name + " schedule with unknown teacher");
            return new BasicResponse(-1, CLabels.get("schedule_class.failed_to_schedule_class_alert.teacher_not_found"));
        }

        Calendar now = Calendar.getInstance();
        Calendar classStart = Calendar.getInstance();
        classStart.setTime(scheduleClassRequest.start_date);
        Calendar classEnd = Calendar.getInstance();
        classEnd.setTime(scheduleClassRequest.start_date);
        classEnd.add(Calendar.MINUTE, scheduleClassRequest.duration_minutes);

        int minTimeBeforeScheduleClassStartHours = CConfig.getInt("website.time.min_time_before_schedule_class_start_hours");

        if (scheduleClassRequest.duration_minutes < teacher.min_class_length) {
            Utils.warning("student " + student.display_name + " can't schedule class with " + teacher.display_name
                    + " class duration " + scheduleClassRequest.duration_minutes + " too short");
            return new BasicResponse(-1, CLabels.get("schedule_class.failed_to_schedule_class_alert.duration_too_short"));

        }
        if (scheduleClassRequest.duration_minutes > teacher.max_class_length) {
            Utils.warning("student " + student.display_name + " can't schedule class with " + teacher.display_name
                    + " class duration " + scheduleClassRequest.duration_minutes + " too long");
            return new BasicResponse(-1, CLabels.get("schedule_class.failed_to_schedule_class_alert.duration_too_long"));
        }

        if ((classStart.getTimeInMillis() - now.getTimeInMillis()) < (minTimeBeforeScheduleClassStartHours * Utils.MS_IN_HOUR)) {
            Utils.warning("student " + student.display_name + " can't schedule class with " + teacher.display_name
                    + " at " + scheduleClassRequest.start_date + " too late.");
            return new BasicResponse(-1, "schedule_class.failed_to_schedule_class_alert.too_late");
        }

        if (!checkClassInAvailableTime(scheduleClassRequest, teacher)) {
            Utils.warning("student " + student.display_name + " can't schedule class with " + teacher.display_name + " not in available time");
            return new BasicResponse(-1, "can't schedule class");
        }

        List<OClass> allTeacherClasses = DB.getTeacherScheduledClasses(teacher);
        for (OClass oClass : allTeacherClasses) {
            Calendar otherClassStart = Calendar.getInstance();
            otherClassStart.setTime(oClass.start_date);
            Calendar otherClassEnd = Calendar.getInstance();
            otherClassEnd.setTime(oClass.start_date);
            otherClassEnd.add(Calendar.MINUTE, oClass.duration_minutes);

            if (Utils.overlappingEvents(classStart, classEnd, otherClassStart, otherClassEnd)) {
                Utils.warning("student " + student.display_name + " can't schedule class with " + teacher.display_name
                        + " at " + scheduleClassRequest.start_date + " . conflict with other class.");
                return new BasicResponse(-1, "can't schedule class");
            }
        }

        // check that it does not collide with other scheduled classes
        OClass oClass = new OClass();
        oClass.teacher = teacher;
        oClass.student = student;
        oClass.start_date = scheduleClassRequest.start_date;
        oClass.duration_minutes = scheduleClassRequest.duration_minutes;
        oClass.price_per_hour = teacher.price_per_hour;
        oClass.subject = scheduleClassRequest.subject;
        oClass.registered = new Date();
        oClass.status = OClass.STATUS_SCHEDULED;
        oClass.payment = null;

        if (1 != DB.add(oClass)) {
            Utils.warning("student " + student.display_name + " schedule class failed. DB error");
            return new BasicResponse(-1, "can't schedule class");
        }

        Utils.info("student " + student.display_name + " scheduled class with " + teacher.display_name
                + " at " + oClass.start_date + " duration " + oClass.duration_minutes + " subject "
                + oClass.subject);

        if (!Utils.isEmpty(scheduleClassRequest.student_comment)) {
            ClassComment oClassComment = new ClassComment();
            oClassComment.added = new Date();
            oClassComment.student = student;
            oClassComment.comment = scheduleClassRequest.student_comment;
            oClassComment.oclass = oClass;
            DB.add(oClassComment);
        }

        sendEmail(student, teacher, oClass, classStart);

        ScheduleClassResponse scheduleClassResponse = new ScheduleClassResponse();
        scheduleClassResponse.class_id = oClass.id;

        // TODO send email
        return scheduleClassResponse;
    }

    private void sendEmail(Student student, Teacher teacher, OClass oClass, Calendar classStart) throws Exception {
        String email_name = Config.get("mail.emails.path") + File.separator
                + Config.get("website.language") + File.separator + "new_class.html";
        Utils.info("sending email " + email_name);

        String emailContent = Utils.getStringFromInputStream(email_name);

        emailContent = emailContent.replaceAll("<% teacherName %>", teacher.display_name);
        emailContent = emailContent.replaceAll("<% classDay %>", Utils.dayNameLong(classStart.get(Calendar.DAY_OF_WEEK)) + " " + new SimpleDateFormat("dd/MM/YYYY").format(oClass.start_date));
        emailContent = emailContent.replaceAll("<% classTime %>", new SimpleDateFormat("HH:mm").format(oClass.start_date));
        emailContent = emailContent.replaceAll("<% oClassLink %>", Config.get("website.url") + "/oclass?id=" + oClass.id);
        emailContent = emailContent.replaceAll("<% gotoClass %>", Labels.get("emails.new_oclass.goto_class"));
        emailContent = emailContent.replaceAll("<% classSubject %>", oClass.subject);

        List<User> to = Arrays.asList(student, teacher);
        EmailSender.addEmail(to, Labels.get("emails.new_oclass.title"), emailContent);
        TasksManager.runNow(EmailSender.EMAIL_SENDER_NAME);
    }

    private boolean checkClassInAvailableTime(ScheduleClassRequest scheduleClassRequest, Teacher teacher) throws SQLException {

        Calendar startDate = Calendar.getInstance();
        startDate.setTime(scheduleClassRequest.start_date);
        int startHour = startDate.get(Calendar.HOUR_OF_DAY);
        int startMinute = startDate.get(Calendar.MINUTE);

        Calendar endDate = Calendar.getInstance();
        endDate.setTime(scheduleClassRequest.start_date);
        endDate.add(Calendar.MINUTE, scheduleClassRequest.duration_minutes);
        int endHour = endDate.get(Calendar.HOUR_OF_DAY);
        int endMinute = endDate.get(Calendar.MINUTE);

        List<AvailableTime> availableTimes = DB.getTeacherAvailableTime(teacher);
        boolean found = false;
        for (AvailableTime availableTime : availableTimes) {
            if (availableTime.day != startDate.get(Calendar.DAY_OF_WEEK)) {
                continue;
            }
            if (startHour < availableTime.start_hour) {
                continue;
            }
            if ((startHour == availableTime.start_hour) && (startMinute < availableTime.start_minute)) {
                continue;
            }
            if (endHour > availableTime.end_hour) {
                continue;
            }
            if ((endHour == availableTime.end_hour) && (endMinute < availableTime.end_minute)) {
                continue;
            }
            found = true;
            break;
        }

        return found;
    }
}
