<%@page import="com.onlineclasses.entities.Teacher"%>
<%@page import="com.onlineclasses.entities.Topic"%>
<%@page import="com.onlineclasses.entities.Subject"%>
<%@page import="com.onlineclasses.utils.Config"%>
<%
    Teacher teacher = (Teacher) BaseServlet.getUser(request);
    if (teacher == null) {
        Utils.warning("teacher not found");
        response.sendRedirect("/");
        return;
    }
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
                            <%= teacher.display_name%>
                        </figcaption>                        
                        <img src="<%= teacher.image_url%>" class="w-100 border rounded img-responsive figure-img rounded mx-1 my-1"/>
                    </figure>
                </div>
                <div class="col-9">
                    <div class="card">
                        <div class="card-header">
                            <div class="card-title">
                                Homepage of <%= teacher.display_name%>
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
            teacher_homepage.teacher = <%= BaseServlet.getUser(request)%>;
            teacher_homepage_init();
        </script>
    </body>

</html>
