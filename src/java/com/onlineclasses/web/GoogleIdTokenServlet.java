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
import java.util.Collections;
import javax.servlet.ServletConfig;

@WebServlet(urlPatterns = {"/servlets/google_id_token"})
public class GoogleIdTokenServlet extends ServletBase {

    private Gson _gson = new Gson();
    private JacksonFactory _jacksonFactory = new JacksonFactory();

    private GoogleIdTokenVerifier _verifier;

    public void init(ServletConfig config)
            throws ServletException {
        String clientId = Config.get("webiste.google.client_id");
        _verifier = new GoogleIdTokenVerifier.Builder(new NetHttpTransport(), _jacksonFactory)
                // Specify the CLIENT_ID of the app that accesses the backend:
                .setAudience(Collections.singletonList(clientId))
                // Or, if multiple clients access the backend:
                //.setAudience(Arrays.asList(CLIENT_ID_1, CLIENT_ID_2, CLIENT_ID_3))
                .build();
    }

    protected BasicResponse handleRequest(String requestString, HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        GoogleIdTokenRequest googleIdTokenRequest = _gson.fromJson(requestString, GoogleIdTokenRequest.class);

        String googleIdToken = googleIdTokenRequest.google_id_token;
        Utils.info("google id token from " + ServletBase.getUser(request) + " token " + googleIdToken);

        // (Receive idTokenString by HTTPS POST)
        GoogleIdToken idToken = _verifier.verify(googleIdToken);
        if (idToken != null) {
            Payload payload = idToken.getPayload();

            // Print user identifier
            String userId = payload.getSubject();
            System.out.println("User ID: " + userId);

            // Get profile information from payload
            String email = payload.getEmail();
            boolean emailVerified = Boolean.valueOf(payload.getEmailVerified());
            String name = (String) payload.get("name");
            String pictureUrl = (String) payload.get("picture");
            String locale = (String) payload.get("locale");
            String familyName = (String) payload.get("family_name");
            String givenName = (String) payload.get("given_name");

            Utils.info("google access from email " + email);
            // Use or store profile information
            // ...
        } else {
            Utils.warning("Invalid ID token.");
        }

        return new BasicResponse(0, "");
    }

}
