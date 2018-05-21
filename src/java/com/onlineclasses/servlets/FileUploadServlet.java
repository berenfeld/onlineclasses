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
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Paths;
import java.util.Date;
import javax.servlet.ServletConfig;
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

    @Override
    public void init(ServletConfig config) throws ServletException {
        String uploadDirName = Utils.getRealPath(config.getServletContext(), "", Config.get("website.file.upload.root"));
        File uploadDir = new File(uploadDirName);
        if (!uploadDir.exists()) {
            Utils.info("creating root folder " + uploadDirName);
            uploadDir.mkdir();
        }
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        AttachedFile attachedFile = null;
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

            attachedFile = new AttachedFile();
            attachedFile.added = new Date();
            attachedFile.scheduled_class = oclass;
            attachedFile.name = fileName;
            attachedFile.size = (int) fileSize;
            attachedFile.uploaded = 0;
            attachedFile.removed = false;
            attachedFile.comment = comment;
            
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

            String classRootDirName = Utils.getRealPath(request.getServletContext(), "",
                    Config.get("website.file.upload.root"),
                    Config.get("website.file.upload.classes_prefix") + scheduledClassId);
            Utils.info("class root dir name " + classRootDirName);

            File classRootDir = new File(classRootDirName);
            if (!classRootDir.exists()) {
                Utils.info("creating scheduled class root folder " + classRootDirName);
                classRootDir.mkdir();
            }

            String outputFileName = Utils.getRealPath(request.getServletContext(), fileName,
                    Config.get("website.file.upload.root"),
                    Config.get("website.file.upload.classes_prefix") + scheduledClassId);

            InputStream fi = filePart.getInputStream();
            File outputFile = new File(outputFileName);
            if (outputFile.exists()) {
                Utils.warning("output file name " + outputFileName + " already uploaded");
                return;
            }

            outputFile.createNewFile();
            FileOutputStream fo = new FileOutputStream(outputFileName);
            int chunkSize = Config.getInt("website.file.upload.chunk_size");
            int updateDbThreshold = Config.getInt("website.file.upload.update_db_threshold");

            int read;
            int written = 0;
            int lastWrittenUpdated = 0;
            final byte[] bytes = new byte[chunkSize];

            while ((read = fi.read(bytes)) != -1) {
                fo.write(bytes, 0, read);
                written += read;
                if (written > lastWrittenUpdated + updateDbThreshold) {
                    attachedFile.uploaded = written;
                    DB.updateAttachedFileUploadedBytes(attachedFile);
                    lastWrittenUpdated = written;
                }
            }
            attachedFile.uploaded = written;
            DB.updateAttachedFileUploadedBytes(attachedFile);

            Utils.info("upload file done file " + fileName + " size " + fileSize);
        } catch (Exception ex) {
            Utils.exception(ex);
        }
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
