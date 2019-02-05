<%@include file="start.jsp" %>

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

<%    String phoneAreas = CLabels.get("website.phone_areas");
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

%>
<!DOCTYPE html>
<html lang="<%= Config.get("website.html_language")%>" dir="<%= Config.get("webiste.direction")%>">
    <head>
        <%@include file="header.jsp" %>
        <title>
            <%= Labels.get("student_update.title")%>
        </title>
    </head>
    <body lang="<%= Config.get("website.html_language")%>" dir="<%= Config.get("webiste.direction")%>">
        <%@include file="body.jsp" %>    

        <div class="container">
            <div class="row no-gutters my-1">
                <div class="col-12">


                    <div class="card my-1">
                        <div class="card-header text-secondary">
                            <h5>
                                <%= Labels.get("student_update.heading")%>
                            </h5>
                            <p>
                                <%= Labels.get("student_update.text1")%>       
                                <br/>
                                <%= Labels.get("student_update.text2")%>      
                                <br/>
                                <%= Labels.get("student_update.required_field_1")%>  
                                <small class="student_update_required">
                                    (*)
                                </small>
                                <%= Labels.get("student_update.required_field_2")%>  
                            </p>
                        </div>
                    </div>

                    <div>
                        <ul class="nav nav-tabs my-1" id="student_update_tab_list">     
                            <li class="nav-item">
                                <a  id="student_update_personal_information_link" class="nav-link" data-toggle="tab" 
                                    href="#student_update_personal_information_tab">
                                    <%= Labels.get("student_update.tabs.personal_information")%>
                                </a>
                            </li>                            
                            <li class="nav-item">
                                <a  id="student_update_education_link" class="nav-link" data-toggle="tab" 
                                    href="#student_update_education_tab">
                                    <%= Labels.get("student_update.tabs.education")%>
                                </a>
                            </li>
                            <li class="nav-item">
                                <a  id="student_update_learning_topics_link" class="nav-link" data-toggle="tab" 
                                    href="#student_update_learning_topics_tab">
                                    <%= Labels.get("student_update.tabs.learning_topics")%>
                                </a>
                            </li>
                            <li class="nav-item">
                                <a  id="student_update_accept_and_finish_link" class="nav-link" data-toggle="tab" 
                                    href="#student_update_accept_and_finish_tab">
                                    <%= Labels.get("student_update.tabs.accept_and_finish")%>
                                </a>
                            </li>
                        </ul> 
                    </div>
                    <div class="tab-content" id="student_update_tabs">
                        
                        <div class="card my-1 tab-pane fade show" id="student_update_personal_information_tab" role="tabpanel" 
                             aria-labelledby="student_update_personal_information_link">
                            <div class="card-header bg-secondary text-white">                                   
                                <div class="card-title">
                                    <%= Labels.get("student_update.form.personal_information.text1")%>                                                                                     
                                </div>
                            </div>
                            <div class="card-body">
                                <div class="form-group row">
                                    <div class="col-12 col-sm-6 col-lg-3 my-1">                                    
                                        <label class="col-form-label" for="student_update_email_input">
                                            <%= Labels.get("student_update.form.login.email")%>  
                                            <small class="student_update_required">
                                                (*)
                                            </small>                                            
                                        </label>                     

                                    </div>

                                    <div class="col-12 col-sm-6 col-lg-3 my-1">
                                        <input type="email" class="form-control" id="student_update_email_input" 
                                               placeholder="<%= Labels.get("student_update.form.login.email")%>" disabled>
                                    </div>

                                    <div class="col-12 col-sm-6 col-lg-3 my-1">
                                        <label class="col-form-label" for="student_update_display_name_input">
                                            <%= Labels.get("student_update.form.login.display_name")%>
                                            <small class="student_update_required">
                                                (*)
                                            </small>
                                            <br/>
                                            <small>
                                                <%= Labels.get("student_update.form.login.display_name.small_text")%>
                                            </small>
                                        </label>
                                    </div>
                                    <div class="col-12 col-sm-6 col-lg-3 my-1">
                                        <input type="text" class="form-control student_update_required" id="student_update_display_name_input" 
                                               placeholder="<%= Labels.get("student_update.form.login.display_name")%>" disabled>
                                    </div>

                                    <div class="col-12 col-sm-6 col-lg-3 my-1">
                                        <label class="col-form-label" for="student_update_first_name_input">
                                            <%= Labels.get("student_update.form.login.first_name")%>
                                        </label>
                                    </div>

                                    <div class="col-12 col-sm-6 col-lg-3 my-1">
                                        <input type="text" class="form-control" id="student_update_first_name_input"
                                               placeholder="<%= Labels.get("student_update.form.login.first_name")%>" disabled>
                                    </div>

                                    <div class="col-12 col-sm-6 col-lg-3 my-1">
                                        <label class="col-form-label" for="student_update_last_name_input">
                                            <%= Labels.get("student_update.form.login.last_name")%>
                                        </label>
                                    </div>

                                    <div class="col-12 col-sm-6 col-lg-3 my-1">
                                        <input type="text" class="form-control" id="student_update_last_name_input" 
                                               placeholder="<%= Labels.get("student_update.form.login.last_name")%>" disabled>
                                    </div>

                                    <div class="col-12 col-sm-6 col-lg-3 my-1">
                                        <label class="col-form-label" for="student_update_gender_input">
                                            <%= Labels.get("student_update.form.login.gender")%>   
                                        </label>
                                        <small class="student_update_required">
                                            (*)
                                        </small>
                                    </div>

                                    <div class="col-12 col-sm-6 col-lg-3 my-1">
                                        <div class="row form-check form-check-inline no-gutters">
                                            <input type="radio" checked class="mx-2 form-check form-check-inline" 
                                                   value="<%= CConfig.get("website.gender.male")%>" 
                                                   id="student_update_gender_input_male" name="student_update_gender_input">
                                            <label class="mx-2 col-form-label" for="student_update_gender_input_male">
                                                <%= Labels.get("student_update.form.login.gender.male")%>   
                                            </label>

                                            <input type="radio" class="mx-2 form-check form-check-inline" 
                                                   value="<%= CConfig.get("website.gender.female")%>" 
                                                   id="student_update_gender_input_female" name="student_update_gender_input">
                                            <label class="mx-2 col-form-label" for="student_update_gender_input_female">
                                                <%= Labels.get("student_update.form.login.gender.female")%>   
                                            </label>
                                        </div>
                                    </div>

                                    <div class="col-12 col-lg-6 my-0">
                                        <div class="row no-gutters" id="student_update_phone_number">   
                                            <div class="col-12 col-md my-1">
                                                <label class="col-form-label" for="student_update_phone_number_input">
                                                    <%= Labels.get("student_update.form.login.phone_number")%>
                                                </label>                                                    
                                            </div>

                                            <div class="input-group form-control border-0 col-12 col-md">
                                                <input type="text" class="col-8 form-control mr-md-3" 
                                                       id="student_update_phone_number_input"                                                           
                                                       onkeypress="return isNumberKey(event)"
                                                       placeholder="<%= Labels.get("student_update.form.login.phone_number")%>">

                                                <select class="col-4 custom-select form-control" 
                                                        id="student_update_phone_area_select">
                                                    <option value="" disabled selected>
                                                        <%= Labels.get("student_update.form.login.phone_area")%>
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

                                    <div class="col-6 col-lg-3 my-1" id="student_update_day_of_birth">
                                        <label class="col-form-label" for="student_update_day_of_birth_input">
                                            <%= Labels.get("student_update.form.login.day_of_birth")%>
                                        </label>
                                        <br/>
                                        <small>
                                            <%= Labels.get("student_update.form.login.day_of_birth.small_text")%>
                                        </small>
                                    </div>

                                    <div class="col-12 col-sm-6 col-lg-3 my-1">
                                        <input type="text" class="form-control" id="student_update_day_of_birth_input"
                                               name="student_update_day_of_birth_input"
                                               placeholder="<%= Labels.get("student_update.form.login.day_of_birth")%>">
                                    </div>

                                    <div class="col-6 col-lg-3 my-1" id="student_update_city">
                                        <label class="col-form-label" for="student_update_city_input">
                                            <%= Labels.get("student_update.form.login.choose_city")%>                                                                                    
                                            <br/>
                                            <small>
                                                <%= Labels.get("student_update.form.login.choose_city.small")%>
                                            </small>
                                        </label>

                                    </div>

                                    <div class="col-12 col-sm-6 col-lg-3 my-1">
                                        <select class="custom-select form-control" id="student_update_city_select">
                                            <option value="0" disabled selected>
                                                <%= Labels.get("student_update.form.login.city")%>
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

                                    <div class="col-12 col-sm-6 col-lg-3 my-1" id="student_update_image">
                                        <label class="col-form-label" for="student_update_image_input">
                                            <%= Labels.get("student_update.form.personal_information.choose_avatar_image")%>
                                            <small class="student_update_required">
                                                (*)
                                            </small>
                                            <br/>
                                            <small>
                                                <%= Labels.get("student_update.form.personal_information.avatar_image_small_text")%>
                                            </small>
                                        </label>

                                    </div>
                                    <iframe id="student_update_post_hidden_iframe" name="student_update_post_hidden_iframe" class="d-none"></iframe>                                                

                                    <div class="col-12 col-sm-6 col-lg-3 my-1" id="student_update_image">                                            
                                        <div class="row no-gutters">
                                            <div class="col-6 px-1">    
                                                <img id="student_update_image_img" class="w-100"></img>                                                  

                                                <p id="student_update_image_loading" class="border rounded d-none text-center">
                                                    <%= Labels.get("student_update.form.personal_information.image_loading")%>
                                                </p>
                                            </div>

                                            <div class="col-6 px-1">    
                                                <form action="/servlets/teacher_image_upload" method="post" 
                                                      enctype="multipart/form-data"
                                                      id="student_update_image_upload_form"                                                      
                                                      target="student_update_post_hidden_iframe">
                                                    <input type="hidden" id="student_update_image_id" name="image_id">

                                                    <div class="common_relative_container w-100">                                                            
                                                        <input type="file" name="img_upload_input" tabindex="-1"
                                                               id="img_upload_input"
                                                               tabindex="-1" class="file_chooser_hidden"
                                                               onchange="student_update_img_upload()">  
                                                        <button type="button" class="btn btn-success btn-block">
                                                            <%= Labels.get("student_update.form.personal_information.upload_from_file")%>
                                                        </button>

                                                    </div>
                                                    <button type="button" onclick="student_update_reset_img_upload()" class="btn btn-success btn-block d-none" id="student_update_img_upload_reset_image">
                                                        <%= Labels.get("student_update.form.personal_information.reset_to_social_image")%>
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div>
                            <div class="card-footer">
                                <div class="d-flex flex-row-reverse">
                                    <button type="button" class="btn btn-info student_update_tabs_button" 
                                            id="student_update_goto_tab_education_button"
                                            onclick="student_update_goto_tab('education')">
                                        <span class="oi" data-glyph="chevron-left"></span>
                                        <%= Labels.get("student_update.tabs.to")%><%= Labels.get("student_update.tabs.education")%>
                                        <span class="oi" data-glyph="chevron-left"></span>                                            
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div class="card my-1 tab-pane fade" id="student_update_education_tab" role="tabpanel" 
                             aria-labelledby="student_update_education_link">

                            <div class="card-header text-white bg-secondary">
                                <div class="card-title">
                                    <%= Labels.get("student_update.form.learning_information.text1")%>   
                                </div>
                            </div>

                            <div class="card-body">
                                <div class="form-group row" aria-expanded="false" >

                                    <label class="col-12 col-sm-6 col-lg-3 my-1 col-form-label" for="student_update_degree_type_button">
                                        <%= Labels.get("student_update.form.learning.degree_type.title")%>
                                    </label>

                                    <div class="col-12 col-sm-6 col-lg-3 my-1">
                                        <select class="custom-select" id="student_update_degree_type_select">

                                            <option id="student_update_degree_type_choose" value="" disabled selected>
                                                <%= Labels.get("student_update.form.learning.degree_type.choose")%>
                                            </option>
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

                                    <label class="col-12 col-sm-6 col-lg-3 my-1 col-form-label" for="student_update_institute_type">
                                        <%= Labels.get("student_update.form.learning.education.title")%>
                                    </label>

                                    <div class="col-12 col-sm-6 col-lg-3 my-1">
                                        <select class="custom-select" id="student_update_institute_type_select">

                                            <option id="student_update_institute_type_choose" value="0" disabled selected>
                                                <%= Labels.get("student_update.form.learning.institue_type.choose")%>
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

                                            <option id="student_update_institute_type_other" value="0">
                                                <%= Labels.get("student_update.form.learning.institue_type.other")%>
                                            </option>
                                        </select>
                                    </div>

                                    <%
                                        for (int instituteType : institutes.keySet()) {
                                            Map<Integer, String> institutesMap = institutes.get(instituteType);

                                    %>

                                    <label id="student_update_institute_<%= instituteType%>_label" class="col-6 col-lg-3 my-1 col-form-label d-none" 
                                           for="student_update_institute_<%= instituteType%>_select">
                                        <%= Labels.get("student_update.form.learning.institue_" + instituteType + "_select")%>
                                    </label>

                                    <div class="col-12 col-sm-6 col-lg-3 my-1 d-none" id="student_update_institute_<%= instituteType%>_div">

                                        <select class="custom-select student_update_institute_select" id="student_update_institute_<%= instituteType%>_select">

                                            <option value="" disabled selected>
                                                <%= Labels.get("student_update.form.learning.institue_" + instituteType + ".choose")%>
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
                                                <%= Labels.get("student_update.form.learning.institue_type.other")%>
                                            </option>
                                        </select>
                                    </div>

                                    <%
                                        }
                                    %>
                                    <label id="student_update_institute_0_label"
                                           class="col-12 col-sm-6 col-lg-3 my-1 col-form-label d-none" 
                                           for="student_update_institute_0_text">
                                        <%= Labels.get("student_update.form.learning.institue.other.choose")%>
                                    </label>

                                    <div id="student_update_institute_0_div" class="col-12 col-sm-6 col-lg-3 my-1 d-none">
                                        <input type="text" class="form-control" id="student_update_institute_0_text" 
                                               name="student_update_institute_0_text"
                                               placeholder="<%= Labels.get("student_update.form.learning.institue.other.choose")%>">
                                    </div>

                                </div>
                                <div class="form-group row">
                                    <label class="col-12 col-sm-6 col-lg-3 my-1 col-form-label" for="student_update_subject">
                                        <%= Labels.get("student_update.form.learning.subject.title")%>
                                    </label>

                                    <div class="col-12 col-sm-6 col-lg-3 my-1">
                                        <select class="custom-select" id="student_update_subject_select">
                                            <option value="0" disabled selected>
                                                <%= Labels.get("student_update.form.learning.subject.choose")%>
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
                                                <%= Labels.get("student_update.form.learning.subject.other")%>
                                                </a>
                                        </select>
                                    </div>   

                                    <label id="student_update_subject_0_label" class="col-12 col-sm-6 col-lg-3 my-1 col-form-label d-none" 
                                           for="student_update_subject_0_text">
                                        <%= Labels.get("student_update.form.learning.subject.other.choose")%>
                                    </label>

                                    <div id="student_update_subject_0_div" class="col-12 col-sm-6 col-lg-3 my-1 d-none">
                                        <input type="text" class="form-control" id="student_update_subject_0_text" 
                                               name="student_update_institute_0_text"
                                               placeholder="<%= Labels.get("student_update.form.learning.subject.other.choose")%>">
                                    </div>

                                </div>

                            </div>

                            <div class="card-footer">
                                <div class="d-flex flex-row-reverse">
                                    <button type="button" class="btn btn-info student_update_tabs_button" 
                                            id="student_update_goto_tab_learning_topics_button"
                                            onclick="student_update_goto_tab('learning_topics')">
                                        <span class="oi" data-glyph="chevron-left"></span>                                            
                                        <%= Labels.get("student_update.tabs.to")%><%= Labels.get("student_update.tabs.learning_topics")%>
                                        <span class="oi" data-glyph="chevron-left"></span>                                            
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div class="card my-1 tab-pane fade" id="student_update_learning_topics_tab" role="tabpanel" 
                             aria-labelledby="student_update_learning_topics_link">
                            <div class="card-header text-white bg-secondary">
                                <div class="card-title">
                                    <%= Labels.get("student_update.form.learning_topics.text1")%>   
                                </div>
                            </div>

                            <div class="card-body">
                                <div class="row no-gutters" id="student_update_topic_list">
                                    <%
                                        for (Subject subject : allSubjects.values()) {
                                    %>
                                    <div class="col-12 px-1">
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
                                                        <span class="text-bold text-primary">
                                                            <%= topic.name%>
                                                        </span>
                                                        <br/>
                                                        <small>
                                                            <%= topic.description%>
                                                        </small>
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
                                    <button type="button" class="btn btn-info student_update_tabs_button" 
                                            id="student_update_goto_tab_accept_and_finish_button"
                                            onclick="student_update_goto_tab('accept_and_finish')">
                                        <span class="oi" data-glyph="chevron-left"></span>                                            
                                        <%= Labels.get("student_update.tabs.to")%><%= Labels.get("student_update.tabs.accept_and_finish")%>
                                        <span class="oi" data-glyph="chevron-left"></span>                                            
                                    </button>
                                </div>
                            </div>

                        </div>

                        <div class="card my-1 tab-pane fade" id="student_update_accept_and_finish_tab" role="tabpanel" 
                             aria-labelledby="student_update_accept_and_finish_link">
                            <div class="card-header text-white bg-secondary">
                                <div class="card-title">
                                    <%= Labels.get("student_update.form.submit.title")%>   
                                </div>
                            </div>
                            <div class="card-body">                            
                                <h6>
                                    <%= Labels.get("student_update.form.submit.accept_terms_of_usage")%>  
                                </h6>
                                <p>
                                    <a href="javascript:student_update_terms_of_usage()">
                                        <%= Labels.get("student_update.form.publish.read_terms_of_usage")%>
                                    </a>
                                </p>

                                <div class="row no-gutters">
                                    <div class="col-12 col-sm-6 col-lg-3 mx-1 my-1" id="student_update_feedback">
                                        <label class="col-form-label" for="student_update_feedback_input">
                                            <%= Labels.get("student_update.form.publish.feedback_text")%>
                                        </label>  
                                    </div>

                                    <div class="col-12 col-sm-6 col-lg-9 mx-1 my-1">
                                        <textarea rows="4" class="form-control" id="student_update_feedback_input" 
                                                  name="student_update_feedback_input"
                                                  placeholder="<%= Labels.get("student_update.form.publish.feedback_placeholder")%>"></textarea>
                                    </div>
                                </div>
                            </div>
                            <div class="card-footer">

                                <div class="d-flex flex-row-reverse">

                                    <div>
                                        <button type="button" class="btn btn-success mx-1 my-auto disabled student_update_tabs_button"
                                                id="student_update_form_submit_button"
                                                onclick="student_update_form_submit()">
                                            <span class="oi" data-glyph="chevron-left"></span>
                                            <%= Labels.get("student_update.form.submit.button.text")%>   
                                            <span class="oi" data-glyph="chevron-left"></span>
                                        </button>
                                    </div>

                                    <div class="checkbox mx-1 h6 my-auto" id="student_update_accept_terms_checkbox_div">
                                        <input class="form-check-input my-1 mx-0 student_update_required" id="student_update_accept_terms_checkbox" 
                                               name="student_update_accept_terms_checkbox" 
                                               type="checkbox" value="">

                                        <label class="form-check-label" for="student_update_accept_terms_checkbox">
                                            <%= Labels.get("student_update.form.submit.terms_of_usage.read_and_accept")%>  
                                        </label>
                                        <small class="student_update_required">
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
            oc.institute_type = <%= Utils.gson().toJson(instituteTypes)%>;
            oc.institutes = <%= Utils.gson().toJson(institutes)%>;
            oc.subjects = <%= Utils.gson().toJson(subjects)%>;
            oc.cities = <%= Utils.gson().toJson(cities)%>;
        </script>
    </body>

</html>
