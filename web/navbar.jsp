<%@page import="com.onlineclasses.utils.Utils"%>
<%@page import="com.onlineclasses.db.DB"%>
<%@page import="com.onlineclasses.entities.Student"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.onlineclasses.entities.ScheduledClass"%>
<%@page import="java.util.List"%>
<%@page import="com.onlineclasses.servlets.ServletBase"%>
<%@page import="com.onlineclasses.utils.Labels"%>
<%@page import="com.onlineclasses.entities.User"%>
<%@page import="java.util.ResourceBundle"%>

<%
    User user = ServletBase.getUser(request);
    List<ScheduledClass> studentUpcomingClasses = new ArrayList<>();
    String userName = Labels.get("navbar.guest.name");
    if (user != null) {
        userName = user.display_name;
        if (user instanceof Student) {
            studentUpcomingClasses = DB.getStudentUpcomingClasses((Student) user);
        }
    }
%>

<div class="container">
    <nav class="navbar navbar-expand-lg navbar-expan-md navbar-dark bg-dark">   

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
                        <a class="dropdown-item" href="#">
                            <%= Labels.get("navbar.about.us.who.we.are")%>
                        </a>
                        <a class="dropdown-item" href="javascript:invite_other_student()"><%= Labels.get("navbar.about.us.invite_student")%></a>
                    </div>
                </li>
                <li class="d-none nav-item"><a class="nav-link" href="start_teaching"><%= Labels.get("navbar.start.teaching")%></a></li>
                <li class="nav-item"><a class="nav-link" href="start_learning"><%= Labels.get("navbar.start.learning")%></a></li>
                <li class="nav-item"><a class="nav-link" href="find_teachers"><%= Labels.get("navbar.find.teachers")%></a></li>

            </ul>
            <ul class="navbar-nav mr-auto">  
                <% if (user == null) {%>                 
                <li class="nav-item">                
                    <a class="nav-link text-info" href="javascript:login_showLoginModal('login_modal')">
                        <%= Labels.get("navbar.login")%>
                    </a>                 
                </li>

                <% } else {%>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" data-toggle="dropdown" href="#">
                        <%= userName%>
                        <span class="caret"></span>
                    </a>
                    <div class="dropdown-menu">
                        <a class="dropdown-item" href="#">
                            <%= Labels.get("navbar.user.upcoming_classes")%>
                        </a>
                        <div class="dropdown-divider"></div>

                        <%
                            for (ScheduledClass studentUpcomingClass : studentUpcomingClasses) {
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
                        <a class="dropdown-item" href="javascript:login_logoutFromNavBar()"><%= Labels.get("navbar.logout")%></a>
                    </div>
                </li>
                <li> 
                    <a class="nav-link" href="homepage">     
                        <img src="<%= user.image_url%>" height="30"/>
                    </a>
                </li>
                <li>

                </li>
                <% }%>
            </ul>
        </div>
    </nav>
</div>

