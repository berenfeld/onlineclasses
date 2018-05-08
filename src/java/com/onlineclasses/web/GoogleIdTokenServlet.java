package com.onlineclasses.web;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken.Payload;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.jackson.JacksonFactory;
import com.onlineclasses.db.DB;
import com.onlineclasses.entities.BasicResponse;
import com.onlineclasses.entities.GoogleIdTokenRequest;
import com.onlineclasses.entities.GoogleIdTokenResponse;
import com.onlineclasses.entities.GoogleUser;
import com.onlineclasses.entities.User;
import java.util.Collections;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/servlets/google_id_token"})
public class GoogleIdTokenServlet extends ServletBase {

    private static final JacksonFactory JACKSON_FACTORY = new JacksonFactory();

    private static final GoogleIdTokenVerifier GOOGLE_ID_TOKEN_VERIFIER;

    static {
        String clientId = Config.get("webiste.google.client_id");
        GOOGLE_ID_TOKEN_VERIFIER = new GoogleIdTokenVerifier.Builder(new NetHttpTransport(), JACKSON_FACTORY)
                // Specify the CLIENT_ID of the app that accesses the backend:
                .setAudience(Collections.singletonList(clientId))
                // Or, if multiple clients access the backend:
                //.setAudience(Arrays.asList(CLIENT_ID_1, CLIENT_ID_2, CLIENT_ID_3))
                .build();

    }

    public static GoogleUser userFromGoogleToken(String googleToken) {
        try {
            GoogleIdToken idToken = GOOGLE_ID_TOKEN_VERIFIER.verify(googleToken);

            if (idToken == null) {
                return null;
            }
            Payload payload = idToken.getPayload();

            GoogleUser user = new GoogleUser();

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

    @Override
    protected BasicResponse handleRequest(String requestString, HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        GoogleIdTokenRequest googleIdTokenRequest = Utils.gson().fromJson(requestString, GoogleIdTokenRequest.class);

        String googleIdToken = googleIdTokenRequest.google_id_token;
        Utils.info("google id token from " + ServletBase.getUser(request) + " token " + googleIdToken);

        GoogleUser googleUser = userFromGoogleToken(googleIdToken);        
        if ( googleUser == null ) {
            Utils.warning("google login from token failed");            
            return new BasicResponse(-1,"");            
        }
        
        User user = DB.getUserByEmail(googleUser.email);
        if (user == null) {
            Utils.info("google login from new email " + googleUser.email);
            DB.addOrUpdateGoogleUser(googleUser);
            
        }
        return new GoogleIdTokenResponse(user != null);        
    }

}
