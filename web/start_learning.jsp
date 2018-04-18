<%@page import="java.util.List"%>
<%@page import="com.onlineclasses.web.Utils"%>
<%@page import="com.onlineclasses.web.Labels"%>
<%@page import="com.onlineclasses.web.CLabels"%>

<%
    String phoneAreas = CLabels.get("website.phone_areas");
    List<String> phoneAreasList = Utils.toList(phoneAreas);

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

            <form class="form">

                <div class="col-md-6 form-group">
                    <label>
                        <%= Labels.get("start_learning.form.login.text1")%>     

                    </label>
                </div>
                <div class="col-md-6 form-group">
                    <div class="g-signin2 center-block"  data-theme="dark"></div>   
                </div>

                <div class="col-md-4 form-group">
                    <label for="start_learning_email_input" class="sr-only"><%= Labels.get("start_learning.form.login.email")%>
                    </label>
                    <input type="email" class="form-control" id="start_learning_email_input" 
                           placeholder="<%= Labels.get("start_learning.form.login.email")%>" disabled>

                </div>
                <div class="col-md-4 form-group">
                    <label for="start_learning_display_name_input" class="sr-only"><%= Labels.get("start_learning.form.login.display_name")%>
                    </label>
                    <input type="text" class="form-control" id="start_learning_display_name_input" 
                           placeholder="<%= Labels.get("start_learning.form.login.display_name")%>">

                </div>

                <div class="col-md-4 form-group">
                    <label for="start_learning_first_name_input" class="sr-only"><%= Labels.get("start_learning.form.login.first_name")%>
                    </label>
                    <input type="text" class="form-control form-control-sm" id="start_learning_first_name_input"
                           placeholder="<%= Labels.get("start_learning.form.login.first_name")%>">
                </div>

                <div class="col-md-4 form-group">

                    <label for="start_learning_last_name_input" class="sr-only"><%= Labels.get("start_learning.form.login.last_name")%>
                    </label>
                    <input type="text" class="form-control form-control-sm" id="start_learning_last_name_input" 
                           placeholder="<%= Labels.get("start_learning.form.login.last_name")%>">
                </div>

                <div class="col-md-4 form-group">

                    <div class="col-md-4">
                        <label for="start_learning_gender_input">
                            <%= Labels.get("start_learning.form.login.gender")%>   
                        </label>
                    </div>

                    <div class="col-md-4 ">
                        <input type="radio" checked class="form-check form-check-inline" value="1" id="start_learning_gender_input_male" name="start_learning_gender_input" placeholder="">
                        <label class="form-check-label" for="start_learning_gender_input_male">
                            <%= Labels.get("start_learning.form.login.gender.male")%>   
                        </label>
                    </div>

                    <div class="col-md-4">
                        <input type="radio" class="form-check form-check-inline" value="2" id="start_learning_gender_input_female" name="start_learning_gender_input" placeholder="">
                        <label class="form-check-label" for="start_learning_gender_input_female">
                            <%= Labels.get("start_learning.form.login.gender.female")%>   
                        </label>
                    </div>

                </div>


                <div class="col-md-4 form-group">
                    <label for="start_learning_phone_number_input" class="sr-only"><%= Labels.get("start_learning.form.login.phone_number")%>
                    </label>
                    <input type="text" class="form-control col-md-8" id="start_learning_phone_number_input"
                           placeholder="<%= Labels.get("start_learning.form.login.phone_number")%>">
                    <label for="start_learning_phone_area" class="sr-only"><%= Labels.get("start_learning.form.login.phone_area")%>
                    </label>                             
                    <select class="form-control col-md-4" id="start_learning_phone_area">
                        <%
                            for (String phoneArea : phoneAreasList) {
                        %>
                        <option value="<%=phoneArea%>"><%=phoneArea%></option>
                        <%
                            }
                        %>
                    </select>
                </div>
            </form>

            <div class="col-md-12 form-group">
                <label>
                    <%= Labels.get("start_learning.form.learning_information.text1")%>   
                </label>
            </div>
        </div>

    </form>
</div>

<%@include file="footer.jsp" %>    
</body>

</html>
