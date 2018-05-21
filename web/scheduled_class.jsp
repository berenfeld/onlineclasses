<%@page import="java.io.File"%>
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
    OClass oClass = DB.getOClass(classId);

    // TODO handle not found / canceled
    Teacher teacher = oClass.teacher;
    Student student = oClass.student;

    boolean isStudent = student.equals(ServletBase.getUser(request));
    boolean isTeacher = teacher.equals(ServletBase.getUser(request));
    List<ClassComment> classComments = DB.getScheuduledClassComments(oClass);
    float classPrice = (((float) oClass.duration_minutes * oClass.price_per_hour) / Utils.MINUTES_IN_HOUR);
    String classPriceFormatted = Utils.formatPrice(classPrice);
    List<AttachedFile> classAttachedFiles = DB.getClassAttachedFiles(oClass);
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
                <input type="hidden" name="amount" value="<%= classPriceFormatted%>">
                <input type="hidden" name="currency_code" value="<%= Config.get("website.paypal.currency_code")%>">
                <INPUT TYPE="hidden" name="charset" value="utf-8">
                <INPUT TYPE="hidden" NAME="return" value="<%= Utils.buildWebsiteURL("scheduled_class", "id=" + oClass.id)%>">
                <input type="hidden" name="<email>" value="<%= student.email%>">
                <input type="hidden" name="<first_name>" value="<%= student.first_name%>">
                <input type="hidden" name="<last_name>" value="<%= student.last_name%> ">
                <input type="hidden" name="quantity" value="1">
                <input type="hidden" name="item_name" value="<%= Config.get("website.paypal.item_name")%>">
                <input type="hidden" name="item_number" value="<%= oClass.id%>">
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
                                               value="<%= classPriceFormatted%>" disabled/>
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
                                        <%= oClass.duration_minutes / 60.0%>
                                        <%= CLabels.get("language.hours")%>
                                        &times;
                                        <%= Labels.get("scheduled.class.payment_modal.calculation_end")%>                                        
                                        <%= Utils.formatPrice(oClass.price_per_hour)%>
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

        <iframe id="scheduled_class_post_hidden_iframe" name="scheduled_class_post_hidden_iframe" class="d-none">

        </iframe>

        <div id="scheduled_class_attach_file_modal" class="modal fade" role="dialog">
            <div class="modal-dialog modal-md">
                <form action="/servlets/file_upload" method="post" enctype="multipart/form-data"
                      target="scheduled_class_post_hidden_iframe"
                      onsubmit="scheduled_class_submit_file()">
                    <div class="modal-content">
                        <div class="modal-header bg-secondary text-white">                                
                            <div class="modal-title"> 
                                <span class="oi" data-glyph="file"></span> 
                                <%= Labels.get("scheduled.class.attach_file_modal.title")%>
                            </div>
                            <span class="oi close_button" data-dismiss="modal" data-glyph="x"></span>   
                        </div>
                        <div class="modal-body">
                            <input type="hidden" name="scheduled_class_id" value="<%= oClass.id%>">
                            <div class="form-group row">                                 
                                <div id="scheduled_class_attach_file_button_wrapper" class="col-4">                                
                                    <input type="file" name="scheduled_class_attach_file_input"
                                           id="scheduled_class_attach_file_input"                                           
                                           onchange="scheduled_class_update_chosen_file()">  
                                    <button class="btn btn-info">
                                        <%= Labels.get("scheduled.class.attach_file_modal.choose_file")%>
                                    </button>
                                </div>
                                <div class="col-8">     
                                    <label type="text" for="scheduled_class_attach_file_input"                                           
                                           class="form-control">
                                        <span id="scheduled_class_attach_file_chosen_file_name">
                                            <%= Labels.get("scheduled.class.attach_file_modal.no_file_chosen")%>
                                        </span>

                                    </label>
                                </div>
                            </div>
                            <div class="form-group row">     
                                <label for="scheduled_class_attach_file_comment"
                                       class="col-form-label col-4">
                                    <%= Labels.get("scheduled.class.attach_file_modal.add_comment")%>
                                </label>
                                <div class="col-8">                                
                                    <input type="text" class="form-control"
                                           name="scheduled_class_attach_file_comment"
                                           id="scheduled_class_attach_file_comment">  
                                </div>
                            </div>
                        </div>
                        <div id="scheduled_class_attach_file_info_div" class="alert alert-info d-none" role="alert">
                            <span class="oi" data-glyph="info"></span>    
                            <span id="scheduled_class_attach_file_info_text"></span>
                        </div>
                        <div class="modal-footer">
                            <input type="submit" id="scheduled_class_attach_file_submit_button" 
                                   class="btn btn-success mx-1" value="<%= Labels.get("buttons.ok")%>" name="upload" id="upload" />
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
                            <%= oClass.subject%>&nbsp;
                        </h6>
                        <h6>
                            <%= Labels.get("scheduled.class.sidebar.status")%>&nbsp;
                            <%= Utils.toList(Labels.get("scheduled_class.status.text")).get(oClass.status - 1)%>&nbsp;
                        </h6>
                        <h6>
                            <%= Labels.get("scheduled.class.sidebar.teacher")%>&nbsp;
                            <%= oClass.teacher.display_name%>&nbsp;
                        </h6>
                        <h6>
                            <%= Labels.get("scheduled.class.sidebar.student")%>&nbsp;
                            <%= oClass.student.display_name%>&nbsp;
                        </h6>
                        <h6>
                            <%= Labels.get("scheduled.class.sidebar.start_date")%>&nbsp;
                            <%= Utils.formatDateTime(oClass.start_date)%>&nbsp;
                        </h6>
                        <h6>
                            <%= Labels.get("scheduled.class.sidebar.duration_text")%>&nbsp;
                            <%= oClass.duration_minutes%>&nbsp;
                            <%= CLabels.get("language.minutes")%>
                        </h6>
                        <h6>
                            <%= Labels.get("scheduled.class.sidebar.price_text")%>&nbsp;
                            <%=  classPriceFormatted%>&nbsp;
                            <%= CLabels.get("website.currency")%>
                            <%
                                if (oClass.payment == null) {
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
                        <button class="btn btn-warning" onclick="scheduled_class_pay()">
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
                        <p class="my-0">
                            <%
                                if (classComments.isEmpty()) {
                                    out.write(Labels.get("scheduled.class.sidebar.comments.no_comments"));
                                }
                                for (ClassComment comment : classComments) {
                            %>

                            <span class="font-weight-bold">
                                <%
                                    if (comment.student != null) {
                                        out.write(comment.student.display_name);
                                    } else {
                                        out.write(comment.teacher.display_name);
                                    }
                                %>

                                &nbsp;,&nbsp;
                                <%= Utils.formatDateTime(comment.added)%>                                
                                &nbsp;:&nbsp;
                            </span>
                            <%= comment.comment%>                            
                            <br/>
                            <%
                                }
                            %>
                        </p>
                    </div>
                    <div class="card-footer">                            
                        <div class="row">
                            <div class="col mx-auto">
                                <button onclick="schedule_class_add_comment()" class="btn btn-info">
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
                        <p class="my-0">
                            <%
                                if (classAttachedFiles.isEmpty()) {
                                    out.write(Labels.get("scheduled.class.sidebar.attache_file.no_attached_files"));
                                }
                                for (AttachedFile oClassAttachedFile : classAttachedFiles) {
                                    if (oClassAttachedFile.size != oClassAttachedFile.uploaded) {
                                        continue;
                                    }
                            %>
                            <%
                                String filePath
                                        = Config.get("website.file.upload.root") + "/"
                                        + Config.get("website.file.upload.classes_prefix")
                                        + oClass.id + "/" + oClassAttachedFile.name;
                            %>
                            <a href="<%= filePath%>" class="text-white" target="_blank">
                                <b>
                                <%= oClassAttachedFile.name%>
                                </b>
                            </a>
                            <span class="small">
                                <%= Labels.get("scheduled.class.attach_file.file_size")%>
                                <%= Utils.formatFileSize(oClassAttachedFile.size)%>
                            </span>
                            <br/>
                            <span class="small">
                                <%= Labels.get("scheduled.class.attach_file.uploaded_by")%>
                                <%
                                    if (oClassAttachedFile.student != null) {
                                        out.write(oClassAttachedFile.student.display_name);
                                    } else {
                                        out.write(oClassAttachedFile.teacher.display_name);
                                    }
                                %>
                                <%= Labels.get("scheduled.class.attach_file.uploaded_at_date")%>                                                                
                                <%= Utils.formatDateTime(oClassAttachedFile.added)%>                                
                            </span>
                            <%
                                if (Utils.isNotEmpty(oClassAttachedFile.comment)) {
                            %>
                            <span class="small">
                                <%= Labels.get("scheduled.class.attach_file.with_comment")%>        
                                <%= oClassAttachedFile.comment%>
                            </span>
                            <%
                                }
                            %>
                            <br/>
                            <%
                                }
                            %>
                        </p>
                    </div>
                    <div class="card-footer">                            
                        <div class="row">
                            <div class="col mx-auto">
                                <button onclick="schedule_class_attach_file()" class="btn btn-info">
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
                            <%= oClass.subject%>
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
    scheduled_class.scheduled_class = <%= Utils.gson().toJson(oClass)%>;
    scheduled_class.teacher = <%= Utils.gson().toJson(teacher)%>;
    scheduled_class.student = <%= Utils.gson().toJson(student)%>;
    scheduled_class_init();
</script>
</body>

</html>
