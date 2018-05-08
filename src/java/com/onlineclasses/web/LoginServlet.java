package com.onlineclasses.web;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import com.onlineclasses.db.DB;
import com.onlineclasses.entities.BasicResponse;
import com.onlineclasses.entities.GoogleUser;
import com.onlineclasses.entities.LoginRequest;
import com.onlineclasses.entities.User;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/servlets/login"})
public class LoginServlet extends ServletBase {

    protected BasicResponse handleRequest(String requestString, HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        LoginRequest loginRequest = Utils.gson().fromJson(requestString, LoginRequest.class);

        if (Utils.isNotEmpty(loginRequest.google_id_token)) {

            GoogleUser googleUser = GoogleIdTokenServlet.userFromGoogleToken(loginRequest.google_id_token);
            if (googleUser == null) {
                Utils.warning("failed to get user from google id token");
                return new BasicResponse(-1, "user was not found");
            }

            User user = DB.getUserByEmail(googleUser.email);
            if (user == null) {
                Utils.warning("Can't find google logged in user with email " + googleUser.email);
                // TODO : fast register
                return new BasicResponse(-1, "user was not found");
            }

            Utils.info("user " + user.display_name + " logged in with email " + user.email);
            ServletBase.loginUser(request, user);
        } else {
            Utils.warning("no google id in login request");
        }
        return new BasicResponse(0, "");
    }

}
