<%@page import="com.onlineclasses.entities.Student"%>
<%@page import="com.onlineclasses.web.Utils"%>
<%@page import="com.onlineclasses.entities.Teacher"%>
<%@page import="com.onlineclasses.db.DB"%>
<%@page import="com.onlineclasses.entities.ScheduledClass"%>
<%@page import="com.onlineclasses.web.Config"%>
<%@page import="com.onlineclasses.web.Labels"%>

<%
    int classId = Integer.parseInt(request.getParameter("id"));
    ScheduledClass scheduledClass = DB.getScheduledClass(classId);
    Teacher teacher = scheduledClass.teacher;
    Student student = scheduledClass.student;
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
                    <div class="col-lg-8 col-md-8 col-sm-8 col-xs-8">
                        <h5>
                            <%= Labels.get("scheduled.class.sidebar.duration_text")%>&nbsp;
                            <%= scheduledClass.duration_minutes%>&nbsp;
                            <%= CLabels.get("language.minutes")%>
                        </h5>
                        <h5>
                            <%= Labels.get("scheduled.class.sidebar.price_text")%>&nbsp;
                            <%= scheduledClass.price_per_hour * scheduledClass.duration_minutes / Utils.MINUTES_IN_HOUR%>&nbsp;
                            <%= CLabels.get("website.currency")%>
                        </h5>
                    </div>
                </div>
                <div class="alert alert-info row">
                    <h4>
                        <%= Labels.get("scheduled.class.sidebar.student")%>
                    </h4>
                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                        <figure class="figure">
                            <img src="<%= student.image_url%>" class="img-responsive img-fluid figure-img img-rounded"/>
                            <figcaption class="figure-caption text-center">
                                <%= student.display_name%>
                            </figcaption>
                        </figure>
                    </div>
                    <div class="col-lg-8 col-md-8 col-sm-8 col-xs-8">
                        <h5>
                            <%= Labels.get("scheduled.class.sidebar.student_comment")%>&nbsp;
                            <%= scheduledClass.student_comment %>
                        </h5>
                    </div>
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
        <script>
            scheduled_class.scheduled_class = <%= Utils.gson().toJson(scheduledClass)%>;
            scheduled_class.teacher = <%= Utils.gson().toJson(teacher)%>;
            scheduled_class.student = <%= Utils.gson().toJson(student)%>;
            scheduled_class_init();
        </script>
    </body>

</html>
