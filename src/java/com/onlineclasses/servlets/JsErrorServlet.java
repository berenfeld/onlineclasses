package com.onlineclasses.servlets;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import com.onlineclasses.entities.BasicResponse;
import com.onlineclasses.entities.JsErrorRequest;
import com.onlineclasses.utils.Utils;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/servlets/js_error"})
public class JsErrorServlet extends BaseServlet {

    @Override
    protected BasicResponse handleRequest(String requestString, HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        JsErrorRequest jsErrorRequest = Utils.gson().fromJson(requestString, JsErrorRequest.class);

        Utils.warning("JS error from " + BaseServlet.getUser(request) + " at " + jsErrorRequest.location_href);
        Utils.warning("js file: " + jsErrorRequest.url + ":" + jsErrorRequest.line_number);
        Utils.warning("message: " + jsErrorRequest.message);
        Utils.warning("error object: " + jsErrorRequest.error_object);

        return new BasicResponse(0, "");
    }

}
