<%@page import="com.onlineclasses.entities.Institute"%>
<%@page import="com.onlineclasses.entities.City"%>
<%@page import="com.onlineclasses.entities.Subject"%>
<%@page import="java.util.Collection"%>
<%@page import="com.onlineclasses.entities.Topic"%>
<%@page import="com.onlineclasses.entities.TeachingTopic"%>
<%@page import="com.onlineclasses.servlets.BaseServlet"%>
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
    int defaultMinPrice = CConfig.getInt("find_teachers.price.min");
    int minPrice = Utils.parseInt(request.getParameter("price_min"), defaultMinPrice);
    int defaultMaxPrice = CConfig.getInt("find_teachers.price.max");
    int maxPrice = Utils.parseInt(request.getParameter("price_max"), defaultMaxPrice);
    String displayName = Utils.nonNullString(request.getParameter("display_name"));
    String topicName = Utils.nonNullString(request.getParameter("topic_name"));
    int availableDay = Utils.parseInt(request.getParameter("available_day"), 0);
    final int startHour = CConfig.getInt("website.time.start_working_hour");
    final int endHour = CConfig.getInt("website.time.end_working_hour");
    int hour, day;
    int minutesPerRow = CConfig.getInt("website.time.calendar_minutes_per_row");
    int minutesPerUnit = CConfig.getInt("website.time.unit.minutes");
    int rowsPerCell = minutesPerRow / minutesPerUnit;

    Utils.debug("user " + BaseServlet.getUser(request) + " find teachers");

    Map<Integer, Subject> allSubjects = DB.getAllMap(Subject.class);
    Map<Integer, Topic> allTopics = DB.getAllMap(Topic.class);

    List<Teacher> teachers = DB.findTeachers(minPrice, maxPrice, displayName, topicName);

    for (Teacher teacher : teachers) {
        teacher.available_time = DB.getTeacherAvailableTime(teacher);
        teacher.teaching_topics = DB.getTeacherTeachingTopics(teacher);
        if (teacher.city != null) {
            teacher.city = DB.get(teacher.city.id, City.class);
        }
        if (teacher.institute != null) {
            teacher.institute = DB.get(teacher.institute.id, Institute.class);
        }
        if (teacher.subject != null) {
            teacher.subject = DB.get(teacher.subject.id, Subject.class);
        }
    }
    List<String> dayNamesLong = Utils.toList(CLabels.get("website.days.long"));
    List<String> dayNamesShort = Utils.toList(CLabels.get("website.days.short"));
%>

<!DOCTYPE html>
<html lang="<%= Config.get("website.html_language")%>" dir="<%= Config.get("webiste.direction")%>">
    <head>
        <%@include file="header.jsp" %>
        <title>
            <%= Labels.get("find_teachers.title")%>
        </title>
        <link rel="stylesheet" href="css/find_teachers.css">
    </head>
    <body lang="<%= Config.get("website.html_language")%>" dir="<%= Config.get("webiste.direction")%>">
        <%@include file="body.jsp" %>   

        <div id="schedule_class_not_logged_in_modal" class="modal fade" role="dialog">
            <div class="modal-dialog modal-md">
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

        <div id="schedule_class_modal" class="modal fade" role="dialog">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header bg-secondary text-white">
                        <div id="schedule_class_modal_title" class="modal-title">
                            <span class="oi" data-glyph="calendar"></span>
                            <%= Labels.get("scheduled.class.modal.title")%>
                            <span id="schedule_class_modal_title_teacher_anchor"></span>
                        </div>
                        <span class="oi close_button" data-dismiss="modal" data-glyph="x"></span>
                    </div>
                    <div class="modal-body">
                        <div class="row no-gutters">
                            <div class="col-12 col-sm-12 col-md-12 col-lg-5 col-xl-5">
                                <form>
                                    <div class="form-group row">
                                        <div class="col-3 my-1">
                                            <label for="start_schedule_class_day_input" class="col-form-label">
                                                <%= Labels.get("scheduled.class.modal.day")%>
                                            </label>
                                        </div>
                                        <div class="col-9 my-1">
                                            <input type="text" class="form-control" name="start_day_input" 
                                                   id="start_schedule_class_day_input" 
                                                   placeholder="<%= Labels.get("scheduled.class.modal.day_placeholder")%>">
                                        </div>                                    

                                        <div class="col-3 my-1">
                                            <label for="schedule_class_start_minute"  class="col-form-label">
                                                <%= Labels.get("scheduled.class.modal.start_hour")%>
                                            </label>
                                        </div>
                                        <div class="row no-gutters col-9">
                                            <div class="input-group my-1 mx-0">

                                                <div class="dropdown col-6 mx-0 px-0 pl-1">
                                                    <button class="btn btn-info btn-block dropdown-toggle" 
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

                                                <div class="dropdown col-6 mx-0 px-0">
                                                    <button class="btn btn-info btn-block dropdown-toggle" 
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
                                        </div>

                                        <div class="col-3 my-1">
                                            <label for="schedule_class_duration_input" class="col-form-label">
                                                <%= Labels.get("scheduled.class.modal.duration")%>
                                            </label>
                                        </div>    

                                        <div class="col-9 my-1">
                                            <button class="btn btn-info btn-block dropdown-toggle" 
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

                                        <div class="col-3 my-1">
                                            <label for="start_schedule_class_subject_input">
                                                <%= Labels.get("scheduled.class.modal.subject")%>
                                            </label>
                                        </div>

                                        <div class="col-9 my-1">
                                            <input type="text" class="form-control" name="start_schedule_class_subject_input" 
                                                   id="start_schedule_class_subject_input" 
                                                   placeholder="<%= Labels.get("scheduled.class.modal.subject_placeholder")%>">
                                        </div>                                    

                                        <div class="col-3 my-1">
                                            <label for="start_schedule_class_student_comment_input">
                                                <%= Labels.get("scheduled.class.modal.student_comment")%>
                                            </label>
                                        </div>
                                        <div class="col-9 my-1">
                                            <textarea rows="5" class="form-control" name="start_schedule_class_student_comment_input" 
                                                      id="start_schedule_class_student_comment_input" 
                                                      placeholder="<%= Labels.get("scheduled.class.modal.student_comment_placeholder")%>"></textarea>
                                        </div>                                    
                                    </div>
                                </form>
                            </div>
                            <div class="col-12 col-sm-12 col-md-12 col-lg-7 col-xl-7 schedule_class_calendar_div">
                                <div class="column-centered text-center">
                                    <nav id="schedule_class_week_select" aria-label="Page navigation">
                                        <ul class="pagination justify-content-center">
                                            <li class="page-item">
                                                <a  class="page-link" href="javascript:schedule_class_previous_week()" aria-label="Previous">
                                                    <span aria-hidden="true">&laquo;</span>
                                                </a>
                                            </li>
                                            <li class="page-item">                                                    
                                                <a class="page-link" href="#">
                                                    <span id="schedule_class_current_week_start_day">
                                                        <%= dayNamesLong.get(0)%>
                                                    </span>
                                                    &nbsp;
                                                    <span class="left_to_right" id="schedule_class_current_week_start"></span>
                                                    -
                                                    <span id="schedule_class_current_week_end_day">
                                                        <%= dayNamesLong.get(6)%>
                                                    </span>
                                                    &nbsp;
                                                    <span class="left_to_right" id="schedule_class_current_week_end"></span></a>
                                            </li>
                                            <li class="page-item">
                                                <a class="page-link" href="javascript:schedule_class_next_week()" aria-label="Next">
                                                    <span aria-hidden="true">&raquo;</span>
                                                </a>
                                            </li>
                                        </ul>
                                    </nav>
                                </div>
                                <div class="row no-gutters">
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
                                                        onclick="schedule_class_select_time(this)"
                                                        class="schedule_class_calendar_time schedule_class_calendar <%= cellClass%>" id="schedule_class_day_<%= (day + 1)%>_hour_<%= hour%>_minute_<%= minute%>">                                                        
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
                            <span class="oi" data-glyph="warning"></span>    
                            <span id="schedule_class_warning"></span>
                            &nbsp;
                            <a class="alert-link d-none" id="schedule_class_warning_a"></a>
                            &nbsp;
                            <a class="alert-link d-none" id="schedule_class_warning_a_not_logged_in"
                               href="javascript:schedule_class_login_clicked()"></a>
                        </div>
                        <div id="schedule_class_info_div" class="alert alert-info d-none fade show alert-dismissible h6">
                            <span class="oi" data-glyph="info"></span>    
                            <span id="schedule_class_info"></span>
                        </div>
                        <div class="modal-footer">                            
                            <button type="button" class="btn btn-info" data-dismiss="modal"><%= Labels.get("buttons.cancel")%></button>
                            <button type="button" class="btn btn-success mx-1" onclick="schedule_class_confirm()"><%= Labels.get("scheduled.class.modal.confirm_button")%></button>
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

                        <form id="find_teachers_form">                        
                            <div class="form-group">
                                <div class="my-2">
                                    <label for="find_teachers_topic_name_input" >
                                        <%= Labels.get("find_teachers.sidebar.topic.text")%>           
                                    </label>
                                </div>
                                <div class="my-2">
                                    <input type="text" class="form-control" id="find_teachers_topic_name_input" 
                                           name="find_teachers_topic_name_input"
                                           placeholder="<%= Labels.get("find_teachers.sidebar.topic.placeholder")%>" 
                                           value="<%= topicName%>">
                                </div>
                                <div class="my-2">
                                    <label for="find_teachers_price_per_hour_slider">
                                        <%= Labels.get("find_teachers.sidebar.price_per_hour")%> :

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
                                    </label> 
                                </div>
                                <div class="my-2">
                                    <div class="mx-2" id="find_teachers_price_per_hour_slider"></div>
                                </div>
                                <div class="my-2">
                                    <label for="find_teachers_display_name_input" >
                                        <%= Labels.get("find_teachers.sidebar.name.text")%>           
                                    </label>
                                </div>
                                <div class="my-2">
                                    <input type="text" class="form-control" id="find_teachers_display_name_input" 
                                           name="find_teachers_display_name_input"
                                           placeholder="<%= Labels.get("find_teachers.sidebar.name.text")%>" 
                                           value="<%= displayName%>">
                                </div>
                                <div class="my-2">
                                    <label class="d-none" for="find_teachers_available_in_days">
                                        <%= Labels.get("find_teachers.sidebar.available_in_days")%>           
                                    </label>
                                </div>
                                <div class="my-2">
                                    <select class="form-control d-none" id="find_teachers_available_in_days">
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

                                <div class="row no-gutters my-3">
                                    <div class="col ml-1">
                                        <button type="button" class="btn btn-primary btn-block" 
                                                id="find_teachers.sidebar.refresh_button"
                                                onclick="find_teachers_refresh_results()">
                                            <span>
                                                <%= Labels.get("find_teachers.sidebar.update_button.text")%>
                                            </span>
                                        </button>    
                                    </div>
                                    <div class="col mr-1">

                                        <button type="button" class="btn btn-info btn-block" 
                                                id="find_teachers.sidebar.clear_button"
                                                onclick="find_teachers_reset_results()">
                                            <span >
                                                <%= Labels.get("find_teachers.sidebar.clear_button.text")%>
                                            </span>
                                        </button>     
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="card text-dark bg-white col-xl-9 col-lg-9">
                    <div class="card-body">
                        <div class="card-header">
                            <h5>
                                <u>
                                <%= Labels.get("find_teachers.list.title")%>
                                </u>
                            </h5>
                            <%
                                if ((minPrice != defaultMinPrice) || (maxPrice != defaultMaxPrice)) {
                            %>
                            <h5>
                                <%= Labels.get("find_teachers.list.with_price_range")%>
                                <span class="left_to_right">                                        
                                    <%= minPrice%>
                                    <%= CLabels.get("website.currency")%>
                                </span>
                                &nbsp;-&nbsp;
                                <span class="left_to_right">                                        
                                    <%= maxPrice%>
                                    <%= CLabels.get("website.currency")%>
                                </span>
                            </h5>
                            <%
                                }
                            %>
                        </div>



                        <%
                            for (Teacher teacher : teachers) {
                        %>
                        <div class="card my-2">
                            <div class="card-body">
                                <div class="row no-gutters">      
                                    <div class="media">
                                        <div class="mx-0 my-0 text-center">
                                            <img src="<%= teacher.image_url%>" class="w-100 mx-auto border border-info img-responsive rounded mx-1 my-1"/>
                                            <h6>
                                                <%= teacher.display_name%>
                                            </h6>

                                            <h6 class="text-secondary">
                                                <%= Labels.get("find_teachers.list.body.price_per_hour")%>
                                                &nbsp;:&nbsp;
                                                <%= teacher.price_per_hour%>
                                                <%= CLabels.get("website.currency")%>
                                            </h6>                                            

                                            <button id="schedule_class_button_<%= teacher.id%>" data-teacher-id="<%= teacher.id%>" 
                                                    data-teacher-display-name="<%= teacher.display_name%>" 
                                                    onclick="schedule_class_button_clicked()" class="btn btn-sm btn-outline-primary rounded btn-block">
                                                <%= Labels.get("find_teachers.list.body.schedule_class_button")%>
                                            </button>
                                        </div>

                                        <div class="media-body mx-3">
                                            <div class="card">                                            
                                                <div class="card-header h5">
                                                    <cite>
                                                        "<%= teacher.moto%>"
                                                    </cite>
                                                </div>                                                
                                            </div>
                                            <div class="card-body">
                                                <div id="find_teacher_personal_details">
                                                    <h6>
                                                        <%
                                                            if (teacher.isMale()) {
                                                        %>

                                                        <%= Labels.get("find_teachers.age_prefix.male")%>
                                                        <%= Utils.yearsFromDate(teacher.day_of_birth)%>
                                                        <%= Labels.get("find_teachers.age_suffix.male")%>

                                                        <% } else {%>

                                                        <%= Labels.get("find_teachers.age_prefix.female")%>
                                                        <%= Utils.yearsFromDate(teacher.day_of_birth)%>
                                                        <%= Labels.get("find_teachers.age_suffix.female")%>

                                                        <%
                                                            }
                                                        %>
                                                        <%
                                                            if (teacher.city != null) {
                                                        %>
                                                        &nbsp;,&nbsp;<%= teacher.city.name%>
                                                        <%
                                                            }
                                                        %>
                                                    </h6>
                                                    <%
                                                        if (teacher.show_degree) {
                                                    %>
                                                    <h6>
                                                        <%= Labels.get("find_teachers.has_degree")%>
                                                        <%= teacher.degree_type%>
                                                        <%= Labels.get("find_teachers.degree_from")%><%= teacher.institute.name%>
                                                        <%= Labels.get("find_teachers.degree_subject")%><%= teacher.subject.name%>
                                                        <%
                                                            }
                                                        %>
                                                    </h6>
                                                </div>
                                                <p>
                                                    <a class="text-secondary" data-toggle="collapse" href="#find_teacher_details_teacher_<%= teacher.id%>" 
                                                       role="button" aria-expanded="false" aria-controls="find_teacher_details_teacher_<%= teacher.id%>">
                                                        <%= Labels.get("find_teachers.list.body.show_more_details")%>
                                                    </a>
                                                </p>                                        
                                                <div class="card text-white bg-secondary collapse" id="find_teacher_details_teacher_<%= teacher.id%>" >
                                                    <div class="card-body">
                                                        <div class="row no-gutters">                                                    
                                                            <div class="col-12 xol-xl-6 col-lg-6">
                                                                <h6>
                                                                    <%= Labels.get("find_teachers.list.body.available_hours")%>                                                    
                                                                </h6>
                                                                <small>
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
                                                                </small>   
                                                            </div>
                                                            <div class="col-12 xol-xl-6 col-lg-6">
                                                                <h6>
                                                                    <%= Labels.get("find_teachers.list.body.teaching_topics")%>                                                    
                                                                </h6>
                                                                <small>
                                                                    <%
                                                                        for (Topic teachingTopic : teacher.teaching_topics) {
                                                                    %>

                                                                    <%= teachingTopic.name%>                                                            
                                                                    <br/>
                                                                    <%
                                                                        }
                                                                    %>  
                                                                </small>   
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="card-footer">
                                                <div class="row no-gutters">                                               
                                                    <%
                                                        if (teacher.show_phone) {
                                                    %>
                                                    <div class="col-12 col-md-6 h6 text-secondary">
                                                        <span class="oi" data-glyph="phone"></span>
                                                        <span class="d-none">    
                                                            <%= Labels.get("find_teachers.list.body.phone")%>
                                                        </span>
                                                        <a href="tel://<%= teacher.phone_area%>-<%= teacher.phone_number%>">
                                                            <%= teacher.phone_area%>-<%= teacher.phone_number%>
                                                        </a>

                                                    </div>   
                                                    <%
                                                        }
                                                    %>

                                                    <%
                                                        if (teacher.show_email) {
                                                    %>
                                                    <div class="col-12 col-md-6 h6 text-secondary">
                                                        <span class="oi" data-glyph="envelope-closed"></span>
                                                        <span class="d-none">    
                                                            <%= Labels.get("find_teachers.list.body.email")%>                                            
                                                        </span>
                                                        <a href="mailto:<%= teacher.email%>">
                                                            <%= teacher.email%>
                                                        </a>
                                                    </div>   
                                                    <%
                                                        }
                                                    %>

                                                    <%
                                                        if (teacher.show_skype) {
                                                    %>
                                                    <div class="col-12 col-md-6 h6 text-secondary">
                                                        <%= Labels.get("find_teachers.list.body.skype")%>                                            
                                                        <a href="skype:<%= teacher.skype_name%>">
                                                            <%= teacher.skype_name%>
                                                        </a>
                                                    </div>   
                                                    <%
                                                        }
                                                    %>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <%
                            }
                        %>
                    </div>
                </div>
            </div>
        </div>

        <%@include file="footer.jsp" %>    
        <script>
            find_teachers.all_subjects = <%= Utils.gson().toJson(allSubjects)%>;
            find_teachers.all_topics = <%= Utils.gson().toJson(allTopics)%>;
            find_teachers_init();
        </script>
    </body>

</html>
