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
import com.onlineclasses.entities.Student;
import com.onlineclasses.entities.User;
import java.io.IOException;
import java.io.PrintWriter;
import java.security.MessageDigest;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.DatatypeConverter;

@WebServlet(urlPatterns = {"/servlets/login"})
public class LoginServlet extends ServletBase {

    private Gson _gson = new Gson();

    protected BasicResponse handleRequest(String requestString, HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        LoginRequest loginRequest = _gson.fromJson(requestString, LoginRequest.class);

        if (Utils.isNotEmpty(loginRequest.google_id)) {

            User user = DB.getUserByGoogleID(loginRequest.google_id);
            if (user == null) {
                Utils.warning("Can't find user with google id " + loginRequest.google_id);
                return new BasicResponse(-1, "user was not found");
            }
            MessageDigest md = MessageDigest.getInstance("MD5");
            String hashString = loginRequest.google_id + "." + user.email;
            md.update(hashString.getBytes());
            String hash = DatatypeConverter.printHexBinary(md.digest());
            
            if (hash.equalsIgnoreCase(loginRequest.hash)) {
                Utils.info("user " + user.display_name + " logged in with google id " + user.google_id);
                ServletBase.loginUser(request, user);
            } else {
                Utils.warning("illegal hash from google id " + loginRequest.google_id + " expected " + hash + " received " + loginRequest.hash);
            }            
        } else {
            Utils.warning("no google id in login request");
        }
        return new BasicResponse(0, "");
    }

}
