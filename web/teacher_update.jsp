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
    int teacherInstituteType = 0;
    if (teacher.institute != null) {
        teacher.institute = DB.get(teacher.institute.id, Institute.class);
        if (teacher.institute.institute_type != null) {
            teacher.institute.institute_type = DB.get(teacher.institute.institute_type.id, InstituteType.class);
            teacherInstituteType = teacher.institute.institute_type.id;
        }
    }
    if (teacher.subject != null) {
        teacher.subject = DB.get(teacher.subject.id, Subject.class);
    }
    if (teacher.city != null) {
        teacher.city = DB.get(teacher.city.id, City.class);
    }

    List<Topic> teachingTopics = DB.getTeacherTeachingTopics(teacher);
    List<AvailableTime> availableTime = DB.getTeacherAvailableTime(teacher);
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
    String checkedMale = "", checkedFemale = "";
    if (teacher.isMale()) {
        checkedMale = "checked";
    } else {
        checkedFemale = "checked";
    }
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
                <form id="teacher_update_form" onsubmit="return false">
                    <div class="card my-1">
                        <div class="card-header text-secondary">
                            <h5>
                                <%= Labels.get("teacher_update.heading")%>
                            </h5>
                            <h5>
                                <small>
                                    <%= Labels.get("teacher_update.heading2")%>
                                    <a href="contact">
                                        <%= Labels.get("teacher_update.contact_us")%>
                                    </a>
                                    <%= Labels.get("teacher_update.heading3")%>
                                </small>
                            </h5>
                            <h5>
                                <small>
                                    <%= Labels.get("teacher_update.required_field_1")%>  
                                    <small class="teacher_update_required">
                                        (*)
                                    </small>
                                    <%= Labels.get("teacher_update.required_field_2")%>  
                                </small>
                            </h5>
                        </div>
                    </div>
                    <div class="card my-1">
                        <div class="card-header bg-secondary text-white">
                            <div class="row no-gutters"  id="teacher_update_google_login">
                                <div class="col-12">
                                    <%= Labels.get("teacher_update.form.login.text1")%> 
                                </div>
                            </div>
                        </div>

                        <div class="card-body">
                            <div class="form-group row">
                                <div class="col-6 col-lg-3 my-1">                                    
                                    <label class="col-form-label" for="teacher_update_email_input">
                                        <%= Labels.get("teacher_update.form.login.email")%>                                        
                                    </label>                     
                                    <small class="teacher_update_required">
                                        (*)
                                    </small>
                                </div>

                                <div class="col-6 col-lg-3 my-1">
                                    <input type="email" class="form-control" id="teacher_update_email_input" 
                                           placeholder="<%= Labels.get("teacher_update.form.login.email")%>" disabled
                                           value="<%= teacher.email%>">
                                </div>

                                <div class="col-6 col-lg-3 my-1">
                                    <label class="col-form-label" for="teacher_update_display_name_input">
                                        <%= Labels.get("teacher_update.form.login.display_name")%>
                                    </label>
                                </div>
                                <div class="col-6 col-lg-3 my-1">
                                    <input type="text" class="form-control" id="teacher_update_display_name_input" 
                                           placeholder="<%= Labels.get("teacher_update.form.login.display_name")%>" 
                                           value="<%= teacher.display_name%>">
                                </div>

                                <div class="col-6 col-lg-3 my-1">
                                    <label class="col-form-label" for="teacher_update_first_name_input">
                                        <%= Labels.get("teacher_update.form.login.first_name")%>
                                    </label>
                                </div>

                                <div class="col-6 col-lg-3 my-1">
                                    <input type="text" class="form-control" id="teacher_update_first_name_input"
                                           placeholder="<%= Labels.get("teacher_update.form.login.first_name")%>" 
                                           value="<%= teacher.first_name%>"> 
                                </div>

                                <div class="col-6 col-lg-3 my-1">
                                    <label class="col-form-label" for="teacher_update_last_name_input">
                                        <%= Labels.get("teacher_update.form.login.last_name")%>
                                    </label>
                                </div>

                                <div class="col-6 col-lg-3 my-1">
                                    <input type="text" class="form-control" id="teacher_update_last_name_input" 
                                           placeholder="<%= Labels.get("teacher_update.form.login.last_name")%>"
                                           value="<%= teacher.last_name%>"> 
                                </div>

                                <div class="col-6 col-lg-3 my-1">
                                    <label class="col-form-label" for="teacher_update_gender_input">
                                        <%= Labels.get("teacher_update.form.login.gender")%>   
                                    </label>
                                    <small class="teacher_update_required">
                                        (*)
                                    </small>
                                </div>

                                <div class="col-6 col-lg-3 my-1">
                                    <div class="row form-check form-check-inline no-gutters">
                                        <input type="radio" <%= checkedMale%> class="mx-2 form-check form-check-inline" 
                                               value="<%= Config.get("website.gender.male")%>" disabled
                                               id="teacher_update_gender_input_male" 
                                               name="teacher_update_gender_input">
                                        <label class="mx-2 col-form-label" for="teacher_update_gender_input_male">
                                            <%= Labels.get("teacher_update.form.login.gender.male")%>   
                                        </label>

                                        <input type="radio" <%= checkedFemale%> class="mx-2 form-check form-check-inline" 
                                               value="<%= Config.get("website.gender.female")%>" disabled
                                               id="teacher_update_gender_input_female" 
                                               name="teacher_update_gender_input">
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
                                            </label>
                                            <small class="teacher_update_required">
                                                (*)
                                            </small>
                                        </div>

                                        <div class="input-group form-control border-0 col-12 col-md">
                                            <input type="text" class="form-control mr-3" id="teacher_update_phone_number_input"
                                                   onkeypress="return isNumberKey(event)"
                                                   value="<%= teacher.phone_number%>" disabled
                                                   placeholder="<%= Labels.get("teacher_update.form.login.phone_number")%>">
                                            <div class="dropdown">
                                                <button class="btn btn-info dropdown-toggle" type="button" 
                                                        id="teacher_update_area_code_button" data-toggle="dropdown" 
                                                        aria-haspopup="true" aria-expanded="false"  disabled
                                                        name="teacher_update_area_code_button">
                                                    <span id="teacher_update_area_code_value">                                                        
                                                        <%= teacher.phone_area%>
                                                    </span>
                                                    <span class="caret"></span>
                                                </button>
                                                <div class="dropdown-menu" aria-labelledby="teacher_update_area_code_button">                                            
                                                    <%
                                                        for (String phoneArea : phoneAreasList) {
                                                    %>

                                                    <a class="dropdown-item" href="javascript:teacher_update_select_area_code('<%= phoneArea%>')">
                                                        <%= phoneArea%>
                                                    </a>

                                                    <%
                                                        }
                                                    %>
                                                    </ul>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-6 col-lg-3 my-1" id="teacher_update_day_of_birth">
                                    <label class="col-form-label" for="teacher_update_day_of_birth_input">
                                        <%= Labels.get("teacher_update.form.login.day_of_birth")%>
                                    </label>
                                    <small class="teacher_update_required">
                                        (*)
                                    </small>
                                </div>

                                <div class="col-6 col-lg-3 my-1">
                                    <input type="text" class="form-control" id="teacher_update_day_of_birth_input"
                                           name="teacher_update_day_of_birth_input"
                                           value="<%= Utils.formatDateWithFullYear(teacher.day_of_birth)%>" disabled
                                           placeholder="<%= Labels.get("teacher_update.form.login.day_of_birth")%>">
                                </div>


                                <div class="col-6 col-lg-3 my-1">
                                    <label class="col-form-label" for="teacher_update_skype_name_input">
                                        <%= Labels.get("teacher_update.form.login.skype_name")%>
                                    </label>
                                </div>

                                <div class="col-6 col-lg-3 my-1">
                                    <input type="text" class="form-control" id="teacher_update_skype_name_input"
                                           name="teacher_update_skype_name_input"
                                           value="<%= teacher.skype_name%>"
                                           placeholder="<%= Labels.get("teacher_update.form.login.skype_name")%>">
                                </div>

                                <div class="col-6 col-lg-3 my-1">
                                    <label class="col-form-label" for="teacher_update_city_input">
                                        <%= Labels.get("teacher_update.form.login.choose_city")%>
                                    </label>
                                </div>

                                <div class="col-6 col-lg-3 my-1">
                                    <div class="dropdown">
                                        <button class="btn btn-block btn-info dropdown-toggle" type="button" 
                                                id="teacher_update_city_input" data-toggle="dropdown"                                                 
                                                aria-haspopup="true" aria-expanded="false" name="teacher_update_city_input">
                                            <%
                                                if (teacher.city != null) {
                                            %>
                                            <%= teacher.city.name %>
                                            <%
                                            } else {
                                            %>
                                            <span id="teacher_update_city_value">
                                                <%= Labels.get("teacher_update.form.login.city")%>
                                            </span>
                                            <span class="caret"></span>                                            
                                            <%
                                                }
                                            %>
                                        </button>
                                        <div class="dropdown-menu" aria-labelledby="teacher_update_city_button">                                            
                                            <%
                                                for (City city : cities) {
                                            %>

                                            <a class="dropdown-item" href="javascript:teacher_update_select_city(<%= city.id%>)">
                                                <%= city.name%>
                                            </a>

                                            <%
                                                }
                                            %>
                                            </ul>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>

                    <div class="card my-1" id="teacher_update_moto_card">
                        <div class="card-header text-white bg-secondary">
                            <%= Labels.get("teacher_update.form.publish.text1")%>   
                        </div>

                        <div class="card-body">
                            <div class="form-group row">
                                <div class="col-6 col-lg-3 my-1" id="teacher_update_moto">
                                    <label class="col-form-label" for="teacher_update_moto_input">
                                        <%= Labels.get("teacher_update.form.publish.moto_text")%>
                                    </label>  
                                    <small class="teacher_update_required">
                                        (*)
                                    </small>
                                </div>

                                <div class="col-6 col-lg-9 my-1">
                                    <textarea rows="4" class="form-control" id="teacher_update_moto_input" 
                                              name="teacher_update_moto_input"
                                              placeholder="<%= Labels.get("teacher_update.form.publish.moto_placeholder")%>"><%= teacher.moto%></textarea>
                                </div>

                                <div class="col-12 my-1">
                                    <input class="form-check-input mx-0"  
                                           id="teacher_update_show_phone" 
                                           name="teacher_update_show_phone"
                                           <% if (teacher.show_phone) {
                                                   out.write("checked");
                                               }%>
                                           type="checkbox" >
                                    <label class="form-check-label" for="teacher_update_show_phone">
                                        <%= Labels.get("teacher_update.form.publish.show_phone")%>
                                    </label>
                                </div>

                                <div class="col-12 my-1">
                                    <input class="form-check-input mx-0"  
                                           id="teacher_update_show_email" 
                                           name="teacher_update_show_email"
                                           <% if (teacher.show_email) {
                                                   out.write("checked");
                                               }%>
                                           type="checkbox">
                                    <label class="form-check-label" for="teacher_update_show_email">
                                        <%= Labels.get("teacher_update.form.publish.show_email")%>
                                    </label>
                                </div>

                                <div class="col-12 my-1">
                                    <input class="form-check-input mx-0"  
                                           id="teacher_update_show_skype" 
                                           name="teacher_update_show_skype"
                                           <% if (teacher.show_skype) {
                                                   out.write("checked");
                                               }%>
                                           type="checkbox">
                                    <label class="form-check-label" for="teacher_update_show_skype">
                                        <%= Labels.get("teacher_update.form.publish.show_skype")%>
                                    </label>
                                </div>

                            </div>
                        </div>

                    </div>

                    <div class="card my-1" id="teacher_update_education_card">

                        <div class="card-header text-white bg-secondary">
                            <%= Labels.get("teacher_update.form.learning_information.text1")%>   
                        </div>

                        <div class="card-body">

                            <div class="form-group row">
                                <a class="list-group-item list-group-item-action" 
                                   aria-expanded="<%= teacher.show_degree%>"
                                   aria-controls="start_learning_degree_information_div"                                   
                                   href="#start_learning_degree_information_div">
                                    <input class="form-check-input my-1 mx-0"  
                                           id="teacher_update_topic_show_degree" 
                                           name="teacher_update_topic_show_degree"
                                           <% if (teacher.show_degree) {
                                                   out.write("checked");
                                               }%>
                                           type="checkbox">
                                    <label class="form-check-label" for="teacher_update_topic_show_degree">
                                        <%= Labels.get("teacher_update.form.learning_information.show_degree")%>
                                    </label>
                                </a>
                            </div>
                            <div class="collapse" id="start_learning_degree_information_div" aria-expanded="<%= teacher.show_degree%>" >
                                <div class="form-group row" >
                                    <label class="col-6 col-lg-3 my-1 col-form-label" for="teacher_update_degree_type_button">
                                        <%= Labels.get("teacher_update.form.learning.degree_type.title")%>
                                    </label>

                                    <div class="col-6 col-lg-3 my-1">
                                        <button class="btn btn-info dropdown-toggle" type="button" 
                                                data-toggle="dropdown" id="teacher_update_degree_type_button"
                                                name="teacher_update_degree_type_button">

                                            <%
                                                if (teacher.degree_type == null) {
                                            %>

                                            <span class="caret"></span>                                        
                                            <%= Labels.get("teacher_update.form.learning.degree_type.select")%>

                                            <% } else {%>
                                            <%= teacher.degree_type%>
                                            <%
                                                }
                                            %>
                                        </button>
                                        <div class="dropdown-menu" aria-labelledby="teacher_update_degree_type_button">
                                            <%
                                                for (String degreeType : degreeTypes) {
                                            %>

                                            <a class="dropdown-item" href="javascript:teacher_update_select_degree_type('<%= degreeType%>')">
                                                <%= degreeType%>
                                            </a>

                                            <%
                                                }
                                            %>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group row">

                                    <label class="col-6 col-lg-3 my-1 col-form-label" for="teacher_update_institute_type">
                                        <%= Labels.get("teacher_update.form.learning.education.title")%>
                                    </label>

                                    <div class="col-6 col-lg-3 my-1">
                                        <button class="btn btn-info dropdown-toggle" type="button" 
                                                data-toggle="dropdown" id="teacher_update_institute_type_button">
                                            <%
                                                if (teacher.institute
                                                        == null) {
                                            %>
                                            <span class="caret"></span>
                                            <%= Labels.get("teacher_update.form.learning.institue_type.select")%>

                                            <% } else {%>

                                            <%= teacher.institute.institute_type.name%>
                                            <%
                                                }
                                            %>


                                        </button>
                                        <div class="dropdown-menu" aria-labelledby="teacher_update_institute_type_button">
                                            <%
                                                for (InstituteType instituteType : instituteTypes) {
                                            %>

                                            <a class="dropdown-item" href="javascript:teacher_update_select_institute_type(<%= instituteType.id%>)">
                                                <%= instituteType.name%>
                                            </a>

                                            <%
                                                }
                                            %>

                                            <a class="dropdown-item" id="teacher_update_institute_type_other" href="javascript:teacher_update_select_institute_type(0)">
                                                <%= Labels.get("teacher_update.form.learning.institue_type.other")%>
                                            </a>
                                        </div>
                                    </div>

                                    <%
                                        for (int instituteType
                                                : institutes.keySet()) {
                                            Map<Integer, String> institutesMap = institutes.get(instituteType);

                                    %>

                                    <label id="teacher_update_institute_<%= instituteType%>_label" class="col-6 col-lg-3 my-1 col-form-label d-none" 
                                           for="teacher_update_institute_<%= instituteType%>_select">
                                        <%= Labels.get("teacher_update.form.learning.institue_" + instituteType + "_select")%>
                                    </label>

                                    <div class="col-6 col-lg-3 my-1 d-none" id="teacher_update_institute_<%= instituteType%>_div">
                                        <button class="btn btn-info dropdown-toggle" type="button" 
                                                data-toggle="dropdown" id="teacher_update_institute_<%= instituteType%>_select">
                                            <%
                                                if (instituteType == teacherInstituteType) {
                                            %>    
                                            <%= teacher.institute.name%>
                                            <% } else {%>
                                            <span class="caret"></span>
                                            <%= Labels.get("teacher_update.form.learning.institue_" + instituteType + "_select")%>
                                            <% }%>
                                        </button>
                                        <div class="dropdown-menu" aria-labelledby="teacher_update_institute_<%= instituteType%>_button">
                                            <%

                                                for (int instituteId : institutesMap.keySet()) {
                                                    String instituteName = institutesMap.get(instituteId);
                                            %>

                                            <a class="dropdown-item" 
                                               href="javascript:teacher_update_select_institute_type(<%= instituteType%>, <%= instituteId%>)">
                                                <%= instituteName%>
                                            </a>

                                            <%
                                                }
                                            %>

                                            <a class="dropdown-item" id="teacher_update_institute_type_other" 
                                               href="javascript:teacher_update_select_institute_type(0)">
                                                <%= Labels.get("teacher_update.form.learning.institue_type.other")%>
                                            </a>
                                        </div>
                                    </div>

                                    <%
                                        }
                                    %>
                                    <label id="teacher_update_institute_0_label"
                                           class="col-6 col-lg-3 my-1 col-form-label d-none" 
                                           for="teacher_update_institute_0_text">
                                        <%= Labels.get("teacher_update.form.learning.institue.other.choose")%>
                                    </label>

                                    <div id="teacher_update_institute_0_div" class="col-6 col-lg-3 my-1 d-none">
                                        <input type="text" class="form-control" id="teacher_update_institute_0_text" 
                                               name="teacher_update_institute_0_text"
                                               <%
                                                   if (teacher.institute_name
                                                           != null) {
                                               %>
                                               value="<%= teacher.institute_name%>"
                                               <%
                                                   }
                                               %>
                                               placeholder="<%= Labels.get("teacher_update.form.learning.institue.other.choose")%>">
                                    </div>

                                </div>
                                <div class="form-group row">
                                    <label class="col-6 col-lg-3 my-1 col-form-label" for="teacher_update_subject">
                                        <%= Labels.get("teacher_update.form.learning.subject.title")%>
                                    </label>

                                    <div class="col-6 col-lg-3 my-1">
                                        <button class="btn btn-info dropdown-toggle" type="button" 
                                                data-toggle="dropdown" id="teacher_update_subject_button">
                                            <%
                                                if (teacher.subject != null) {
                                            %>
                                            <%= teacher.subject.name%>
                                            <%
                                            } else {
                                            %>
                                            <span class="caret"></span>
                                            <%= Labels.get("teacher_update.form.learning.subject.select")%>
                                            <%
                                                }
                                            %>
                                        </button>
                                        <div class="dropdown-menu" aria-labelledby="teacher_update_subject_button">
                                            <%                                                for (Subject subject : subjects) {
                                            %>

                                            <a class="dropdown-item" href="javascript:teacher_update_select_subject(<%= subject.id%>)">
                                                <%= subject.name%>
                                            </a>

                                            <%
                                                }
                                            %>

                                            <a class="dropdown-item" id="teacher_update_subject_other" href="javascript:teacher_update_select_subject(0)">
                                                <%= Labels.get("teacher_update.form.learning.subject.other")%>
                                            </a>
                                        </div>
                                    </div>   

                                    <label id="teacher_update_subject_0_label" class="col-6 col-lg-3 my-1 col-form-label d-none" 
                                           for="teacher_update_subject_0_text">
                                        <%= Labels.get("teacher_update.form.learning.subject.other.choose")%>
                                    </label>

                                    <div id="teacher_update_subject_0_div" class="col-6 col-lg-3 my-1 d-none">
                                        <input type="text" class="form-control" id="teacher_update_subject_0_text" 
                                               name="teacher_update_institute_0_text"
                                               <%
                                                   if (teacher.subject_name
                                                           != null) {
                                               %>
                                               value="<%= teacher.subject_name%>"
                                               <%
                                                   }
                                               %>
                                               placeholder="<%= Labels.get("teacher_update.form.learning.subject.other.choose")%>">
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card my-1" id="teacher_update_topics_card">
                        <div class="card-header text-white bg-secondary">
                            <%= Labels.get("teacher_update.form.teaching_topics.text1")%>   
                        </div>

                        <div class="card-body">
                            <div class="row no-gutters">
                                <%
                                    for (Subject subject
                                            : allSubjects.values()) {
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
                                                   href="javascript:teacher_update_select_topic(<%= topic.id%>)">
                                                    <input class="form-check-input my-1 mx-0"  
                                                           id="teacher_update_topic_<%= topic.id%>_checkbox" 
                                                           name="teacher_update_topic_<%= topic.id%>_checkbox" 
                                                           <%
                                                               if (teachingTopics.contains(topic)) {
                                                                   out.write("checked");
                                                               }
                                                           %>
                                                           type="checkbox" data-topic-id="<%=topic.id%>">
                                                    <label class="form-check-label" for="teacher_update_topic_<%= topic.id%>_checkbox">
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
                    </div>


                    <div class="card my-1" id="teacher_update_payment_card">
                        <div class="card-header text-white bg-secondary">
                            <%= Labels.get("teacher_update.form.payment.text1")%>   
                        </div>
                        <div class="card-body">
                            <div class="form-group row">
                                <div class="col-6 col-lg-3 my-1" id="teacher_update_paypal_email">
                                    <label class="col-form-label" for="teacher_update_paypal_email_input">
                                        <%= Labels.get("teacher_update.form.payment.paypal_email")%>
                                    </label>   
                                    <small class="teacher_update_required">
                                        (*)
                                    </small>
                                </div>

                                <div class="col-6 col-lg-3 my-1">
                                    <input type="email" class="form-control" id="teacher_update_paypal_email_input" 
                                           name="teacher_update_paypal_email_input"
                                           value="<%= teacher.paypal_email%>" disabled
                                           placeholder="<%= Labels.get("teacher_update.form.paypal_email.placeholder")%>">
                                </div>

                                <div class="col-6 col-lg-3 my-1">
                                    <label class="col-form-label" for="teacher_update_price_per_hour_input">
                                        <%= Labels.get("teacher_update.form.payment.price_per_hour")%>
                                    </label> 
                                    <small class="teacher_update_required">
                                        (*)
                                    </small>
                                </div>

                                <div class="col-6 col-lg-3 my-1" id="teacher_update_price_per_hour">
                                    <div class="input-group">
                                        <input type="text" class="form-control" id="teacher_update_price_per_hour_input" 
                                               name="teacher_update_price_per_hour_input"
                                               onkeypress="return isNumberKey(event)"
                                               value="<%= teacher.price_per_hour%>"
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

                    </div>

                    <div class="card my-1" id="teacher_update_available_hours_card">
                        <div class="card-header text-white bg-secondary">
                            <%= Labels.get("teacher_update.form.available_hours.text1")%>   
                        </div>
                        <div class="card-body">
                            <div class="row no-gutters">
                                <div class="col-12 col-lg-6">
                                    <p class="h6">
                                        <%= Labels.get("teacher_update.form.available_hours.choose_hours")%>   
                                    </p>  
                                    <p class="h6">
                                        <%= Labels.get("teacher_update.form.available_hours.choose_hours2")%>   
                                    </p>  
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
                                        <button class="btn btn-primary" onclick="teacher_update_clear_calendar()">
                                            <%= Labels.get("teacher_update.form.available_hours.clear_button")%>   
                                        </button>
                                    </div>
                                </div>

                                <div class="col-12 col-lg-6 row no-gutters">
                                    <div class="mx-auto">
                                        <table id="teacher_update_calendar_table" class="table table-responsive table-sm">
                                            <thead>
                                                <tr>
                                                    <th class="teacher_update_calendar" style="width: 12%">
                                                    </th>                                        
                                                    <% for (day = 0;
                                                                day < 7; day++) {

                                                    %>                                        
                                                    <th class="teacher_update_calendar"  style="width: 12%">
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
                                                        onclick="teacher_update_select_time(this)"
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
                        </div>

                    </div>

                    <div class="card my-1" id="teacher_update_accept_terms_card">
                        <div class="card-header text-white bg-secondary">
                            <h6>
                                <%= Labels.get("teacher_update.form.submit.title")%>   
                            </h6>                            
                        </div>
                        <div class="card-footer">
                            <button class="btn btn-success my-2" onclick="teacher_update_form_submit()">
                                <%= Labels.get("teacher_update.form.submit.button.text")%>   
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>


        <%@include file="footer.jsp" %>    

        <script>
            teacher_update.teacher = <%= Utils.gson().toJson(teacher)%>
            teacher_update.available_time = <%= Utils.gson().toJson(availableTime)%>
            oc.institute_type = <%= Utils.gson().toJson(instituteTypes)%>;
            oc.institutes = <%= Utils.gson().toJson(institutes)%>;
            oc.subjects = <%= Utils.gson().toJson(subjects)%>;
            teacher_update_init();
        </script>

    </body>

</html>
