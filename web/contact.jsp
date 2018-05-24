<%@page import="com.onlineclasses.utils.Config"%>
<!DOCTYPE html>
<html lang="<%= Config.get("website.html_language")%>" dir="<%= Config.get("webiste.direction")%>">
    <head>
        <%@include file="header.jsp" %>
        <title>
            <%= Labels.get("contact.title")%>
        </title>
    </head>
    <body lang="<%= Config.get("website.html_language")%>" dir="<%= Config.get("webiste.direction")%>">

        <%@include file="body.jsp" %>    
        <div class="container">
            <div class="card my-1">
                <div class="card-header">
                    <div class="card-title h4">                    
                        <%= Labels.get("contact.heading")%>
                    </div>
                </div>
                <div class="card-body">
                    <h5>
                        <%= Labels.get("contact.text1")%>
                    </h5>
                    <div class="form-group row">
                        <div class="col-4 col-xl-2 col-lg-2 my-1">
                            <label for="contact_name_input" >
                                <%= Labels.get("contact.name")%>
                            </label>
                        </div>
                        <div class="col-8 col-xl-4 col-lg-4 my-1">
                            <input type="text" class="form-control" id="contact_name_input" 
                                   name="contact_name_input">
                        </div>                            
                        <div class="col-4 col-xl-2 col-lg-2 my-1">
                            <label for="contact_email_input" >
                                <%= Labels.get("contact.email")%>
                            </label>
                        </div>
                        <div class="col-8 col-xl-4 col-lg-4 my-1">
                            <input type="email" class="form-control" id="contact_email_input" 
                                   name="contact_email_input">
                        </div>
                        <div class="col-4 col-xl-2 col-lg-2 my-1">
                            <label for="contact_phone_input" >
                                <%= Labels.get("contact.phone_number")%>
                            </label>
                        </div>
                        <div class="col-8 col-xl-4 col-lg-4 my-1">
                            <input type="email" class="form-control" id="contact_phone_input" 
                                   name="contact_phone_input">
                        </div>
                    </div>
                    <div class="form-group row">
                        <div class="col-4 col-xl-2 col-lg-2 my-1">
                            <label for="contact_message_input" >
                                <%= Labels.get("contact.reason")%>
                            </label>
                        </div>
                        <div class="col-8 col-xl-10 col-lg-10 my-1">
                            <textarea class="form-control" id="contact_message_input" 
                                      name="contact_message_input"
                                      placeholder="<%= Labels.get("contact.reason.placeholder")%>"></textarea>
                        </div>
                    </div>
                </div>
                <div class="card-footer">
                    <button type="button" class="btn btn-success" onclick="contact_submit_form()">
                        <%= Labels.get("contact.button.text")%>
                    </button>
                </div>
            </div>
        </div>
        <%@include file="footer.jsp" %>    
    </body>
</html>
