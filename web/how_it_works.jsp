<%@page import="java.io.File"%>
<%@include file="start.jsp" %>
<%@page import="com.onlineclasses.utils.Config"%>

<!DOCTYPE html>
<html lang="<%= Config.get("website.html_language")%>" dir="<%= Config.get("webiste.direction")%>">
    <head>
        <%@include file="header.jsp" %>
        <title>
            <%= Labels.get("how_it_works.title")%>
        </title>
    </head>
    <body lang="<%= Config.get("website.html_language")%>" dir="<%= Config.get("webiste.direction")%>">

        <%@include file="body.jsp" %>    
        <div class="container">
            
            <%
                String htmlFileName = Config.get("html.path") + File.separator
                        + Config.get("website.language") + File.separator + "how_it_works.html";
                String htmlContent = Utils.getStringFromInputStream(htmlFileName);
                out.write(htmlContent);
            %>
             
        </div>
        <%@include file="footer.jsp" %>    
    </body>
</html>
