<%@page import="com.onlineclasses.entities.AvailableTime"%>
<%@page import="java.util.List"%>
<%@page import="com.onlineclasses.entities.Teacher"%>
<%@page import="com.onlineclasses.db.DB"%>
<%@page import="com.onlineclasses.web.Utils"%>
<%@page import="com.onlineclasses.web.CConfig"%>
<%@page import="com.onlineclasses.web.Config"%>
<%@page import="com.onlineclasses.web.Labels"%>

<%
    int minPrice = Utils.parseInt(request.getParameter("price_min"), CConfig.getInt("find_teachers.price.min"));
    int maxPrice = Utils.parseInt(request.getParameter("price_max"), CConfig.getInt("find_teachers.price.max"));
    String displayName = Utils.nonNullString(request.getParameter("display_name"));
    int availableDay = Utils.parseInt(request.getParameter("available_day"), 0);

    List<Teacher> teachers = DB.findTeachers(minPrice, maxPrice, displayName);
    for (Teacher teacher : teachers) {
        teacher.available_time = DB.getTeacherAvailableTime(teacher);
        Utils.info("teacher " + teacher.display_name + " avail " + teacher.available_time.size());
    }
    List<String> dayNamesLong = Utils.toList(CLabels.get("website.days.long"));
    List<String> dayNamesShort = Utils.toList(CLabels.get("website.days.short"));
%>

<!DOCTYPE html>
<html lang="<%= Config.get("website.html_language")%>">
    <head>
        <%@include file="header.jsp" %>
    </head>
    <body>
        <%@include file="body.jsp" %>   
        <div class="container">

            <div id="schedule_class_not_logged_in_modal" class="modal fade" role="dialog">
                <div class="modal-dialog modal-md">

                    <!-- Modal content-->
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" aria-label="close" data-dismiss="modal">
                                <span aria-hidden="true">&times;</span>
                            </button>

                            <div class="modal-title"> 
                                <h4 class="text-warning">
                                    <span class="glyphicon glyphicon-alert"></span>
                                    <span  id="schedule_class_not_logged_in_title">
                                        <%= Labels.get("website.schedule_class.not_logged_in.title")%>                        
                                    </span>
                                </h4>
                            </div>
                        </div>
                        <div class="modal-body">
                            <h4>
                                <%= Labels.get("website.schedule_class.not_logged_in.text1")%>
                            </h4>
                            <h4>
                                <a href='javascript:schedule_class_login()'>
                                    <%= Labels.get("website.schedule_class.not_logged_in.login")%>
                                </a>
                                <%= Labels.get("website.schedule_class.not_logged_in.text2")%>
                                <a href="start_learning">
                                    <%= Labels.get("website.schedule_class.not_logged_in.start_learning")%>
                                </a>
                                <%= Labels.get("website.schedule_class.not_logged_in.text3")%>
                            </h4>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-success" data-dismiss="modal"><%= Labels.get("buttons.ok")%></button>
                        </div>

                    </div>

                </div>
            </div>
            <div id="schedule_class_modal" class="modal fade" role="dialog">
                <div class="modal-dialog modal-md">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" aria-label="close" data-dismiss="modal">
                                <span aria-hidden="true">&times;</span>
                            </button>
                            <h4 id="schedule_class_modal_title" class="modal-title">
                                <%= Labels.get("schedule.class.modal.title")%>
                                <span id="schedule_class_modal_title_teacher_anchor"></span>
                            </h4>
                        </div>
                        <div class="modal-body">                            
                            <form>
                                <div class="container-fluid">
                                    <div class="col-md-10 col-md-offset-1">
                                        <div class="form-group row">
                                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                <label for="start_day_input" class="col-form-label">
                                                    <%= Labels.get("schedule.class.modal.day")%>
                                                </label>
                                            </div>
                                            <div class="col-lg-8 col-md-8 col-sm-8 col-xs-8">
                                                <input type="text" class="form-control" name="start_day_input" 
                                                       id="start_day_input" 
                                                       placeholder="<%= Labels.get("schedule.class.modal.day_placeholder")%>">
                                            </div>                                    
                                        </div>
                                        <div class="form-group row">
                                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                <label for="schedule_class_start_minute"  class="col-form-label">
                                                    <%= Labels.get("schedule.class.modal.start_hour")%>
                                                </label>
                                            </div>

                                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                <button class="btn btn-primary dropdown-toggle form-control" 
                                                        id="schedule_class_start_minute"
                                                        name="schedule_class_start_minute"
                                                        data-toggle="dropdown">
                                                    <span class="caret"></span>
                                                    <%= Labels.get("schedule.class.modal.start_minute_choose")%>
                                                </button>
                                                <ul class="dropdown-menu dropdown-menu-right">
                                                    <%
                                                        int minute = 0;
                                                        int minuteStep = Config.getInt("website.time.unit.minutes");
                                                        while (minute < 60) {
                                                    %>
                                                    <li>
                                                        <a href="javascript:schedule_class_select_minute('<%= String.format("%02d", minute)%>')">
                                                            <%= String.format("%02d", minute)%>
                                                        </a>
                                                    </li>
                                                    <%
                                                            minute += minuteStep;
                                                        }
                                                    %>
                                                </ul>
                                            </div>                                        
                                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                <button class="btn btn-primary dropdown-toggle form-control" 
                                                        id="schedule_class_start_hour"
                                                        name="schedule_class_start_hour" data-toggle="dropdown">
                                                    <span class="caret"></span>
                                                    <%= Labels.get("schedule.class.modal.start_hour_choose")%>
                                                </button>
                                                <ul class="dropdown-menu dropdown-menu-right">
                                                    <%
                                                        int startHour = Config.getInt("website.time.start_working_hour");
                                                        int endHour = Config.getInt("website.time.end_working_hour");
                                                        int hour = startHour;
                                                        while (hour < endHour) {
                                                    %>
                                                    <li>
                                                        <a href="javascript:schedule_class_select_hour('<%= String.format("%02d", hour)%>')">
                                                            <%= String.format("%02d", hour)%> 
                                                        </a>
                                                    </li>
                                                    <%
                                                            ++hour;
                                                        }
                                                    %>
                                                </ul>
                                            </div>
                                        </div>
                                        <div class="form-group row">
                                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                <label for="schedule_class_duration_input" class="col-form-label">
                                                    <%= Labels.get("schedule.class.modal.duration")%>
                                                </label>
                                            </div>
                                            <div class="col-lg-8 col-md-8 col-sm-8 col-xs-8">
                                                <button class="btn btn-primary dropdown-toggle form-control" 
                                                        id="schedule_class_duration_input"
                                                        name="schedule_class_duration_input" data-toggle="dropdown">
                                                    <span class="caret"></span>
                                                    <%= Labels.get("schedule.class.modal.duration.select")%>
                                                </button>
                                                <ul class="dropdown-menu dropdown-menu-right">
                                                    <%
                                                        int maximumLessonLength = Config.getInt("website.time.max_lesson_length_minutes");
                                                        int lessonLength = minuteStep;
                                                        while (lessonLength <= maximumLessonLength) {
                                                    %>
                                                    <li>
                                                        <a href="javascript:schedule_class_select_duration('<%= String.format("%02d", lessonLength)%>')">
                                                            <%= String.format("%02d", lessonLength) + " " + Labels.get("language.minutes")%> 
                                                        </a>
                                                    </li>
                                                    <%
                                                            lessonLength += minuteStep;
                                                        }
                                                    %>
                                                </ul>
                                            </div>                                 
                                        </div>                                
                                    </div>
                                </div>
                            </form>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-success" onclick="schedule_class_confirm()" data-dismiss="modal"><%= Labels.get("schedule.class.modal.confirm_button")%></button>
                                <button type="button" class="btn btn-default" data-dismiss="modal"><%= Labels.get("buttons.cancel")%></button>
                            </div>
                        </div>

                    </div>
                </div>
            </div>

            <div class="container">

                <div class="well col-md-4 container">

                    <h4 class="text-info">                        
                        <%= Labels.get("find_teachers.sidebar.title")%>                                
                    </h4>
                    <form>
                        <div class="form-group">
                            <label for="find_teachers_price_per_hour_slider">
                                <%= Labels.get("find_teachers.sidebar.price_per_hour")%> :
                            </label>                        
                            <span dir="LTR">
                                <span id="find_teachers_price_per_hour_value_min">
                                    <%= minPrice%>                                
                                </span>
                                <%= CLabels.get("website.currency")%>                                
                                &nbsp;-&nbsp;
                                <span id="find_teachers_price_per_hour_value_max">                                
                                    <%= maxPrice%>                                
                                </span>
                                <%= CLabels.get("website.currency")%>
                            </span>

                            <div id="find_teachers_price_per_hour_slider"></div>
                        </div>
                        <div class="form-group">
                            <label for="find_teachers_display_name_input" >
                                <%= Labels.get("find_teachers.sidebar.name.text")%>           
                            </label>

                            <input type="text" class="form-control" id="find_teachers_display_name_input" 
                                   placeholder="<%= Labels.get("find_teachers.sidebar.name.text")%>" 
                                   value="<%= displayName%>">
                        </div>
                        <div class="form-group">
                            <label for="find_teachers_available_in_days">
                                <%= Labels.get("find_teachers.sidebar.available_in_days")%>           
                            </label>
                            <select class="form-control" id="find_teachers_available_in_days">
                                <option value="0" <% if (availableDay == 0) { %> selected <% }%>>
                                    <%= Labels.get("find_teachers.sidebar.all_days")%>  
                                </option>
                                <%
                                    for (int i = 0; i < dayNamesLong.size(); i++) {
                                %>
                                <option value="<%= i + 1%>" <% if (availableDay == (i + 1)) { %> selected <% }%>>
                                    <%=dayNamesLong.get(i)%>
                                </option>
                                <%
                                    }
                                %>
                            </select>
                        </div>

                        <div class="form-group">
                            <button type="button" class="btn btn-primary col-1" 
                                    id="find_teachers.sidebar.refresh_button"
                                    onclick="find_teachers_refresh_results()" >
                                <span class="glyphicon glyphicon-refresh"></span>
                                &nbsp;
                                <%= Labels.get("find_teachers.sidebar.update_button.text")%>
                            </button>    

                            <button type="button" class="btn btn-info col-1" 
                                    id="find_teachers.sidebar.clear_button">
                                <span class="glyphicon glyphicon-refresh"></span>
                                &nbsp;
                                <%= Labels.get("find_teachers.sidebar.clear_button.text")%>
                            </button>

                        </div>
                    </form>
                </div>

                <div class="col-md-8 container">
                    <h3>
                        <%= Labels.get("find_teachers.list.title")%>
                    </h3>

                    <div>
                        <table class="table table-striped table-responsive table-borderless table-hover table-sm">
                            <thead>
                            <th style="width: 20%">
                                <%= Labels.get("find_teachers.list.header.teacher_name")%>
                            </th>
                            <th style="width: 60%">
                                <%= Labels.get("find_teachers.list.header.teacher_details")%>
                            </th>
                            <th style="width: 20%">
                                <%= Labels.get("find_teachers.list.header.price_and_actions")%>
                            </th>
                            </thead>
                            <tbody>
                                <%
                                    for (Teacher teacher : teachers) {
                                %>
                                <tr>
                                    <td>
                                        <figure class="figure">
                                            <img src="<%= teacher.image_url%>" class="img-responsive img-fluid figure-img img-rounded"/>
                                            <figcaption class="figure-caption text-center">
                                                <%= teacher.display_name%>
                                            </figcaption>
                                        </figure>
                                    </td>
                                    <td>
                                        <cite>
                                            <%= teacher.moto%>
                                        </cite>

                                        <p>
                                            <a class="info" data-toggle="collapse" href="#find_teacher_details_teacher_<%= teacher.id%>" 
                                               role="button" aria-expanded="false" aria-controls="find_teacher_details_teacher_<%= teacher.id%>">
                                                <%= Labels.get("find_teachers.list.body.show_more_details")%>
                                            </a>
                                        </p>
                                        <div class="well collapse" id="find_teacher_details_teacher_<%= teacher.id%>">
                                            <h5 class="text-info">
                                                <%= Labels.get("find_teachers.list.body.available_hours")%>
                                            </h5>
                                            <%
                                                for (AvailableTime availableTime : teacher.available_time) {
                                            %>

                                            <%= dayNamesLong.get(availableTime.day - 1)%>
                                            <span style="direction: ltr; unicode-bidi: bidi-override;">                                        
                                                <%= String.format("%02d:%02d", availableTime.start_hour, availableTime.start_minute)%>                                    
                                                &nbsp;-&nbsp;
                                                <%= String.format("%02d:%02d", availableTime.end_hour, availableTime.end_minute)%>                                    
                                            </span>
                                            <br/>

                                            <%
                                                }
                                            %>  

                                        </div>

                                    </td>
                                    <td>
                                        <h5 class="text-info">
                                            <%= Labels.get("find_teachers.list.body.price_per_hour")%>
                                            &nbsp;:&nbsp;
                                            <%= teacher.price_per_hour%>
                                            <%= CLabels.get("website.currency")%>
                                        </h5>
                                        <button id="schedule_class_button_<%= teacher.id%>" data-teacher-id="<%= teacher.id%>" 
                                                data-teacher-display-name="<%= teacher.display_name%>" onclick="schedule_class_button_clicked()" class="btn btn-primary">
                                            <%= Labels.get("find_teachers.list.body.schedule_class_button")%>
                                        </button>
                                    </td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <%@include file="footer.jsp" %>    
    </body>

</html>
