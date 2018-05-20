package com.onlineclasses.servlets;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import com.onlineclasses.db.DB;
import com.onlineclasses.entities.AttachedFile;
import com.onlineclasses.entities.Teacher;
import com.onlineclasses.entities.Student;
import com.onlineclasses.entities.OClass;
import com.onlineclasses.entities.User;
import com.onlineclasses.utils.Config;
import com.onlineclasses.utils.Utils;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Paths;
import java.util.Date;
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

            int scheduledClassId = Utils.parseInt(request.getParameter("scheduled_class_id"));
            String comment = request.getParameter("scheduled_class_attach_file_comment");
            Part filePart = request.getPart("scheduled_class_attach_file_input");
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            long fileSize = filePart.getSize();
            Utils.info("upload file " + fileName + " size " + fileSize + " from user " + user + " sched class " + scheduledClassId + " comment " + comment);

            OClass oclass = DB.getOClass(scheduledClassId);
            if (oclass == null) {
                Utils.warning("class id " + scheduledClassId + " not found");
                return;
            }

            if (user == null) {
                Utils.warning("guest can't upload file");
                return;
            }
            
            AttachedFile attachedFile = new AttachedFile();
            attachedFile.added = new Date();
            attachedFile.scheduled_class = oclass;
            attachedFile.name = fileName;
            attachedFile.size = (int) fileSize;
            attachedFile.uploaded = 0;
            attachedFile.removed = false;
            if (user.equals(oclass.student)) {
                attachedFile.student = (Student) user;
            } else if (user.equals(oclass.teacher)) {
                attachedFile.teacher = (Teacher) user;
            } else {
                Utils.warning("not teacher and not student can't upload file");
                return;
            }
            DB.add(attachedFile);
            if (attachedFile.id == 0) {
                Utils.warning("failed to add attached file");
                return;
            }

            String outputFileName = Utils.getRealPath(getServletContext(), fileName,
                    Config.get("website.file.upload.root"),
                    Config.get("website.file.upload.classes_prefix") + scheduledClassId);

            InputStream fi = filePart.getInputStream();
            FileOutputStream fo = new FileOutputStream(outputFileName);
            int chunkSize = Config.getInt("website.file.upload.chunk_size");
            
            int read;
            int written = 0;
            final byte[] bytes = new byte[chunkSize];

            while ((read = fi.read(bytes)) != -1) {
                fo.write(bytes, 0, read);
                written += read;
                attachedFile.uploaded = written;
                DB.updateAttachedFileUploadedBytes(attachedFile);
            }
            Utils.info("upload file done file " + fileName + " size " + fileSize );
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
