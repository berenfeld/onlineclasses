<%@page import="com.onlineclasses.entities.City"%>
<%@page import="com.onlineclasses.entities.AvailableTime"%>
<%@page import="com.onlineclasses.entities.TeachingTopic"%>
<%@page import="com.onlineclasses.entities.Teacher"%>
<%@page import="com.onlineclasses.entities.Topic"%>
<%@page import="java.io.File"%>
<%@page import="com.onlineclasses.entities.Subject"%>
<%@page import="com.onlineclasses.entities.Institute"%>
<%@page import="com.onlineclasses.entities.InstituteType"%>
<%@page import="com.onlineclasses.db.DB"%>
<%@page import="java.util.List"%>
<%@page import="com.onlineclasses.utils.Utils"%>
<%@page import="com.onlineclasses.utils.Labels"%>
<%@page import="com.onlineclasses.utils.CLabels"%>

<%
    Teacher teacher = (Teacher) BaseServlet.getUser(request);
    if (teacher == null) {
        Utils.warning("teacher not found");
        response.sendRedirect("/");
        return;
    }
    List<City> cities = DB.getAll(City.class);
    Map<Integer, Topic> allTopics = DB.getAllMap(Topic.class);
    
    if (teacher.institute != null) {
        teacher.institute = DB.get(teacher.institute.id, Institute.class);
        if (teacher.institute.institute_type != null) {
            teacher.institute.institute_type = DB.get(teacher.institute.institute_type.id, InstituteType.class);    
        }
    }
    if (teacher.subject != null) {
        teacher.subject = DB.get(teacher.subject.id, Subject.class);
    }
    if (teacher.city != null) {
        teacher.city = DB.get(teacher.city.id, City.class);
    }

    List<Topic> teachingTopics = DB.getTeacherTeachingTopics(teacher);
    List<AvailableTime> availableTimes = DB.getTeacherAvailableTime(teacher);
    String phoneAreas = CLabels.get("website.phone_areas");
    List<String> phoneAreasList = Utils.toList(phoneAreas);
    List<InstituteType> instituteTypes = DB.getAll(InstituteType.class);
    Map<Integer, Map<Integer, String>> institutes = new HashMap<>();
    for (InstituteType instituteType : instituteTypes) {

        List<Institute> allInstitutes = DB.getInstitutes(instituteType);

        Map<Integer, String> instituteNames = new HashMap<>();
        for (Institute institute : allInstitutes) {
            instituteNames.put(institute.id, institute.name);
        }
        institutes.put(instituteType.id, instituteNames);
    }
    List<Subject> subjects = DB.getAll(Subject.class);
    String degreeTypesList = Labels.get("db.degree_type");
    List<String> degreeTypes = Utils.toList(degreeTypesList);
    Map<Integer, Subject> allSubjects = DB.getAllMap(Subject.class);

    List<String> dayNamesLong = Utils.toList(CLabels.get("website.days.long"));
    List<String> dayNamesShort = Utils.toList(CLabels.get("website.days.short"));
    final int startHour = CConfig.getInt("website.time.start_working_hour");
    final int endHour = CConfig.getInt("website.time.end_working_hour");
    int hour, day, minute;
    int minutesPerRow = CConfig.getInt("website.time.calendar_minutes_per_row");
    int minutesPerUnit = CConfig.getInt("website.time.unit.minutes");
    int rowsPerCell = minutesPerRow / minutesPerUnit;
    int minimumClassLengthMinutes = CConfig.getInt("website.time.min_lesson_length_minutes");
    int maximumClassLengthMinutes = CConfig.getInt("website.time.max_lesson_length_minutes");
%>
<!DOCTYPE html>
<html lang="<%= Config.get("website.html_language")%>" dir="<%= Config.get("webiste.direction")%>">
    <head>
        <%@include file="header.jsp" %>
        <title>
            <%= Labels.get("teacher_update.title")%>
        </title>
        <link rel="stylesheet" href="css/teacher_update.css">
    </head>
    <body lang="<%= Config.get("website.html_language")%>" dir="<%= Config.get("webiste.direction")%>">
        <%@include file="body.jsp" %>    

         <div class="container">
            <div class="row no-gutters my-1">
                <div class="col-12">


                    <div class="card my-1">
                        <div class="card-header text-secondary">
                            <h5>
                                <%= Labels.get("teacher_update.heading")%>
                            </h5>
                            <p>
                                <%= Labels.get("teacher_update.text1")%>       
                                <br/>
                                <%= Labels.get("teacher_update.text2")%>      
                                <br/>
                                <%= Labels.get("teacher_update.required_field_1")%>  
                                <small class="teacher_update_required teacher_update_required_filled">
                                    (*)
                                </small>
                                <%= Labels.get("teacher_update.required_field_2")%>  
                            </p>
                        </div>
                    </div>

                    <div>
                        <ul class="nav nav-tabs my-1" id="teacher_update_tab_list">     
                            <li class="nav-item">
                                <a  id="teacher_update_personal_information_link" class="nav-link active" data-toggle="tab" 
                                    href="#teacher_update_personal_information_tab">
                                    <%= Labels.get("teacher_update.tabs.personal_information")%>
                                </a>
                            </li>
                            <li class="nav-item">
                                <a  id="teacher_update_profile_link" class="nav-link" data-toggle="tab" 
                                    href="#teacher_update_profile_tab">
                                    <%= Labels.get("teacher_update.tabs.profile")%>
                                </a>
                            </li>
                            <li class="nav-item">
                                <a  id="teacher_update_education_link" class="nav-link" data-toggle="tab" 
                                    href="#teacher_update_education_tab">
                                    <%= Labels.get("teacher_update.tabs.education")%>
                                </a>
                            </li>
                            <li class="nav-item">
                                <a  id="teacher_update_teaching_topics_link" class="nav-link" data-toggle="tab" 
                                    href="#teacher_update_teaching_topics_tab">
                                    <%= Labels.get("teacher_update.tabs.teaching_topics")%>
                                </a>
                            </li>
                            <li class="nav-item">
                                <a  id="teacher_update_prices_link" class="nav-link" data-toggle="tab" 
                                    href="#teacher_update_prices_tab">
                                    <%= Labels.get("teacher_update.tabs.prices")%>
                                </a>
                            </li>
                            <li class="nav-item">
                                <a  id="teacher_update_teaching_hours_link" class="nav-link" data-toggle="tab" 
                                    href="#teacher_update_teaching_hours_tab">
                                    <%= Labels.get("teacher_update.tabs.teaching_hours")%>
                                </a>
                            </li>
                            <li class="nav-item">
                                <a  id="teacher_update_accept_and_finish_link" class="nav-link" data-toggle="tab" 
                                    href="#teacher_update_accept_and_finish_tab">
                                    <%= Labels.get("teacher_update.tabs.accept_and_finish")%>
                                </a>
                            </li>
                        </ul> 
                    </div>
                    <div class="tab-content" id="teacher_update_tabs">                        
                        <div class="card my-1 tab-pane fade show active" id="teacher_update_personal_information_tab" role="tabpanel" 
                             aria-labelledby="teacher_update_personal_information_link">
                            <div class="card-header bg-secondary text-white">                                   
                                <div class="card-title">
                                    <%= Labels.get("teacher_update.form.personal_information.text1")%>                                                                                     
                                </div>
                            </div>
                            <div class="card-body">
                                <div class="form-group row">
                                    <div class="col-12 col-sm-6 col-lg-3 my-1">                                    
                                        <label class="col-form-label" for="teacher_update_email_input">
                                            <%= Labels.get("teacher_update.form.login.email")%>  
                                            <small class="teacher_update_required teacher_update_required_filled">
                                                (*)
                                            </small>                                            
                                        </label>                     

                                    </div>

                                    <div class="col-12 col-sm-6 col-lg-3 my-1">
                                        <input type="email" class="form-control" id="teacher_update_email_input" 
                                               placeholder="<%= Labels.get("teacher_update.form.login.email")%>" disabled>
                                    </div>

                                    <div class="col-12 col-sm-6 col-lg-3 my-1">
                                        <label class="col-form-label" for="teacher_update_display_name_input">
                                            <%= Labels.get("teacher_update.form.login.display_name")%>
                                            <br/>
                                            <small>
                                                <%= Labels.get("teacher_update.form.login.display_name.small_text")%>
                                            </small>
                                        </label>
                                    </div>
                                    <div class="col-12 col-sm-6 col-lg-3 my-1">
                                        <input type="text" class="form-control" id="teacher_update_display_name_input" 
                                               placeholder="<%= Labels.get("teacher_update.form.login.display_name")%>" disabled>
                                    </div>

                                    <div class="col-12 col-sm-6 col-lg-3 my-1">
                                        <label class="col-form-label" for="teacher_update_first_name_input">
                                            <%= Labels.get("teacher_update.form.login.first_name")%>
                                        </label>
                                    </div>

                                    <div class="col-12 col-sm-6 col-lg-3 my-1">
                                        <input type="text" class="form-control" id="teacher_update_first_name_input"
                                               placeholder="<%= Labels.get("teacher_update.form.login.first_name")%>" disabled>
                                    </div>

                                    <div class="col-12 col-sm-6 col-lg-3 my-1">
                                        <label class="col-form-label" for="teacher_update_last_name_input">
                                            <%= Labels.get("teacher_update.form.login.last_name")%>
                                        </label>
                                    </div>

                                    <div class="col-12 col-sm-6 col-lg-3 my-1">
                                        <input type="text" class="form-control" id="teacher_update_last_name_input" 
                                               placeholder="<%= Labels.get("teacher_update.form.login.last_name")%>" disabled>
                                    </div>

                                    <div class="col-12 col-sm-6 col-lg-3 my-1">
                                        <label class="col-form-label" for="teacher_update_gender_input">
                                            <%= Labels.get("teacher_update.form.login.gender")%>   
                                        </label>
                                        <small class="teacher_update_required teacher_update_required_filled">
                                            (*)
                                        </small>
                                    </div>

                                    <div class="col-12 col-sm-6 col-lg-3 my-1">
                                        <div class="row form-check form-check-inline no-gutters">
                                            <input type="radio" checked class="mx-2 form-check form-check-inline" 
                                                   value="<%= CConfig.get("website.gender.male")%>" 
                                                   id="teacher_update_gender_input_male" name="teacher_update_gender_input">
                                            <label class="mx-2 col-form-label" for="teacher_update_gender_input_male">
                                                <%= Labels.get("teacher_update.form.login.gender.male")%>   
                                            </label>

                                            <input type="radio" class="mx-2 form-check form-check-inline" 
                                                   value="<%= CConfig.get("website.gender.female")%>" 
                                                   id="teacher_update_gender_input_female" name="teacher_update_gender_input">
                                            <label class="mx-2 col-form-label" for="teacher_update_gender_input_female">
                                                <%= Labels.get("teacher_update.form.login.gender.female")%>   
                                            </label>
                                        </div>
                                    </div>

                                    <div class="col-12 col-lg-6 my-0">
                                        <div class="row no-gutters" id="teacher_update_phone_number">   
                                            <div class="col-12 col-md my-1">
                                                <label class="col-form-label" for="teacher_update_phone_number_input">
                                                    <%= Labels.get("teacher_update.form.login.phone_number")%>
                                                    <small class="teacher_update_required teacher_update_required_filled">
                                                        (*)
                                                    </small>                                                    
                                                </label>                                                    
                                            </div>

                                            <div class="input-group form-control border-0 col-12 col-md">
                                                <input type="text" class="col-8 form-control mr-md-3 teacher_update_required teacher_update_required_filled" 
                                                       id="teacher_update_phone_number_input"                                                           
                                                       onkeypress="return isNumberKey(event)"
                                                       placeholder="<%= Labels.get("teacher_update.form.login.phone_number")%>">

                                                <select class="col-4 custom-select form-control teacher_update_required teacher_update_required_filled" 
                                                        id="teacher_update_phone_area_select">
                                                    <option value="" disabled selected>
                                                        <%= Labels.get("teacher_update.form.login.phone_area")%>
                                                    </option>
                                                    <%
                                                        for (String phoneArea : phoneAreasList) {
                                                    %>

                                                    <option value="<%= phoneArea%>">
                                                        <%= phoneArea%>
                                                    </option>

                                                    <%
                                                        }
                                                    %>
                                                </select>                                                    
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-6 col-lg-3 my-1" id="teacher_update_day_of_birth">
                                        <label class="col-form-label" for="teacher_update_day_of_birth_input">
                                            <%= Labels.get("teacher_update.form.login.day_of_birth")%>
                                            <small class="teacher_update_required teacher_update_required_filled">
                                            (*)
                                        </small>
                                            <br/>
                                            <small>
                                                <%= Labels.get("teacher_update.form.login.day_of_birth.small_text")%>
                                            </small>
                                        </label>
                                        
                                    </div>

                                    <div class="col-12 col-sm-6 col-lg-3 my-1">
                                        <input type="text" class="form-control" id="teacher_update_day_of_birth_input"
                                               name="teacher_update_day_of_birth_input" disabled
                                               placeholder="<%= Labels.get("teacher_update.form.login.day_of_birth")%>">
                                    </div>

                                    <div class="col-12 col-sm-6 col-lg-3 my-1">
                                        <label class="col-form-label" for="teacher_update_skype_name_input">
                                            <%= Labels.get("teacher_update.form.login.skype_name")%>
                                        </label>
                                    </div>

                                    <div class="col-12 col-sm-6 col-lg-3 my-1">
                                        <input type="text" class="form-control" id="teacher_update_skype_name_input"
                                               name="teacher_update_skype_name_input"
                                               placeholder="<%= Labels.get("teacher_update.form.login.skype_name")%>">
                                    </div>

                                    <div class="col-6 col-lg-3 my-1" id="teacher_update_city">
                                        <label class="col-form-label" for="teacher_update_city_input">
                                            <%= Labels.get("teacher_update.form.login.choose_city")%>                                        
                                        </label>
                                        <small class="teacher_update_required teacher_update_required_filled">
                                            (*)
                                        </small>
                                    </div>

                                    <div class="col-12 col-sm-6 col-lg-3 my-1">
                                        <select class="custom-select form-control teacher_update_required teacher_update_required_filled" id="teacher_update_city_select">
                                            <option value="0" disabled selected>
                                                <%= Labels.get("teacher_update.form.login.city")%>
                                            </option>
                                            <%
                                                for (City city : cities) {
                                            %>

                                            <option value="<%= city.id%>">
                                                <%= city.name%>
                                            </option>

                                            <%
                                                }
                                            %>
                                        </select>                                                    
                                    </div>

                                    <div class="col-12 col-sm-6 col-lg-3 my-1" id="teacher_update_image">
                                        <label class="col-form-label" for="teacher_update_image_input">
                                            <%= Labels.get("teacher_update.form.personal_information.choose_avatar_image")%>
                                            <small class="teacher_update_required teacher_update_required_filled">
                                                (*)
                                            </small>
                                            <br/>
                                            <small>
                                                <%= Labels.get("teacher_update.form.personal_information.avatar_image_small_text")%>
                                            </small>
                                        </label>

                                    </div>
                                    <iframe id="teacher_update_post_hidden_iframe" name="teacher_update_post_hidden_iframe" class="d-none"></iframe>                                                

                                    <div class="col-12 col-sm-6 col-lg-3 my-1" id="teacher_update_image">                                            
                                        <div class="row no-gutters">
                                            <div class="col-6 px-1">    
                                                <img src="<%= teacher.image_url %>" id="teacher_update_image_img" class="w-100"></img>                                                  

                                                <p id="teacher_update_image_loading" class="border rounded d-none text-center">
                                                    <%= Labels.get("teacher_update.form.personal_information.image_loading")%>
                                                </p>
                                            </div>

                                            <div class="col-6 px-1">    
                                                <form action="/servlets/teacher_image_upload" method="post" 
                                                      enctype="multipart/form-data"
                                                      id="teacher_update_image_upload_form"                                                      
                                                      target="teacher_update_post_hidden_iframe">
                                                    <input type="hidden" id="teacher_update_image_id" name="image_id">

                                                    <div id="teacher_update_img_upload_button_wrapper" class="w-100">                                                         
                                                        <input type="file" name="teacher_update_img_upload_input"
                                                               id="teacher_update_img_upload_input"
                                                               onchange="teacher_update_img_upload()">  
                                                        <button type="button" class="btn btn-success btn-block">
                                                            <%= Labels.get("teacher_update.form.personal_information.upload_from_file")%>
                                                        </button>

                                                    </div>
                                                    <button type="button" onclick="teacher_update_reset_img_upload()" class="btn btn-success btn-block d-none" id="teacher_update_img_upload_reset_image">
                                                        <%= Labels.get("teacher_update.form.personal_information.reset_to_social_image")%>
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div>
                            <div class="card-footer">
                                <div class="d-flex flex-row-reverse">
                                    <button type="button" class="btn btn-info teacher_update_tabs_button" 
                                            id="teacher_update_goto_tab_profile_button"
                                            onclick="teacher_update_goto_tab('profile')">
                                        <span class="oi" data-glyph="chevron-left"></span>
                                        <%= Labels.get("teacher_update.tabs.to")%><%= Labels.get("teacher_update.tabs.profile")%>
                                        <span class="oi" data-glyph="chevron-left"></span>                                            
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div class="card my-1 tab-pane fade" id="teacher_update_profile_tab" role="tabpanel" 
                             aria-labelledby="teacher_update_profile_link">
                            <div class="card-header text-white bg-secondary">
                                <div class="card-title">
                                    <%= Labels.get("teacher_update.form.publish.text1")%>   
                                </div>
                            </div>

                            <div class="card-body">                                
                                <div class="form-group row">
                                    <div class="col-12 col-sm-6 col-lg-3 my-1" id="teacher_update_moto">
                                        <label class="col-form-label" for="teacher_update_moto_input">
                                            <%= Labels.get("teacher_update.form.publish.moto_text")%>
                                        </label>  
                                        <small class="teacher_update_required teacher_update_required_filled">
                                            (*)
                                        </small>
                                        <br/>
                                        <small>
                                            <%= Labels.get("teacher_update.form.publish.moto.small_text")%>
                                        </small>
                                    </div>

                                    <div class="col-12 col-sm-6 col-lg-9 my-1">
                                        <textarea rows="4" class="form-control teacher_update_required teacher_update_required_filled" id="teacher_update_moto_input" 
                                                  name="teacher_update_moto_input"
                                                  placeholder="<%= Labels.get("teacher_update.form.publish.moto_placeholder")%>"></textarea>
                                    </div>

                                    <div class="col-12 my-1 d-inline form-control border rounded bg-light">
                                        <input class="form-check-input mx-0"  
                                               id="teacher_update_show_phone" 
                                               name="teacher_update_show_phone"
                                               type="checkbox" value="">
                                        <label class="form-check-label" for="teacher_update_show_phone">
                                            <%= Labels.get("teacher_update.form.publish.show_phone")%>
                                        </label>
                                    </div>

                                    <div class="col-12 my-1 d-inline form-control border rounded bg-light">
                                        <input class="form-check-input mx-0"  
                                               id="teacher_update_show_email" 
                                               name="teacher_update_show_email"
                                               type="checkbox" value="">
                                        <label class="form-check-label" for="teacher_update_show_email">
                                            <%= Labels.get("teacher_update.form.publish.show_email")%>
                                        </label>
                                    </div>

                                    <div class="col-12 my-1 d-inline form-control border rounded bg-light">
                                        <input class="form-check-input mx-0"  
                                               id="teacher_update_show_skype" 
                                               name="teacher_update_show_skype"
                                               type="checkbox" value="">
                                        <label class="form-check-label" for="teacher_update_show_skype">
                                            <%= Labels.get("teacher_update.form.publish.show_skype")%>
                                        </label>
                                    </div>

                                </div>
                            </div>

                            <div class="card-footer">
                                <div class="d-flex flex-row-reverse">
                                    <button type="button" class="btn btn-info teacher_update_tabs_button"
                                            id="teacher_update_goto_tab_education_button"
                                            onclick="teacher_update_goto_tab('education')">
                                        <span class="oi" data-glyph="chevron-left"></span>                                            
                                        <%= Labels.get("teacher_update.tabs.to")%><%= Labels.get("teacher_update.tabs.education")%>
                                        <span class="oi" data-glyph="chevron-left"></span>                                            
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div class="card my-1 tab-pane fade" id="teacher_update_education_tab" role="tabpanel" 
                             aria-labelledby="teacher_update_education_link">

                            <div class="card-header text-white bg-secondary">
                                <div class="card-title">
                                    <%= Labels.get("teacher_update.form.learning_information.text1")%>   
                                </div>
                            </div>

                            <div class="card-body">

                                <div class="form-group row">
                                    <div class="col-12 my-1 d-inline form-control border rounded bg-light">
                                        <input class="form-check-input mx-0"  
                                               id="teacher_update_show_degree" 
                                               name="teacher_update_show_degree"
                                               type="checkbox">
                                        <label class="form-check-label" data-toggle="collapse"  for="teacher_update_show_degree"
                                               data-target="#teacher_update_degree_information_div" 
                                               aria-expanded="false" aria-controls="teacher_update_degree_information_div">                                            
                                            <%= Labels.get("teacher_update.form.learning_information.show_degree")%>
                                        </label>

                                    </div>
                                </div>

                                <div class="collapse" id="teacher_update_degree_information_div">
                                    <div class="form-group row" aria-expanded="false" >

                                        <label class="col-12 col-sm-6 col-lg-3 my-1 col-form-label" for="teacher_update_degree_type_button">
                                            <%= Labels.get("teacher_update.form.learning.degree_type.title")%>
                                        </label>

                                        <div class="col-12 col-sm-6 col-lg-3 my-1">
                                            <select class="custom-select" id="teacher_update_degree_type_select">

                                                <%
                                                    for (String degreeType : degreeTypes) {
                                                %>

                                                <option value="<%= degreeType%>">
                                                    <%= degreeType%>
                                                </option>

                                                <%
                                                    }
                                                %>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group row">

                                        <label class="col-12 col-sm-6 col-lg-3 my-1 col-form-label" for="teacher_update_institute_type">
                                            <%= Labels.get("teacher_update.form.learning.education.title")%>
                                        </label>

                                        <div class="col-12 col-sm-6 col-lg-3 my-1">
                                            <select class="custom-select" id="teacher_update_institute_type_select">

                                                <option id="teacher_update_institute_type_choose" value="0" disabled selected>
                                                    <%= Labels.get("teacher_update.form.learning.institue_type.choose")%>
                                                </option>

                                                <%
                                                    for (InstituteType instituteType : instituteTypes) {
                                                %>

                                                <option value="<%= instituteType.id%>">
                                                    <%= instituteType.name%>
                                                </option>

                                                <%
                                                    }
                                                %>

                                                <option id="teacher_update_institute_type_other" value="0">
                                                    <%= Labels.get("teacher_update.form.learning.institue_type.other")%>
                                                </option>
                                            </select>
                                        </div>

                                        <%
                                            for (int instituteType : institutes.keySet()) {
                                                Map<Integer, String> institutesMap = institutes.get(instituteType);

                                        %>

                                        <label id="teacher_update_institute_<%= instituteType%>_label" class="col-6 col-lg-3 my-1 col-form-label d-none" 
                                               for="teacher_update_institute_<%= instituteType%>_select">
                                            <%= Labels.get("teacher_update.form.learning.institue_" + instituteType + "_select")%>
                                        </label>

                                        <div class="col-12 col-sm-6 col-lg-3 my-1 d-none" id="teacher_update_institute_<%= instituteType%>_div">

                                            <select class="custom-select teacher_update_institute_select" id="teacher_update_institute_<%= instituteType%>_select">

                                                <option value="" disabled selected>
                                                    <%= Labels.get("teacher_update.form.learning.institue_" + instituteType + ".choose")%>
                                                </option>
                                                <%
                                                    for (int instituteId : institutesMap.keySet()) {
                                                        String instituteName = institutesMap.get(instituteId);
                                                %>

                                                <option value="<%= instituteId%>">                                                       
                                                    <%= instituteName%>
                                                </option>

                                                <%
                                                    }
                                                %>

                                                <option value="0">
                                                    <%= Labels.get("teacher_update.form.learning.institue_type.other")%>
                                                </option>
                                            </select>
                                        </div>

                                        <%
                                            }
                                        %>
                                        <label id="teacher_update_institute_0_label"
                                               class="col-12 col-sm-6 col-lg-3 my-1 col-form-label d-none" 
                                               for="teacher_update_institute_0_text">
                                            <%= Labels.get("teacher_update.form.learning.institue.other.choose")%>
                                        </label>

                                        <div id="teacher_update_institute_0_div" class="col-12 col-sm-6 col-lg-3 my-1 d-none">
                                            <input type="text" class="form-control" id="teacher_update_institute_0_text" 
                                                   name="teacher_update_institute_0_text"
                                                   placeholder="<%= Labels.get("teacher_update.form.learning.institue.other.choose")%>">
                                        </div>

                                    </div>
                                    <div class="form-group row">
                                        <label class="col-12 col-sm-6 col-lg-3 my-1 col-form-label" for="teacher_update_subject">
                                            <%= Labels.get("teacher_update.form.learning.subject.title")%>
                                        </label>

                                        <div class="col-12 col-sm-6 col-lg-3 my-1">
                                            <select class="custom-select" id="teacher_update_subject_select">
                                                <option value="0" disabled selected>
                                                    <%= Labels.get("teacher_update.form.learning.subject.choose")%>
                                                </option>
                                                <%
                                                    for (Subject subject : subjects) {
                                                %>

                                                <option value="<%= subject.id%>">                                                    
                                                    <%= subject.name%>
                                                </option>

                                                <%
                                                    }
                                                %>

                                                <option value="0">
                                                    <%= Labels.get("teacher_update.form.learning.subject.other")%>
                                                    </a>
                                            </select>
                                        </div>   

                                        <label id="teacher_update_subject_0_label" class="col-12 col-sm-6 col-lg-3 my-1 col-form-label d-none" 
                                               for="teacher_update_subject_0_text">
                                            <%= Labels.get("teacher_update.form.learning.subject.other.choose")%>
                                        </label>

                                        <div id="teacher_update_subject_0_div" class="col-12 col-sm-6 col-lg-3 my-1 d-none">
                                            <input type="text" class="form-control" id="teacher_update_subject_0_text" 
                                                   name="teacher_update_institute_0_text"
                                                   placeholder="<%= Labels.get("teacher_update.form.learning.subject.other.choose")%>">
                                        </div>

                                    </div>
                                </div>
                            </div>

                            <div class="card-footer">
                                <div class="d-flex flex-row-reverse">
                                    <button type="button" class="btn btn-info teacher_update_tabs_button" 
                                            id="teacher_update_goto_tab_teaching_topics_button"
                                            onclick="teacher_update_goto_tab('teaching_topics')">
                                        <span class="oi" data-glyph="chevron-left"></span>                                            
                                        <%= Labels.get("teacher_update.tabs.to")%><%= Labels.get("teacher_update.tabs.teaching_topics")%>
                                        <span class="oi" data-glyph="chevron-left"></span>                                            
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div class="card my-1 tab-pane fade" id="teacher_update_teaching_topics_tab" role="tabpanel" 
                             aria-labelledby="teacher_update_teaching_topics_link">
                            <div class="card-header text-white bg-secondary">
                                <div class="card-title">
                                    <%= Labels.get("teacher_update.form.teaching_topics.text1")%>   
                                </div>
                            </div>

                            <div class="card-body">
                                <div class="row no-gutters" id="teacher_update_topic_list">
                                    <%
                                        for (Subject subject : allSubjects.values()) {
                                    %>
                                    <div class="col-xl-4 col-lg-4 px-1">
                                        <div class="card">
                                            <div class="card-header text-white bg-info">
                                                <%= subject.name%>
                                            </div>
                                            <div class="card-body h6">                                            
                                                <div class="list-group">

                                                    <%
                                                        for (Topic topic : allTopics.values()) {
                                                            if (topic.subject.equals(subject)) {
                                                    %>

                                                    <button type="button" data-topic-id="<%= topic.id%>" class="text-right list-group-item list-group-item-light">
                                                        <span class="d-none oi" data-glyph="check"></span>
                                                        <%= topic.name%>
                                                    </button>
                                                    <%
                                                            }
                                                        }
                                                    %>

                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <%
                                        }
                                    %>                                        
                                </div>
                            </div>

                            <div class="card-footer">
                                <div class="d-flex flex-row-reverse">
                                    <button type="button" class="btn btn-info teacher_update_tabs_button" 
                                            id="teacher_update_goto_tab_prices_button"
                                            onclick="teacher_update_goto_tab('prices')">
                                        <span class="oi" data-glyph="chevron-left"></span>                                            
                                        <%= Labels.get("teacher_update.tabs.to")%><%= Labels.get("teacher_update.tabs.prices")%>
                                        <span class="oi" data-glyph="chevron-left"></span>                                            
                                    </button>
                                </div>
                            </div>

                        </div>

                        <div class="card my-1 tab-pane fade" id="teacher_update_prices_tab" role="tabpanel" 
                             aria-labelledby="teacher_update_prices_link">
                            <div class="card-header text-white bg-secondary">
                                <div class="card-title">
                                    <%= Labels.get("teacher_update.form.payment.text1")%>   
                                </div>
                            </div>
                            <div class="card-body">
                                <div class="form-group row">
                                    <div class="col-6 col-lg-3 my-1" id="teacher_update_paypal_email">
                                        <label class="col-form-label" for="teacher_update_paypal_email_input">
                                            <%= Labels.get("teacher_update.form.payment.paypal_email")%>
                                        </label>   
                                        <small class="teacher_update_required teacher_update_required_filled">
                                            (*)
                                        </small>
                                    </div>

                                    <div class="col-12 col-sm-6 col-lg-3 my-1">
                                        <input type="email" class="form-control teacher_update_required teacher_update_required_filled" id="teacher_update_paypal_email_input" 
                                               name="teacher_update_paypal_email_input"
                                               placeholder="<%= Labels.get("teacher_update.form.paypal_email.placeholder")%>">
                                    </div>

                                    <div class="col-12 col-sm-6 col-lg-3 my-1">
                                        <label class="col-form-label" for="teacher_update_price_per_hour_input">
                                            <%= Labels.get("teacher_update.form.payment.price_per_hour")%>
                                            <small class="teacher_update_required teacher_update_required_filled">
                                            (*)
                                            </small>
                                            <br/>
                                            <small>
                                            <%= Labels.get("teacher_update.form.payment.price_per_hour.small_text")%>
                                            </small>
                                        </label> 
                                        
                                    </div>

                                    <div class="col-12 col-sm-6 col-lg-3 my-1" id="teacher_update_price_per_hour">
                                        <div class="input-group">
                                            <input type="text" class="form-control teacher_update_required teacher_update_required_filled" id="teacher_update_price_per_hour_input" 
                                                   name="teacher_update_price_per_hour_input"
                                                   onkeypress="return isNumberKey(event)"
                                                   placeholder="<%= Labels.get("teacher_update.form.payment.price_per_hour.placeholder")%>">
                                            <div class="input-group-prepend">
                                                <span class="input-group-text">
                                                    <%= CLabels.get("website.currency")%>
                                                </span>
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </div>

                            <div class="card-footer">
                                <div class="d-flex flex-row-reverse">
                                    <button type="button" class="btn btn-info teacher_update_tabs_button" 
                                            id="teacher_update_goto_tab_teaching_hours_button"
                                            onclick="teacher_update_goto_tab('teaching_hours')">
                                        <span class="oi" data-glyph="chevron-left"></span>                                            
                                        <%= Labels.get("teacher_update.tabs.to")%><%= Labels.get("teacher_update.tabs.teaching_hours")%>
                                        <span class="oi" data-glyph="chevron-left"></span>                                            
                                    </button>
                                </div>
                            </div>

                        </div>

                        <div class="card my-1 tab-pane fade" id="teacher_update_teaching_hours_tab" role="tabpanel" 
                             aria-labelledby="teacher_update_teaching_hours_link">
                            <div class="card-header text-white bg-secondary">
                                <div class="card-title">
                                    <%= Labels.get("teacher_update.form.available_hours.text1")%>   
                                </div>
                            </div>
                            <div class="card-body">
                                <div class="row no-gutters">
                                    <div class="col-12 col-lg-4">
                                        <p class="h6">
                                            <%= Labels.get("teacher_update.form.available_hours.choose_hours")%>   
                                        </p>  
                                        <p class="h6">
                                            <%= Labels.get("teacher_update.form.available_hours.choose_hours2")%>   
                                        </p> 
                                        <p class="h6">
                                            <%= Labels.get("teacher_update.form.available_hours.choose_hours3")%>   
                                        </p>
                                        <div class="row no-gutters my-1">
                                            <div class="col-12 col-sm-6 col-md-3 col-lg-6 my-1">
                                                <label class="col-form-label mx-1" for="teacher_update_min_class_length">
                                                    <%= Labels.get("teacher_update.form.available_hours.min_class_length")%>
                                                </label>
                                            </div>
                                            <div class="col-12 col-sm-6 col-md-3 col-lg-6 my-1">
                                                <select class="custom-select form-control" id="teacher_update_min_class_length">
                                                    <%
                                                        int minutes = minimumClassLengthMinutes;
                                                        while (minutes <= maximumClassLengthMinutes) {
                                                    %>

                                                    <option value="<%= minutes%>"
                                                            <% if (minutes == minimumClassLengthMinutes) {
                                                                    out.write("selected");
                                                                }%>
                                                            >
                                                        <%= minutes%>&nbsp;<%= CLabels.get("language.minutes")%>
                                                    </option>
                                                    <%
                                                            minutes += minutesPerUnit;
                                                        }
                                                    %>

                                                </select>                                                    
                                            </div>
                                            <div class="col-12 col-sm-6 col-md-3 col-lg-6 my-1">
                                                <label class="col-form-label mx-1" for="teacher_update_max_class_length">
                                                    <%= Labels.get("teacher_update.form.available_hours.max_class_length")%>
                                                </label>
                                            </div>
                                            <div class="col-12 col-sm-6 col-md-3 col-lg-6 my-1">
                                                <select class="custom-select form-control" id="teacher_update_max_class_length">
                                                    <%
                                                        minutes = minimumClassLengthMinutes;
                                                        while (minutes <= maximumClassLengthMinutes) {
                                                    %>

                                                    <option value="<%= minutes%>"
                                                            <% if (minutes == maximumClassLengthMinutes) {
                                                                    out.write("selected");
                                                                }%>
                                                            >
                                                        <%= minutes%>&nbsp;<%= CLabels.get("language.minutes")%>
                                                    </option>
                                                    <%
                                                            minutes += minutesPerUnit;
                                                        }
                                                    %>

                                                </select>                                                    
                                            </div>
                                        </div>
                                        <div class="card my-1">
                                            <div class="h6 card-header">
                                                <%= Labels.get("teacher_update.form.available_hours.hours_chosen")%>   
                                            </div>


                                            <div class="card-body">
                                                <p class="h6" id="teacher_update_selected_hours">

                                                </p>
                                            </div>
                                        </div>
                                        <div class="my-2">
                                            <button type="button" class="btn btn-primary" onclick="teacher_update_clear_calendar()">
                                                <%= Labels.get("teacher_update.form.available_hours.clear_button")%>   
                                            </button>
                                        </div>
                                    </div>

                                    <div class="px-2 col-12 col-lg-8 row no-gutters">

                                        <table id="teacher_update_calendar_table" class="d-table table table-responsive table-sm">
                                            <thead>
                                                <tr>
                                                    <th class="teacher_update_calendar" style="width: 12.5%">
                                                    </th>                                        
                                                    <% for (day = 0; day < 7; day++) {

                                                    %>                                        
                                                    <th class="teacher_update_calendar"  style="width: 12.5%">
                                                        <span><%= dayNamesLong.get(day)%></span>
                                                        <br/>
                                                        <span id="teacher_update_day_<%= (day + 1)%>"></span>
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
                                                            cellClass = "teacher_update_row_end";
                                                        } else {
                                                            cellClass = "teacher_update_row_middle";
                                                        }
                                                        if (rowCount == 0) {
                                                            cellClass = "teacher_update_row_start";
                                                    %>
                                                    <td rowspan="<%= rowsPerCell%>" class="teacher_update_calendar">
                                                        <%= Utils.formatTime(hour, 0)%>                                                        
                                                    </td>
                                                    <% } %>

                                                    <% for (day = 0; day < 7; day++) {
                                                    %>
                                                    <td data-day="<%= day + 1%>" data-hour="<%= hour%>" data-minute="<%= minute%>"                                                            
                                                        class="teacher_update_calendar_time teacher_update_calendar <%= cellClass%>" id="teacher_update_day_<%= (day + 1)%>_hour_<%= hour%>_minute_<%= minute%>">                                                       
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

                            <div class="card-footer">
                                <div class="d-flex flex-row-reverse">
                                    <button type="button" class="btn btn-info teacher_update_tabs_button" 
                                            id="teacher_update_goto_tab_accept_and_finish_button"
                                            onclick="teacher_update_goto_tab('accept_and_finish')">
                                        <span class="oi" data-glyph="chevron-left"></span>                                            
                                        <%= Labels.get("teacher_update.tabs.to")%><%= Labels.get("teacher_update.tabs.accept_and_finish")%>
                                        <span class="oi" data-glyph="chevron-left"></span>                                            
                                    </button>
                                </div>
                            </div>

                        </div>

                        <div class="card my-1 tab-pane fade" id="teacher_update_accept_and_finish_tab" role="tabpanel" 
                             aria-labelledby="teacher_update_accept_and_finish_link">
                            <div class="card-header text-white bg-secondary">
                                <div class="card-title">
                                    <%= Labels.get("teacher_update.form.submit.title")%>   
                                </div>
                            </div>
                            <div class="card-body">                            
                                <h6>
                                    <%= Labels.get("teacher_update.form.submit.accept_terms_of_usage")%>  
                                </h6>
                                <p>
                                    <a href="javascript:teacher_update_terms_of_usage()">
                                        <%= Labels.get("teacher_update.form.publish.read_terms_of_usage")%>
                                    </a>
                                </p>

                                <div class="row no-gutters">
                                    <div class="col-12 col-sm-6 col-lg-3 my-1" id="teacher_update_feedback">
                                        <label class="col-form-label" for="teacher_update_feedback_input">
                                            <%= Labels.get("teacher_update.form.publish.feedback_text")%>
                                        </label>  
                                    </div>

                                    <div class="col-12 col-sm-6 col-lg-9 my-1">
                                        <textarea rows="4" class="form-control" id="teacher_update_feedback_input" 
                                                  name="teacher_update_feedback_input"
                                                  placeholder="<%= Labels.get("teacher_update.form.publish.feedback_placeholder")%>"></textarea>
                                    </div>
                                </div>
                            </div>
                            <div class="card-footer">

                                <div class="d-flex flex-row-reverse">
                                    <div>
                                        <button type="button" class="btn btn-success mx-1 my-auto disabled teacher_update_tabs_button"
                                                id="teacher_update_form_submit_button"
                                                onclick="teacher_update_form_submit()">
                                            <span class="oi" data-glyph="chevron-left"></span>
                                            <%= Labels.get("teacher_update.form.submit.button.text")%>   
                                            <span class="oi" data-glyph="chevron-left"></span>
                                        </button>
                                    </div>

                                    <div class="checkbox mx-1 h6 my-auto" id="teacher_update_accept_terms_checkbox_div">
                                        <input class="form-check-input my-1 mx-0 teacher_update_required teacher_update_required_filled" id="teacher_update_accept_terms_checkbox" 
                                               name="teacher_update_accept_terms_checkbox" 
                                               type="checkbox" value="">

                                        <label class="form-check-label" for="teacher_update_accept_terms_checkbox">
                                            <%= Labels.get("teacher_update.form.submit.terms_of_usage.read_and_accept")%>  
                                        </label>
                                        <small class="teacher_update_required teacher_update_required_filled">
                                            (*)
                                        </small>
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
            teacher_update.teacher = <%= Utils.gson().toJson(teacher)%>
            teacher_update.available_times = <%= Utils.gson().toJson(availableTimes)%>
            teacher_update.teaching_topics = <%= Utils.gson().toJson(teachingTopics) %>
            oc.institute_type = <%= Utils.gson().toJson(instituteTypes)%>;
            oc.institutes = <%= Utils.gson().toJson(institutes)%>;
            oc.subjects = <%= Utils.gson().toJson(subjects)%>;
        </script>

    </body>

</html>
