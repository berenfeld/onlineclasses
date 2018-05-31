<%@page import="java.io.File"%>
<%@page import="com.onlineclasses.entities.Topic"%>
<%@page import="com.onlineclasses.entities.Subject"%>
<%@page import="com.onlineclasses.utils.Config"%>
<%
    Map<Integer, Subject> allSubjects = DB.getAllMap(Subject.class);
    Map<Integer, Topic> allTopics = DB.getAllMap(Topic.class);
%>
<!DOCTYPE html>
<html lang="<%= Config.get("website.html_language")%>" dir="<%= Config.get("webiste.direction")%>">
    <head>
        <%@include file="header.jsp" %>
        <title>
            <%= Labels.get("mainpage.title")%>
        </title>
    </head>
    <body lang="<%= Config.get("website.html_language")%>" dir="<%= Config.get("webiste.direction")%>">

        <%@include file="body.jsp" %>    
        <div class="container">
            <div class="card">
                <div class="card-body">
                    <%
                        String htmlFileName = Config.get("html.path") + File.separator
                                + Config.get("website.language") + File.separator + "privacy_policy.html";
                        String htmlContent = Utils.getStringFromInputStream(getServletContext(), htmlFileName);
                        out.write(htmlContent);
                    %>
                </div>
            </div>
        </div>
        <%@include file="footer.jsp" %>    
        <script>
            index.all_subjects = <%= Utils.gson().toJson(allSubjects)%>;
            index.all_topics = <%= Utils.gson().toJson(allTopics)%>;
            index_init();
        </script>
    </body>

</html>
