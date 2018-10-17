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
    int defaultMinPrice = CConfig.getInt("website.price_per_hour.min");
    int minPrice = Utils.parseInt(request.getParameter("price_min"), defaultMinPrice);
    int defaultMaxPrice = CConfig.getInt("website.price_per_hour.max");
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
            teacher.institute_name = teacher.institute.name;
        }
        if (teacher.subject != null) {
            teacher.subject = DB.get(teacher.subject.id, Subject.class);
            teacher.subject_name = teacher.subject.name;
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

        <div id="schedule_class_modal" class="modal fade" role="dialog">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header bg-secondary text-white">
                        <div id="schedule_class_modal_title" class="modal-title">
                            <span class="oi" data-glyph="calendar"></span>
                            <%= Labels.get("oclass.modal.title")%>
                            <span id="schedule_class_modal_title_teacher_anchor"></span>
                        </div>
                        <span class="oi close_button" data-dismiss="modal" data-glyph="x"></span>
                    </div>
                    <div class="modal-body">
                        <div class="row no-gutters">
                            <div class="px-1 col-12 col-sm-12 col-md-12 col-lg-5 col-xl-5">
                                <form id="schedule_class_form">
                                    <div class="form-group row">
                                        <div class="col-3 my-1">
                                            <label for="start_schedule_class_day_input" class="col-form-label">
                                                <%= Labels.get("oclass.modal.day")%>
                                            </label>
                                        </div>
                                        <div class="col-9 my-1">
                                            <input type="text" class="form-control" name="start_day_input" 
                                                   id="start_schedule_class_day_input" 
                                                   placeholder="<%= Labels.get("oclass.modal.day_placeholder")%>">
                                        </div>                                    
                                        <div class="col-3 my-1">
                                            <label for="schedule_class_start_minute_select"  class="col-form-label">
                                                <%= Labels.get("oclass.modal.start_hour")%>
                                            </label>
                                        </div>
                                        <div class="row no-gutters col-9">
                                            <div class="input-group my-1 mx-0">
                                                <select class="custom-select form-control" id="schedule_class_start_minute_select">
                                                    <option value="-1">
                                                        <%= Labels.get("oclass.modal.start_minute.choose")%>
                                                    </option>
                                                    <%
                                                        int minute = 0;
                                                        int minuteStep = CConfig.getInt("website.time.unit.minutes");
                                                        while (minute < 60) {
                                                    %>
                                                    <option value="<%= minute%>">
                                                        <%= String.format("%02d", minute)%>
                                                    </option>                                                        
                                                    <%
                                                            minute += minuteStep;
                                                        }
                                                    %>
                                                </select>

                                                <select class="custom-select form-control" id="schedule_class_start_hour_select">
                                                    <option value="-1">
                                                        <%= Labels.get("oclass.modal.start_hour.choose")%>
                                                    </option>
                                                    <%
                                                        hour = startHour;
                                                        while (hour < endHour) {
                                                    %>
                                                    <option id="schedule_class_start_hour_option_<%= hour%>" class="schedule_class_start_hour_option" value="<%= hour%>">
                                                        <%= String.format("%02d", hour)%>
                                                    </option>                                                            
                                                    <%
                                                            ++hour;
                                                        }
                                                    %>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="col-3 my-1">
                                            <label for="schedule_class_duration_input" class="col-form-label">
                                                <%= Labels.get("oclass.modal.duration")%>
                                            </label>
                                        </div>    

                                        <div class="col-9 my-1">
                                            <select class="custom-select form-control" 
                                                    id="find_teachers_duration_select">
                                                <option id="find_teachers_duration_option_choose" value="0" selected disabled>
                                                    <%= Labels.get("oclass.modal.duration.choose")%>
                                                </option>
                                                <%
                                                    int maximumLessonLength = CConfig.getInt("website.time.max_class_length_minutes");
                                                    int lessonLength = minuteStep;
                                                    while (lessonLength <= maximumLessonLength) {
                                                        String lessonMinutes = String.format("%02d", lessonLength) + " " + CLabels.get("language.minutes");
                                                %>
                                                <option id="find_teachers_duration_option_<%= lessonLength%>" value="<%= lessonLength%>">
                                                    <%= lessonMinutes%>
                                                </option>

                                                <%
                                                        lessonLength += minuteStep;
                                                    }
                                                %>   
                                            </select>
                                        </div>                                 

                                        <div class="col-3 my-1">
                                            <label for="start_schedule_class_subject_input">
                                                <%= Labels.get("oclass.modal.subject")%>
                                            </label>
                                        </div>

                                        <div class="col-9 my-1">
                                            <input type="text" class="form-control" name="start_schedule_class_subject_input" 
                                                   id="start_schedule_class_subject_input" 
                                                   placeholder="<%= Labels.get("oclass.modal.subject_placeholder")%>">
                                        </div>                                    

                                        <div class="col-3 my-1">
                                            <label for="start_schedule_class_student_comment_input">
                                                <%= Labels.get("oclass.modal.student_comment")%>
                                            </label>
                                        </div>
                                        <div class="col-9 my-1">
                                            <textarea rows="5" class="form-control" name="start_schedule_class_student_comment_input" 
                                                      id="start_schedule_class_student_comment_input" 
                                                      placeholder="<%= Labels.get("oclass.modal.student_comment_placeholder")%>"></textarea>
                                        </div>   
                                        <div class="col-3 my-1">
                                            <label for="start_schedule_class_price_input">
                                                <%= Labels.get("oclass.modal.class_price")%>
                                            </label>
                                        </div>
                                        <div class="col-9 my-1">
                                            <div class="input-group">
                                                <input type="text" class="form-control" 
                                                       id="start_schedule_class_price_input"
                                                       name="start_schedule_class_price_input"
                                                       value="" disabled/>
                                                <div class="input-group-prepend">
                                                    <span class="input-group-text">
                                                        <%= CLabels.get("website.currency")%>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </form>
                            </div>
                            <div class="px-1 col-12 col-sm-12 col-md-12 col-lg-7 col-xl-7 schedule_class_calendar_div">
                                <div class="column-centered text-center">
                                    <nav id="schedule_class_week_select" aria-label="Page navigation">
                                        <ul class="pagination justify-content-center">
                                            <li id="schedule_class_previous_week_li" class="page-item">
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
                                <div>
                                    <table id="schedule_class_calendar_table" class="d-table table table-responsive table-sm">
                                        <thead>
                                            <tr>
                                                <th class="schedule_class_calendar" style="width: 12.5%">
                                                </th>                                        
                                                <% for (day = 0; day < 7; day++) {

                                                %>                                        
                                                <th class="schedule_class_calendar"  style="width: 12.5%">
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
                                            <tr class="schedule_class_hour_row schedule_class_hour_row_<%= hour%>">
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

                                    <div id="schedule_class_table_legend" class="table-responsive text-center">                                            
                                        <table class="table table-sm table-borderless">
                                            <tr >
                                                <td style="width:25%" class="px-2 calendar_booked">
                                                    <%= Labels.get("oclass.legend.booked")%>
                                                </td>
                                                <td style="width:25%" class="px-2 calendar_selected">
                                                    <%= Labels.get("oclass.legend.selected")%>
                                                </td>  
                                                <td style="width:25%" class="px-2 calendar_busy">
                                                    <%= Labels.get("oclass.legend.busy")%>
                                                </td>                                                
                                                <td style="width:25%" class="px-2 calendar_available">
                                                    <%= Labels.get("oclass.legend.available")%>
                                                </td>                                                
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div id="schedule_class_warning_div" class="alert alert-warning d-none fade show alert-dismissible h6">
                            <span class="oi" data-glyph="warning"></span>    
                            <span id="schedule_class_warning"></span>
                        </div>
                        <div id="schedule_class_info_div" class="alert alert-info d-none fade show alert-dismissible h6">
                            <span class="oi" data-glyph="info"></span>    
                            <span id="schedule_class_info"></span>
                        </div>    
                    </div>
                    <div class="modal-footer mx-0">
                        <div class="d-flex flex-row-reverse mx-0">
                            <button type="button" class="btn btn-info" data-dismiss="modal"><%= Labels.get("buttons.cancel")%></button>
                            <button id="schedule_class_confirm_button" type="button" class="btn btn-success mx-1">
                                <%= Labels.get("oclass.modal.confirm_button")%>
                            </button>
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
                    <div class="card-header">
                        <h5>
                            <u>
                                <%= Labels.get("find_teachers.list.displaying")%>
                                <%= teachers.size()%>
                                <%= Labels.get("find_teachers.list.private_teachers")%>
                            </u>
                        </h5>

                        <%
                            if (Utils.isNotEmpty(topicName)) {
                        %>
                        <h6>                                
                            <%= Labels.get("find_teachers.list.with_topic_name")%>
                            &nbsp;:
                            <%= topicName%>
                            &nbsp;
                            <a href="javascript:find_teachers_clear_topic_name()" class="text-warning">
                                <small>(&nbsp;<%= Labels.get("find_teachers.list.remove")%>&nbsp;<span class="oi" data-glyph="x"></span>)</small>
                            </a>
                        </h6>
                        <%
                            }
                        %>

                        <%
                            if ((minPrice != defaultMinPrice) || (maxPrice != defaultMaxPrice)) {
                        %>
                        <h6>                                
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
                            &nbsp;
                            <a href="javascript:find_teachers_clear_price()" class="text-warning">
                                <small>(&nbsp;<%= Labels.get("find_teachers.list.remove")%>&nbsp;<span class="oi" data-glyph="x"></span>)</small>
                            </a>
                        </h6>
                        <%
                            }
                        %>

                        <%
                            if (Utils.isNotEmpty(displayName)) {
                        %>
                        <h6>                                
                            <%= Labels.get("find_teachers.list.with_display_name")%>
                            &nbsp;:
                            <%= displayName%>
                            &nbsp;
                            <a href="javascript:find_teachers_clear_display_name()" class="text-warning">
                                <small>(&nbsp;<%= Labels.get("find_teachers.list.remove")%>&nbsp;<span class="oi" data-glyph="x"></span>)</small>
                            </a>
                        </h6>
                        <%
                            }
                        %>

                    </div>
                    <div class="card-body">


                        <%
                            for (Teacher teacher : teachers) {
                        %>            

                        <div class="card my-1">
                            <div class="card-body">
                                <div class="row no-gutters">      
                                    <div class="col-3 col-xl-2 px-1 mx-0 my-0 text-center">
                                        <img src="<%= teacher.image_url%>" class="w-100 mx-auto border border-info img-responsive rounded mx-1 my-1"/>
                                        <h6>
                                            <a href="teacher_homepage?id=<%= teacher.id%>">
                                                <%= teacher.display_name%>
                                            </a>
                                        </h6>
                                        <h6>
                                            <div class="d-inline-block" style="position:relative; cursor:default"
                                                 title="<%= Labels.get("find_teachers.list.body.rating_prefix")%>&nbsp;<%= teacher.rating%>&nbsp;<%= Labels.get("find_teachers.list.body.rating_suffix")%>">
                                                <div class="bg-white"
                                                     style="opacity: 0.8; position:absolute; height:100%; width:<%= (int) (100 - (teacher.rating * 20))%>%">
                                                </div>
                                                <div class="d-inline-block text-primary">
                                                    <span class="oi" data-glyph="star"></span>
                                                    <span class="oi" data-glyph="star"></span>
                                                    <span class="oi" data-glyph="star"></span>
                                                    <span class="oi" data-glyph="star"></span>
                                                    <span class="oi" data-glyph="star"></span>
                                                </div>
                                            </div>
                                        </h6>
                                        <h6>
                                            <button id="schedule_class_button_<%= teacher.id%>" data-teacher-id="<%= teacher.id%>" 
                                                    data-teacher-display-name="<%= teacher.display_name%>" 
                                                    class="schedule_class_button btn btn-sm btn-outline-primary rounded btn-block">
                                                <%= Labels.get("find_teachers.list.body.schedule_class_button")%>
                                            </button>
                                        </h6>
                                    </div>

                                    <div class="media-body col-9 col-xl-10 mx-0 px-1">
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
                                                    if ((teacher.show_degree)
                                                            && (!Utils.isEmpty(teacher.institute_name))
                                                            && (!Utils.isEmpty(teacher.subject_name))
                                                            && (!Utils.isEmpty(teacher.degree_type))) {
                                                %>
                                                <h6>                                                    
                                                    <%= Labels.get("find_teachers.has_degree")%>
                                                    <%= teacher.degree_type%>                                                    
                                                    <%= Labels.get("find_teachers.degree_from")%><%= teacher.institute_name%>
                                                    <%= Labels.get("find_teachers.degree_subject")%><%= teacher.subject_name%>
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
                                                <div class="col-12 col-md-6 h6 text-info">
                                                    <%= Labels.get("find_teachers.list.body.price_per_hour")%>
                                                    &nbsp;:&nbsp;
                                                    <%= teacher.price_per_hour%>
                                                    <%= CLabels.get("website.currency")%>
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
        </script>
    </body>

</html>
