package com.onlineclasses.web;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import com.onlineclasses.web.ServletBase;
import com.google.gson.Gson;
import com.onlineclasses.db.DB;
import com.onlineclasses.entities.BasicRequest;
import com.onlineclasses.entities.BasicResponse;
import com.onlineclasses.entities.LoginRequest;
import com.onlineclasses.entities.RegisterStudentRequest;
import com.onlineclasses.entities.Student;
import com.onlineclasses.entities.TeacherCalendarRequest;
import com.onlineclasses.entities.TeacherCalendarResponse;
import com.onlineclasses.entities.User;
import static com.onlineclasses.web.ServletBase._gson;
import java.io.IOException;
import java.io.PrintWriter;
import java.security.MessageDigest;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.DatatypeConverter;

@WebServlet(urlPatterns = {"/servlets/teacher_calendar"})
public class TeacherCalendarServlet extends ServletBase {

    protected BasicResponse handleRequest(String requestString, HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        
        TeacherCalendarRequest teacherCalendarRequest = _gson.fromJson(requestString, TeacherCalendarRequest.class);
        
        
        TeacherCalendarResponse teacherCalendarResponse = new TeacherCalendarResponse();
        
        teacherCalendarResponse.teacher = DB.getTeacher(teacherCalendarRequest.teacher_id);
        teacherCalendarResponse.available_times = DB.getTeacherAvailableTime(teacherCalendarResponse.teacher);
        teacherCalendarResponse.scheduled_classes = DB.getTeacherScheduledClasses(teacherCalendarResponse.teacher);               
        return teacherCalendarResponse;
    }

}
