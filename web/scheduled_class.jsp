<%@page import="com.onlineclasses.entities.ScheduledClassComment"%>
<%@page import="com.onlineclasses.entities.Student"%>
<%@page import="com.onlineclasses.utils.Utils"%>
<%@page import="com.onlineclasses.entities.Teacher"%>
<%@page import="com.onlineclasses.db.DB"%>
<%@page import="com.onlineclasses.entities.ScheduledClass"%>
<%@page import="com.onlineclasses.utils.Config"%>
<%@page import="com.onlineclasses.utils.Labels"%>

<%
    int classId = Integer.parseInt(request.getParameter("id"));
    ScheduledClass scheduledClass = DB.getScheduledClass(classId);
    // TODO handle not found

    Teacher teacher = scheduledClass.teacher;
    Student student = scheduledClass.student;

    boolean isStudent = student.equals(ServletBase.getUser(request));
    boolean isTeacher = teacher.equals(ServletBase.getUser(request));
    List<ScheduledClassComment> scheduledClassComments = DB.getScheuduledClassComments(scheduledClass);
    float schedledClassPrice = (((float) scheduledClass.duration_minutes * scheduledClass.price_per_hour) / Utils.MINUTES_IN_HOUR);
    String schedledClassPriceFormatted = Utils.formatPrice(schedledClassPrice);
%>

<!DOCTYPE html>
<html lang="<%= Config.get("website.html_language")%>" dir="<%= Config.get("webiste.direction")%>">
    <head>
        <%@include file="header.jsp" %>
        <link rel="stylesheet" href="css/scheduled_class.css">
    </head>
    <body lang="<%= Config.get("website.html_language")%>" dir="<%= Config.get("webiste.direction")%>">
        <%@include file="body.jsp" %>    

        <div class="container">   
            <div id="schedule_class_payment_modal" class="modal fade" role="dialog">
                <form action="https://www.paypal.com/cgi-bin/webscr" method="post">
                    <div class="modal-dialog modal-md">

                        <div class="modal-content">
                            <div class="modal-header bg-secondary text-white">
                                <h6 class="modal-title"> 
                                    <%= Labels.get("scheduled.class.payment_modal.title")%>
                                </h6>
                            </div>
                            <div class="modal-body">
                                <h6>
                                    <%= Labels.get("scheduled.class.payment_modal.text1")%>
                                    <br/>
                                    <%= Labels.get("scheduled.class.payment_modal.text2")%>
                                </h6>
                                <div class="form-group row">
                                    <label for="schedule_class_payment_modal_price" class="col col-form-label">
                                        <%= Labels.get("scheduled.class.payment_modal.totla_price")%>
                                    </label>
                                    <div class="col">
                                        <input type="text" class="form-control" 
                                               id="schedule_class_payment_modal_price"
                                               name="schedule_class_payment_modal_price"
                                               value="<%= schedledClassPriceFormatted%>" disabled/>
                                    </div>
                                </div>

                            </div>
                            <div class="modal-footer">
                                <input type="image" name="submit"
                                       src="https://www.paypalobjects.com/webstatic/en_US/i/buttons/checkout-logo-medium.png" 
                                       alt="Check out with PayPal" />
                                <button type="button" class="btn btn-info mx-1" data-dismiss="modal">
                                    <%= Labels.get("buttons.cancel")%>
                                </button>
                            </div>

                        </div>

                    </div>
                </form>
            </div>

            <div class="row no-gutter">
                <div class="col-xl-4 col-lg-4">                        
                    <div class="card my-2">
                        <div class="card-header h5">
                            <%= Labels.get("scheduled.class.sidebar.general.title")%>
                        </div>
                        <div class="card-body bg-secondary text-white">

                            <h6>
                                <%= Labels.get("scheduled.class.sidebar.subject")%>&nbsp;
                                <%= scheduledClass.subject%>&nbsp;
                            </h6>
                            <h6>
                                <%= Labels.get("scheduled.class.sidebar.teacher")%>&nbsp;
                                <%= scheduledClass.teacher.display_name%>&nbsp;
                            </h6>
                            <h6>
                                <%= Labels.get("scheduled.class.sidebar.student")%>&nbsp;
                                <%= scheduledClass.student.display_name%>&nbsp;
                            </h6>
                            <h6>
                                <%= Labels.get("scheduled.class.sidebar.start_date")%>&nbsp;
                                <%= Utils.formatDateTime(scheduledClass.start_date)%>&nbsp;
                            </h6>
                            <h6>
                                <%= Labels.get("scheduled.class.sidebar.duration_text")%>&nbsp;
                                <%= scheduledClass.duration_minutes%>&nbsp;
                                <%= CLabels.get("language.minutes")%>
                            </h6>
                            <h6>
                                <%= Labels.get("scheduled.class.sidebar.price_text")%>&nbsp;
                                <%=  schedledClassPriceFormatted%>&nbsp;
                                <%= CLabels.get("website.currency")%>
                                <%
                                    if (scheduledClass.payment == null) {
                                %>
                                <a class="text-warning" href="javascript:scheduled_class_pay()">
                                    <%= Labels.get("scheduled.class.sidebar.payment.not_paid_yet")%>                                
                                </a>
                                <%
                                    }
                                %>
                            </h6>
                        </div>
                        <div class="card-footer">     
                            <%
                                if (isStudent) {
                            %>
                            <button class="btn btn-warning" onclick="javascript:scheduled_class_pay()">
                                <%= Labels.get("scheduled.class.sidebar.pay_for_class")%>
                            </button>
                            <%
                                }
                            %>
                            <%
                                if (isTeacher) {
                            %>
                            <button class="btn btn-info">
                                <%= Labels.get("scheduled.class.sidebar.update_price")%>
                            </button>
                            <%
                                }
                            %>
                            <button class="btn btn-danger">
                                <%= Labels.get("scheduled.class.sidebar.cancel_class")%>
                            </button>

                        </div>
                    </div>
                    <div class="card my-2">
                        <div class="card-header h5">
                            <%= Labels.get("scheduled.class.sidebar.comments.title")%>
                        </div>
                        <div class="card-body bg-secondary text-white">
                            <p>
                                <%
                                    for (ScheduledClassComment scheduledClassComment : scheduledClassComments) {
                                %>

                                <span class="font-weight-bold">
                                    <%
                                        if (scheduledClassComment.student != null) {
                                            out.write(scheduledClassComment.student.display_name);
                                        } else {
                                            out.write(scheduledClassComment.teacher.display_name);
                                        }
                                    %>

                                    &nbsp;,&nbsp;
                                    <%= Utils.formatDateTime(scheduledClassComment.added)%>                                
                                    &nbsp;:&nbsp;
                                </span>
                                <%= scheduledClassComment.comment%>                            
                                <br/>
                                <%
                                    }
                                %>
                            </p>
                        </div>
                        <div class="card-footer">                            
                            <div class="row">
                                <div class="col mx-auto">
                                    <button onclick="javascript:schedule_class_add_comment()" class="btn btn-info">
                                        <%= Labels.get("scheduled.class.sidebar.add_comment")%>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-8 col-lg-8 my-2">
                    <div id="scheduled_class_main_board">
                        <table>
                            <tr ><h2 class="text-center">&nbsp;</h2></tr>
                            <tr ><h2 class="text-center">&nbsp;</h2></tr>
                            <tr>                            
                            <h2 class="text-center" id="scheduled_class_main_board_title">
                                <%= Labels.get("scheduled.class.title")%>
                                <%= scheduledClass.subject%>
                            </h2>
                            </tr>
                            <tr>
                            <h2 class="text-center" id="scheduled_class_main_board_starting_in">
                                <%= Labels.get("scheduled.class.starting_in")%>  
                                <span id="scheduled_class_main_board_starting_in_value"></span>
                            </h2>
                            </tr>                        
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>        
    <%@include file="footer.jsp" %>    
    <script>
        scheduled_class.scheduled_class = <%= Utils.gson().toJson(scheduledClass)%>;
        scheduled_class.teacher = <%= Utils.gson().toJson(teacher)%>;
        scheduled_class.student = <%= Utils.gson().toJson(student)%>;
        scheduled_class_init();
    </script>
</body>

</html>
