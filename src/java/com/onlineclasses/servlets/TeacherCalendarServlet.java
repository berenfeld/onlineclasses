package com.onlineclasses.servlets;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import com.onlineclasses.db.DB;
import com.onlineclasses.entities.BasicResponse;
import com.onlineclasses.entities.OClass;
import com.onlineclasses.servlets.entities.TeacherCalendarRequest;
import com.onlineclasses.servlets.entities.TeacherCalendarResponse;
import com.onlineclasses.utils.Utils;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/servlets/teacher_calendar"})
public class TeacherCalendarServlet extends BaseServlet {

    @Override
    protected BasicResponse handleRequest(String requestString, HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        TeacherCalendarRequest teacherCalendarRequest = Utils.gson().fromJson(requestString, TeacherCalendarRequest.class);

        TeacherCalendarResponse teacherCalendarResponse = new TeacherCalendarResponse();

        teacherCalendarResponse.teacher = DB.getTeacher(teacherCalendarRequest.teacher_id);
        teacherCalendarResponse.available_times = DB.getTeacherAvailableTime(teacherCalendarResponse.teacher);
        teacherCalendarResponse.oclasses = DB.getTeacherScheduledClasses(teacherCalendarResponse.teacher);
        for (OClass oClass : teacherCalendarResponse.oclasses) 
        {
            oClass.payment = DB.getPaymentOfClass(oClass);
        }
        return teacherCalendarResponse;
    }

}
