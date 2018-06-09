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
    User nav_user = BaseServlet.getUser(request);
    List<OClass> studentUpcomingClasses = new ArrayList<>();
    String nav_userName = Labels.get("navbar.guest.name");
    String homepagePage = "teacher_homepage";
    String updateDetailsPage = "teacher_update";
    if (nav_user != null) {
        nav_userName = nav_user.display_name;

        if (nav_user instanceof Student) {
            studentUpcomingClasses = DB.getStudentUpcomingClasses((Student) nav_user);
            homepagePage = "student_homepage";
            updateDetailsPage = "student_update";
        }
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
                        <a class="dropdown-item" href="javascript:invite_other_student()">
                            <%= Labels.get("navbar.about.us.invite_student")%>
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
                    if (nav_user == null) {
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
                    if (nav_user == null) {
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
                <% if (nav_user == null) {%>                 
                <li class="nav-item">                
                    <a class="nav-link text-info" href="javascript:login_showLoginModal()">
                        <%= Labels.get("navbar.login")%>
                    </a>                 
                </li>

                <% } else {%>
                <li class="nav-item dropdown">
                    <a class="text-success nav-link dropdown-toggle" data-toggle="dropdown" href="#">
                        <%= nav_userName%>
                        <span class="caret"></span>
                    </a>
                    <div class="dropdown-menu">
                        <a class="dropdown-item" href="<%= homepagePage%>">
                            <%= Labels.get("navbar.user.homepage")%>
                        </a>
                        <a class="dropdown-item" href="<%= updateDetailsPage %>">
                            <%= Labels.get("navbar.user.update_details")%>
                        </a>
                        <%
                            if (!studentUpcomingClasses.isEmpty()) {
                        %>
                        <a class="dropdown-item" href="#">
                            <%= Labels.get("navbar.user.upcoming_classes")%>
                        </a>
                        <div class="dropdown-divider"></div>
                        <%
                            for (OClass studentUpcomingClass : studentUpcomingClasses) {
                        %>
                        <a class="dropdown-item" href="scheduled_class?id=<%= studentUpcomingClass.id%>">
                            <%= studentUpcomingClass.subject%>
                            &nbsp;
                            <%= Utils.formatDateTime(studentUpcomingClass.start_date)%>
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
                    <a class="nav-link" href="<%= homepagePage%>">     
                        <img src="<%= nav_user.image_url%>" class="img-responsive d-inline-block" height="30"/>
                    </a>                    
                </li>

                <% }%>
            </ul>
        </div>
    </nav>
</div>