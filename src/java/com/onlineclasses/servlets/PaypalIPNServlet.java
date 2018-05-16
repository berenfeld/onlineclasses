package com.onlineclasses.servlets;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import com.onlineclasses.entities.BasicResponse;
import com.onlineclasses.utils.Utils;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/servlets/paypal_ipn"})
public class PaypalIPNServlet extends ServletBase {

    @Override
    protected BasicResponse handleRequest(String requestString, HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        Utils.info("paypal ipn request " + request.getRequestURI());

        Utils.info("parameters : " + request.getParameterNames());
        Utils.info("parameters : " + request.getParameterMap());

        while (request.getParameterNames().hasMoreElements()) {
            String parameter = request.getParameterNames().nextElement();
            String value = request.getParameter(parameter);
            Utils.info("parameter : " + parameter + " value " + value);
        }

        return new BasicResponse(0, "");
    }

}
