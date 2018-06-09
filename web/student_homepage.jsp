<%@page import="com.onlineclasses.entities.Topic"%>
<%@page import="com.onlineclasses.entities.Subject"%>
<%@page import="com.onlineclasses.entities.Student"%>
<%@page import="com.onlineclasses.utils.Config"%>
<%
    Student student = (Student) BaseServlet.getUser(request);
%>
<!DOCTYPE html>
<html lang="<%= Config.get("website.html_language")%>" dir="<%= Config.get("webiste.direction")%>">
    <head>
        <%@include file="header.jsp" %>
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
                            <%= student.display_name%>
                        </figcaption>
                        <img src="<%= student.image_url%>" class="w-100 border border-success img-responsive figure-img rounded mx-1 my-1"/>
                    </figure>
                </div>
                <div class="col-9">
                    <div class="card">
                        <div class="card-header">
                            <div class="card-title">
                                Homepage of <%= student.display_name%>
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
                student_homepage.student = <%= BaseServlet.getUser(request)%>;
                student_homepage_init();
        </script>
    </body>

</html>
