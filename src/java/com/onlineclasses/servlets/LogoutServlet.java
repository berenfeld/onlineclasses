package com.onlineclasses.servlets;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import com.onlineclasses.entities.BasicResponse;
import com.onlineclasses.entities.User;
import com.onlineclasses.utils.Utils;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/servlets/logout"})
public class LogoutServlet extends BaseServlet {

    @Override
    protected BasicResponse handleRequest(String requestString, HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        User user = BaseServlet.getUser(request);
        if (user != null) {
            Utils.info("user " + user.display_name + " logged out");
            BaseServlet.logoutUser(request);
        }

        return new BasicResponse(0, "");
    }

}
