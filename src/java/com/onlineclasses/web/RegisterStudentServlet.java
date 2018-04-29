package com.onlineclasses.web;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import com.onlineclasses.db.DB;
import com.onlineclasses.web.ServletBase;
import com.google.gson.Gson;
import com.onlineclasses.entities.BasicResponse;
import com.onlineclasses.entities.LoginRequest;
import com.onlineclasses.entities.RegisterStudentRequest;
import com.onlineclasses.entities.Student;
import com.onlineclasses.entities.User;
import java.io.IOException;
import java.io.PrintWriter;
import java.security.MessageDigest;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.DatatypeConverter;

@WebServlet(urlPatterns = {"/servlets/register_student"})
public class RegisterStudentServlet extends ServletBase {

    

    protected BasicResponse handleRequest(String requestString, HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        RegisterStudentRequest registerStudentRequest = _gson.fromJson(requestString, RegisterStudentRequest.class);

        if (Utils.isNotEmpty(registerStudentRequest.google_id_token)) {

            User googleUser = GoogleIdTokenServlet.userFromGoogleToken(registerStudentRequest.google_id_token);
            if (googleUser == null) {
                Utils.warning("failed to get user from google id token");
                return new BasicResponse(-1, "user was not found");
            }
            
            User user = DB.getUserByEmail(googleUser.email);
            if (user != null) {
                Utils.warning("user " + user.display_name + " email " + user.email + " already registered");
                return new BasicResponse(-1, "user is already registered");
            }                       
            
            Student registeringStudent = new Student();
            registeringStudent.email = googleUser.email;            
            registeringStudent.display_name = googleUser.display_name;
            registeringStudent.image_url = googleUser.image_url;
            registeringStudent.first_name = registerStudentRequest.first_name;
            registeringStudent.last_name = registerStudentRequest.last_name;
            registeringStudent.gender = registerStudentRequest.gender;
            registeringStudent.phone_area = registerStudentRequest.phone_area;
            registeringStudent.phone_number = registerStudentRequest.phone_number;
            registeringStudent.registered = new Date();
            
            if (DB.addStudent(registeringStudent) != 1 ) {
                Utils.warning("Could not add user " + registeringStudent.display_name);
                return new BasicResponse(-1, "user is already registered");
            }
            ServletBase.loginUser(request, registeringStudent);
            Utils.info("user " + registeringStudent.display_name + " email " + registeringStudent.email + " registered");
        } else {
            Utils.warning("no google id in login request");
        }
        return new BasicResponse(0, "");
    }

}