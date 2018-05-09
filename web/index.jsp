<%@page import="com.onlineclasses.utils.Config"%>
<!DOCTYPE html>
<html lang="<%= Config.get("website.html_language") %>" dir="<%= Config.get("webiste.direction") %>">
    <head>
        <%@include file="header.jsp" %>
    </head>
    <body lang="<%= Config.get("website.html_language") %>" dir="<%= Config.get("webiste.direction") %>">
        <%@include file="body.jsp" %>    
        <div class="container">
            
        </div>
        <%@include file="footer.jsp" %>    
    </body>

</html>
