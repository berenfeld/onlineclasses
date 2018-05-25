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
            <div class="row no-gutters my-3">
                <div class="col-xl-6 col-kg6">
                    <div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel">
                        <ol class="carousel-indicators">
                            <li data-target="#carouselExampleIndicators" data-slide-to="0" class="active"></li>
                            <li data-target="#carouselExampleIndicators" data-slide-to="1"></li>
                            <li data-target="#carouselExampleIndicators" data-slide-to="2"></li>                            
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
                        <a class="carousel-control-prev" href="#carouselExampleIndicators" role="button" data-slide="prev">
                            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                            <span class="sr-only">Previous</span>
                        </a>
                        <a class="carousel-control-next" href="#carouselExampleIndicators" role="button" data-slide="next">
                            <span class="carousel-control-next-icon" aria-hidden="true"></span>
                            <span class="sr-only">Next</span>
                        </a>
                    </div>
                </div>
                <div class="col-xl-6 col-lg-6">
                    <div class="card border-0">
                        <div class="card-header h2">
                            <%= Labels.get("mainpage.heading")%>
                        </div>
                        <div class="card-body text-info">
                            <p class="h4">

                                <%= Labels.get("mainpage.heading2")%>
                            </p>
                            <p class="h4">
                                <a href="<%= Config.get("website.url")%>">
                                    <%= Labels.get("website.name")%>
                                </a>
                                <%= Labels.get("mainpage.heading3")%>
                            </p>
                            <div class="form-group row">
                                <div class="col-xl-3 col-lg-3">
                                    <label class="h3 col-form-label-lg">
                                        <%= Labels.get("mainpage.topic")%>
                                    </label>
                                </div>
                                <div class="col-xl-9 col-lg-9">
                                    <div>
                                        <input type="text" name="index_topic_name"
                                               id="index_topic_name" 
                                               class="form-control form-control-lg"
                                               placeholder="<%= Labels.get("mainpage.topic2")%>">
                                        </input>                                                
                                    </div>
                                </div>
                            </div>
                            <div class="form-group row">
                                <div class="col">
                                    <button type="button" onclick="index_find_teachers_submit()" class="float-left btn btn-lg btn-info">
                                        <%= Labels.get("mainpage.start_button")%>
                                    </button>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
            <div class="row no-gutters my-3">
                <div class="col">
                    <div class="card mx-3" style="border:none">
                        <p class="h1 text-center">
                            welcome to onlineclasses.co.il
                        </p>
                        <div class="h2 text-info mx-1 text-left">
                            We are a team of profesional teachers, for computer science and
                            other technology fields
                        </div>
                        <div class="h2 text-info mx-1 text-left">
                            We are a team of profesional teachers, for computer science and
                            other technology fields. 
                            <a href="about_us">
                                Read more about us
                            </a>
                        </div>
                        <div class="row">
                            <div class="col">
                                <div class="h4 text-center">
                                    Our students get
                                    <ul class="h5 text-left list-unstyled">
                                        <li>                                            
                                            the best teachers
                                            <span class="oi" data-glyph="star"></span>      
                                        </li>
                                        <li>
                                            user friendly, advanced website
                                            <span class="oi" data-glyph="star"></span>      
                                        </li>
                                        <li>
                                            all the material and classes available, 24/7
                                            <span class="oi" data-glyph="star"></span>      
                                        </li>
                                        <li>
                                            our guarantee
                                            <span class="oi" data-glyph="star"></span>      
                                        </li>
                                        <li>
                                            Want to join us and start learning ?
                                            <a href="start_learning">
                                                click here to start
                                            </a>
                                            <span class="oi" data-glyph="star"></span>      
                                        </li>
                                    </ul>
                                </div>
                            </div>
                            <div class="col">
                                <div class="h3 text-center">                                
                                    <a href="find_teachers">
                                        Our teachers
                                    </a>
                                    get
                                    <ul class="h5 text-left list-unstyled">
                                        <li>
                                            mentoring and guidance
                                            <span class="oi" data-glyph="star"></span>      
                                        </li>
                                        <li>
                                            our guarantee
                                            <span class="oi" data-glyph="star"></span>      
                                        </li>
                                        <li>
                                            free for new teachers ! USB electronic pen
                                            <span class="oi" data-glyph="star"></span>      
                                        </li>
                                        <li>
                                            want to become a teacher ?
                                            contact us at
                                            <a href="mailto:admin@onlineclasses.co.il">
                                                admin@onlineclasses.co.il
                                            </a>
                                            <span class="oi" data-glyph="star"></span>      
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
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
