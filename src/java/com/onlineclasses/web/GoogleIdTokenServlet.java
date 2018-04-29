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
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken.Payload;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.jackson.JacksonFactory;
import com.onlineclasses.db.DB;
import com.onlineclasses.entities.GoogleIdTokenResponse;
import java.util.Collections;
import javax.servlet.ServletConfig;

@WebServlet(urlPatterns = {"/servlets/google_id_token"})
public class GoogleIdTokenServlet extends ServletBase {

    private static JacksonFactory _jacksonFactory = new JacksonFactory();

    private static GoogleIdTokenVerifier _verifier;

    static {

        String clientId = Config.get("webiste.google.client_id");
        _verifier = new GoogleIdTokenVerifier.Builder(new NetHttpTransport(), _jacksonFactory)
                // Specify the CLIENT_ID of the app that accesses the backend:
                .setAudience(Collections.singletonList(clientId))
                // Or, if multiple clients access the backend:
                //.setAudience(Arrays.asList(CLIENT_ID_1, CLIENT_ID_2, CLIENT_ID_3))
                .build();

    }

    public static User userFromGoogleToken(String googleToken) {
        try {
            GoogleIdToken idToken = _verifier.verify(googleToken);

            if (idToken == null) {
                return null;
            }
            Payload payload = idToken.getPayload();

            User user = new User();

            // Get profile information from payload
            user.email = payload.getEmail();
            // TODO handle email verified
            //boolean emailVerified = Boolean.valueOf(payload.getEmailVerified());
            user.display_name = (String) payload.get("name");
            user.image_url = (String) payload.get("picture");

            user.last_name = (String) payload.get("family_name");
            user.first_name = (String) payload.get("given_name");

            return user;
            // Use or store profile information
        } catch (Exception ex) {
            Utils.exception(ex);
            return null;
        }
    }

    protected BasicResponse handleRequest(String requestString, HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        GoogleIdTokenRequest googleIdTokenRequest = _gson.fromJson(requestString, GoogleIdTokenRequest.class);

        String googleIdToken = googleIdTokenRequest.google_id_token;
        Utils.debug("google id token from " + ServletBase.getUser(request) + " token " + googleIdToken);

        User googleUser = userFromGoogleToken(googleIdToken);        
        if ( googleUser == null ) {
            Utils.warning("google login from token failed");            
            return new BasicResponse(-1,"");
            
        }
        User user = DB.getUserByEmail(googleUser.email);
        if (user == null) {
            Utils.info("google login from new email " + googleUser.email);
        }
        return new GoogleIdTokenResponse(user != null);        
    }

}
