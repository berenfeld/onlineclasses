package com.onlineclasses.web;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import com.onlineclasses.db.DB;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.onlineclasses.entities.BasicResponse;
import com.onlineclasses.entities.User;
import com.onlineclasses.entities.WCookie;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.Reader;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.security.MessageDigest;
import java.util.concurrent.TimeUnit;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.websocket.Session;
import javax.xml.bind.DatatypeConverter;

public abstract class ServletBase extends HttpServlet {

    private static Gson _gson = new Gson();

    private String getRequestString(HttpServletRequest request) throws IOException {
        String requestString = "";
        BufferedReader reader = request.getReader();
        while (reader.ready()) {
            requestString += URLDecoder.decode(reader.readLine(), "UTF-8");
        }
        return requestString;
    }

    private static String calculateUserHash(User user) throws Exception {
        MessageDigest md = MessageDigest.getInstance("MD5");
        String hashString = user.id + "." + user.email + "." + Config.get("website.secret.md5");
        Utils.info("calculate hash of '" + hashString + "'");
        md.update(hashString.getBytes());
        String userHash = DatatypeConverter.printHexBinary(md.digest());
        return userHash;
    }    

    private static boolean verifyHash(User user, String hash) throws Exception {
        String userHash = calculateUserHash(user);
        return userHash.equalsIgnoreCase(hash);
    }

    private static Cookie findCookieFromUser(HttpServletRequest request) {
        String cookieName = Config.get("website.cookie.name");
        for (Cookie cookie : request.getCookies()) {
            if (cookie.getName().equals(cookieName)) {
                return cookie;
            }
        }
        return null;
    }

    public static User loginUser(HttpServletRequest request, User user) throws Exception {
        HttpSession session = request.getSession();
        session.setAttribute(Config.get("website.session.variable.name"), user);
                
        Utils.info("user " + user.display_name + " logged in session " + session);
        return user;
    }

    public static void logoutUser(HttpServletRequest request) throws Exception {
        HttpSession session = request.getSession();
        session.removeAttribute(Config.get("website.session.variable.name"));
    }

    
    public static User getUser(HttpServletRequest request)
    {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(Config.get("website.session.variable.name"));
        return user;
    }
    
    public static User handleLoginInRequest(HttpServletRequest request) throws Exception {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(Config.get("website.session.variable.name"));
        if (user == null) {
            Utils.info("no user in session " + session);
            Cookie cookie = findCookieFromUser(request);
            if (cookie == null) {                
                Utils.info("no cookie in session " + session);
                logoutUser(request);
                return null;
            }
            
            String cookieStr = URLDecoder.decode(cookie.getValue(), "UTF-8");
            WCookie websiteCookie = _gson.fromJson(cookieStr, WCookie.class);
            user = DB.getUser(websiteCookie.user_id);
            if ( user == null ) {
                Utils.info("no user id from cookie in session " + session);
                logoutUser(request);
                return null;
            }
            
            if (!verifyHash(user, websiteCookie.hash)) {
                Utils.info("incorrect hash in cookie in session " + session);
                logoutUser(request);
                return null;
            }
            return loginUser(request, user);
        } else {
            return loginUser(request, user);
        }
    }

    public static void handleLoginInResponse(HttpServletRequest request, HttpServletResponse response) throws Exception
    {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(Config.get("website.session.variable.name"));
        
        String cookieName = Config.get("website.cookie.name");
        Cookie cookie = new Cookie(cookieName,"");
        cookie.setPath("/");
        if ( user == null )
        {                        
            cookie.setMaxAge(0);         
        } else {
            WCookie websiteCookie = new WCookie();
            websiteCookie.user_id = user.id;
            websiteCookie.hash = calculateUserHash(user);
            String websiteCookieString = URLEncoder.encode( _gson.toJson(websiteCookie), "UTF-8");
            cookie.setValue(websiteCookieString);
            cookie.setMaxAge((int) TimeUnit.DAYS.toSeconds(Config.getInt("website.cookie.age.days")));
        }
        Utils.debug("set cookie value " + cookie.getValue() + " age " + cookie.getMaxAge());
        response.addCookie(cookie);        
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            handleLoginInRequest(request);

            String requestString = getRequestString(request);
            Utils.info("request : " + requestString);

            BasicResponse responseObject = handleRequest(requestString, request, response);
            String responseStr = _gson.toJson(responseObject);
            
            response.setContentType("application/json;charset=UTF-8");
            handleLoginInResponse(request, response);
            response.getWriter().write(responseStr);
        } catch (Exception ex) {
            Utils.exception(ex);
            // TODO exception
        }
    }

    protected abstract BasicResponse handleRequest(String requestString, HttpServletRequest request, HttpServletResponse response) throws Exception;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

}
