<%@include file="start.jsp" %>

<%@page import="com.onlineclasses.entities.Topic"%>
<%@page import="com.onlineclasses.entities.Subject"%>
<%@page import="com.onlineclasses.utils.Config"%>
<%    Map<Integer, Subject> allSubjects = DB.getAllMap(Subject.class);
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
            <div class="row no-gutters my-3">
                <div class="col-12 col-xl-7 col-lg-7">
                    <div class="card border-0">
                        <div class="card-header h3">
                            <%= Labels.get("mainpage.heading")%>
                        </div>
                        <div class="card-body text-info">
                            <p class="h5">
                                <%= Labels.get("mainpage.heading2")%>
                            </p>
                            <p class="h5">
                                <a href="<%= Config.get("website.url")%>">
                                    <%= Labels.get("website.name")%>
                                </a>
                                <%= Labels.get("mainpage.heading3")%>
                            </p>
                            <div class="form-group row">
                                <div class="col-xl-3 col-lg-3 col-md-3">
                                    <label class="col-form-label col-form-label-lg">
                                        <%= Labels.get("mainpage.topic")%>
                                    </label>
                                </div>
                                <div class="col-xl-9 col-lg-9 col-md-9">
                                    <div>
                                        <input type="text" name="index_topic_name"
                                               id="index_topic_name" 
                                               class="form-control form-control-lg rounded"
                                               placeholder="<%= Labels.get("mainpage.topic2")%>">
                                        </input>                                                
                                    </div>
                                </div>
                            </div>
                            <div class="form-group row">
                                <div class="col">
                                    <button type="button" onclick="index_find_teachers_submit()" class="float-left mr-1 btn btn-lg btn-info">
                                        <%= Labels.get("mainpage.start_button")%>
                                    </button>
                                    <%
                                        if (!BaseServlet.isLoggedIn(request)) {
                                    %>
                                    <button type="button" title="<%= Labels.get("mainpage.student.register.hint")%>" onclick="login_registerStudent()" class="float-left btn btn-lg btn-primary">
                                        <%= Labels.get("mainpage.student.register")%>
                                    </button>
                                    <%
                                        }
                                    %>

                                </div>

                            </div>

                        </div>
                    </div>
                </div>
                <div class="col-12 col-xl-5 col-lg-5">
                    <div id="index_carousel" class="carousel slide" data-ride="carousel">
                        <ol class="carousel-indicators">
                            <li data-target="#index_carousel" data-slide-to="0" class="active"></li>
                            <li data-target="#index_carousel" data-slide-to="1"></li>
                            <li data-target="#index_carousel" data-slide-to="2"></li>                            
                        </ol>
                        <div class="carousel-inner">
                            <div class="carousel-item active">
                                <img class="d-block w-100 h-100" src="images/main1.jpg" alt="First slide">
                            </div>
                            <div class="carousel-item">
                                <img class="d-block w-100 h-100" src="images/main2.jpg" alt="First slide">
                            </div>
                            <div class="carousel-item">
                                <img class="d-block w-100 h-100" src="images/main3.jpg" alt="First slide">
                            </div>
                        </div>
                        <a class="carousel-control-prev" href="#index_carousel" role="button" data-slide="prev">
                            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                            <span class="sr-only">Previous</span>
                        </a>
                        <a class="carousel-control-next" href="#index_carousel" role="button" data-slide="next">
                            <span class="carousel-control-next-icon" aria-hidden="true"></span>
                            <span class="sr-only">Next</span>
                        </a>
                    </div>
                </div>
            </div>
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
                                    <a href="javascript:login_registerStudent()">
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
        <script>
            index.all_subjects = <%= Utils.gson().toJson(allSubjects)%>;
            index.all_topics = <%= Utils.gson().toJson(allTopics)%>;
        </script>
    </body>

</html>
