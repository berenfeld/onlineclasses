<%@page import="com.onlineclasses.entities.Student"%>
<%@page import="com.onlineclasses.utils.Utils"%>
<%@page import="com.onlineclasses.entities.Teacher"%>
<%@page import="com.onlineclasses.db.DB"%>
<%@page import="com.onlineclasses.entities.ScheduledClass"%>
<%@page import="com.onlineclasses.utils.Config"%>
<%@page import="com.onlineclasses.utils.Labels"%>

<%
    int classId = Integer.parseInt(request.getParameter("id"));
    ScheduledClass scheduledClass = DB.getScheduledClass(classId);
    Teacher teacher = scheduledClass.teacher;
    Student student = scheduledClass.student;
    // TODO handle not found
%>

<!DOCTYPE html>
<html lang="<%= Config.get("website.html_language") %>" dir="<%= Config.get("webiste.direction") %>">
    <head>
        <%@include file="header.jsp" %>
        <link rel="stylesheet" href="css/scheduled_class.css">
    </head>
    <body lang="<%= Config.get("website.html_language") %>" dir="<%= Config.get("webiste.direction") %>">
        <%@include file="body.jsp" %>    
        <div class="container">            
            <div class="row no-gutter">
                <div class="col-xl-4 col-lg-4">                        
                    <div class="card text-white bg-secondary my-2">
                        <div class="card-body">
                            <h5 class="card-title">                    
                                <%= Labels.get("scheduled.class.sidebar.teacher")%>
                            </h5>
                            <div class="row no-gutter">
                                <div class="col-4">
                                    <figure class="figure">
                                        <img src="<%= teacher.image_url%>" class="img-responsive figure-img rounded"/>
                                        <figcaption class="figure-caption text-center">
                                            <%= teacher.display_name%>
                                        </figcaption>
                                    </figure>
                                </div>
                                <div class="col-8">
                                    <h6>
                                        <%= Labels.get("scheduled.class.sidebar.duration_text")%>&nbsp;
                                        <%= scheduledClass.duration_minutes%>&nbsp;
                                        <%= CLabels.get("language.minutes")%>
                                    </h6>
                                    <h6>
                                        <%= Labels.get("scheduled.class.sidebar.price_text")%>&nbsp;
                                        <%= scheduledClass.price_per_hour * scheduledClass.duration_minutes / Utils.MINUTES_IN_HOUR%>&nbsp;
                                        <%= CLabels.get("website.currency")%>
                                    </h6>
                                </div>
                            </div>
                            <div>
                                <button class="btn btn-info">
                                    <%= Labels.get("scheduled.class.sidebar.update_price")%>
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="card text-white bg-secondary my-2">
                        <div class="card-body">
                            <h5 class="card-title">     
                                <%= Labels.get("scheduled.class.sidebar.student")%>
                            </h5>
                            <div class="row">
                                <div class="col-4">
                                    <figure class="figure">
                                        <img src="<%= student.image_url%>" class="img-responsive figure-img rounded"/>
                                        <figcaption class="figure-caption text-center">
                                            <%= student.display_name%>
                                        </figcaption>
                                    </figure>
                                </div>
                                <div class="col-8">
                                    <h6>
                                        <%= Labels.get("scheduled.class.sidebar.student_comment")%>&nbsp;
                                        <%= scheduledClass.student_comment%>
                                    </h6>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-8 col-lg-8">
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
