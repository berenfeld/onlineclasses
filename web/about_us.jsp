<%@page import="java.io.File"%>
<%@include file="start.jsp" %>
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
                String htmlContent = Utils.getStringFromInputStream(htmlFileName);
                out.write(htmlContent);
            %>

             <div class="row no-gutters my-4">
                <div class="col-12 col-xl-4 col-lg-4 px-1">
                    <div class="card">                        
                        <div class="card-header bg-info text-white">
                            <div class="h5 text-center">                                
                                <span class="oi" data-glyph="audio-spectrum"></span>    
                                <%= Labels.get("mainpage.feedbacks.title")%>
                            </div>
                        </div>
                        <div class="card-body my-2">
                            <div class="card bg-light">                            
                                <div class="card-body">
                                    <p class="card-text">
                                        <%= Labels.get("mainpage.feedbacks.text1")%>
                                    </p>
                                </div>
                                <div class="card-footer text-left">
                                    <cite>
                                        <%= Labels.get("mainpage.feedbacks.student1")%>
                                    </cite>
                                </div>
                            </div>
                                    
                            <div class="card bg-light my-2">                            
                                <div class="card-body">
                                    <p class="card-text">
                                        <%= Labels.get("mainpage.feedbacks.text2")%>
                                    </p>
                                </div>
                                <div class="card-footer text-left">
                                    <cite>
                                        <%= Labels.get("mainpage.feedbacks.student2")%>
                                    </cite>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                                    
                <div class="col-12 col-xl-4 col-lg-4 px-1">
                    <div class="card">
                        <div class="card-header bg-info text-white">
                            <div class="h5 text-center">
                                <span class="oi" data-glyph="people"></span>    
                                <%= Labels.get("mainpage.students.title")%>
                            </div>
                        </div>
                        <div class="card-body">
                            <ul class="h6 list-unstyled">
                                <li>       
                                    <span class="oi" data-glyph="star"></span>      
                                    <%= Labels.get("mainpage.students.list1")%>
                                </li>
                                <li>
                                    <span class="oi" data-glyph="star"></span> 
                                    <%= Labels.get("mainpage.students.list2")%>
                                </li>
                                <li>
                                    <span class="oi" data-glyph="star"></span> 
                                    <%= Labels.get("mainpage.students.list3")%>
                                </li>
                                <li>
                                    <span class="oi" data-glyph="star"></span> 
                                    <%= Labels.get("mainpage.students.list4")%>
                                </li>
                                <li>
                                    <span class="oi" data-glyph="star"></span> 
                                    <%= Labels.get("mainpage.students.list5")%>
                                    <a href="start_learning">
                                        <%= Labels.get("mainpage.students.to_start_learning")%>
                                    </a>    
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-xl-4 col-lg-4 px-1">
                    <div class="card">
                        <div class="card-header bg-info text-white">
                            <div class="h5 text-center">                                
                                <span class="oi" data-glyph="pencil"></span>    
                                <a href="find_teachers" class="text-white">                                    
                                    <%= Labels.get("mainpage.teachers.title.out_teachers")%>
                                </a>

                                <%= Labels.get("mainpage.teachers.title.get")%>
                            </div>
                        </div>
                        <div class="card-body">
                            <ul class="h6 list-unstyled">
                                <li>
                                    <span class="oi" data-glyph="star"></span>      
                                    <%= Labels.get("mainpage.teachers.list1")%>
                                </li>
                                <li>
                                    <span class="oi" data-glyph="star"></span>      
                                    <%= Labels.get("mainpage.teachers.list2")%>
                                </li>
                                <li>
                                    <span class="oi" data-glyph="star"></span>      
                                    <%= Labels.get("mainpage.teachers.list3")%>
                                </li>
                                <li>
                                    <span class="oi" data-glyph="star"></span>      
                                    <%= Labels.get("mainpage.teachers.lits4")%>
                                    <a href="start_teaching">
                                        <%= Labels.get("mainpage.teachers.start_teaching")%>
                                    </a>                                    
                            </ul>
                        </div>
                    </div>
                </div>
                
            </div>
        </div>
        <%@include file="footer.jsp" %>    
    </body>
</html>
