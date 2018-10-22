package com.onlineclasses.servlets;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import com.onlineclasses.db.DB;
import com.onlineclasses.entities.BasicResponse;
import com.onlineclasses.entities.OClass;
import com.onlineclasses.entities.Payment;
import com.onlineclasses.entities.Student;
import com.onlineclasses.entities.Teacher;
import com.onlineclasses.entities.User;
import com.onlineclasses.servlets.entities.AddClassCommentRequest;
import com.onlineclasses.servlets.entities.AddExternalPaymentRequest;
import com.onlineclasses.servlets.entities.CancelClassRequest;
import com.onlineclasses.servlets.entities.UpdateClassPriceRequest;
import com.onlineclasses.utils.Config;
import com.onlineclasses.utils.EmailSender;
import com.onlineclasses.utils.Labels;
import com.onlineclasses.utils.TasksManager;
import com.onlineclasses.utils.Utils;
import java.io.File;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/servlets/add_external_payment"})
public class AddExternalPaymentServlet extends BaseServlet {

    @Override
    protected BasicResponse handleRequest(String requestString, HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        AddExternalPaymentRequest addExternalPaymentRequest = Utils.gson().fromJson(requestString, AddExternalPaymentRequest.class);

        User user = getUser(request);
        if (user == null) {
            Utils.warning("guest can'f cancel scheduled class id " + addExternalPaymentRequest.oclass_id);
            return new BasicResponse(-1, "guest can't cancel class");
        }

        Utils.info(user + " update class price " + addExternalPaymentRequest.oclass_id + " new_price " + addExternalPaymentRequest.amount);

        OClass oClass = DB.getOClass(addExternalPaymentRequest.oclass_id);
        if (oClass == null) {
            Utils.warning("can'd find scheduled class id " + addExternalPaymentRequest.oclass_id);
            return new BasicResponse(-1, "scheduled class not found");
        }

        if (oClass.payment != null) {
            Utils.warning("class" + addExternalPaymentRequest.oclass_id + " already paid");
            return new BasicResponse(-1, "class already has payment");
        }

        if (!user.equals(oClass.teacher)) {
            Utils.warning(user + "can'dtadd external payment on class id " + addExternalPaymentRequest.oclass_id + ", not teacher");
            return new BasicResponse(-1, "not teacher");
        }

        Payment payment = new Payment();
        payment.payer = oClass.teacher.email;
        payment.amount = addExternalPaymentRequest.amount;
        payment.date = new Date();
        payment.external = true;
        payment.oclass = oClass;
        
        DB.add(payment);
        
        oClass.price_per_hour = (int)( payment.amount * 60 ) / oClass.duration_minutes;
        DB.update(oClass);
        
        sendEmail(user, oClass, addExternalPaymentRequest);

        return new BasicResponse(0, "");
    }

    private void sendEmail(User user, OClass oClass, AddExternalPaymentRequest addExternalPaymentRequest) throws Exception {
        String email_name = Config.get("mail.emails.path") + File.separator
                + Config.get("website.language") + File.separator + "class_external_payment_added.html";
        Utils.info("sending email " + email_name);

        Teacher teacher = DB.get(oClass.teacher.id, Teacher.class);
        Student student = DB.get(oClass.student.id, Student.class);

        String emailContent = Utils.getStringFromInputStream(getServletContext(), email_name);

        emailContent = emailContent.replaceAll("<% classPrice %>", String.valueOf(addExternalPaymentRequest.amount));
        emailContent = emailContent.replaceAll("<% studentName %>", student.display_name);
        emailContent = emailContent.replaceAll("<% teacherName %>", teacher.display_name);
        emailContent = emailContent.replaceAll("<% classSubject %>", oClass.subject);
        emailContent = emailContent.replaceAll("<% oClassLink %>", Config.get("website.url") + "/oclass?id=" + oClass.id);

        List<User> to = Arrays.asList(student, teacher);
        EmailSender.addEmail(to, Labels.get("emails.class_price_updated.title"), emailContent);
        TasksManager.runNow(EmailSender.EMAIL_SENDER_NAME);
    }

}
