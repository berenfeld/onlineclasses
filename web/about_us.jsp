<%@page import="java.io.File"%>
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
            
            <%
                String htmlFileName = Config.get("html.path") + File.separator
                        + Config.get("website.language") + File.separator + "about_us.html";
                String htmlContent = Utils.getStringFromInputStream(getServletContext(), htmlFileName);
                out.write(htmlContent);
            %>

        </div>
        <%@include file="footer.jsp" %>    
    </body>
</html>
