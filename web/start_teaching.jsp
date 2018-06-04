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
    List<String> phoneAreasList = Utils.toList(phoneAreas);
    List<InstituteType> instituteTypes = DB.getAllInstituteTypes();
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
            <%= Labels.get("start_teaching.title")%>
        </title>
    </head>
    <body lang="<%= Config.get("website.html_language")%>" dir="<%= Config.get("webiste.direction")%>">
        <%@include file="body.jsp" %>    

        <div class="container">
            <div class="row no-gutters my-1">
                <form onsubmit="return false">
                    <div class="card my-1">
                        <div class="card-header text-secondary">
                            <h5>
                                <%= Labels.get("start_teaching.heading")%>
                            </h5>
                            <p>
                                <%= Labels.get("start_teaching.text1")%>       
                                <br/>
                                <%= Labels.get("start_teaching.text2")%>       
                            </p>
                        </div>
                    </div>
                    <div class="card my-1">
                        <div class="card-header bg-secondary text-white">
                            <div class="row no-gutters">
                                <div class="col-9">
                                    <%= Labels.get("start_teaching.form.login.text1")%>    
                                </div>
                                <div class="col-3">
                                    <input type="image" src="images/google_login_button.png" class="w-100" onclick="start_teaching_googleLogin()">              
                                </div>
                                <div class="col-3 d-none">                        
                                    <input type="image" src="images/facebook_login_button.png" class="w-100" onclick="start_teaching_facebookLogin()">                             
                                </div>
                            </div>
                        </div>

                        <div class="card-body">
                            <div class="form-group row">
                                <div class="col-6 col-lg-3 my-1">
                                    <label class="col-form-label" for="start_teaching_email_input">
                                        <%= Labels.get("start_teaching.form.login.email")%>
                                    </label>
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
                                           placeholder="<%= Labels.get("start_teaching.form.login.display_name")%>">
                                </div>

                                <div class="col-6 col-lg-3 my-1">
                                    <label class="col-form-label" for="start_teaching_first_name_input">
                                        <%= Labels.get("start_teaching.form.login.first_name")%>
                                    </label>
                                </div>

                                <div class="col-6 col-lg-3 my-1">
                                    <input type="text" class="form-control" id="start_teaching_first_name_input"
                                           placeholder="<%= Labels.get("start_teaching.form.login.first_name")%>">
                                </div>

                                <div class="col-6 col-lg-3 my-1">
                                    <label class="col-form-label" for="start_teaching_last_name_input">
                                        <%= Labels.get("start_teaching.form.login.last_name")%>
                                    </label>
                                </div>

                                <div class="col-6 col-lg-3 my-1">
                                    <input type="text" class="form-control" id="start_teaching_last_name_input" 
                                           placeholder="<%= Labels.get("start_teaching.form.login.last_name")%>">
                                </div>

                                <div class="col-6 col-lg-3 my-1">
                                    <label class="col-form-label" for="start_teaching_gender_input">
                                        <%= Labels.get("start_teaching.form.login.gender")%>   
                                    </label>
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
                                    <div class="row no-gutters">   
                                        <div class="col my-1">
                                            <label class="col-form-label" for="start_teaching_phone_number_input">
                                                <%= Labels.get("start_teaching.form.login.phone_number")%>
                                            </label>
                                        </div>

                                        <div class="input-group form-control border-0 col">
                                            <input type="text" class="form-control mr-3" id="start_teaching_phone_number_input"
                                                   onkeypress="return isNumberKey(event)"
                                                   placeholder="<%= Labels.get("start_teaching.form.login.phone_number")%>">

                                            <div class="dropdown">
                                                <button class="btn btn-info dropdown-toggle" type="button" 
                                                        id="start_teaching_area_code_button" data-toggle="dropdown" 
                                                        aria-haspopup="true" aria-expanded="false" name="start_teaching_area_code_button">
                                                    <span id="start_teaching_area_code_value">
                                                        <%= Labels.get("start_teaching.form.login.phone_area")%>
                                                    </span>
                                                    <span class="caret"></span>
                                                </button>
                                                <div class="dropdown-menu" aria-labelledby="start_teaching_area_code_button">                                            
                                                    <%
                                                        for (String phoneArea : phoneAreasList) {
                                                    %>

                                                    <a class="dropdown-item" href="javascript:start_teaching_select_area_code('<%= phoneArea%>')">
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

                                <div class="col-6 col-lg-3 my-1">
                                    <label class="col-form-label" for="start_teaching_day_of_birth_input">
                                        <%= Labels.get("start_teaching.form.login.day_of_birth")%>
                                    </label>
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

                            </div>
                        </div>
                    </div>

                    <div class="card my-1" id="start_teaching_moto_card">
                        <div class="card-header text-white bg-secondary">
                            <%= Labels.get("start_teaching.form.publish.text1")%>   
                        </div>

                        <div class="card-body">
                            <div class="form-group row">
                                <div class="col-6 col-lg-3 my-1">
                                    <label class="col-form-label" for="start_teaching_moto_input">
                                        <%= Labels.get("start_teaching.form.publish.moto_text")%>
                                    </label>                                    
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

                    </div>

                    <div class="card my-1" id="start_teaching_education_card">

                        <div class="card-header text-white bg-secondary">
                            <%= Labels.get("start_teaching.form.learning_information.text1")%>   
                        </div>

                        <div class="card-body">

                            <div class="form-group row">
                                <a class="list-group-item list-group-item-action" 
                                   aria-expanded="false"
                                   aria-controls="start_learning_degree_information_div"                                   
                                   href="#start_learning_degree_information_div">
                                    <input class="form-check-input my-1 mx-0"  
                                           id="start_teaching_topic_show_degree" 
                                           name="start_teaching_topic_show_degree"
                                           type="checkbox" value="">
                                    <label class="form-check-label" for="start_teaching_topic_show_degree">
                                        <%= Labels.get("start_teaching.form.learning_information.show_degree")%>
                                    </label>
                                </a>
                            </div>
                            <div class="collapse" id="start_learning_degree_information_div">
                                <div class="form-group row" aria-expanded="false" >

                                    <label class="col-6 col-lg-3 my-1 col-form-label" for="start_teaching_degree_type_button">
                                        <%= Labels.get("start_teaching.form.learning.degree_type.title")%>
                                    </label>

                                    <div class="col-6 col-lg-3 my-1">
                                        <button class="btn btn-info dropdown-toggle" type="button" 
                                                data-toggle="dropdown" id="start_teaching_degree_type_button"
                                                name="start_teaching_degree_type_button">
                                            <span class="caret"></span>                                        
                                            <%= Labels.get("start_teaching.form.learning.degree_type.select")%>
                                        </button>
                                        <div class="dropdown-menu" aria-labelledby="start_teaching_degree_type_button">
                                            <%
                                                for (String degreeType : degreeTypes) {
                                            %>

                                            <a class="dropdown-item" href="javascript:start_teaching_select_degree_type('<%= degreeType%>')">
                                                <%= degreeType%>
                                            </a>

                                            <%
                                                }
                                            %>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group row">

                                    <label class="col-6 col-lg-3 my-1 col-form-label" for="start_teaching_institute_type">
                                        <%= Labels.get("start_teaching.form.learning.education.title")%>
                                    </label>

                                    <div class="col-6 col-lg-3 my-1">
                                        <button class="btn btn-info dropdown-toggle" type="button" 
                                                data-toggle="dropdown" id="start_teaching_institute_type_button">
                                            <span class="caret"></span>
                                            <%= Labels.get("start_teaching.form.learning.institue_type.select")%>
                                        </button>
                                        <div class="dropdown-menu" aria-labelledby="start_teaching_institute_type_button">
                                            <%
                                                for (InstituteType instituteType : instituteTypes) {
                                            %>

                                            <a class="dropdown-item" href="javascript:start_teaching_select_institute_type(<%= instituteType.id%>)">
                                                <%= instituteType.name%>
                                            </a>

                                            <%
                                                }
                                            %>

                                            <a class="dropdown-item" id="start_teaching_institute_type_other" href="javascript:start_teaching_select_institute_type(0)">
                                                <%= Labels.get("start_teaching.form.learning.institue_type.other")%>
                                            </a>
                                        </div>
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
                                        <button class="btn btn-info dropdown-toggle" type="button" 
                                                data-toggle="dropdown" id="start_teaching_institute_<%= instituteType%>_select">
                                            <span class="caret"></span>
                                            <%= Labels.get("start_teaching.form.learning.institue_" + instituteType + "_select")%>

                                        </button>
                                        <div class="dropdown-menu" aria-labelledby="start_teaching_institute_<%= instituteType%>_button">
                                            <%

                                                for (int instituteId : institutesMap.keySet()) {
                                                    String instituteName = institutesMap.get(instituteId);
                                            %>

                                            <a class="dropdown-item" 
                                               href="javascript:start_teaching_select_institute_type(<%= instituteType%>, <%= instituteId%>)">
                                                <%= instituteName%>
                                            </a>

                                            <%
                                                }
                                            %>

                                            <a class="dropdown-item" id="start_teaching_institute_type_other" 
                                               href="javascript:start_teaching_select_institute_type(0)">
                                                <%= Labels.get("start_teaching.form.learning.institue_type.other")%>
                                            </a>
                                        </div>
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
                    </div>

                    <div class="card my-1" id="start_teaching_topics_card">
                        <div class="card-header text-white bg-secondary">
                            <%= Labels.get("start_teaching.form.teaching_topics.text1")%>   
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
                                                    <input class="form-check-input my-1 mx-0"  
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
                    </div>


                    <div class="card my-1" id="start_teaching_payment_card">
                        <div class="card-header text-white bg-secondary">
                            <%= Labels.get("start_teaching.form.payment.text1")%>   
                        </div>
                        <div class="card-body">
                            <div class="form-group row">
                                <div class="col-6 col-lg-3 my-1">
                                    <label class="col-form-label" for="start_teaching_paypal_email_input">
                                        <%= Labels.get("start_teaching.form.payment.paypal_email")%>
                                    </label>                                    
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
                                </div>

                                <div class="col-6 col-lg-3 my-1">
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

                    </div>


                    <div class="card my-1" id="start_teaching_accept_terms_card">
                        <div class="card-header text-white bg-secondary">
                            <h6>
                                <%= Labels.get("start_teaching.form.submit.title")%>   
                            </h6>

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

                            <div class="checkbox my-1" id="start_teaching_accept_terms_checkbox_div">
                                <input class="form-check-input my-1 mx-0" id="start_teaching_accept_terms_checkbox" name="start_teaching_accept_terms_checkbox" 
                                       type="checkbox" value="">

                                <label class="form-check-label" for="start_teaching_accept_terms_checkbox">
                                    <%= Labels.get("start_teaching.form.submit.terms_of_usage.read_and_accept")%>  
                                </label>
                            </div>

                            <button class="btn btn-success" onclick="start_teaching_form_submit()">
                                <%= Labels.get("start_teaching.form.submit.button.text")%>   
                            </button>
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
        </script>

    </body>

</html>
