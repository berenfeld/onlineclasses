<%@page import="com.onlineclasses.entities.City"%>
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
    String phoneAreas = CLabels.get("website.phone_areas");
    List<City> cities = DB.getAll(City.class);
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
    Map<Integer, Topic> allTopics = DB.getAllMap(Topic.class);
    List<String> dayNamesLong = Utils.toList(CLabels.get("website.days.long"));
    final int startHour = CConfig.getInt("website.time.start_working_hour");
    final int endHour = CConfig.getInt("website.time.end_working_hour");
    int hour, day, minute;
    int minutesPerRow = CConfig.getInt("website.time.calendar_minutes_per_row");
    int minutesPerUnit = CConfig.getInt("website.time.unit.minutes");
    int rowsPerCell = minutesPerRow / minutesPerUnit;
%>
<!DOCTYPE html>
<html lang="<%= Config.get("website.html_language")%>" dir="<%= Config.get("webiste.direction")%>">
    <head>
        <%@include file="header.jsp" %>
        <title>
            <%= Labels.get("start_teaching.title")%>
        </title>
    </head>
    <body lang="<%= Config.get("website.html_language")%>" dir="<%= Config.get("webiste.direction")%>">
        <%@include file="body.jsp" %>    

        <div class="container">
            <div class="row no-gutters my-1">
                <div class="col-12">

                    <form id="start_teaching_form" onsubmit="return false">

                        <div class="card my-1">
                            <div class="card-header text-secondary">
                                <h5>
                                    <%= Labels.get("start_teaching.heading")%>
                                </h5>
                                <p>
                                    <%= Labels.get("start_teaching.text1")%>       
                                    <br/>
                                    <%= Labels.get("start_teaching.text2")%>      
                                    <br/>
                                    <%= Labels.get("start_teaching.required_field_1")%>  
                                    <small class="start_teaching_required">
                                        (*)
                                    </small>
                                    <%= Labels.get("start_teaching.required_field_2")%>  
                                </p>
                            </div>
                        </div>

                        <div>
                            <ul class="nav nav-tabs my-1" id="start_teaching_tab_list">                         
                                <li class="nav-item">
                                    <a  id="start_teaching_personal_information_link" class="nav-link active" data-toggle="tab" 
                                        href="#start_teaching_personal_information_tab">
                                        <%= Labels.get("start_teaching.tabs.personal_information")%>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a  id="start_teaching_profile_link" class="nav-link" data-toggle="tab" 
                                        href="#start_teaching_profile_tab">
                                        <%= Labels.get("start_teaching.tabs.profile")%>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a  id="start_teaching_education_link" class="nav-link" data-toggle="tab" 
                                        href="#start_teaching_education_tab">
                                        <%= Labels.get("start_teaching.tabs.education")%>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a  id="start_teaching_teaching_topics_link" class="nav-link" data-toggle="tab" 
                                        href="#start_teaching_teaching_topics_tab">
                                        <%= Labels.get("start_teaching.tabs.teaching_topics")%>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a  id="start_teaching_prices_link" class="nav-link" data-toggle="tab" 
                                        href="#start_teaching_prices_tab">
                                        <%= Labels.get("start_teaching.tabs.prices")%>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a  id="start_teaching_teaching_hours_link" class="nav-link" data-toggle="tab" 
                                        href="#start_teaching_teaching_hours_tab">
                                        <%= Labels.get("start_teaching.tabs.teaching_hours")%>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a  id="start_teaching_accept_and_finish_link" class="nav-link" data-toggle="tab" 
                                        href="#start_teaching_accept_and_finish_tab">
                                        <%= Labels.get("start_teaching.tabs.accept_and_finish")%>
                                    </a>
                                </li>
                            </ul> 
                        </div>
                        <div class="tab-content" id="start_teaching_tabs">

                            <div class="card my-1 tab-pane fade show active" id="start_teaching_personal_information_tab" role="tabpanel" 
                                 aria-labelledby="start_teaching_personal_information_link">
                                <div class="card-header bg-secondary text-white">
                                    <div class="row no-gutters" id="start_teaching_google_login">
                                        <div class="col-12 col-md-6 col-lg-9">
                                            <%= Labels.get("start_teaching.form.login.text1")%> 
                                            <small class="start_teaching_required">
                                                (*)
                                            </small>
                                            <br/>
                                            <small>
                                                <%= Labels.get("start_teaching.form.login.text2")%> 
                                            </small>
                                        </div>
                                        <div class="col-12 col-md-6 col-lg-3">
                                            <input type="image" src="images/google_login_button.png" class="w-100 google_login_button d-none" onclick="start_teaching_googleLogin()">
                                        </div>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <div class="form-group row">
                                        <div class="col-6 col-lg-3 my-1">                                    
                                            <label class="col-form-label" for="start_teaching_email_input">
                                                <%= Labels.get("start_teaching.form.login.email")%>                                        
                                            </label>                     
                                            <small class="start_teaching_required">
                                                (*)
                                            </small>
                                        </div>

                                        <div class="col-6 col-lg-3 my-1">
                                            <input type="email" class="form-control" id="start_teaching_email_input" 
                                                   placeholder="<%= Labels.get("start_teaching.form.login.email")%>" disabled>
                                        </div>

                                        <div class="col-6 col-lg-3 my-1">
                                            <label class="col-form-label" for="start_teaching_display_name_input">
                                                <%= Labels.get("start_teaching.form.login.display_name")%>
                                            </label>
                                        </div>
                                        <div class="col-6 col-lg-3 my-1">
                                            <input type="text" class="form-control" id="start_teaching_display_name_input" 
                                                   placeholder="<%= Labels.get("start_teaching.form.login.display_name")%>" disabled>
                                        </div>

                                        <div class="col-6 col-lg-3 my-1">
                                            <label class="col-form-label" for="start_teaching_first_name_input">
                                                <%= Labels.get("start_teaching.form.login.first_name")%>
                                            </label>
                                        </div>

                                        <div class="col-6 col-lg-3 my-1">
                                            <input type="text" class="form-control" id="start_teaching_first_name_input"
                                                   placeholder="<%= Labels.get("start_teaching.form.login.first_name")%>" disabled>
                                        </div>

                                        <div class="col-6 col-lg-3 my-1">
                                            <label class="col-form-label" for="start_teaching_last_name_input">
                                                <%= Labels.get("start_teaching.form.login.last_name")%>
                                            </label>
                                        </div>

                                        <div class="col-6 col-lg-3 my-1">
                                            <input type="text" class="form-control" id="start_teaching_last_name_input" 
                                                   placeholder="<%= Labels.get("start_teaching.form.login.last_name")%>" disabled>
                                        </div>

                                        <div class="col-6 col-lg-3 my-1">
                                            <label class="col-form-label" for="start_teaching_gender_input">
                                                <%= Labels.get("start_teaching.form.login.gender")%>   
                                            </label>
                                            <small class="start_teaching_required">
                                                (*)
                                            </small>
                                        </div>

                                        <div class="col-6 col-lg-3 my-1">
                                            <div class="row form-check form-check-inline no-gutters">
                                                <input type="radio" checked class="mx-2 form-check form-check-inline" 
                                                       value="<%= Config.get("website.gender.male")%>" 
                                                       id="start_teaching_gender_input_male" name="start_teaching_gender_input">
                                                <label class="mx-2 col-form-label" for="start_teaching_gender_input_male">
                                                    <%= Labels.get("start_teaching.form.login.gender.male")%>   
                                                </label>

                                                <input type="radio" class="mx-2 form-check form-check-inline" 
                                                       value="<%= Config.get("website.gender.female")%>" 
                                                       id="start_teaching_gender_input_female" name="start_teaching_gender_input">
                                                <label class="mx-2 col-form-label" for="start_teaching_gender_input_female">
                                                    <%= Labels.get("start_teaching.form.login.gender.female")%>   
                                                </label>
                                            </div>
                                        </div>

                                        <div class="col-12 col-lg-6 my-0">
                                            <div class="row no-gutters" id="start_teaching_phone_number">   
                                                <div class="col-12 col-md my-1">
                                                    <label class="col-form-label" for="start_teaching_phone_number_input">
                                                        <%= Labels.get("start_teaching.form.login.phone_number")%>
                                                    </label>
                                                    <small class="start_teaching_required">
                                                        (*)
                                                    </small>
                                                </div>

                                                <div class="input-group form-control border-0 col-12 col-md">
                                                    <input type="text" class="form-control mr-md-3" id="start_teaching_phone_number_input"
                                                           onkeypress="return isNumberKey(event)"
                                                           placeholder="<%= Labels.get("start_teaching.form.login.phone_number")%>">

                                                    <select class="custom-select form-control" id="start_teaching_phone_area_select">
                                                        <option value="" disabled selected>
                                                            <%= Labels.get("start_teaching.form.login.phone_area")%>
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

                                        <div class="col-6 col-lg-3 my-1" id="start_teaching_day_of_birth">
                                            <label class="col-form-label" for="start_teaching_day_of_birth_input">
                                                <%= Labels.get("start_teaching.form.login.day_of_birth")%>
                                            </label>
                                            <small class="start_teaching_required">
                                                (*)
                                            </small>
                                        </div>

                                        <div class="col-6 col-lg-3 my-1">
                                            <input type="text" class="form-control" id="start_teaching_day_of_birth_input"
                                                   name="start_teaching_day_of_birth_input"
                                                   placeholder="<%= Labels.get("start_teaching.form.login.day_of_birth")%>">
                                        </div>

                                        <div class="col-6 col-lg-3 my-1">
                                            <label class="col-form-label" for="start_teaching_skype_name_input">
                                                <%= Labels.get("start_teaching.form.login.skype_name")%>
                                            </label>
                                        </div>

                                        <div class="col-6 col-lg-3 my-1">
                                            <input type="text" class="form-control" id="start_teaching_skype_name_input"
                                                   name="start_teaching_skype_name_input"
                                                   placeholder="<%= Labels.get("start_teaching.form.login.skype_name")%>">
                                        </div>

                                        <div class="col-6 col-lg-3 my-1" id="start_teaching_city">
                                            <label class="col-form-label" for="start_teaching_city_input">
                                                <%= Labels.get("start_teaching.form.login.choose_city")%>                                        
                                            </label>
                                            <small class="start_teaching_required">
                                                (*)
                                            </small>
                                        </div>

                                        <div class="col-6 col-lg-3 my-1">
                                            <select class="custom-select form-control" id="start_teaching_city_select">
                                                <option value="0" disabled selected>
                                                    <%= Labels.get("start_teaching.form.login.city")%>
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

                                    </div>
                                </div>
                                <div class="card-footer">
                                    <div class="d-flex flex-row-reverse">
                                        <button class="btn btn-info" onclick="start_teaching_goto_tab('profile')">
                                            <span class="oi" data-glyph="chevron-left"></span>
                                            <%= Labels.get("start_teaching.tabs.to")%><%= Labels.get("start_teaching.tabs.profile")%>
                                            <span class="oi" data-glyph="chevron-left"></span>                                            
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <div class="card my-1 tab-pane fade" id="start_teaching_profile_tab" role="tabpanel" 
                                 aria-labelledby="start_teaching_profile_link">
                                <div class="card-header text-white bg-secondary">
                                    <div class="card-title">
                                        <%= Labels.get("start_teaching.form.publish.text1")%>   
                                    </div>
                                </div>

                                <div class="card-body">                                
                                    <div class="form-group row">
                                        <div class="col-6 col-lg-3 my-1" id="start_teaching_moto">
                                            <label class="col-form-label" for="start_teaching_moto_input">
                                                <%= Labels.get("start_teaching.form.publish.moto_text")%>
                                            </label>  
                                            <small class="start_teaching_required">
                                                (*)
                                            </small>
                                        </div>

                                        <div class="col-6 col-lg-9 my-1">
                                            <textarea rows="4" class="form-control" id="start_teaching_moto_input" 
                                                      name="start_teaching_moto_input"
                                                      placeholder="<%= Labels.get("start_teaching.form.publish.moto_placeholder")%>"></textarea>
                                        </div>

                                        <div class="col-12 my-1">
                                            <input class="form-check-input mx-0"  
                                                   id="start_teaching_show_phone" 
                                                   name="start_teaching_show_phone"
                                                   type="checkbox" value="">
                                            <label class="form-check-label" for="start_teaching_show_phone">
                                                <%= Labels.get("start_teaching.form.publish.show_phone")%>
                                            </label>
                                        </div>

                                        <div class="col-12 my-1">
                                            <input class="form-check-input mx-0"  
                                                   id="start_teaching_show_email" 
                                                   name="start_teaching_show_email"
                                                   type="checkbox" value="">
                                            <label class="form-check-label" for="start_teaching_show_email">
                                                <%= Labels.get("start_teaching.form.publish.show_email")%>
                                            </label>
                                        </div>

                                        <div class="col-12 my-1">
                                            <input class="form-check-input mx-0"  
                                                   id="start_teaching_show_skype" 
                                                   name="start_teaching_show_skype"
                                                   type="checkbox" value="">
                                            <label class="form-check-label" for="start_teaching_show_skype">
                                                <%= Labels.get("start_teaching.form.publish.show_skype")%>
                                            </label>
                                        </div>

                                    </div>
                                </div>

                                <div class="card-footer">
                                    <div class="d-flex flex-row-reverse">
                                        <button class="btn btn-info" onclick="start_teaching_goto_tab('education')">
                                            <span class="oi" data-glyph="chevron-left"></span>                                            
                                            <%= Labels.get("start_teaching.tabs.to")%><%= Labels.get("start_teaching.tabs.education")%>
                                            <span class="oi" data-glyph="chevron-left"></span>                                            
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <div class="card my-1 tab-pane fade" id="start_teaching_education_tab" role="tabpanel" 
                                 aria-labelledby="start_teaching_education_link">

                                <div class="card-header text-white bg-secondary">
                                    <div class="card-title">
                                        <%= Labels.get("start_teaching.form.learning_information.text1")%>   
                                    </div>
                                </div>

                                <div class="card-body">

                                    <div class="form-group row">
                                        <a class="list-group-item list-group-item-action" 
                                           aria-expanded="false"
                                           aria-controls="start_teaching_degree_information_div"                                   
                                           data-toggle="collapse"
                                           href="#start_teaching_degree_information_div">
                                            <input class="form-check-input my-1 mx-0"  
                                                   id="start_teaching_topic_show_degree" 
                                                   name="start_teaching_topic_show_degree"
                                                   type="checkbox" value="">
                                            <label class="form-check-label" for="start_teaching_topic_show_degree">
                                                <%= Labels.get("start_teaching.form.learning_information.show_degree")%>
                                            </label>
                                        </a>
                                    </div>
                                    <div class="collapse" id="start_teaching_degree_information_div">
                                        <div class="form-group row" aria-expanded="false" >

                                            <label class="col-6 col-lg-3 my-1 col-form-label" for="start_teaching_degree_type_button">
                                                <%= Labels.get("start_teaching.form.learning.degree_type.title")%>
                                            </label>

                                            <div class="col-6 col-lg-3 my-1">
                                                <select class="custom-select" id="start_teaching_degree_type_select">

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

                                            <label class="col-6 col-lg-3 my-1 col-form-label" for="start_teaching_institute_type">
                                                <%= Labels.get("start_teaching.form.learning.education.title")%>
                                            </label>

                                            <div class="col-6 col-lg-3 my-1">
                                                <select class="custom-select" id="start_teaching_institute_type_select">

                                                    <option id="start_teaching_institute_type_choose" value="0" disabled selected>
                                                        <%= Labels.get("start_teaching.form.learning.institue_type.choose")%>
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

                                                    <option id="start_teaching_institute_type_other" value="0">
                                                        <%= Labels.get("start_teaching.form.learning.institue_type.other")%>
                                                    </option>
                                                </select>
                                            </div>

                                            <%
                                                for (int instituteType : institutes.keySet()) {
                                                    Map<Integer, String> institutesMap = institutes.get(instituteType);

                                            %>

                                            <label id="start_teaching_institute_<%= instituteType%>_label" class="col-6 col-lg-3 my-1 col-form-label d-none" 
                                                   for="start_teaching_institute_<%= instituteType%>_select">
                                                <%= Labels.get("start_teaching.form.learning.institue_" + instituteType + "_select")%>
                                            </label>

                                            <div class="col-6 col-lg-3 my-1 d-none" id="start_teaching_institute_<%= instituteType%>_div">

                                                <select class="custom-select start_teaching_institute_select" id="start_teaching_institute_<%= instituteType%>_select>">

                                                    <%
                                                        for (int instituteId : institutesMap.keySet()) {
                                                            String instituteName = institutesMap.get(instituteId);
                                                    %>

                                                    <option value="<%= instituteId %>">                                                       
                                                        <%= instituteName%>
                                                    </option>

                                                    <%
                                                        }
                                                    %>

                                                    <option value="0">
                                                        <%= Labels.get("start_teaching.form.learning.institue_type.other")%>
                                                    </option>
                                                </select>
                                            </div>

                                            <%
                                                }
                                            %>
                                            <label id="start_teaching_institute_0_label"
                                                   class="col-6 col-lg-3 my-1 col-form-label d-none" 
                                                   for="start_teaching_institute_0_text">
                                                <%= Labels.get("start_teaching.form.learning.institue.other.choose")%>
                                            </label>

                                            <div id="start_teaching_institute_0_div" class="col-6 col-lg-3 my-1 d-none">
                                                <input type="text" class="form-control" id="start_teaching_institute_0_text" 
                                                       name="start_teaching_institute_0_text"
                                                       placeholder="<%= Labels.get("start_teaching.form.learning.institue.other.choose")%>">
                                            </div>

                                        </div>
                                        <div class="form-group row">
                                            <label class="col-6 col-lg-3 my-1 col-form-label" for="start_teaching_subject">
                                                <%= Labels.get("start_teaching.form.learning.subject.title")%>
                                            </label>

                                            <div class="col-6 col-lg-3 my-1">
                                                <button class="btn btn-info dropdown-toggle" type="button" 
                                                        data-toggle="dropdown" id="start_teaching_subject_button">
                                                    <span class="caret"></span>
                                                    <%= Labels.get("start_teaching.form.learning.subject.select")%>

                                                </button>
                                                <div class="dropdown-menu" aria-labelledby="start_teaching_subject_button">
                                                    <%
                                                        for (Subject subject : subjects) {
                                                    %>

                                                    <a class="dropdown-item" href="javascript:start_teaching_select_subject(<%= subject.id%>)">
                                                        <%= subject.name%>
                                                    </a>

                                                    <%
                                                        }
                                                    %>

                                                    <a class="dropdown-item" id="start_teaching_subject_other" href="javascript:start_teaching_select_subject(0)">
                                                        <%= Labels.get("start_teaching.form.learning.subject.other")%>
                                                    </a>
                                                </div>
                                            </div>   

                                            <label id="start_teaching_subject_0_label" class="col-6 col-lg-3 my-1 col-form-label d-none" 
                                                   for="start_teaching_subject_0_text">
                                                <%= Labels.get("start_teaching.form.learning.subject.other.choose")%>
                                            </label>

                                            <div id="start_teaching_subject_0_div" class="col-6 col-lg-3 my-1 d-none">
                                                <input type="text" class="form-control" id="start_teaching_subject_0_text" 
                                                       name="start_teaching_institute_0_text"
                                                       placeholder="<%= Labels.get("start_teaching.form.learning.subject.other.choose")%>">
                                            </div>

                                        </div>
                                    </div>
                                </div>

                                <div class="card-footer">
                                    <div class="d-flex flex-row-reverse">
                                        <button class="btn btn-info" onclick="start_teaching_goto_tab('teaching_topics')">
                                            <span class="oi" data-glyph="chevron-left"></span>                                            
                                            <%= Labels.get("start_teaching.tabs.to")%><%= Labels.get("start_teaching.tabs.teaching_topics")%>
                                            <span class="oi" data-glyph="chevron-left"></span>                                            
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <div class="card my-1 tab-pane fade" id="start_teaching_teaching_topics_tab" role="tabpanel" 
                                 aria-labelledby="start_teaching_teaching_topics_link">
                                <div class="card-header text-white bg-secondary">
                                    <div class="card-title">
                                        <%= Labels.get("start_teaching.form.teaching_topics.text1")%>   
                                    </div>
                                </div>

                                <div class="card-body">
                                    <div class="row no-gutters">
                                        <%
                                            for (Subject subject : allSubjects.values()) {
                                        %>
                                        <div class="col-xl-4 col-lg-4 px-1">
                                            <div class="card">
                                                <div class="card-header text-white bg-info">
                                                    <%= subject.name%>
                                                </div>
                                                <div class="card-body h6">                                            
                                                    <ul class="list-group">

                                                        <%
                                                            for (Topic topic : allTopics.values()) {
                                                                if (topic.subject.equals(subject)) {
                                                        %>

                                                        <a class="list-group-item list-group-item-action"
                                                           href="javascript:start_teaching_select_topic(<%= topic.id%>)">
                                                            <input class="start_teaching_teaching_topics_input form-check-input my-1 mx-0"  
                                                                   id="start_teaching_topic_<%= topic.id%>_checkbox" 
                                                                   name="start_teaching_topic_<%= topic.id%>_checkbox" 
                                                                   type="checkbox" data-topic-id="<%=topic.id%>" value="">
                                                            <label class="form-check-label" for="start_teaching_topic_<%= topic.id%>_checkbox">
                                                                <%= topic.name%>
                                                            </label>
                                                        </a>
                                                        <%
                                                                }
                                                            }
                                                        %>

                                                    </ul>
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
                                        <button class="btn btn-info" onclick="start_teaching_goto_tab('prices')">
                                            <span class="oi" data-glyph="chevron-left"></span>                                            
                                            <%= Labels.get("start_teaching.tabs.to")%><%= Labels.get("start_teaching.tabs.prices")%>
                                            <span class="oi" data-glyph="chevron-left"></span>                                            
                                        </button>
                                    </div>
                                </div>

                            </div>

                            <div class="card my-1 tab-pane fade" id="start_teaching_prices_tab" role="tabpanel" 
                                 aria-labelledby="start_teaching_prices_link">
                                <div class="card-header text-white bg-secondary">
                                    <div class="card-title">
                                        <%= Labels.get("start_teaching.form.payment.text1")%>   
                                    </div>
                                </div>
                                <div class="card-body">
                                    <div class="form-group row">
                                        <div class="col-6 col-lg-3 my-1" id="start_teaching_paypal_email">
                                            <label class="col-form-label" for="start_teaching_paypal_email_input">
                                                <%= Labels.get("start_teaching.form.payment.paypal_email")%>
                                            </label>   
                                            <small class="start_teaching_required">
                                                (*)
                                            </small>
                                        </div>

                                        <div class="col-6 col-lg-3 my-1">
                                            <input type="email" class="form-control" id="start_teaching_paypal_email_input" 
                                                   name="start_teaching_paypal_email_input"
                                                   placeholder="<%= Labels.get("start_teaching.form.paypal_email.placeholder")%>">
                                        </div>

                                        <div class="col-6 col-lg-3 my-1">
                                            <label class="col-form-label" for="start_teaching_price_per_hour_input">
                                                <%= Labels.get("start_teaching.form.payment.price_per_hour")%>
                                            </label> 
                                            <small class="start_teaching_required">
                                                (*)
                                            </small>
                                        </div>

                                        <div class="col-6 col-lg-3 my-1" id="start_teaching_price_per_hour">
                                            <div class="input-group">
                                                <input type="text" class="form-control" id="start_teaching_price_per_hour_input" 
                                                       name="start_teaching_price_per_hour_input"
                                                       onkeypress="return isNumberKey(event)"
                                                       placeholder="<%= Labels.get("start_teaching.form.payment.price_per_hour.placeholder")%>">
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
                                        <button class="btn btn-info" onclick="start_teaching_goto_tab('teaching_hours')">
                                            <span class="oi" data-glyph="chevron-left"></span>                                            
                                            <%= Labels.get("start_teaching.tabs.to")%><%= Labels.get("start_teaching.tabs.teaching_hours")%>
                                            <span class="oi" data-glyph="chevron-left"></span>                                            
                                        </button>
                                    </div>
                                </div>

                            </div>

                            <div class="card my-1 tab-pane fade" id="start_teaching_teaching_hours_tab" role="tabpanel" 
                                 aria-labelledby="start_teaching_teaching_hours_link">
                                <div class="card-header text-white bg-secondary">
                                    <div class="card-title">
                                        <%= Labels.get("start_teaching.form.available_hours.text1")%>   
                                    </div>
                                </div>
                                <div class="card-body">
                                    <div class="row no-gutters">
                                        <div class="col-12 col-lg-4">
                                            <p class="h6">
                                                <%= Labels.get("start_teaching.form.available_hours.choose_hours")%>   
                                            </p>  
                                            <p class="h6">
                                                <%= Labels.get("start_teaching.form.available_hours.choose_hours2")%>   
                                            </p>  
                                            <div class="card my-1">
                                                <div class="h6 card-header">
                                                    <%= Labels.get("start_teaching.form.available_hours.hours_chosen")%>   
                                                </div>
                                                <div class="card-body">
                                                    <p class="h6" id="start_teaching_selected_hours">

                                                    </p>
                                                </div>
                                            </div>
                                            <div class="my-2">
                                                <button class="btn btn-primary" onclick="start_teaching_clear_calendar()">
                                                    <%= Labels.get("start_teaching.form.available_hours.clear_button")%>   
                                                </button>
                                            </div>
                                        </div>

                                        <div class="px-2 col-12 col-lg-8 row no-gutters">

                                            <table id="start_teaching_calendar_table" class="d-table table table-responsive table-sm">
                                                <thead>
                                                    <tr>
                                                        <th class="start_teaching_calendar" style="width: 12.5%">
                                                        </th>                                        
                                                        <% for (day = 0; day < 7; day++) {

                                                        %>                                        
                                                        <th class="start_teaching_calendar"  style="width: 12.5%">
                                                            <span><%= dayNamesLong.get(day)%></span>
                                                            <br/>
                                                            <span id="start_teaching_day_<%= (day + 1)%>"></span>
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
                                                                cellClass = "start_teaching_row_end";
                                                            } else {
                                                                cellClass = "start_teaching_row_middle";
                                                            }
                                                            if (rowCount == 0) {
                                                                cellClass = "start_teaching_row_start";
                                                        %>
                                                        <td rowspan="<%= rowsPerCell%>" class="start_teaching_calendar">
                                                            <%= Utils.formatTime(hour, 0)%>                                                        
                                                        </td>
                                                        <% } %>

                                                        <% for (day = 0; day < 7; day++) {
                                                        %>
                                                        <td data-day="<%= day + 1%>" data-hour="<%= hour%>" data-minute="<%= minute%>"
                                                            onclick="start_teaching_select_time(this)"
                                                            class="start_teaching_calendar_time start_teaching_calendar <%= cellClass%>" id="start_teaching_day_<%= (day + 1)%>_hour_<%= hour%>_minute_<%= minute%>">                                                       
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
                                        <button class="btn btn-info" onclick="start_teaching_goto_tab('accept_and_finish')">
                                            <span class="oi" data-glyph="chevron-left"></span>                                            
                                            <%= Labels.get("start_teaching.tabs.to")%><%= Labels.get("start_teaching.tabs.accept_and_finish")%>
                                            <span class="oi" data-glyph="chevron-left"></span>                                            
                                        </button>
                                    </div>
                                </div>

                            </div>

                            <div class="card my-1 tab-pane fade" id="start_teaching_accept_and_finish_tab" role="tabpanel" 
                                 aria-labelledby="start_teaching_accept_and_finish_link">
                                <div class="card-header text-white bg-secondary">
                                    <div class="card-title">

                                        <%= Labels.get("start_teaching.form.submit.title")%>   
                                    </div>
                                </div>
                                <div class="card-body">                            
                                    <h6>
                                        <%= Labels.get("start_teaching.form.submit.accept_terms_of_usage")%>  
                                    </h6>

                                    <%
                                        String htmlFileName = Config.get("html.path") + File.separator
                                                + Config.get("website.language") + File.separator + "terms_of_usage.html";
                                        String htmlContent = Utils.getStringFromInputStream(getServletContext(), htmlFileName);

                                        out.write(htmlContent);
                                    %>

                                    <div class="row no-gutters">
                                        <div class="col-12 col-sm-6 col-lg-3 my-1" id="start_teaching_feedback">
                                            <label class="col-form-label" for="start_teaching_feedback_input">
                                                <%= Labels.get("start_teaching.form.publish.feedback_text")%>
                                            </label>  
                                        </div>

                                        <div class="col-12 col-sm-6 col-lg-9 my-1">
                                            <textarea rows="4" class="form-control" id="start_teaching_feedback_input" 
                                                      name="start_teaching_feedback_input"
                                                      placeholder="<%= Labels.get("start_teaching.form.publish.feedback_placeholder")%>"></textarea>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-footer">

                                    <div class="d-flex flex-row-reverse">

                                        <div>
                                            <button class="btn btn-success mx-1 my-auto" onclick="start_teaching_form_submit()">
                                                <span class="oi" data-glyph="chevron-left"></span>
                                                <%= Labels.get("start_teaching.form.submit.button.text")%>   
                                                <span class="oi" data-glyph="chevron-left"></span>
                                            </button>
                                        </div>

                                        <div class="checkbox mx-1 h6 my-auto" id="start_teaching_accept_terms_checkbox_div">
                                            <input class="form-check-input my-1 mx-0" id="start_teaching_accept_terms_checkbox" name="start_teaching_accept_terms_checkbox" 
                                                   type="checkbox" value="">

                                            <label class="form-check-label" for="start_teaching_accept_terms_checkbox">
                                                <%= Labels.get("start_teaching.form.submit.terms_of_usage.read_and_accept")%>  
                                            </label>
                                            <small class="start_teaching_required">
                                                (*)
                                            </small>
                                        </div>

                                    </div>
                                </div>
                            </div>

                        </div>

                    </form>
                </div>
            </div>


            <%@include file="footer.jsp" %>    

            <script>
                oc.institute_type = <%= Utils.gson().toJson(instituteTypes)%>;
                oc.institutes = <%= Utils.gson().toJson(institutes)%>;
                oc.subjects = <%= Utils.gson().toJson(subjects)%>;
                oc.cities = <%= Utils.gson().toJson(cities)%>;
            </script>

    </body>

</html>
