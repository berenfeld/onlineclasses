package com.onlineclasses.servlets;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import com.onlineclasses.db.DB;
import com.onlineclasses.entities.BasicResponse;
import com.onlineclasses.entities.GoogleUser;
import com.onlineclasses.entities.Institute;
import com.onlineclasses.entities.Student;
import com.onlineclasses.entities.User;
import com.onlineclasses.servlets.entities.RegisterStudentRequest;
import com.onlineclasses.utils.Utils;
import java.util.Date;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/servlets/register_student"})
public class RegisterStudentServlet extends ServletBase {

    @Override
    protected BasicResponse handleRequest(String requestString, HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        RegisterStudentRequest registerStudentRequest = Utils.gson().fromJson(requestString, RegisterStudentRequest.class);

        if (Utils.isNotEmpty(registerStudentRequest.google_id_token)) {

            GoogleUser googleUser = GoogleIdTokenServlet.userFromGoogleToken(registerStudentRequest.google_id_token);
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
            registeringStudent.display_name = registerStudentRequest.display_name;
            registeringStudent.image_url = googleUser.image_url;
            registeringStudent.first_name = registerStudentRequest.first_name;
            registeringStudent.last_name = registerStudentRequest.last_name;
            registeringStudent.gender = registerStudentRequest.gender;
            registeringStudent.phone_area = registerStudentRequest.phone_area;
            registeringStudent.phone_number = registerStudentRequest.phone_number;
            registeringStudent.day_of_birth = registerStudentRequest.day_of_birth;
            registeringStudent.registered = new Date();
            registeringStudent.emails_enabled = true;
            
            if ( registerStudentRequest.institute_id != 0 ) {                
                registeringStudent.institute = DB.getInstitute(registerStudentRequest.institute_id);
            } else {
                registeringStudent.institute_name = registerStudentRequest.institute_name;
            }
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
