<%@page import="com.onlineclasses.entities.Teacher"%>
<%@page import="com.onlineclasses.utils.Utils"%>
<%@page import="com.onlineclasses.db.DB"%>
<%@page import="com.onlineclasses.entities.Student"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.onlineclasses.entities.OClass"%>
<%@page import="java.util.List"%>
<%@page import="com.onlineclasses.servlets.BaseServlet"%>
<%@page import="com.onlineclasses.utils.Labels"%>
<%@page import="com.onlineclasses.entities.User"%>
<%@page import="java.util.ResourceBundle"%>

<%
    User com_user = BaseServlet.getUser(request);
    List<OClass> com_upcomingClasses = new ArrayList<>();
    String com_userName = Labels.get("navbar.guest.name");
    String com_homepagePage = "teacher_homepage";
    String com_updateDetailsPage = "teacher_update";
    if (com_user != null) {
        com_userName = com_user.display_name;

        if (com_user instanceof Student) {
            com_upcomingClasses = DB.getStudentUpcomingClasses((Student) com_user);
            com_homepagePage = "student_homepage";
            com_updateDetailsPage = "student_update";
        } else {
            com_upcomingClasses = DB.getTeacherUpcomingClasses((Teacher) com_user);
        }
    }
    String com_visibleToAdminClass = "d-none";
    if (BaseServlet.isAdmin(request)) {
        com_visibleToAdminClass = "";
    }
%>

<div class="container">
    <nav class="navbar navbar-expand-lg navbar-expand-md navbar-dark bg-dark">   

        <a class="navbar-brand" href="/"><%= Labels.get("navbar.website.name")%></a>
        <button type="button" class="navbar-toggler" data-toggle="collapse" data-target="#navbar_main">
            <span class="navbar-toggler-icon"></span>    
        </button>

        <div class="collapse navbar-collapse" id="navbar_main">
            <ul class="navbar-nav">            
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" data-toggle="dropdown" href="#">
                        <%= Labels.get("navbar.about.us")%>
                        <span class="caret"></span>
                    </a>
                    <div class="dropdown-menu">
                        <a class="dropdown-item" href="abous_us">
                            <%= Labels.get("navbar.about.us.who.we.are")%>
                        </a>
                        <a class="dropdown-item <%= com_visibleToAdminClass %>" href="javascript:invite_student()">
                            <%= Labels.get("navbar.about.us.invite_student")%>
                        </a>
                        <a class="dropdown-item <%= com_visibleToAdminClass %>" href="javascript:invite_teacher()">
                            <%= Labels.get("navbar.about.us.invite_teacher")%>
                        </a>
                        <a class="dropdown-item" href="contact">
                            <%= Labels.get("navbar.contacs_us")%>
                        </a>
                        <a class="dropdown-item" href="terms_of_usage">
                            <%= Labels.get("navbar.about.us.terms_of_usage")%>
                        </a>
                        <a class="dropdown-item" href="privacy_policy">
                            <%= Labels.get("navbar.about.us.privacy_policy")%>
                        </a>
                    </div>
                </li>

                <%
                    if (com_user == null) {
                %>
                <li class="nav-item">
                    <a class="nav-link" href="start_learning">
                        <%= Labels.get("navbar.start.learning")%>
                        <small class="text-info">
                            <%= Labels.get("navbar.start.learning.free")%>
                        </small>
                    </a>
                </li>
                <%
                    }
                %>


                <li class="nav-item">
                    <a class="nav-link" href="find_teachers">
                        <%= Labels.get("navbar.find.teachers")%>
                    </a>
                </li>

                <%
                    if (com_user == null) {
                %>
                <li class="nav-item">
                    <a class="nav-link" href="start_teaching">
                        <%= Labels.get("navbar.start.teaching")%>
                    </a>
                </li>
                <%
                    }
                %>
                <li class="nav-item"><a class="nav-link d-none" href="javascript:start_teaching()"><%= Labels.get("navbar.start.teaching")%></a></li>
            </ul>
            <ul class="navbar-nav mr-auto">  
                <% if (com_user == null) {%>                 
                <li class="nav-item">                
                    <a class="nav-link text-info" href="javascript:login_showLoginModal()">
                        <%= Labels.get("navbar.login")%>
                    </a>                 
                </li>

                <% } else {%>
                <li class="nav-item dropdown">
                    <a class="text-success nav-link dropdown-toggle" data-toggle="dropdown" href="#">
                        <%= com_userName%>
                        <span class="caret"></span>
                    </a>
                    <div class="dropdown-menu">
                        <a class="dropdown-item" href="<%= com_homepagePage%>">
                            <%= Labels.get("navbar.user.homepage")%>
                        </a>
                        <a class="dropdown-item" href="<%= com_updateDetailsPage%>">
                            <%= Labels.get("navbar.user.update_details")%>
                        </a>
                        <%
                            if (!com_upcomingClasses.isEmpty()) {
                        %>
                        <a class="dropdown-item" href="#">
                            <%= Labels.get("navbar.user.upcoming_classes")%>
                        </a>
                        <div class="dropdown-divider"></div>
                        <%
                            for (OClass upcomingClass : com_upcomingClasses) {
                        %>
                        <a class="dropdown-item" href="oclass?id=<%= upcomingClass.id%>">
                            <%= upcomingClass.subject%>
                            &nbsp;
                            <%= Utils.formatDateTime(upcomingClass.start_date)%>
                        </a>
                        <%
                            }
                        %>
                        <div class="dropdown-divider"></div>
                        <%
                            }
                        %>
                        <a class="dropdown-item" href="javascript:login_logoutFromNavBar()">
                            <%= Labels.get("navbar.logout")%>
                        </a>
                    </div>
                </li>
                <li> 
                    <a class="nav-link" href="<%= com_homepagePage%>">     
                        <img src="<%= com_user.image_url%>" class="img-responsive d-inline-block" height="30"/>
                    </a>                    
                </li>

                <% }%>
            </ul>
        </div>
    </nav>
</div>

<div id="login_modal" class="modal fade" role="dialog">
    <div class="modal-dialog modal-md" role="document">
        <div class="modal-content">
            <div class="modal-header bg-secondary text-white">
                <div class="h5 modal-title">
                    <span class="oi mx-1" data-glyph="account-login"></span>                                       
                    <%= Labels.get("login.modal.title")%>                        
                </div>
                <span class="oi close_button" data-dismiss="modal" data-glyph="x"></span>      
            </div>
            <div class="modal-body">
                <h5>
                    <%= Labels.get("login.modal.text1")%>                    
                </h5>
                <div class="row no-gutters">
                    <div class="col-6">                        
                        <input type="image" src="images/google_login_button.png" class="w-100" onclick="login_googleLogin()">              
                    </div>
                </div>
                <h5>
                    <small>
                        <%= Labels.get("login.modal.text1_small")%>
                        <span class="oi" data-glyph="info"></span>     
                        <span class="text-info">
                            <%= Labels.get("login.modal.text2")%>                    
                            <a class="alert-link" href="start_learning">
                                <%= Labels.get("login.modal.register.student")%>
                            </a> 
                        </span>
                    </small>
                </h5>
            </div>
            <div id="login_modal_info_div" class="alert alert-info d-none" role="alert">
                <span class="oi" data-glyph="info"></span>    
                <span id="login_modal_info_text"></span>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-info" data-dismiss="modal">
                    <%= Labels.get("buttons.cancel")%>
                </button>
            </div>                
        </div>

    </div>
</div>

<div id="confirm_modal" class="modal fade" role="dialog">
    <div class="modal-dialog modal-sm">
        <div class="modal-content">
            <div class="modal-header bg-secondary text-white">
                <div class="modal-title">
                    <span class="oi" data-glyph="check"></span>
                    <span id="confirm_modal_title"></span>
                </div>
                <span class="oi close_button" data-dismiss="modal" data-glyph="x"></span>      
            </div>
            <div class="modal-body">
                <span id="confirm_modal_message"></span>                   
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-info mx-1" onclick="confirm_cancel()" data-dismiss="modal"><%= Labels.get("buttons.cancel")%></button>
                <button type="button" class="btn btn-success mx-1" onclick="confirm_ok()" data-dismiss="modal"><%= Labels.get("buttons.ok")%></button>
            </div>
        </div>

    </div>
</div>

<div id="alert_modal" class="modal fade" role="dialog">
    <div class="modal-dialog modal-sm">

        <div class="modal-content">
            <div class="modal-header bg-secondary text-white">
                <div class="modal-title"> 
                    <h6>
                        <span class="oi mx-1" data-glyph="info"></span>       
                        <span id="alert_modal_title">
                            <%= Labels.get("alert.modal.title")%>
                        </span>
                    </h6>
                </div>
                <span class="oi close_button" data-dismiss="modal" data-glyph="x"></span>      
            </div>
            <div class="modal-body">
                <h6 id="alert_modal_text1">
                    <%= Labels.get("alert.modal.text1")%>
                </h6>                    
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-success" data-dismiss="modal">
                    <%= Labels.get("buttons.ok")%>
                </button>
            </div>

        </div>

    </div>
</div>

<div id="invite_student_modal" class="modal fade" role="dialog">
    <div class="modal-dialog modal-md">

        <div class="modal-content">
            <div class="modal-header bg-secondary text-white">
                <div class="modal-title"> 
                    <span class="oi mx-1" data-glyph="envelope-closed"></span>                
                    <%= Labels.get("invite_student.modal.title")%>                            
                </div>
                <span class="oi close_button" data-dismiss="modal" data-glyph="x"></span>      
            </div>
            <div class="modal-body  text-secondary">
                <p>
                    <%= Labels.get("invite_student.modal.text")%>      
                </p>
                <form>
                    <div class="form-group row">
                        <label class="col-form-label col-xl-6 col-lg-6 col-md-6 col-12" for="invite_student_name">
                            <%= Labels.get("invite_student.form.name_label")%>
                        </label>
                        <div class="col-xl-6 col-lg-6 col-md-6 col-12">
                            <input type="text" class="form-control" id="invite_student_name" 
                                   placeholder="<%= Labels.get("invite_student.form.name")%>">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-form-label col-xl-6 col-lg-6 col-md-6 col-12" for="invite_student_email">
                            <%= Labels.get("invite_student.form.email_label")%>
                        </label>
                        <div class="col-xl-6 col-lg-6 col-md-6 col-12">
                            <input type="email" class="form-control" id="invite_student_email" 
                                   placeholder="<%= Labels.get("invite_student.form.email")%>">
                        </div>
                    </div>
                </form>                
            </div>
            <div class="alert alert-warning d-none" role="alert" id="invite_student_warning">                    
                <span class="oi" data-glyph="warning"></span>
                <span id="invite_student_warning_text"></span>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-info mx-1" data-dismiss="modal"><%= Labels.get("buttons.cancel")%></button>
                <button type="button" class="btn btn-success mx-1" onclick="invite_student_send()"><%= Labels.get("buttons.ok")%></button>
            </div>

        </div>

    </div>
</div>

<div id="invite_teacher_modal" class="modal fade" role="dialog">
    <div class="modal-dialog modal-md">

        <div class="modal-content">
            <div class="modal-header bg-secondary text-white">
                <div class="modal-title"> 
                    <span class="oi mx-1" data-glyph="envelope-closed"></span>                
                    <%= Labels.get("invite_teacher.modal.title")%>                            
                </div>
                <span class="oi close_button" data-dismiss="modal" data-glyph="x"></span>      
            </div>
            <div class="modal-body  text-secondary">
                <p>
                    <%= Labels.get("invite_teacher.modal.text")%>      
                </p>
                <form>
                    <div class="form-group row">
                        <label class="col-form-label col-xl-6 col-lg-6 col-md-6 col-12" for="invite_teacher_name">
                            <%= Labels.get("invite_teacher.form.name_label")%>
                        </label>
                        <div class="col-xl-6 col-lg-6 col-md-6 col-12">
                            <input type="text" class="form-control" id="invite_teacher_name" 
                                   placeholder="<%= Labels.get("invite_teacher.form.name")%>">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-form-label col-xl-6 col-lg-6 col-md-6 col-12" for="invite_teacher_email">
                            <%= Labels.get("invite_teacher.form.email_label")%>
                        </label>
                        <div class="col-xl-6 col-lg-6 col-md-6 col-12">
                            <input type="email" class="form-control" id="invite_teacher_email" 
                                   placeholder="<%= Labels.get("invite_teacher.form.email")%>">
                        </div>
                    </div>
                </form>                
            </div>
            <div class="alert alert-warning d-none" role="alert" id="invite_teacher_warning">                    
                <span class="oi" data-glyph="warning"></span>
                <span id="invite_teacher_warning_text"></span>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-info mx-1" data-dismiss="modal"><%= Labels.get("buttons.cancel")%></button>
                <button type="button" class="btn btn-success mx-1" onclick="invite_teacher_send()"><%= Labels.get("buttons.ok")%></button>
            </div>

        </div>

    </div>
</div>

<div id="progress_modal" class="modal fade" role="dialog">
    <div class="modal-dialog modal-sm">

        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" aria-label="close" data-dismiss="modal">
                    <span aria-hidden="true">&times;</span>
                </button>

                <div class="modal-title"> 
                    <h5 class="text-warning">
                        <span id="progress_modal_title">                      
                        </span>
                    </h5>
                </div>
            </div>
            <div class="modal-body">
                <div class="progress">
                    <div id="progress_modal_bar" class="progress-bar progress-bar-success" role="progressbar" 
                         aria-valuemin="0" aria-valuemax="100">
                        <span id="progress_modal_text1"></span>
                        (<span id="progress_modal_percent"></span>%)
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>

<div id="text_input_modal" class="modal fade" role="dialog">
    <div class="modal-dialog modal-md">

        <div class="modal-content">
            <div class="modal-header text-white bg-secondary">                
                <div class="modal-title">                     
                    <span class="oi" data-glyph="comment-square"></span>                     
                    <span id="text_input_modal_title">                        
                        <%= Labels.get("text_input.modal.title")%>
                    </span>
                </div>                                             
                <span class="oi close_button" data-dismiss="modal" data-glyph="x"></span>      
            </div>
            <div class="modal-body">     
                <label id="text_input_modal_text1" class="col-form-label" for="text_input_modal_input">
                    <%= Labels.get("text_input.modal.text1")%>
                </label>   
                <input id ="text_input_modal_input" class="form-control" type="text" >
                </input>
            </div>
            <div id="text_input_modal_info_div" class="alert alert-info d-none my-0" role="alert">
                <span class="oi" data-glyph="info"></span>    
                <span id="text_input_modal_info_text"></span>
            </div>
            <div class="modal-footer">

                <button type="button" class="btn btn-info mx-1" data-dismiss="modal">
                    <%= Labels.get("buttons.cancel")%>
                </button>

                <button type="button" class="btn btn-success mx-1" onclick="text_input_modal_ok()">
                    <%= Labels.get("buttons.ok")%>
                </button>            
            </div>

        </div>

    </div>
</div>
