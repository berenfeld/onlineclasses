<%@page import="com.onlineclasses.web.Config"%>
<!DOCTYPE html>
<html lang="<%= Config.get("website.html_language") %>" dir="<%= Config.get("webiste.direction") %>">
    <head>
        <%@include file="header.jsp" %>
    </head>
    <body>
        <%@include file="body.jsp" %>    
        <div class="container">
            
        </div>
        <%@include file="footer.jsp" %>    
    </body>

</html>
