package com.onlineclasses.servlets;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import com.onlineclasses.db.DB;
import com.onlineclasses.entities.BasicResponse;
import com.onlineclasses.entities.FacebookUser;
import com.onlineclasses.servlets.entities.FacebookAccessTokenRequest;
import com.onlineclasses.utils.Config;
import com.onlineclasses.utils.Utils;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/servlets/facebook_access_token"})
public class FacebookAccessTokenServlet extends BaseServlet {

    private static class FacebookProfile {

        public String id;
        public String first_name;
        public String last_name;
        public String name;
        public String email;

        @Override
        public String toString() {
            return "FB user " + id + "," + name + "," + first_name + "," + last_name + "," + email;
        }
    }

    public static FacebookUser getFacebookUser(String accessToken) {
        try {

            String facebookGraphURL = Config.get("facebook.graph_api_url");
            String url = facebookGraphURL + "/me?access_token=" + accessToken + "&fields=" + Config.get("facebook.fields");
            Utils.debug("getting from facebook url " + url);
            URL u = new URL(url);
            URLConnection c = u.openConnection();

            BufferedReader in = new BufferedReader(new InputStreamReader(c.getInputStream()));
            FacebookProfile profile = Utils.gson().fromJson(in, FacebookProfile.class);
            in.close();

            FacebookUser facebookUser = new FacebookUser();
            facebookUser.display_name = profile.name;
            facebookUser.first_name = profile.first_name;
            facebookUser.last_name = profile.last_name;
            facebookUser.email = profile.email;
            facebookUser.facebook_id = profile.id;
            facebookUser.image_url = "http://graph.facebook.com/" + profile.id + "/picture?type=square";
            
            if (Config.getBool("facebook.debug_fake_emails")) {
                facebookUser.email = "facebook_user_" + facebookUser.facebook_id + "@gmail.com";
            }
            
            return facebookUser;
        } catch (Exception e) {
            Utils.exception(e);
        }
        return null;

    }

    @Override
    protected BasicResponse handleRequest(String requestString, HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        FacebookAccessTokenRequest facebookAccessTokenRequest = Utils.gson().fromJson(requestString, FacebookAccessTokenRequest.class);

        String accessToken = facebookAccessTokenRequest.facebook_access_token;
        FacebookUser facebookUser = getFacebookUser(accessToken);

        if (facebookUser == null) {
            Utils.warning("failed to get facebook profile from access token");
            return new BasicResponse(0, "");
        }

        FacebookUser existingFacebookUser = DB.getFacebookUserByFacebookID(facebookUser.facebook_id);
        if (existingFacebookUser != null) {
            return new BasicResponse(0, "");
        }

        DB.add(facebookUser);
        Utils.info("welcome facebook user " + facebookUser);

        return new BasicResponse(0, "");
    }

}
