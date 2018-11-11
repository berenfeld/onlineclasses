package com.onlineclasses.servlets;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import com.onlineclasses.entities.AttachedFile;
import com.onlineclasses.entities.OClass;
import com.onlineclasses.entities.User;
import com.onlineclasses.utils.CConfig;
import com.onlineclasses.utils.Config;
import com.onlineclasses.utils.EmailSender;
import com.onlineclasses.utils.Labels;
import com.onlineclasses.utils.TasksManager;
import com.onlineclasses.utils.Utils;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.List;
import javax.imageio.ImageIO;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@MultipartConfig
@WebServlet(urlPatterns = {"/servlets/teacher_image_upload"}, loadOnStartup = 1)
public class TeacherImageUploadServlet extends HttpServlet {

    private static BufferedImage resize(BufferedImage img, int height, int width) {
        Image tmp = img.getScaledInstance(width, height, Image.SCALE_SMOOTH);
        BufferedImage resized = new BufferedImage(width, height, BufferedImage.TYPE_INT_ARGB);
        Graphics2D g2d = resized.createGraphics();
        g2d.drawImage(tmp, 0, 0, null);
        g2d.dispose();
        return resized;
    }

    @Override
    public void init(ServletConfig config) throws ServletException {
        Utils.info("servlet " + getClass().getSimpleName() + "init");

        String uploadImagesDirName = Utils.getPath("",
                Config.get("website.file.local_files_root"), CConfig.get("website.file.upload.images_root"));
        File uploadImagesDir = new File(uploadImagesDirName);
        if (!uploadImagesDir.exists()) {
            Utils.info("creating root images folder " + uploadImagesDir);
            uploadImagesDir.mkdir();
        }
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        try {
            User user = BaseServlet.getUser(request);

            String imageId = request.getParameter("image_id");
            Part filePart = request.getPart("img_upload_input");
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            long fileSize = filePart.getSize();
            Utils.info("upload file " + fileName + " size " + fileSize + " from user " + user);

            InputStream fi = filePart.getInputStream();
            BufferedImage image = ImageIO.read(fi);
            BufferedImage resized = resize(image, image.getWidth(), image.getWidth());
            String scaledOutputFileName = Utils.getPath(imageId + ".png",
                    Config.get("website.file.local_files_root"),
                    CConfig.get("website.file.upload.images_root"));

            File output = new File(scaledOutputFileName);
            ImageIO.write(resized, "png", output);

            Utils.info("upload file done file " + fileName + " size " + fileSize + " scled file " + scaledOutputFileName);
        } catch (IOException | ServletException ex) {
            Utils.exception(ex);
        }
    }

    private void sendEmail(User uploader, OClass oClass, AttachedFile attachedFile) throws Exception {
        String email_name = Config.get("mail.emails.path") + File.separator
                + Config.get("website.language") + File.separator + "class_added_file.html";
        Utils.info("sending email " + email_name);

        Calendar classStart = Calendar.getInstance();
        classStart.setTime(oClass.start_date);

        String emailContent = Utils.getStringFromInputStream(email_name);

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
        TasksManager.runNow(EmailSender.EMAIL_SENDER_NAME);
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
