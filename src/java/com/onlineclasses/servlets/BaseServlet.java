package com.onlineclasses.servlets;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import com.onlineclasses.db.DB;
import com.onlineclasses.entities.BasicResponse;
import com.onlineclasses.entities.Student;
import com.onlineclasses.entities.Teacher;
import com.onlineclasses.entities.User;
import com.onlineclasses.entities.WCookie;
import com.onlineclasses.utils.Config;
import com.onlineclasses.utils.Utils;
import java.io.BufferedReader;
import java.io.IOException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.concurrent.TimeUnit;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public abstract class BaseServlet extends HttpServlet {

    private String getRequestString(HttpServletRequest request) throws IOException {
        String requestString = "";
        BufferedReader reader = request.getReader();
        while (reader.ready()) {
            requestString += URLDecoder.decode(reader.readLine(), "UTF-8");
        }
        return requestString;
    }

    private static String calculateUserHash(User user) throws Exception {
        String hashString = user.id + "." + user.email + "." + Config.get("website.secret.md5");
        Utils.debug("calculate hash of '" + hashString + "'");
        String userHash = Utils.md5(hashString);
        return userHash;
    }

    private static boolean verifyHash(User user, String hash) throws Exception {
        String userHash = calculateUserHash(user);
        return userHash.equalsIgnoreCase(hash);
    }

    private static Cookie findCookieFromUser(HttpServletRequest request) {
        String cookieName = Config.get("website.cookie.name");
        if ( request.getCookies() == null) {
            return null;
        }
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

    public static User getUser(HttpServletRequest request) {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(Config.get("website.session.variable.name"));
        return user;
    }

    public static boolean isLoggedIn(HttpServletRequest request) {
        return getUser(request) != null;
    }

    public static boolean isStudent(HttpServletRequest request) {
        User user = getUser(request);
        return (user != null) && (user instanceof Student);
    }

    public static boolean isTeacher(HttpServletRequest request) {
        User user = getUser(request);
        return (user != null) && (user instanceof Teacher);
    }
    
     public static boolean isAdmin(HttpServletRequest request) {
        User user = getUser(request);
        return (user != null) && (user.admin);
    }

    public static User handleLoginInRequest(HttpServletRequest request) throws Exception {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(Config.get("website.session.variable.name"));
        if (user == null) {
            Utils.debug("no user in session " + session);
            Cookie cookie = findCookieFromUser(request);
            if (cookie == null) {
                Utils.debug("no cookie in session " + session);
                logoutUser(request);
                return null;
            }

            String cookieStr = URLDecoder.decode(cookie.getValue(), "UTF-8");
            WCookie websiteCookie = Utils.gson().fromJson(cookieStr, WCookie.class);
            if (websiteCookie.is_teacher) {
                user = DB.getTeacher(websiteCookie.user_id);
            } else {
                user = DB.getStudent(websiteCookie.user_id);
            }
            if (user == null) {
                Utils.debug("no user id from cookie in session " + session);
                logoutUser(request);
                return null;
            }

            if (!verifyHash(user, websiteCookie.hash)) {
                Utils.debug("incorrect hash in cookie in session " + session);
                logoutUser(request);
                return null;
            }
            Utils.debug("found user in cookie in session " + session);
            return loginUser(request, user);
        } else {
            Utils.debug("found user in session " + session);
            return loginUser(request, user);
        }
    }

    public static void handleLoginInResponse(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(Config.get("website.session.variable.name"));

        String cookieName = Config.get("website.cookie.name");
        Cookie cookie = new Cookie(cookieName, "");
        cookie.setPath("/");
        if (user == null) {
            cookie.setMaxAge(0);
        } else {
            WCookie websiteCookie = new WCookie();
            websiteCookie.user_id = user.id;
            websiteCookie.hash = calculateUserHash(user);
            websiteCookie.is_teacher = user.isTeacher();
            String websiteCookieString = URLEncoder.encode(Utils.gson().toJson(websiteCookie), "UTF-8");
            cookie.setValue(websiteCookieString);
            cookie.setMaxAge((int) TimeUnit.DAYS.toSeconds(Config.getInt("website.cookie.age.days")));
        }
        response.addCookie(cookie);
        Utils.debug("set cookie value " + cookie.getValue() + " age " + cookie.getMaxAge() + " on url " + request.getRequestURI());
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            request.setCharacterEncoding("UTF-8");
            handleLoginInRequest(request);

            String requestString = getRequestString(request);
            Utils.info("*** request : " + request.getRequestURI() + " data : " + requestString);

            BasicResponse responseObject = handleRequest(requestString, request, response);
            String responseStr = Utils.gson().toJson(responseObject);

            response.setContentType("application/json;charset=UTF-8");
            handleLoginInResponse(request, response);
            response.getWriter().write(responseStr);
            Utils.info("*** response : " + request.getRequestURI() + " data : " + responseStr);
        } catch (Exception ex) {
            Utils.exception(ex);
            // TODO exception
        }
    }

    protected abstract BasicResponse handleRequest(String requestString, HttpServletRequest request, HttpServletResponse response) throws Exception;

    @Override
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
