package com.onlineclasses.web;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import com.onlineclasses.web.ServletBase;
import com.google.gson.Gson;
import com.onlineclasses.entities.BasicRequest;
import com.onlineclasses.entities.BasicResponse;
import com.onlineclasses.entities.GoogleIdTokenRequest;
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

@WebServlet(urlPatterns = {"/servlets/google_id_token"})
public class GoogleIdTokenServlet extends ServletBase {

    private Gson _gson = new Gson();

    protected BasicResponse handleRequest(String requestString, HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        
        GoogleIdTokenRequest googleIdTokenRequest = _gson.fromJson(requestString, GoogleIdTokenRequest.class);

        String googleIdToken = googleIdTokenRequest.google_id_token;
        Utils.info("google id token from " + ServletBase.getUser(request) + " token " + googleIdToken);
      
        
        return new BasicResponse(0, "");
    }

}
