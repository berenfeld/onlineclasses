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
import com.onlineclasses.utils.CConfig;
import com.onlineclasses.utils.Config;
import com.onlineclasses.utils.EmailSender;
import com.onlineclasses.utils.Labels;
import com.onlineclasses.utils.TasksManager;
import com.onlineclasses.utils.Utils;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@MultipartConfig
@WebServlet(urlPatterns = {"/servlets/file_upload"}, loadOnStartup = 1)
public class FileUploadServlet extends HttpServlet {

    @Override
    public void init(ServletConfig config) throws ServletException {
        Utils.info("servlet " + getClass().getSimpleName() + "init");
        String uploadDirName = Utils.getPath( "", Config.get("website.file.local_files_root"));
        File uploadDir = new File(uploadDirName);
        if (!uploadDir.exists()) {
            Utils.info("creating root folder " + uploadDirName);
            uploadDir.mkdir();
        }
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        AttachedFile attachedFile;
        try {
            User user = BaseServlet.getUser(request);

            int oClassId = Utils.parseInt(request.getParameter("oclass_id"));
            String comment = request.getParameter("oclass_attach_file_comment");
            Part filePart = request.getPart("oclass_attach_file_input");
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            long fileSize = filePart.getSize();
            Utils.info("upload file " + fileName + " size " + fileSize + " from user " + user + " sched class " + oClassId + " comment " + comment);

            OClass oclass = DB.getOClass(oClassId);
            if (oclass == null) {
                Utils.warning("class id " + oClassId + " not found");
                return;
            }

            if (user == null) {
                Utils.warning("guest can't upload file");
                return;
            }

            attachedFile = new AttachedFile();
            attachedFile.added = new Date();
            attachedFile.oclass = oclass;
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

            String classRootDirName = Utils.getPath("",
                    Config.get("website.file.local_files_root"),
                    CConfig.get("website.file.upload.classes_prefix") + oClassId);
            Utils.info("class root dir name " + classRootDirName);

            File classRootDir = new File(classRootDirName);
            if (!classRootDir.exists()) {
                Utils.info("creating scheduled class root folder " + classRootDirName);
                classRootDir.mkdir();
            }

            String outputFileName = classRootDirName + File.separator + fileName;

            InputStream fi = filePart.getInputStream();
            File outputFile = new File(outputFileName);
            if (outputFile.exists()) {
                Utils.warning("output file name " + outputFileName + " already uploaded");
                return;
            }
            
            Utils.info("creating new file " + outputFile.getAbsolutePath());
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

            sendEmail(request, user, oclass, attachedFile);
            Utils.info("upload file done file " + fileName + " size " + fileSize);
        } catch (Exception ex) {
            Utils.exception(ex);
        }
    }

    private void sendEmail(HttpServletRequest request, User uploader, OClass oClass, AttachedFile attachedFile) throws Exception {
        String email_name = Config.get("mail.emails.path") + File.separator
                + Config.get("website.language") + File.separator + "class_added_file.html";
        Utils.info("sending email " + email_name);

        Calendar classStart = Calendar.getInstance();
        classStart.setTime(oClass.start_date);

        String emailContent = Utils.getStringFromInputStream(request.getServletContext(), email_name);

        emailContent = emailContent.replaceAll("<% commentator %>", uploader.display_name);
        emailContent = emailContent.replaceAll("<% fileName %>", attachedFile.name);
        emailContent = emailContent.replaceAll("<% comment %>", attachedFile.comment);
        emailContent = emailContent.replaceAll("<% classDay %>", Utils.dayNameLong(classStart.get(Calendar.DAY_OF_WEEK)) + " " + new SimpleDateFormat("dd/MM/YYYY").format(oClass.start_date));
        emailContent = emailContent.replaceAll("<% classTime %>", new SimpleDateFormat("HH:mm").format(oClass.start_date));
        emailContent = emailContent.replaceAll("<% oClassLink %>", Config.get("website.url") + "/oclass?id=" + oClass.id);
        emailContent = emailContent.replaceAll("<% gotoClass %>", Labels.get("emails.new_oclass.goto_class"));
        emailContent = emailContent.replaceAll("<% classSubject %>", oClass.subject);

        List<User> to = Arrays.asList(oClass.student, oClass.teacher);
        EmailSender.addEmail(to, Labels.get("emails.oclass_added_comment.title"), emailContent);
        TasksManager.runNow(TasksManager.TASK_EMAIL);
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
