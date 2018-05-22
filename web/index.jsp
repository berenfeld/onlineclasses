<%@page import="com.onlineclasses.utils.Config"%>
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
                <div class="col-xl-6 col-lg-6">
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
                                    <ul class="h5 text-left">
                                        <li>
                                            the best teachers
                                        </li>
                                        <li>
                                            user friendly, advanced website
                                        </li>
                                        <li>
                                            all the material and classes available, 24/7
                                        </li>
                                        <li>
                                            our guarantee
                                        </li>
                                        <li>
                                            Want to join us and start learning ?
                                            <a href="start_learning">
                                                click here to start
                                            </a>
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
                                    <ul class="h5 text-left">
                                        <li>
                                            mentoring and guidance
                                        </li>
                                        <li>
                                            our guarantee
                                        </li>
                                        <li>
                                            free for new teachers ! USB electronic pen
                                        </li>
                                        <li>
                                            want to become a teacher ?
                                            contact us at
                                            <a href="mailto:admin@onlineclasses.co.il">
                                                admin@onlineclasses.co.il
                                            </a>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-6 col-kg-6">
                    <div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel">
                        <ol class="carousel-indicators">
                            <li data-target="#carouselExampleIndicators" data-slide-to="0" class="active"></li>
                            <li data-target="#carouselExampleIndicators" data-slide-to="1"></li>
                            <li data-target="#carouselExampleIndicators" data-slide-to="2"></li>
                        </ol>
                        <div class="carousel-inner">
                            <div class="carousel-item active">
                                <img class="d-block w-100" src="images/car3.jpg" alt="First slide">
                            </div>
                            <div class="carousel-item">
                                <img class="d-block w-100" src="images/car4.jpg" alt="Second slide">
                            </div>
                            <div class="carousel-item">
                                <img class="d-block w-100" src="images/car2.jpg" alt="Third slide">
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
            </div>
        </div>
        <%@include file="footer.jsp" %>    

    </body>

</html>
