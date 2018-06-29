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
import com.onlineclasses.servlets.entities.CancelClassRequest;
import com.onlineclasses.servlets.entities.UpdateClassPriceRequest;
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

@WebServlet(urlPatterns = {"/servlets/update_class_price"})
public class UpdateClassPriceServlet extends BaseServlet {

    @Override
    protected BasicResponse handleRequest(String requestString, HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        UpdateClassPriceRequest updateClassPriceRequest = Utils.gson().fromJson(requestString, UpdateClassPriceRequest.class);

        User user = getUser(request);
        if (user == null) {
            Utils.warning("guest can'f cancel scheduled class id " + updateClassPriceRequest.oclass_id);
            return new BasicResponse(-1, "guest can't cancel class");
        }

        Utils.info(user + " update class price " + updateClassPriceRequest.oclass_id + " new_price " + updateClassPriceRequest.new_price);

        OClass oClass = DB.getOClass(updateClassPriceRequest.oclass_id);
        if (oClass == null) {
            Utils.warning("can'd find scheduled class id " + updateClassPriceRequest.oclass_id);
            return new BasicResponse(-1, "scheduled class not found");
        }

        if (oClass.payment != null) {
            Utils.warning("class" + updateClassPriceRequest.oclass_id + " already paid");
            return new BasicResponse(-1, "class already canceled");
        }

        if (!user.equals(oClass.teacher)) {
            Utils.warning(user + "can'd update price on class id " + updateClassPriceRequest.oclass_id + ", not teacher");
            return new BasicResponse(-1, "not teacher");
        }

        int newPricePerHour = (int) (updateClassPriceRequest.new_price * Utils.MINUTES_IN_HOUR) / oClass.duration_minutes;
        DB.updateClassPricePerHour(oClass, newPricePerHour);

        sendEmail(user, oClass, updateClassPriceRequest.new_price);

        return new BasicResponse(0, "");
    }

    private void sendEmail(User user, OClass oClass, int newPrice) throws Exception {
        String email_name = Config.get("mail.emails.path") + File.separator
                + Config.get("website.language") + File.separator + "class_price_updated.html";
        Utils.info("sending email " + email_name);

        Teacher teacher = DB.get(oClass.teacher.id, Teacher.class);
        Student student = DB.get(oClass.student.id, Student.class);

        String emailContent = Utils.getStringFromInputStream(getServletContext(), email_name);

        emailContent = emailContent.replaceAll("<% classUpdatedPrice %>", String.valueOf(newPrice));
        emailContent = emailContent.replaceAll("<% studentName %>", student.display_name);
        emailContent = emailContent.replaceAll("<% teacherName %>", teacher.display_name);
        emailContent = emailContent.replaceAll("<% classSubject %>", oClass.subject);
        emailContent = emailContent.replaceAll("<% oClassLink %>", Config.get("website.url") + "/oclass?id=" + oClass.id);

        List<User> to = Arrays.asList(student, teacher);
        EmailSender.addEmail(to, Labels.get("emails.class_price_updated.title"), emailContent);
        TasksManager.runNow(TasksManager.TASK_EMAIL);
    }

}
