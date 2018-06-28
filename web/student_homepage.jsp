<%@page import="com.onlineclasses.entities.Topic"%>
<%@page import="com.onlineclasses.entities.Subject"%>
<%@page import="com.onlineclasses.entities.Student"%>
<%@page import="com.onlineclasses.utils.Config"%>

<%
    int studentId = Utils.parseInt(request.getParameter("id"));
    Student student = null; 
    if (studentId != 0) {
        student = DB.getStudent(studentId);
    } else {
        student = (Student) BaseServlet.getUser(request);
    }
    if (student == null) {
        Utils.warning("student not found");
        response.sendRedirect("/");
        return;
    }
%>
<!DOCTYPE html>
<html lang="<%= Config.get("website.html_language")%>" dir="<%= Config.get("webiste.direction")%>">
    <head>
        <%@include file="header.jsp" %>
        <%
            User shp_user = BaseServlet.getUser(request);
            Student shp_student = (Student) shp_user;
        %>
        <title>
            <%= Labels.get("mainpage.title")%>
        </title>
    </head>
    <body lang="<%= Config.get("website.html_language")%>" dir="<%= Config.get("webiste.direction")%>">

        <%@include file="body.jsp" %>    
        <div class="container my-2">
            <div class="row no-gutters">
                <div class="col-3">
                    <figure class="w-100 figure h5 px-2">
                        <figcaption class="figure-caption text-center my-1">
                            <%= shp_student.display_name%>
                        </figcaption>
                        <img src="<%= shp_student.image_url%>" class="w-100 border border-success img-responsive figure-img rounded mx-1 my-1"/>
                    </figure>
                </div>
                <div class="col-9">
                    <div class="card">
                        <div class="card-header">
                            <div class="card-title">
                                Homepage of <%= shp_student.display_name%>
                            </div>
                        </div>
                        <div class="card-body">

                        </div>
                    </div>
                </div>
            </div>
        </div>
        <%@include file="footer.jsp" %>   
        <script>
            student_homepage.student = <%= Utils.gson().toJson(BaseServlet.getUser(request))%>;
            student_homepage_init();
        </script>
    </body>

</html>
