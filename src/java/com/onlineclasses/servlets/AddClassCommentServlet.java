package com.onlineclasses.servlets;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import com.onlineclasses.db.DB;
import com.onlineclasses.entities.BasicResponse;
import com.onlineclasses.entities.OClass;
import com.onlineclasses.entities.ClassComment;
import com.onlineclasses.entities.Student;
import com.onlineclasses.entities.Teacher;
import com.onlineclasses.entities.User;
import com.onlineclasses.servlets.entities.AddClassCommentRequest;
import com.onlineclasses.utils.Config;
import com.onlineclasses.utils.EmailSender;
import com.onlineclasses.utils.Labels;
import com.onlineclasses.utils.TasksManager;
import com.onlineclasses.utils.Utils;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/servlets/add_class_comment"})
public class AddClassCommentServlet extends BaseServlet {

    @Override
    protected BasicResponse handleRequest(String requestString, HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        AddClassCommentRequest addClassCommentRequest = Utils.gson().fromJson(requestString, AddClassCommentRequest.class);

        User user = getUser(request);
        if (user == null) {
            Utils.warning("guest can'f add comment on scheduled class id " + addClassCommentRequest.oclass_id);
            return new BasicResponse(-1, "guest can't add comment");
        }

        Utils.info(user + " add comment " + addClassCommentRequest.comment + " on class id " + addClassCommentRequest.oclass_id);

        OClass oClass = DB.getOClass(addClassCommentRequest.oclass_id);
        if (oClass == null) {
            Utils.warning("can'f find scheduled class id " + addClassCommentRequest.oclass_id);
            return new BasicResponse(-1, "scheduled class not found");
        }

        ClassComment oClassComment = new ClassComment();
        oClassComment.comment = addClassCommentRequest.comment;
        oClassComment.oclass = oClass;

        if (user.equals(oClass.student)) {
            oClassComment.student = (Student) user;
        } else if (user.equals(oClass.teacher)) {
            oClassComment.teacher = (Teacher) user;
        } else {
            Utils.warning(user + "can'f add comment on scheduled class id " + addClassCommentRequest.oclass_id + ", not student not teacher");
            return new BasicResponse(-1, "not student not teacher");
        }

        oClassComment.added = new Date();
        if (1 != DB.add(oClassComment)) {
            Utils.warning("failed to add scheduled class comment");
            return new BasicResponse(-1, "failed to add comment");
        }

        Calendar classStart = Calendar.getInstance();
        classStart.setTime(oClass.start_date);

        sendEmail(user, oClass, classStart, oClassComment.comment);

        return new BasicResponse(0, "");
    }

    private void sendEmail(User commentator, OClass oClass, Calendar classStart, String comment) throws Exception {
        String email_name = Config.get("mail.emails.path") + File.separator
                + Config.get("website.language") + File.separator + "class_added_comment.html";
        Utils.info("sending email " + email_name);

        String emailContent = Utils.getStringFromInputStream(email_name);

        emailContent = emailContent.replaceAll("<% commentator %>", commentator.display_name);
        emailContent = emailContent.replaceAll("<% comment %>", comment);
        emailContent = emailContent.replaceAll("<% classDay %>", Utils.dayNameLong(classStart.get(Calendar.DAY_OF_WEEK)) + " " + new SimpleDateFormat("dd/MM/YYYY").format(oClass.start_date));
        emailContent = emailContent.replaceAll("<% classTime %>", new SimpleDateFormat("HH:mm").format(oClass.start_date));
        emailContent = emailContent.replaceAll("<% oClassLink %>", Config.get("website.url") + "/oclass?id=" + oClass.id);
        emailContent = emailContent.replaceAll("<% gotoClass %>", Labels.get("emails.new_oclass.goto_class"));
        emailContent = emailContent.replaceAll("<% classSubject %>", oClass.subject);

        List<User> to = Arrays.asList(oClass.student, oClass.teacher);
        EmailSender.addEmail(to, Labels.get("emails.oclass_added_comment.title"), emailContent);
        TasksManager.runNow(EmailSender.EMAIL_SENDER_NAME);
    }

}
