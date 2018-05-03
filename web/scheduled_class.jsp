<%@page import="com.onlineclasses.entities.Teacher"%>
<%@page import="com.onlineclasses.db.DB"%>
<%@page import="com.onlineclasses.entities.ScheduledClass"%>
<%@page import="com.onlineclasses.web.Config"%>
<%@page import="com.onlineclasses.web.Labels"%>

<%
    int classId = Integer.parseInt(request.getParameter("id"));
    ScheduledClass scheduledClass = DB.getScheduledClass(classId);
    Teacher teacher = scheduledClass.teacher;
    // TODO handle not found
%>

<!DOCTYPE html>
<html lang="<%= Config.get("website.html_language")%>">
    <head>
        <%@include file="header.jsp" %>
        <link rel="stylesheet" href="css/scheduled_class.css">
    </head>
    <body>
        <%@include file="body.jsp" %>    
        <div class="container">
            <div class="col-lg-4 col-md-4">

                <div class="row alert alert-success">
                    <h4>
                        <%= Labels.get("scheduled.class.sidebar.teacher")%>
                    </h4>
                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                        <figure class="figure">
                            <img src="<%= teacher.image_url%>" class="img-responsive img-fluid figure-img img-rounded"/>
                            <figcaption class="figure-caption text-center">
                                <%= teacher.display_name%>
                            </figcaption>
                        </figure>
                    </div>
                </div>
                <div class="alert alert-info row">
                    Student
                </div>
            </div>

            <div class="col-lg-8 col-md-8">
                <div id="scheduled_class_main_board">
                    <table>
                        <tr ><h2 class="text-center">&nbsp;</h2></tr>
                        <tr ><h2 class="text-center">&nbsp;</h2></tr>
                        <tr>                            
                        <h2 class="text-center" id="scheduled_class_main_board_title">
                            <%= Labels.get("scheduled.class.title")%>
                            <%= scheduledClass.subject%>
                        </h2>
                        </tr>
                        <tr>
                        <h2 class="text-center" id="scheduled_class_main_board_starting_in">
                            <%= Labels.get("scheduled.class.starting_in")%>  
                            <span id="scheduled_class_main_board_starting_in_value"></span>
                        </h2>
                        </tr>                        
                    </table>
                </div>
            </div>
        </div>
        <%@include file="footer.jsp" %>    
    </body>

</html>
