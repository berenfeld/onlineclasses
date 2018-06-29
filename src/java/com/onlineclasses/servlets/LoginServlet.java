package com.onlineclasses.servlets;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import com.onlineclasses.db.DB;
import com.onlineclasses.entities.BasicResponse;
import com.onlineclasses.entities.FacebookUser;
import com.onlineclasses.entities.GoogleUser;
import com.onlineclasses.entities.LoginRequest;
import com.onlineclasses.entities.User;
import com.onlineclasses.utils.Labels;
import com.onlineclasses.utils.Utils;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/servlets/login"})
public class LoginServlet extends BaseServlet {

    private BasicResponse loginWithGoogle(LoginRequest loginRequest, HttpServletRequest request) throws Exception {

        if (getUser(request) != null) {
            Utils.warning("login from user " + getUser(request).display_name + " already connected");
            return new BasicResponse(-1, Labels.get("login.request.already_connected"));
        }
        GoogleUser googleUser = GoogleIdTokenServlet.userFromGoogleToken(loginRequest.google_id_token);
        if (googleUser == null) {
            Utils.warning("failed to get user from google id token");
            return new BasicResponse(-1, Labels.get("login.request.user_not_found"));
        }

        User user = DB.getUserByEmail(googleUser.email);
        if (user == null) {
            Utils.warning("Can't find google logged in user with email " + googleUser.email);
            // TODO : fast register
            return new BasicResponse(-1, Labels.get("login.request.user_not_found"));
        }

        Utils.info("user " + user.display_name + " logged in with email " + user.email);
        BaseServlet.loginUser(request, user);
        return new BasicResponse(0, "");
    }

    private BasicResponse loginWithFacebook(LoginRequest loginRequest, HttpServletRequest request) throws Exception {
        FacebookUser facebookUser = FacebookAccessTokenServlet.getFacebookUser(loginRequest.facebook_access_token);
        if (facebookUser == null) {
            Utils.warning("failed to get user from facebook access token");
            return new BasicResponse(-1, Labels.get("login.request.user_not_found"));
        }

        User user = DB.getUserByEmail(facebookUser.email);
        if (user == null) {
            Utils.warning("Can't find facebook logged in user with email " + facebookUser.email);
            // TODO : fast register
            return new BasicResponse(-1, Labels.get("login.request.user_not_found"));
        }

        Utils.info("user " + user.display_name + " logged in with email " + user.email);
        BaseServlet.loginUser(request, user);
        return new BasicResponse(0, "");
    }

    @Override
    protected BasicResponse handleRequest(String requestString, HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        LoginRequest loginRequest = Utils.gson().fromJson(requestString, LoginRequest.class);

        if (Utils.isNotEmpty(loginRequest.google_id_token)) {
            return loginWithGoogle(loginRequest, request);
        } else if (Utils.isNotEmpty(loginRequest.facebook_access_token)) {
            return loginWithFacebook(loginRequest, request);
        } else {
            Utils.warning("no google id or facebook token in login request");
        }
        Utils.warning("no google id in login request");
        return new BasicResponse(-1, Labels.get("login.request.invalid_request"));

    }

}
