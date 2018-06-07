<%@page import="com.onlineclasses.utils.Labels"%>

<div id="login_modal" class="modal fade" role="dialog">
    <div class="modal-dialog modal-md" role="document">
        <div class="modal-content">
            <div class="modal-header bg-secondary text-white">
                <div class="h5 modal-title">
                    <span class="oi mx-1" data-glyph="account-login"></span>                                       
                    <%= Labels.get("login.modal.title")%>                        
                </div>
                <span class="oi close_button" data-dismiss="modal" data-glyph="x"></span>      
            </div>
            <div class="modal-body">
                <h5>
                    <%= Labels.get("login.modal.text1")%>                    
                </h5>
                <div class="row no-gutters">
                    <div class="col-6">                        
                        <input type="image" src="images/google_login_button.png" class="w-100" onclick="login_googleLogin()">              
                    </div>
                </div>
                <h5>
                <small>
                    <%= Labels.get("login.modal.text1_small")%>
                    <span class="oi" data-glyph="info"></span>     
                    <span class="text-info">
                        <%= Labels.get("login.modal.text2")%>                    
                        <a class="alert-link" href="start_learning">
                            <%= Labels.get("login.modal.register.student")%>
                        </a> 
                    </span>
                </small>
                </h5>
            </div>
            <div id="login_modal_info_div" class="alert alert-info d-none" role="alert">
                <span class="oi" data-glyph="info"></span>    
                <span id="login_modal_info_text"></span>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-info" data-dismiss="modal">
                    <%= Labels.get("buttons.cancel")%>
                </button>
            </div>                
        </div>

    </div>
</div>

<div id="confirm_modal" class="modal fade" role="dialog">
    <div class="modal-dialog modal-sm">
        <div class="modal-content">
            <div class="modal-header bg-secondary text-white">
                <div class="modal-title">
                    <span class="oi" data-glyph="check"></span>
                    <span id="confirm_modal_title"></span>
                </div>
                <span class="oi close_button" data-dismiss="modal" data-glyph="x"></span>      
            </div>
            <div class="modal-body">
                <span id="confirm_modal_message"></span>                   
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-info mx-1" onclick="confirm_cancel()" data-dismiss="modal"><%= Labels.get("buttons.cancel")%></button>
                <button type="button" class="btn btn-success mx-1" onclick="confirm_ok()" data-dismiss="modal"><%= Labels.get("buttons.ok")%></button>
            </div>
        </div>

    </div>
</div>

<div id="alert_modal" class="modal fade" role="dialog">
    <div class="modal-dialog modal-sm">

        <div class="modal-content">
            <div class="modal-header bg-secondary text-white">
                <div class="modal-title"> 
                    <h6>
                        <span class="oi mx-1" data-glyph="info"></span>       
                        <span id="alert_modal_title">
                            <%= Labels.get("alert.modal.title")%>
                        </span>
                    </h6>
                </div>
                <span class="oi close_button" data-dismiss="modal" data-glyph="x"></span>      
            </div>
            <div class="modal-body">
                <h6 id="alert_modal_text1">
                    <%= Labels.get("alert.modal.text1")%>
                </h6>                    
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-success" data-dismiss="modal"><%= Labels.get("buttons.ok")%></button>
            </div>

        </div>

    </div>
</div>

<div id="invite_other_student_modal" class="modal fade" role="dialog">
    <div class="modal-dialog modal-md">

        <div class="modal-content">
            <div class="modal-header bg-secondary text-white">
                <div class="modal-title"> 
                    <span class="oi mx-1" data-glyph="envelope-closed"></span>                
                    <%= Labels.get("invite_other_student.modal.title")%>                            
                </div>
                <span class="oi close_button" data-dismiss="modal" data-glyph="x"></span>      
            </div>
            <div class="modal-body  text-secondary">
                <p>
                    <%= Labels.get("invite_other_student.modal.text")%>      
                </p>
                <form>
                    <div class="form-group row">
                        <label class="col-form-label col-xl-6 col-lg-6 col-md-6 col-12" for="invite_other_student_name">
                            <%= Labels.get("invite_other_student.form.name_label")%>
                        </label>
                        <div class="col-xl-6 col-lg-6 col-md-6 col-12">
                            <input type="text" class="form-control" id="invite_other_student_name" 
                                   placeholder="<%= Labels.get("invite_other_student.form.name")%>">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-form-label col-xl-6 col-lg-6 col-md-6 col-12" for="invite_other_student_email">
                            <%= Labels.get("invite_other_student.form.email_label")%>
                        </label>
                        <div class="col-xl-6 col-lg-6 col-md-6 col-12">
                            <input type="email" class="form-control" id="invite_other_student_email" 
                                   placeholder="<%= Labels.get("invite_other_student.form.email")%>">
                        </div>
                    </div>
                </form>                
            </div>
            <div class="alert alert-warning d-none" role="alert" id="invite_other_student_warning">                    
                <span class="oi" data-glyph="warning"></span>
                <span id="invite_other_student_warning_text"></span>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-info mx-1" data-dismiss="modal"><%= Labels.get("buttons.cancel")%></button>
                <button type="button" class="btn btn-success mx-1" onclick="invite_other_student_send()"><%= Labels.get("buttons.ok")%></button>
            </div>

        </div>

    </div>
</div>

<div id="progress_modal" class="modal fade" role="dialog">
    <div class="modal-dialog modal-sm">

        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" aria-label="close" data-dismiss="modal">
                    <span aria-hidden="true">&times;</span>
                </button>

                <div class="modal-title"> 
                    <h5 class="text-warning">
                        <span id="progress_modal_title">                      
                        </span>
                    </h5>
                </div>
            </div>
            <div class="modal-body">
                <div class="progress">
                    <div id="progress_modal_bar" class="progress-bar progress-bar-success" role="progressbar" 
                         aria-valuemin="0" aria-valuemax="100">
                        <span id="progress_modal_text1"></span>
                        (<span id="progress_modal_percent"></span>%)
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>

<div id="text_input_modal" class="modal fade" role="dialog">
    <div class="modal-dialog modal-md">

        <div class="modal-content">
            <div class="modal-header text-white bg-secondary">                
                <div class="modal-title">                     
                    <span class="oi" data-glyph="comment-square"></span>                     
                    <span id="text_input_modal_title">                        
                        <%= Labels.get("text_input.modal.title")%>
                    </span>
                </div>                                             
                <span class="oi close_button" data-dismiss="modal" data-glyph="x"></span>      
            </div>
            <div class="modal-body">     
                <label id="text_input_modal_text1" class="col-form-label" for="text_input_modal_input">
                    <%= Labels.get("text_input.modal.text1")%>
                </label>   
                <input id ="text_input_modal_input" class="form-control" type="text" >
                </input>
            </div>
            <div id="text_input_modal_info_div" class="alert alert-info d-none my-0" role="alert">
                <span class="oi" data-glyph="info"></span>    
                <span id="text_input_modal_info_text"></span>
            </div>
            <div class="modal-footer">

                <button type="button" class="btn btn-info mx-1" data-dismiss="modal">
                    <%= Labels.get("buttons.cancel")%>
                </button>

                <button type="button" class="btn btn-success mx-1" onclick="text_input_modal_ok()">
                    <%= Labels.get("buttons.ok")%>
                </button>            
            </div>

        </div>

    </div>
</div>
