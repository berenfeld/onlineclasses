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

        Utils.info("student " + student.display_name + " scheduled class with " + teacher.display_name + 
                " at " + scheduledClass.start_date + " duration " + scheduledClass.duration_minutes + " subject " +
                scheduledClass.subject);

        EmailSender.addEmail(student.email, "new scheduled class", "subject : " + scheduledClass.subject);
        EmailSender.addEmail(teacher.email, "new scheduled class", "subject : " + scheduledClass.subject);
        EmailSender.addEmail(Config.get("mail.admin"), "new scheduled class", "subject : " + scheduledClass.subject);
        
        ScheduleClassResponse scheduleClassResponse = new ScheduleClassResponse();
        scheduleClassResponse.class_id = scheduledClass.id;

        // TODO send email
        return scheduleClassResponse;
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
