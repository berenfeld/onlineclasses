<%@include file="start.jsp" %>

<%@page import="com.onlineclasses.entities.Teacher"%>
<%@page import="com.onlineclasses.entities.Topic"%>
<%@page import="com.onlineclasses.entities.Subject"%>
<%@page import="com.onlineclasses.utils.Config"%>

<%
    int teacherId = Utils.parseInt(request.getParameter("id"));
    Teacher teacher = null;
    if (teacherId != 0) {
        teacher = DB.getTeacher(teacherId);
    } else {
        teacher = (Teacher) BaseServlet.getUser(request);
    }
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

                        <img src="<%= teacher.image_url%>" class="w-100 border rounded img-responsive figure-img rounded mx-1 my-1"/>
                        <figcaption class="figure-caption text-center my-1">
                            <%= teacher.display_name%>
                        </figcaption>     
                    </figure>
                </div>
                <div class="col-9">
                    <div class="card">
                        <div class="card-header">
                            <div class="card-title h4">
                                <%= Labels.get("teacher_homepage.title.start")%>
                                <%= teacher.display_name%>
                            </div>

                        </div>
                        <div class="card-body">
                            <div class="my-1">
                                &quot;
                                <cite class="h5">
                                    <%= teacher.moto%>
                                </cite>
                                &quot;
                            </div>
                            <div class="my-1">
                                <ul class="list-group">
                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                        teacing in the website
                                        <span class="badge badge-primary badge-pill">
                                            2 years and 3 months
                                        </span>
                                    </li>
                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                        classes given
                                        <span class="badge badge-primary badge-pill">
                                            15
                                        </span>
                                    </li>
                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                        Rating from students         
                                        
                                        <span class="badge badge-primary badge-pill">                                            
                                            <div cass="d-inline-block" style="position:relative; cursor:default"
                                                 title="<%= Labels.get("find_teachers.list.body.rating_prefix")%>&nbsp;<%= teacher.rating%>&nbsp;<%= Labels.get("find_teachers.list.body.rating_suffix")%>">
                                                <div class="bg-white"
                                                     style="opacity: 0.8; position:absolute; height:100%; width:<%= (int) (100 - (teacher.rating * 20))%>%">
                                                </div>
                                                <div class="d-inline-block text-white">
                                                    <span class="oi" data-glyph="star"></span>
                                                    <span class="oi" data-glyph="star"></span>
                                                    <span class="oi" data-glyph="star"></span>
                                                    <span class="oi" data-glyph="star"></span>
                                                    <span class="oi" data-glyph="star"></span>
                                                </div>
                                            </div>
                                        </span>
                                    </li>
                                </ul>
                            </div>
                            <div class="row no-gutters my-2">
                                <div class="col-4 pl-1">
                                    <div class="card">
                                        <div class="card-header">
                                            <div class="card-title">
                                                teaching subjects
                                            </div>
                                        </div>
                                        <div class="card-body">
                                        </div>
                                    </div>
                                </div>
                                <div class="col-4 px-1">
                                    <div class="card">
                                        <div class="card-header">
                                            <div class="card-title">
                                                last classes
                                            </div>
                                        </div>
                                        <div class="card-body">
                                        </div>
                                    </div>
                                </div>
                                <div class="col-4 pr-1">
                                    <div class="card">
                                        <div class="card-header">
                                            <div class="card-title">
                                                available hours
                                            </div>
                                        </div>
                                        <div class="card-body">
                                        </div>
                                    </div>
                                </div>
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
