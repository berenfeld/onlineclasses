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
    <nav class="navbar navbar-inverse">    
        <div class="navbar-header col-md-2">
            <a class="navbar-brand" href="/"><%= Labels.get("navbar.website.name")%></a>
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#navbar_main">
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>         
            </button>
        </div>
        <div class="collapse navbar-collapse row col-md-10" id="navbar_main">
            <ul class="nav navbar-nav col-md-8">            
                <li class="dropdown">
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#"><%= Labels.get("navbar.about.us")%>
                        <span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a href="#"><%= Labels.get("navbar.about.us.who.we.are")%></a></li>
                        <li><a href="#"><%= Labels.get("navbar.about.us.who.we.are")%></a></li>
                        <li><a href="#"><%= Labels.get("navbar.about.us.who.we.are")%></a></li>
                    </ul>
                </li>
                <li class="hide"><a href="start_teaching"><%= Labels.get("navbar.start.teaching")%></a></li>
                <li><a href="start_learning"><%= Labels.get("navbar.start.learning")%></a></li>
                <li><a href="find_teachers"><%= Labels.get("navbar.find.teachers")%></a></li>
            </ul>     

            <ul class="nav navbar-nav col-md-4">            
                <% if (user_navbar == null) {%>                 
                <li>                
                    <span class="navbar-text">
                        <%= Labels.get("navbar.greeting")%>&nbsp;,&nbsp;<%= Labels.get("navbar.guest.name")%>                           
                    </span>
                </li>
                <li>                
                    <a class="nav-link" href="javascript:login_showLoginModal('login_modal')">
                        <%= Labels.get("navbar.login")%>
                    </a>                 
                </li>

                <% } else {%>
                <li>     

                    <a href="#">
                        <%= Labels.get("navbar.greeting")%>&nbsp;,&nbsp;<%= userName%>
                    </a>

                </li>
                <li> 
                    <a href="homepage">     
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