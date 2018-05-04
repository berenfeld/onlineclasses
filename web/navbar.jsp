<%@page import="com.onlineclasses.web.ServletBase"%>
<%@page import="com.onlineclasses.web.Labels"%>
<%@page import="com.onlineclasses.entities.User"%>
<%@page import="java.util.ResourceBundle"%>

<%
    ResourceBundle l_navbar = ResourceBundle.getBundle("labels");
    User user_navbar = ServletBase.getUser(request);

    String userName = Labels.get("navbar.guest.name");
    if (user_navbar != null) {
        userName = user_navbar.display_name;
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
                    <a class="nav-link dropdown-toggle" data-toggle="dropdown" href="#"><%= Labels.get("navbar.about.us")%>
                        <span class="caret"></span></a>
                    <div class="dropdown-menu">
                        <a class="dropdown-item" href="#"><%= Labels.get("navbar.about.us.who.we.are")%></a>
                        <a class="dropdown-item" href="#"><%= Labels.get("navbar.about.us.who.we.are")%></a>
                        <a class="dropdown-item" href="#"><%= Labels.get("navbar.about.us.who.we.are")%></a>
                    </div>
                </li>
                <li class="nav-item"><a class="nav-link" href="start_teaching"><%= Labels.get("navbar.start.teaching")%></a></li>
                <li class="nav-item"><a class="nav-link" href="start_learning"><%= Labels.get("navbar.start.learning")%></a></li>
                <li class="nav-item"><a class="nav-link" href="find_teachers"><%= Labels.get("navbar.find.teachers")%></a></li>

            </ul>
            <ul class="navbar-nav mr-auto">  
                <% if (user_navbar == null) {%>                 
                <li class="nav-item">                
                    <span class="navbar-text">
                        <%= Labels.get("navbar.greeting")%>&nbsp;,&nbsp;<%= Labels.get("navbar.guest.name")%>                           
                    </span>
                </li>
                <li class="nav-item">                
                    <a class="nav-link" href="javascript:login_showLoginModal('login_modal')">
                        <%= Labels.get("navbar.login")%>
                    </a>                 
                </li>

                <% } else {%>
                <li>     

                    <a class="nav-link" href="#">
                        <%= Labels.get("navbar.greeting")%>&nbsp;,&nbsp;<%= userName%>
                    </a>

                </li>
                <li> 
                    <a class="nav-link" href="homepage">     
                        <img src="<%= user_navbar.image_url%>" height="30"/>
                    </a>
                </li>
                <li>
                    <a class="nav-link" href="javascript:login_logoutFromNavBar()"><%= Labels.get("navbar.logout")%></a>
                </li>
                <% }%>
            </ul>
        </div>
    </nav>
</div>