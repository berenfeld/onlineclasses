<%@page import="java.util.Calendar"%>
<%@page import="com.onlineclasses.entities.AvailableTime"%>
<%@page import="java.util.List"%>
<%@page import="com.onlineclasses.entities.Teacher"%>
<%@page import="com.onlineclasses.db.DB"%>
<%@page import="com.onlineclasses.utils.Utils"%>
<%@page import="com.onlineclasses.utils.CConfig"%>
<%@page import="com.onlineclasses.utils.Config"%>
<%@page import="com.onlineclasses.utils.Labels"%>

<%
    int minPrice = Utils.parseInt(request.getParameter("price_min"), CConfig.getInt("find_teachers.price.min"));
    int maxPrice = Utils.parseInt(request.getParameter("price_max"), CConfig.getInt("find_teachers.price.max"));
    String displayName = Utils.nonNullString(request.getParameter("display_name"));
    int availableDay = Utils.parseInt(request.getParameter("available_day"), 0);
    final int startHour = CConfig.getInt("website.time.start_working_hour");
    final int endHour = CConfig.getInt("website.time.end_working_hour");
    int hour, day;
    int minutesPerRow = CConfig.getInt("website.time.calendar_minutes_per_row");
    int minutesPerUnit = CConfig.getInt("website.time.unit.minutes");
    int rowsPerCell = minutesPerRow / minutesPerUnit;

    Utils.info("user " + ServletBase.getUser(request) + " find teachers");

    List<Teacher> teachers = DB.findTeachers(minPrice, maxPrice, displayName);
    for (Teacher teacher : teachers) {
        teacher.available_time = DB.getTeacherAvailableTime(teacher);
        Utils.info("teacher " + teacher.display_name + " avail " + teacher.available_time.size());
    }
    List<String> dayNamesLong = Utils.toList(CLabels.get("website.days.long"));
    List<String> dayNamesShort = Utils.toList(CLabels.get("website.days.short"));
%>

<!DOCTYPE html>
<html lang="<%= Config.get("website.html_language")%>" dir="<%= Config.get("webiste.direction")%>">
    <head>
        <%@include file="header.jsp" %>
        <link rel="stylesheet" href="css/find_teachers.css">
    </head>
    <body lang="<%= Config.get("website.html_language")%>" dir="<%= Config.get("webiste.direction")%>">
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
                                <h5 class="text-warning">
                                    <span  id="schedule_class_not_logged_in_title">
                                        <%= Labels.get("website.schedule_class.not_logged_in.title")%>                        
                                    </span>
                                </h5>
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
        </div>
        <div class="container">
            <div id="schedule_class_modal" class="modal fade" role="dialog">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">

                            <h5 id="schedule_class_modal_title" class="modal-title">
                                <%= Labels.get("scheduled.class.modal.title")%>
                                <span id="schedule_class_modal_title_teacher_anchor"></span>
                            </h5>
                        </div>
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-12 col-sm-12 col-md-12 col-lg-5">
                                    <form class="form-horizontal">

                                        <div class="form-group form-row">
                                            <div class="col-3">
                                                <label for="start_schedule_class_day_input" class="col-form-label">
                                                    <%= Labels.get("scheduled.class.modal.day")%>
                                                </label>
                                            </div>
                                            <div class="col-9">
                                                <input type="text" class="form-control" name="start_day_input" 
                                                       id="start_schedule_class_day_input" 
                                                       placeholder="<%= Labels.get("scheduled.class.modal.day_placeholder")%>">
                                            </div>                                    
                                        </div>
                                        <div class="form-group form-row">
                                            <div class="col-3">
                                                <label for="schedule_class_start_minute"  class="col-form-label">
                                                    <%= Labels.get("scheduled.class.modal.start_hour")%>
                                                </label>
                                            </div>

                                            <div class="col-4">
                                                <button class="btn btn-info dropdown-toggle" 
                                                        id="schedule_class_start_minute_button"
                                                        name="schedule_class_start_minute"
                                                        data-toggle="dropdown">
                                                    <span class="caret"></span>
                                                    <span id="schedule_class_start_minute">
                                                        <%= Labels.get("scheduled.class.modal.start_minute_choose")%>
                                                    </span>
                                                </button>
                                                <div class="dropdown-menu dropdown-menu-right">
                                                    <%
                                                        int minute = 0;
                                                        int minuteStep = CConfig.getInt("website.time.unit.minutes");
                                                        while (minute < 60) {
                                                    %>
                                                    <li>
                                                        <a class="dropdown-item" href="javascript:schedule_class_select_minute('<%= String.format("%02d", minute)%>')">
                                                            <%= String.format("%02d", minute)%>
                                                        </a>
                                                    </li>
                                                    <%
                                                            minute += minuteStep;
                                                        }
                                                    %>
                                                </div>
                                            </div>                                        
                                            <div class="col-4">
                                                <button class="btn btn-info dropdown-toggle" 
                                                        id="schedule_class_start_hour_button"
                                                        name="schedule_class_start_hour_button" data-toggle="dropdown">
                                                    <span class="caret"></span>
                                                    <span id="schedule_class_start_hour">
                                                        <%= Labels.get("scheduled.class.modal.start_hour_choose")%>
                                                    </span>
                                                </button>
                                                <div class="dropdown-menu dropdown-menu-right">
                                                    <%
                                                        hour = startHour;
                                                        while (hour < endHour) {
                                                    %>
                                                    <li>
                                                        <a class="dropdown-item" href="javascript:schedule_class_select_hour('<%= String.format("%02d", hour)%>')">
                                                            <%= String.format("%02d", hour)%> 
                                                        </a>
                                                    </li>
                                                    <%
                                                            ++hour;
                                                        }
                                                    %>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group form-row">
                                            <div class="col-3">
                                                <label for="schedule_class_duration_input" class="col-form-label">
                                                    <%= Labels.get("scheduled.class.modal.duration")%>
                                                </label>
                                            </div>                                                    
                                            <div class="col-9">
                                                <button class="btn btn-info dropdown-toggle" 
                                                        id="schedule_class_duration_input"
                                                        name="schedule_class_duration_input" data-toggle="dropdown">
                                                    <span class="caret"></span>
                                                    <span id="schedule_class_duration">
                                                        <%= Labels.get("scheduled.class.modal.duration.select")%>
                                                    </span>
                                                </button>
                                                <div class="dropdown-menu dropdown-menu-right">
                                                    <%
                                                        int maximumLessonLength = CConfig.getInt("website.time.max_lesson_length_minutes");
                                                        int lessonLength = minuteStep;
                                                        while (lessonLength <= maximumLessonLength) {
                                                            String lessonMinutes = String.format("%02d", lessonLength) + " " + CLabels.get("language.minutes");
                                                    %>
                                                    <li>
                                                        <a class="dropdown-item" href="javascript:schedule_class_select_duration('<%= lessonMinutes%>')">
                                                            <%= lessonMinutes%> 
                                                        </a>
                                                    </li>
                                                    <%
                                                            lessonLength += minuteStep;
                                                        }
                                                    %>
                                                </div>
                                            </div>                                 
                                        </div>

                                        <div class="form-group form-row">
                                            <div class="col-3">
                                                <label for="start_schedule_class_subject_input">
                                                    <%= Labels.get("scheduled.class.modal.subject")%>
                                                </label>
                                            </div>
                                            <div class="col-9">
                                                <input type="text" class="form-control" name="start_schedule_class_subject_input" 
                                                       id="start_schedule_class_subject_input" 
                                                       placeholder="<%= Labels.get("scheduled.class.modal.subject_placeholder")%>">
                                            </div>                                    
                                        </div>

                                        <div class="form-group form-row">
                                            <div class="col-lg-3">
                                                <label for="start_schedule_class_student_comment_input">
                                                    <%= Labels.get("scheduled.class.modal.student_comment")%>
                                                </label>
                                            </div>
                                            <div class="col-lg-9">
                                                <textarea rows="5" class="form-control" name="start_schedule_class_student_comment_input" 
                                                          id="start_schedule_class_student_comment_input" 
                                                          placeholder="<%= Labels.get("scheduled.class.modal.student_comment_placeholder")%>"></textarea>
                                            </div>                                    
                                        </div>
                                    </form>
                                </div>
                                <div class="col-12 col-sm-12 col-md-12 col-lg-7 schedule_class_calendar_div">

                                    <div class="column-centered text-center">
                                        <nav id="schedule_class_week_select" aria-label="Page navigation">
                                            <ul class="pagination justify-content-center">
                                                <li class="page-item">
                                                    <a  class="page-link" href="javascript:schedule_class_previous_week()" aria-label="Previous">
                                                        <span aria-hidden="true">&laquo;</span>
                                                    </a>
                                                </li>
                                                <li class="page-item">                                                    
                                                    <a class="page-link left_to_right" href="#">
                                                        <span id="schedule_class_current_week_start"></span>
                                                        -
                                                        <span id="schedule_class_current_week_end"></span></a>
                                                </li>
                                                <li class="page-item">
                                                    <a class="page-link" href="javascript:schedule_class_next_week()" aria-label="Next">
                                                        <span aria-hidden="true">&raquo;</span>
                                                    </a>
                                                </li>
                                            </ul>
                                        </nav>
                                    </div>
                                    <div class="row no-gutter">
                                        <div class="mx-auto">
                                            <table id="schedule_class_calendar_table" class="table table-responsive table-sm">
                                                <thead>
                                                    <tr>
                                                        <th class="schedule_class_calendar" style="width: 12%">
                                                        </th>                                        
                                                        <% for (day = 0; day < 7; day++) {

                                                        %>                                        
                                                        <th class="schedule_class_calendar"  style="width: 12%">
                                                            <span><%= dayNamesShort.get(day)%></span>
                                                            <br/>
                                                            <span id="schedule_class_day_<%= (day + 1)%>"></span>
                                                        </th>
                                                        <% }%>
                                                    <tr/>
                                                </thead>
                                                <tbody>
                                                    <%
                                                        hour = startHour;
                                                        minute = 0;
                                                        int rowCount = 0;
                                                        String cellClass = "";
                                                        while (hour < endHour) {
                                                    %>  
                                                    <tr>
                                                        <%
                                                            if (rowCount == (rowsPerCell - 1)) {
                                                                cellClass = "schedule_class_row_end";
                                                            } else {
                                                                cellClass = "schedule_class_row_middle";
                                                            }
                                                            if (rowCount == 0) {
                                                                cellClass = "schedule_class_row_start";
                                                        %>
                                                        <td rowspan="<%= rowsPerCell%>" class="schedule_class_calendar">
                                                            <%= Utils.formatTime(hour, 0)%>
                                                        </td>
                                                        <% } %>

                                                        <% for (day = 0; day < 7; day++) {
                                                        %>
                                                        <td data-day="<%=day%>" data-hour="<%= hour%>" data-minute="<%= minute%>"
                                                            onclick="javascript:schedule_class_select_time(this)"
                                                            class="schedule_class_calendar <%= cellClass%>" id="schedule_class_day_<%= (day + 1)%>_hour_<%= hour%>_minute_<%= minute%>">
                                                        </td>                                            
                                                        <% } %>                                                                                                
                                                    </tr>
                                                    <%
                                                            rowCount = (rowCount + 1) % rowsPerCell;
                                                            minute += minutesPerUnit;
                                                            if (minute == 60) {
                                                                minute = 0;
                                                                hour++;
                                                            }
                                                        }
                                                    %>
                                                </tbody>
                                            </table> 
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div id="schedule_class_warning_div" class="alert alert-warning d-none fade show alert-dismissible h6">
                                <span id="schedule_class_warning"></span>
                                &nbsp;
                                <a class="alert-link d-none" id="schedule_class_warning_a"></a>
                                &nbsp;
                                <a class="alert-link d-none" id="schedule_class_warning_a_not_logged_in"
                                   href="javascript:schedule_class_login_clicked()"></a>
                            </div>
                            <div id="schedule_class_info_div" class="alert alert-info d-none fade show alert-dismissible h6">
                                <span id="schedule_class_info"></span>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-success mx-1" onclick="schedule_class_confirm()"><%= Labels.get("scheduled.class.modal.confirm_button")%></button>
                                <button type="button" class="btn btn-info mx-1" data-dismiss="modal"><%= Labels.get("buttons.cancel")%></button>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>

        <div class="container">
            <div class="row no-gutters my-1">
                <div class="card text-white bg-secondary col-xl-3 col-lg-3">
                    <div class="card-body">
                        <h6 class="card-title">                        
                            <%= Labels.get("find_teachers.sidebar.title")%>                                
                        </h6>

                        <form>                        
                            <div class="form-group">
                                <label for="find_teachers_price_per_hour_slider">
                                    <%= Labels.get("find_teachers.sidebar.price_per_hour")%> :
                                </label>                        
                                <span dir="ltr">
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
                                        <option value="0" <% if (availableDay
                                                    == 0) { %> selected <% }%>>
                                        <%= Labels.get("find_teachers.sidebar.all_days")%>  
                                    </option>
                                    <%
                                        for (int i = 0;
                                                i < dayNamesLong.size();
                                                i++) {

                                    %>
                                    <option value="<%= i + 1%>" <% if (availableDay == (i + 1)) { %> selected <% }%>>
                                        <%=dayNamesLong.get(i)%>
                                    </option>
                                    <%
                                        }
                                    %>
                                </select>
                            </div>

                            <div class="form-group form-row">                                
                                <button type="button" class="btn btn-primary mx-1 col" 
                                        id="find_teachers.sidebar.refresh_button"
                                        onclick="find_teachers_refresh_results()" >                         
                                    <span>
                                        <%= Labels.get("find_teachers.sidebar.update_button.text")%>
                                    </span>
                                </button>    

                                <button type="button" class="btn btn-info mx-1 col" 
                                        id="find_teachers.sidebar.clear_button">
                                    <span >
                                        <%= Labels.get("find_teachers.sidebar.clear_button.text")%>
                                    </span>
                                </button>                            
                            </div>
                        </form>
                    </div>
                </div>

                <div class="card text-dark bg-white col-xl-9 col-lg-9">
                    <div class="card-body">
                        <h6 class="card-header">
                            <%= Labels.get("find_teachers.list.title")%>
                        </h6>

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
                                            <img src="<%= teacher.image_url%>" class="img-fluid figure-img rounded"/>
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
                                            <a class="text-secondary" data-toggle="collapse" href="#find_teacher_details_teacher_<%= teacher.id%>" 
                                               role="button" aria-expanded="false" aria-controls="find_teacher_details_teacher_<%= teacher.id%>">
                                                <%= Labels.get("find_teachers.list.body.show_more_details")%>
                                            </a>
                                        </p>
                                        <div class="card text-white bg-secondary collapse" id="find_teacher_details_teacher_<%= teacher.id%>">
                                            <div class="card-body">
                                                <div class="card-title">
                                                    <%= Labels.get("find_teachers.list.body.available_hours")%>
                                                </div>
                                                <%
                                                    for (AvailableTime availableTime : teacher.available_time) {
                                                %>


                                                <%= dayNamesLong.get(availableTime.day - 1)%>
                                                <span class="left_to_right">                                        
                                                    <%= String.format("%02d:%02d", availableTime.start_hour, availableTime.start_minute)%>                                    
                                                    &nbsp;-&nbsp;
                                                    <%= String.format("%02d:%02d", availableTime.end_hour, availableTime.end_minute)%>                                    
                                                </span>
                                                <br/>
                                                <%
                                                    }
                                                %>  
                                            </div>
                                        </div>

                                    </td>
                                    <td>
                                        <h6 class="text-secondary">
                                            <%= Labels.get("find_teachers.list.body.price_per_hour")%>
                                            &nbsp;:&nbsp;
                                            <%= teacher.price_per_hour%>
                                            <%= CLabels.get("website.currency")%>
                                        </h6>                                            
                                        <button id="schedule_class_button_<%= teacher.id%>" data-teacher-id="<%= teacher.id%>" 
                                                data-teacher-display-name="<%= teacher.display_name%>" 
                                                onclick="schedule_class_button_clicked()" class="btn btn-success">
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
        </div>
        <%@include file="footer.jsp" %>    
    </body>

</html>
