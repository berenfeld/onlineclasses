package com.onlineclasses.servlets;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import com.onlineclasses.db.DB;
import com.onlineclasses.entities.BasicResponse;
import com.onlineclasses.entities.GoogleUser;
import com.onlineclasses.entities.LoginRequest;
import com.onlineclasses.entities.OClass;
import com.onlineclasses.entities.User;
import com.onlineclasses.utils.Config;
import com.onlineclasses.utils.Utils;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Paths;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@MultipartConfig
@WebServlet(urlPatterns = {"/servlets/file_upload"})
public class FileUploadServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute(Config.get("website.session.variable.name"));

            int ScheduledClassId = Utils.parseInt(request.getParameter("scheduled_class_id"));
            String comment = request.getParameter("scheduled_class_attach_file_comment");
            Part filePart = request.getPart("scheduled_class_attach_file_input");
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            Utils.info("upload file " + fileName + " from user " + user + " sched class " + ScheduledClassId + " comment "+ comment);

            OClass oclass = DB.get(ScheduledClassId, OClass.class);
            InputStream fileContent = filePart.getInputStream();
        } catch (Exception ex) {
            Utils.exception(ex);
        }
        return;
    }

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
