<%@page import="com.onlineclasses.db.DB"%>
<%@page import="com.onlineclasses.entities.Student"%>
<%@page import="com.onlineclasses.web.Config"%>
<!DOCTYPE html>
<%
    String email;
    Student student;
    do {
        email = request.getParameter("email");
        String hash = request.getParameter("hash");

        student = DB.getStudentByEmail(email);
        if (student == null) {
            Utils.warning("email unsuscribe unknown email " + email);        
            break;
        }

        String hashString = student.email + "." + Config.get("website.secret.md5");
        String verifyHash = Utils.md5(hashString);

        if (!verifyHash.equals(hash)) {
            Utils.warning("email unsuscribe bad hash on email " + email);        
            break;
        }

        student.emails_enabled = false;
        if (1 != DB.updateUserEmailEnabled(student)) {
            Utils.warning("failed to update email unsuscribe on student " + student + " email " + student.email);
        }    
    } while ( false);
%>
<html lang="<%= Config.get("website.html_language")%>" dir="<%= Config.get("webiste.direction")%>">
    <head>
        <%@include file="header.jsp" %>
    </head>
    <body lang="<%= Config.get("website.html_language") %>" dir="<%= Config.get("webiste.direction") %>">
        <%@include file="body.jsp" %>    
        <div class="container">
            <div class="card text-white bg-info"></div>
            <h5>
                We unsubscribed the email <%= email %> from our lists
            </h5>
        </div>
        <%@include file="footer.jsp" %>    
    </body>

</html>
