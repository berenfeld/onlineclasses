<%@page import="com.onlineclasses.web.Labels"%>

<%
    ResourceBundle l_start_treaching = ResourceBundle.getBundle("labels");
%>

<!DOCTYPE html>
<html lang="<%= Config.get("website.html_language") %>" dir="<%= Config.get("webiste.direction") %>">
    <head>
        <%@include file="header.jsp" %>
        <script src="js/start_teacher.js"></script>
    </head>
    <body>
        <%@include file="body.jsp" %>
        <div class="container">
            <ul class="nav nav-tabs">
                <li class="active"><a data-toggle="tab" href="#start_teaching_login"><%= Labels.get("start_teaching.login.tab.tab_title")%> </a></li>
                <li><a data-toggle="tab" href="#menu1">                        Menu 1</a></li>
                <li><a data-toggle="tab" href="#menu2">Menu 2</a></li>
            </ul>

            <div class="tab-content">
                <div id="start_teaching_login" class="tab-pane fade in active">
                    <h3><%= Labels.get("start_teaching.login.tab.title")%></h3>
                    <p><%= Labels.get("start_teaching.login.tab.text1")%></p>
                    <div class="g-signin2" data-onsuccess="start_teacher_googleSignIn" data-theme="dark"></div>
                </div>
                <div id="menu1" class="tab-pane fade">
                    <h3>Menu 1</h3>
                    <p>Some content in menu 1.</p>

                </div>
                <div id="menu2" class="tab-pane fade">
                    <h3>Menu 2</h3>
                    <p>Some content in menu 2.</p>
                </div>
            </div>
        </div>
    </body>
</html>
