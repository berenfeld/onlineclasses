package com.onlineclasses.web;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import com.onlineclasses.db.DB;
import com.onlineclasses.entities.AvailableTime;
import com.onlineclasses.entities.BasicResponse;
import com.onlineclasses.entities.ScheduleClassRequest;
import com.onlineclasses.entities.ScheduleClassResponse;
import com.onlineclasses.entities.ScheduledClass;
import com.onlineclasses.entities.Student;
import com.onlineclasses.entities.Teacher;
import com.onlineclasses.entities.User;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.List;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/servlets/schedule_class"})
public class ScheduleClassServlet extends ServletBase {

    protected BasicResponse handleRequest(String requestString, HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        User user = ServletBase.getUser(request);
        if (user == null) {
            Utils.warning("not logged in user can't schedule class");
            return new BasicResponse(-1, "can't schedule class");
        }
        Student student = DB.getStudent(user.id);
        if (student == null) {
            Utils.warning("teacher " + student.display_name + " can't schedule class");
            return new BasicResponse(-1, "can't schedule class");
        }

        ScheduleClassRequest scheduleClassRequest = Utils.gson().fromJson(requestString, ScheduleClassRequest.class);

        Teacher teacher = DB.getTeacher(scheduleClassRequest.teacher_id);
        if (teacher == null) {
            Utils.warning("student " + student.display_name + " schedule with unknown teacher");
            return new BasicResponse(-1, "can't schedule class");
        }

        Calendar now = Calendar.getInstance();
        Calendar classStart = Calendar.getInstance();
        classStart.setTime(scheduleClassRequest.start_date);
        Calendar classEnd = Calendar.getInstance();
        classEnd.setTime(scheduleClassRequest.start_date);
        classEnd.add(Calendar.MINUTE, scheduleClassRequest.duration_minutes);

        int minTimeBeforeScheduleClassStartHours = CConfig.getInt("website.time.min_time_before_schedule_class_start_hours");

        if ((classStart.getTimeInMillis() - now.getTimeInMillis()) < (minTimeBeforeScheduleClassStartHours * Utils.MS_IN_HOUR)) {
            Utils.warning("student " + student.display_name + " can't schedule class with " + teacher.display_name
                    + " at " + scheduleClassRequest.start_date + " too late.");
            return new BasicResponse(-1, "can't schedule class");
        }

        if (!checkClassInAvailableTime(scheduleClassRequest, teacher)) {
            Utils.warning("student " + student.display_name + " can't schedule class with " + teacher.display_name + " not in available time");
            return new BasicResponse(-1, "can't schedule class");
        }

        List<ScheduledClass> allTeacherClasses = DB.getTeacherScheduledClasses(teacher);
        for (ScheduledClass scheduledClass : allTeacherClasses) {
            Calendar otherClassStart = Calendar.getInstance();
            otherClassStart.setTime(scheduledClass.start_date);
            Calendar otherClassEnd = Calendar.getInstance();
            otherClassEnd.setTime(scheduledClass.start_date);
            otherClassEnd.add(Calendar.MINUTE, scheduledClass.duration_minutes);

            if (Utils.overlappingEvents(classStart, classEnd, otherClassStart, otherClassEnd)) {
                Utils.warning("student " + student.display_name + " can't schedule class with " + teacher.display_name
                        + " at " + scheduleClassRequest.start_date + " . conflict with other class.");
                return new BasicResponse(-1, "can't schedule class");
            }
        }

        // check that it does not collide with other scheduled classes
        ScheduledClass scheduledClass = new ScheduledClass();
        scheduledClass.teacher = teacher;
        scheduledClass.student = student;
        scheduledClass.start_date = scheduleClassRequest.start_date;
        scheduledClass.duration_minutes = scheduleClassRequest.duration_minutes;
        scheduledClass.price_per_hour = teacher.price_per_hour;
        scheduledClass.subject = scheduleClassRequest.subject;
        scheduledClass.student_comment = scheduleClassRequest.student_comment;

        if (1 != DB.addScheduledClass(scheduledClass)) {
            Utils.warning("student " + student.display_name + " schedule class failed. DB error");
            return new BasicResponse(-1, "can't schedule class");
        }

        Utils.info("student " + student.display_name + " scheduled class with " + teacher.display_name
                + " at " + scheduledClass.start_date + " duration " + scheduledClass.duration_minutes + " subject "
                + scheduledClass.subject);

        String email_name = Config.get("mail.emails.path") + File.separator + 
            Config.get("website.language") + File.separator + "new_schedule_class.html";
        Utils.info("sending email " + email_name);
        InputStream is = getServletContext().getResourceAsStream(email_name);
        String emailContent = getStringFromInputStream(is);        
        
        emailContent = emailContent.replace("<% teacherName %>", teacher.display_name);
        emailContent = emailContent.replace("<% classDay %>", Utils.dayNameLong( classStart.get(Calendar.DAY_OF_WEEK)) + " " + new SimpleDateFormat("dd/MM/YYYY").format(scheduledClass.start_date));
        emailContent = emailContent.replace("<% classTime %>", new SimpleDateFormat("HH:mm").format(scheduledClass.start_date));
        
        List<String> to = Arrays.asList( student.email, teacher.email, Config.get("mail.admin") );
        EmailSender.addEmail(to, Labels.get("emails.new_scheduled_class.title"), emailContent);
        
        TasksManager.runNow(TasksManager.TASK_EMAIL);
        
        ScheduleClassResponse scheduleClassResponse = new ScheduleClassResponse();
        scheduleClassResponse.class_id = scheduledClass.id;

        // TODO send email
        return scheduleClassResponse;
    }

    // convert InputStream to String
    private static String getStringFromInputStream(InputStream is) {

        BufferedReader br = null;
        StringBuilder sb = new StringBuilder();

        String line;
        try {

            br = new BufferedReader(new InputStreamReader(is));
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }

        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (br != null) {
                try {
                    br.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        return sb.toString();

    }

    private boolean checkClassInAvailableTime(ScheduleClassRequest scheduleClassRequest, Teacher teacher) {

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
