<%@page import="com.onlineclasses.entities.InstituteType"%>
<%@page import="com.onlineclasses.db.DB"%>
<%@page import="java.util.List"%>
<%@page import="com.onlineclasses.utils.Utils"%>
<%@page import="com.onlineclasses.utils.Labels"%>
<%@page import="com.onlineclasses.utils.CLabels"%>

<%
    String phoneAreas = CLabels.get("website.phone_areas");
    List<String> phoneAreasList = Utils.toList(phoneAreas);
    List<InstituteType> instituteTypeList = DB.getAllInstituteTypes();
%>
<!DOCTYPE html>
<html lang="<%= Config.get("website.html_language")%>" dir="<%= Config.get("webiste.direction")%>">
    <head>
        <%@include file="header.jsp" %>
    </head>
    <body lang="<%= Config.get("website.html_language")%>" dir="<%= Config.get("webiste.direction")%>">
        <%@include file="body.jsp" %>    

        <div class="container">
            <h6>
                <%= Labels.get("start_learning.title1")%>    
                <br/>
                <%= Labels.get("start_learning.text1")%>       
            </h6>
            <div class="card my-1">
                <div class="card-header bg-secondary text-white">

                    <div style="float:left">
                        <div class="g-signin2" data-theme="dark"></div>
                    </div>
                    <h6>
                        <%= Labels.get("start_learning.form.login.text1")%>     
                    </h6>                    
                </div>
                <div class="card-body">
                    <form>
                        <div class="form-group row">
                            <label class="col-6 col-lg-3 col-xl-3 my-1 col-form-label" for="start_learning_email_input">
                                <%= Labels.get("start_learning.form.login.email")%>
                            </label>

                            <div class="col-6 col-lg-3 col-xl-3 my-1">
                                <input type="email" class="form-control" id="start_learning_email_input" 
                                       placeholder="<%= Labels.get("start_learning.form.login.email")%>" disabled>
                            </div>

                            <label class="col-6 col-lg-3 col-xl-3 col-form-label" for="start_learning_display_name_input">
                                <%= Labels.get("start_learning.form.login.display_name")%>
                            </label>

                            <div class="col-6 col-lg-3 col-xl-3 my-1">
                                <input type="text" class="form-control" id="start_learning_display_name_input" 
                                       placeholder="<%= Labels.get("start_learning.form.login.display_name")%>">
                            </div>

                            <label class="col-6 col-lg-3 col-xl-3 my-1 col-form-label" for="start_learning_first_name_input">
                                <%= Labels.get("start_learning.form.login.first_name")%>
                            </label>

                            <div class="col-6 col-lg-3 col-xl-3 my-1">
                                <input type="text" class="form-control" id="start_learning_first_name_input"
                                       placeholder="<%= Labels.get("start_learning.form.login.first_name")%>">
                            </div>

                            <label class="col-6 col-lg-3 col-xl-3 my-1 col-form-label" for="start_learning_last_name_input">
                                <%= Labels.get("start_learning.form.login.last_name")%>
                            </label>

                            <div class="col-6 col-lg-3 col-xl-3 my-1">
                                <input type="text" class="form-control" id="start_learning_last_name_input" 
                                       placeholder="<%= Labels.get("start_learning.form.login.last_name")%>">
                            </div>

                            <label class="col-6 col-lg-3 col-xl-3 my-1 col-form-label" for="start_learning_gender_input">
                                <%= Labels.get("start_learning.form.login.gender")%>   
                            </label>

                            <div class="col-6 col-lg-3 col-xl-3 my-1">
                                <div class="row no-gutter">
                                    <div class="col">
                                        <input type="radio" checked class="form-check form-check-inline" 
                                               value="<%= Config.get("website.gender.male")%>" 
                                               id="start_learning_gender_input_male" name="start_learning_gender_input" placeholder="">
                                        <label class="col-form-label my-1" for="start_learning_gender_input_male">
                                            <%= Labels.get("start_learning.form.login.gender.male")%>   
                                        </label>
                                    </div>
                                    <div class="col">
                                        <input type="radio" class="form-check form-check-inline" 
                                               value="<%= Config.get("website.gender.female")%>" 
                                               id="start_learning_gender_input_female" name="start_learning_gender_input" placeholder="">
                                        <label class="col-form-label my-1" for="start_learning_gender_input_female">
                                            <%= Labels.get("start_learning.form.login.gender.female")%>   
                                        </label>
                                    </div>
                                </div>
                            </div>

                            <div class="col-12 col-lg-6 col-xl-6 my-1">

                                <div class="row no-gutter">
                                    <label class="col-form-label col" for="start_learning_phone_number_input">
                                        <%= Labels.get("start_learning.form.login.phone_number")%>
                                    </label>

                                    <div class="input-group col">
                                        <input type="text" class="form-control" id="start_learning_phone_number_input"
                                               placeholder="<%= Labels.get("start_learning.form.login.phone_number")%>">

                                        <div class="dropdown">
                                            <button class="btn btn-info dropdown-toggle" type="button" 
                                                    id="start_learning_area_code_button" data-toggle="dropdown" 
                                                    aria-haspopup="true" aria-expanded="false" name="start_learning_area_code_button">
                                                <span id="start_learning_area_code_value">
                                                    <%= Labels.get("start_learning.form.login.phone_area")%>
                                                </span>
                                                <span class="caret"></span>
                                            </button>
                                            <div class="dropdown-menu" aria-labelledby="start_learning_area_code_button">                                            
                                                <%
                                                    for (String phoneArea : phoneAreasList) {
                                                %>

                                                <a class="dropdown-item" href="javascript:start_learning_select_area_code('<%= phoneArea%>')">
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
                                </form>

                            </div>

                            <label class="col-6 col-lg-3 col-xl-3 my-1 col-form-label" for="start_learning_day_of_birth_input">
                                <%= Labels.get("start_learning.form.login.day_of_birth")%>
                            </label>

                            <div class="col-6 col-lg-3 col-xl-3 my-1">
                                <input type="text" class="form-control" id="start_learning_day_of_birth_input"
                                       name="start_learning_day_of_birth_input"
                                       placeholder="<%= Labels.get("start_learning.form.login.day_of_birth")%>">
                            </div>
                        </div>

                        <div class="card my-1">
                            <div class="card-header text-white bg-primary">
                                <h6>
                                    <%= Labels.get("start_learning.form.learning_information.text1")%>   
                                </h6>
                            </div>

                            <div class="card-body">
                                <div class="form-group row">

                                    <label class="col-6 col-lg-3 col-xl-3 my-1 col-form-label" for="start_learning_institute_type">
                                        <%= Labels.get("start_learning.form.learning.education.title")%>
                                    </label>

                                    <div class="col-6 col-lg-3 col-xl-3 my-1">
                                        <button class="btn btn-info dropdown-toggle" type="button" 
                                                data-toggle="dropdown" id="start_learning_institute_type_button">
                                            <span class="caret"></span>
                                            <%= Labels.get("start_learning.form.learning.institue_type.select")%>

                                        </button>
                                        <div class="dropdown-menu" aria-labelledby="start_learning_institute_type_button">
                                            <%
                                                for (InstituteType instituteType : instituteTypeList) {
                                            %>

                                            <a class="dropdown-item" href="javascript:start_learning_select_institute_type(<%= instituteType.id%>)">
                                                <%= instituteType.name%>
                                            </a>

                                            <%
                                                }
                                            %>

                                            <a class="dropdown-item" id="start_learning_institute_type_other" href="javascript:start_learning_select_institute_type(0)">
                                                <%= Labels.get("start_learning.form.learning.institue_type.other")%>
                                            </a>
                                        </div>
                                    </div>
                                    <label id="start_learning_institute_other_text_label"
                                           class="col-6 col-lg-3 col-xl-3 my-1 col-form-label d-none" 
                                           for="start_learning_institute_other_text">
                                        <%= Labels.get("start_learning.form.learning.institue.other.choose")%>
                                    </label>

                                    <div id="start_learning_institute_other_text_div" class="col-6 col-lg-3 col-xl-3 my-1 d-none">
                                        <input type="text" class="form-control" id="start_learning_institute_other_text" 
                                               name="start_learning_institute_other_text"
                                               placeholder="<%= Labels.get("start_learning.form.learning.institue.other.choose")%>">
                                    </div>
                                </div>

                            </div>
                        </div>
                </div>
            </div>
            <hr/>
            <div class="card">
                <div class="card-header  text-white bg-secondary">
                    <h6>
                        <%= Labels.get("start_learning.form.submit.title")%>   
                    </h6>

                </div>
                <div class="card-body">
                    <h6>
                        <%= Labels.get("start_learning.form.submit.accept_terms_of_usage")%>  
                    </h6>
                    <div class="well">
                        <h6>
                            <%= Labels.get("start_learning.form.submit.terms_of_usage.heading")%>  
                        </h6>
                        <ul>
                            <li>
                                <%= Labels.get("start_learning.form.submit.terms_of_usage.text1")%>  
                            </li>
                            <li>
                                <%= Labels.get("start_learning.form.submit.terms_of_usage.text2")%>  
                            </li>
                            <li>
                                <%= Labels.get("start_learning.form.submit.terms_of_usage.text3")%>  
                            </li>
                            <li>
                                <%= Labels.get("start_learning.form.submit.terms_of_usage.text4")%>  
                            </li>
                            <li>
                                <%= Labels.get("start_learning.form.submit.terms_of_usage.text5")%>  
                            </li>
                            <li>
                                <%= Labels.get("start_learning.form.submit.terms_of_usage.text6")%>  
                            </li>
                        </ul>
                    </div>
                    <div class="checkbox" id="start_learning_accept_terms_checkbox_div">
                        <label for="start_learning_accept_terms_checkbox">
                            <input id="start_learning_accept_terms_checkbox" name="start_learning_accept_terms_checkbox" 
                                   type="checkbox" value="">
                            <%= Labels.get("start_learning.form.submit.terms_of_usage.read_and_accept")%>  
                        </label>
                    </div>
                    <button class="btn btn-success" onclick="start_learning_form_submit()">
                        <%= Labels.get("start_learning.form.submit.button.text")%>   
                    </button>
                </div>
            </div>
            <%@include file="footer.jsp" %>    

            <script>
                online_classes.institute_type = <%= Utils.gson().toJson(instituteTypeList)%>;
            </script>
        </div>

    </body>

</html>
