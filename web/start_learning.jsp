<%@page import="com.onlineclasses.entities.InstituteType"%>
<%@page import="com.onlineclasses.db.DB"%>
<%@page import="java.util.List"%>
<%@page import="com.onlineclasses.web.Utils"%>
<%@page import="com.onlineclasses.web.Labels"%>
<%@page import="com.onlineclasses.web.CLabels"%>

<%
    String phoneAreas = CLabels.get("website.phone_areas");
    List<String> phoneAreasList = Utils.toList(phoneAreas);
    List<InstituteType> instituteTypeList = DB.getAllInstituteTypes();
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <%@include file="header.jsp" %>
    </head>
    <body>
        <%@include file="body.jsp" %>    

        <div class="container">

            <h3>
                <%= Labels.get("start_learning.title1")%>                        
            </h3>
            <div class="panel panel-info">
                <div class="panel-heading">
                    <div style="float:left">
                        <div class="g-signin2" data-theme="dark"></div>
                    </div>
                    <h4>
                        <%= Labels.get("start_learning.form.login.text1")%>     
                    </h4>                    


                </div>
                <div class="panel-body">
                    <form class="form-horizontal">
                        <div class="form-group">
                            <label class="control-label col-md-4" for="start_learning_email_input">
                                <%= Labels.get("start_learning.form.login.email")%>
                            </label>
                            <div class="col-md-8">
                                <input type="email" class="form-control" id="start_learning_email_input" 
                                       placeholder="<%= Labels.get("start_learning.form.login.email")%>" disabled>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-md-4" for="start_learning_display_name_input">
                                <%= Labels.get("start_learning.form.login.display_name")%>
                            </label>
                            <div class="col-md-8">
                                <input type="text" class="form-control" id="start_learning_display_name_input" 
                                       placeholder="<%= Labels.get("start_learning.form.login.display_name")%>">
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label col-md-4" for="start_learning_first_name_input">
                                <%= Labels.get("start_learning.form.login.first_name")%>
                            </label>
                            <div class="col-md-8">
                                <input type="text" class="form-control form-control-sm" id="start_learning_first_name_input"
                                       placeholder="<%= Labels.get("start_learning.form.login.first_name")%>">
                            </div>
                        </div>

                        <div class="form-group">

                            <label class="control-label col-md-4" for="start_learning_last_name_input">
                                <%= Labels.get("start_learning.form.login.last_name")%>
                            </label>
                            <div class="col-md-8">
                                <input type="text" class="form-control form-control-sm" id="start_learning_last_name_input" 
                                       placeholder="<%= Labels.get("start_learning.form.login.last_name")%>">
                            </div>
                        </div>

                        <div class="form-group">

                            <label class="control-label col-md-4" for="start_learning_gender_input">
                                <%= Labels.get("start_learning.form.login.gender")%>   
                            </label>

                            <div class="col-md-2">
                                <input type="radio" checked class="form-check form-check-inline" value="1" id="start_learning_gender_input_male" name="start_learning_gender_input" placeholder="">
                                <label class="form-check-label" for="start_learning_gender_input_male">
                                    <%= Labels.get("start_learning.form.login.gender.male")%>   
                                </label>
                            </div>
                            <div class="col-md-2">
                                <input type="radio" class="form-check form-check-inline" value="2" id="start_learning_gender_input_female" name="start_learning_gender_input" placeholder="">
                                <label class="form-check-label" for="start_learning_gender_input_female">
                                    <%= Labels.get("start_learning.form.login.gender.female")%>   
                                </label>
                            </div>

                        </div>

                        <div class="form-group">
                            <label class="control-label col-md-4" for="start_learning_phone_number_input">
                                <%= Labels.get("start_learning.form.login.phone_number")%>
                            </label>
                            <div class="col-md-4">
                                <input type="text" class="form-control" id="start_learning_phone_number_input"
                                       placeholder="<%= Labels.get("start_learning.form.login.phone_number")%>">
                            </div>
                            <label class="control-label col-md-2" for="start_learning_phone_area">
                                <%= Labels.get("start_learning.form.login.phone_area")%>
                            </label>   

                            <div class="col-md-2">
                                <button class="btn btn-primary dropdown-toggle form-control" type="button" data-toggle="dropdown">
                                    <span class="caret"></span>
                                    <%= Labels.get("start_learning.form.login.phone_area")%>
                                </button>
                                <ul class="dropdown-menu dropdown-menu-right">
                                    <%
                                        for (String phoneArea : phoneAreasList) {
                                    %>

                                    <li>
                                        <a href="#">
                                            <%= phoneArea%>
                                        </a>
                                    </li>
                                    <%
                                        }
                                    %>
                                </ul>
                            </div>
                        </div>
                    </form>

                </div>

            </div>

            <div class="panel panel-primary">
                <div class="panel-heading">

                    <h4>
                        <%= Labels.get("start_learning.form.learning_information.text1")%>   
                    </h4>

                </div>
                <div class="panel-body">
                    <div class="form-group">
                        <label class="control-label col-md-4" for="start_learning_institute_type">
                            <%= Labels.get("start_learning.form.learning.institue")%>
                        </label>
                        <div class="col-md-2">
                            <button class="btn btn-primary dropdown-toggle form-control" type="button" data-toggle="dropdown">
                                <span class="caret"></span>
                                <%= Labels.get("start_learning.form.learning.institue.text")%>

                            </button>
                            <ul class="dropdown-menu dropdown-menu-right">
                                <%
                                    for (InstituteType instituteType : instituteTypeList) {
                                %>

                                <li>
                                    <a href="#">
                                        <%= instituteType.name%>
                                    </a>
                                </li>
                                <%
                                    }
                                %>
                            </ul>

                        </div>
                    </div>
                </div>
            </div>

            <div class="panel panel-primary">
                <div class="panel-heading">

                    <h4>
                        <%= Labels.get("start_learning.form.submit.title")%>   
                    </h4>

                </div>
                <div class="panel-body">
                    <h5>
                        <%= Labels.get("start_learning.form.submit.accept_terms_of_usage")%>  
                    </h5>
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
                    <button class="btn btn-primary" onclick="start_learning_form_submit()">
                        <%= Labels.get("start_learning.form.submit.button.text")%>   
                    </button>
                </div>
            </div>
            <%@include file="footer.jsp" %>    
    </body>

</html>
