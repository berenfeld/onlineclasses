package com.onlineclasses.servlets;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import com.onlineclasses.entities.BasicResponse;
import com.onlineclasses.entities.ContactRequest;
import com.onlineclasses.utils.Utils;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/servlets/contact"})
public class ContactServlet extends BaseServlet {

    @Override
    protected BasicResponse handleRequest(String requestString, HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        ContactRequest contactRequest = Utils.gson().fromJson(requestString, ContactRequest.class);
                        
        return new BasicResponse(0, "");
    }

}
