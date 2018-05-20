<%@page import="com.onlineclasses.entities.AttachedFile"%>
<%@page import="com.onlineclasses.entities.ClassComment"%>
<%@page import="com.onlineclasses.entities.Student"%>
<%@page import="com.onlineclasses.utils.Utils"%>
<%@page import="com.onlineclasses.entities.Teacher"%>
<%@page import="com.onlineclasses.db.DB"%>
<%@page import="com.onlineclasses.entities.OClass"%>
<%@page import="com.onlineclasses.utils.Config"%>
<%@page import="com.onlineclasses.utils.Labels"%>

<%
    int classId = Integer.parseInt(request.getParameter("id"));
    OClass scheduledClass = DB.getOClass(classId);
    
    // TODO handle not found / canceled

    Teacher teacher = scheduledClass.teacher;
    Student student = scheduledClass.student;

    boolean isStudent = student.equals(ServletBase.getUser(request));
    boolean isTeacher = teacher.equals(ServletBase.getUser(request));
    List<ClassComment> scheduledClassComments = DB.getScheuduledClassComments(scheduledClass);
    float schedledClassPrice = (((float) scheduledClass.duration_minutes * scheduledClass.price_per_hour) / Utils.MINUTES_IN_HOUR);
    String schedledClassPriceFormatted = Utils.formatPrice(schedledClassPrice);
    List<AttachedFile> scheduledClassAttachedFiles = DB.getScheuduledClassAttachedFiles(scheduledClass);
%>

<!DOCTYPE html>
<html lang="<%= Config.get("website.html_language")%>" dir="<%= Config.get("webiste.direction")%>">
    <head>
        <%@include file="header.jsp" %>
        <link rel="stylesheet" href="css/scheduled_class.css">
    </head>
    <body lang="<%= Config.get("website.html_language")%>" dir="<%= Config.get("webiste.direction")%>">
        <%@include file="body.jsp" %>    

        <div id="schedule_class_payment_modal" class="modal fade" role="dialog">
            <form action="https://www.paypal.com/cgi-bin/webscr" method="post">
                <input type="hidden" name="cmd" value="_xclick">
                <input type="hidden" name="business" value="<%= teacher.paypal_email%>">
                <input type="hidden" name="amount" value="<%= schedledClassPriceFormatted%>">
                <input type="hidden" name="currency_code" value="<%= Config.get("website.paypal.currency_code")%>">
                <INPUT TYPE="hidden" name="charset" value="utf-8">
                <INPUT TYPE="hidden" NAME="return" value="<%= Utils.buildWebsiteURL("scheduled_class", "id=" + scheduledClass.id)%>">
                <input type="hidden" name="<email>" value="<%= student.email%>">
                <input type="hidden" name="<first_name>" value="<%= student.first_name%>">
                <input type="hidden" name="<last_name>" value="<%= student.last_name%> ">
                <input type="hidden" name="quantity" value="1">
                <input type="hidden" name="item_name" value="<%= Config.get("website.paypal.item_name")%>">
                <input type="hidden" name="item_number" value="<%= scheduledClass.id%>">
                <input type="hidden" name="notify_url" value="<%= Utils.buildWebsiteURL("servlets/paypal_ipn")%>">

                <div class="modal-dialog modal-md">
                    <div class="modal-content">
                        <div class="modal-header bg-secondary text-white">                                
                            <div class="modal-title"> 
                                <span class="oi" data-glyph="dollar"></span> 
                                <%= Labels.get("scheduled.class.payment_modal.title")%>
                            </div>
                            <span class="oi close_button" data-dismiss="modal" data-glyph="x"></span>   
                        </div>
                        <div class="modal-body">
                            <h6>
                                <%= Labels.get("scheduled.class.payment_modal.text1")%>
                                <br/>
                                <%= Labels.get("scheduled.class.payment_modal.text2")%>
                            </h6>
                            <div class="form-group row">
                                <label for="schedule_class_payment_modal_price" class="col-6 col-form-label my-1">
                                    <%= Labels.get("scheduled.class.payment_modal.total_price")%>
                                </label>
                                <div class="col-6 my-1">
                                    <div class="input-group">

                                        <input type="text" class="form-control" 
                                               id="schedule_class_payment_modal_price"
                                               name="schedule_class_payment_modal_price"
                                               value="<%= schedledClassPriceFormatted%>" disabled/>
                                        <div class="input-group-prepend">
                                            <span class="input-group-text">
                                                <%= CLabels.get("website.currency")%>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                <br/>
                                <p class="col-12 my-1">
                                    <small>
                                        <%= Labels.get("scheduled.class.payment_modal.calculation_start")%>                                        
                                        <%= scheduledClass.duration_minutes / 60.0%>
                                        <%= CLabels.get("language.hours")%>
                                        &times;
                                        <%= Labels.get("scheduled.class.payment_modal.calculation_end")%>                                        
                                        <%= Utils.formatPrice(scheduledClass.price_per_hour)%>
                                        <%= CLabels.get("website.currency")%>
                                    </small>
                                </p>
                            </div>

                        </div>
                        <div class="modal-footer">
                            <input type="submit" name="submit"
                                   class="btn btn-success mx-1"                                   
                                   alt="Check out with PayPal" 
                                   value="<%= Labels.get("website.paypal.pay_now_button")%>"/>
                            <button type="button" class="btn btn-info mx-1" data-dismiss="modal">
                                <%= Labels.get("buttons.cancel")%>
                            </button>
                        </div>

                    </div>

                </div>
            </form>
        </div>

        <div id="scheduled_class_attach_file_modal" class="modal fade" role="dialog">
            <div class="modal-dialog modal-md">
                <form action="/servlets/upload_file" method="post" enctype="multipart/form-data">
                    <div class="modal-content">
                        <div class="modal-header bg-secondary text-white">                                
                            <div class="modal-title"> 
                                <span class="oi" data-glyph="file"></span> 
                                <%= Labels.get("scheduled.class.attach_file_modal.title")%>
                            </div>
                            <span class="oi close_button" data-dismiss="modal" data-glyph="x"></span>   
                        </div>
                        <div class="modal-body">
                            <h6>
                                <%= Labels.get("scheduled.class.attach_file_modal.text1")%>
                            </h6>
                            <div class="custom-file">

                                <input type="hidden" name="scheduled_class_id" value="<%= scheduledClass.id%>">
                                <input type="file" class="custom-file-input" id="scheduled_class_attach_file_custom_file_input">
                                <label class="custom-file-label" for="scheduled_class_attach_file_custom_file_input">
                                    <%= Labels.get("scheduled.class.attach_file_modal.choose_file")%>
                                </label>
                            </div>

                        </div>
                        <div class="modal-footer">
                            <input type="submit" class="btn btn-success mx-1" value="<%= Labels.get("buttons.ok")%>" name="upload" id="upload" />

                            <button type="button" class="btn btn-info mx-1" data-dismiss="modal">
                                <%= Labels.get("buttons.cancel")%>
                            </button>
                        </div>
                </form>
            </div>

        </div>
    </div>

    <div class="container">   
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
                            <%= Labels.get("scheduled.class.sidebar.status")%>&nbsp;
                            <%= Utils.toList(Labels.get("scheduled_class.status.text")).get(scheduledClass.status - 1) %>&nbsp;
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
                        <button class="btn btn-danger" onclick="schedule_class_cancel_click()">
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
                                for (ClassComment scheduledClassComment : scheduledClassComments) {
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

                <div class="card my-2">
                    <div class="card-header h5">
                        <%= Labels.get("scheduled.class.sidebar.attached_files")%>
                    </div>
                    <div class="card-body bg-secondary text-white">
                        <p>
                            <%
                                for (AttachedFile scheduledClassAttachedFile : scheduledClassAttachedFiles) {
                            %>

                            <span class="font-weight-bold">
                                <%
                                    if (scheduledClassAttachedFile.student != null) {
                                        out.write(scheduledClassAttachedFile.student.display_name);
                                    } else {
                                        out.write(scheduledClassAttachedFile.teacher.display_name);
                                    }
                                %>

                                &nbsp;,&nbsp;
                                <%= Utils.formatDateTime(scheduledClassAttachedFile.added)%>                                
                                &nbsp;:&nbsp;
                            </span>
                            <%= scheduledClassAttachedFile.name%>                            
                            <br/>
                            <%
                                }
                            %>
                        </p>
                    </div>
                    <div class="card-footer">                            
                        <div class="row">
                            <div class="col mx-auto">
                                <button onclick="javascript:schedule_class_attach_file()" class="btn btn-info">
                                    <%= Labels.get("scheduled.class.sidebar.attache_file")%>
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
