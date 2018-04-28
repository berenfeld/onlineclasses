<%@page import="com.onlineclasses.web.Labels"%>

<div class="container">
    <div id="login_modal" class="modal fade" role="dialog">
        <div class="modal-dialog modal-md">
            <div class="modal-content">
                <div class="modal-header modal-header-primary">
                    <button type="button" class="close" aria-label="close" title="<%= Labels.get("login.modal.close_title")%>" data-dismiss="modal">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <div class="h4 modal-title text-success">
                        <span class="table_cell glyphicon glyphicon-log-in"></span>
                        <span class="table_cell">
                            <%= Labels.get("login.modal.title")%>
                        </span>                        
                    </div>
                </div>
                <div class="modal-body">
                    <h4 class="text-secondary">
                        <%= Labels.get("login.modal.text1")%>
                    </h4>
                    <div class="alert alert-success g-signin2" data-theme="dark"></div>                    
                    <h4 class="text-secondary">
                        <%= Labels.get("login.modal.text2")%>                    
                        <a class="alert-link" href="start_learning">
                            <%= Labels.get("login.modal.register.student")%>
                        </a>                            
                    </h4>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">
                        <%= Labels.get("buttons.cancel")%>
                    </button>
                </div>                
            </div>

        </div>
    </div>

    <div id="confirm_modal" class="modal fade" role="dialog">
        <div class="modal-dialog modal-sm">

            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header modal-header-success">
                    <button type="button" class="close" aria-label="close" data-dismiss="modal">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title text-warning">
                        <span class="table_cell glyphicon glyphicon-question-sign" aria-hidden="true"></span>
                        <span class="table_cell" id="confirm_modal_title"></span>
                    </h4>
                </div>
                <div class="modal-body">
                    <h5 class="text-warning">
                        <span id="confirm_modal_message"></span>
                    </h5>                    
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" onclick="confirm_cancel()" data-dismiss="modal"><%= Labels.get("buttons.cancel")%></button>
                    <button type="button" class="btn btn-success" onclick="confirm_ok()" data-dismiss="modal"><%= Labels.get("buttons.ok")%></button>
                </div>
            </div>

        </div>
    </div>

    <div id="alert_modal" class="modal fade" role="dialog">
        <div class="modal-dialog modal-sm">

            <div class="modal-content">
                <div class="modal-header modal-header-warning">
                    <button type="button" class="close" aria-label="close" data-dismiss="modal">
                        <span aria-hidden="true">&times;</span>
                    </button>

                    <div class="modal-title"> 
                        <h4>
                            <span class="table_cell glyphicon glyphicon-alert"></span>
                            <span class="table_cell" id="alert_modal_title">
                                <%= Labels.get("alert.modal.title")%>
                            </span>
                        </h4>
                    </div>
                </div>
                <div class="modal-body">
                    <h5 id="alert_modal_text1">
                        <%= Labels.get("alert.modal.text1")%>
                    </h5>                    
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success" onclick="alert_ok()" data-dismiss="modal"><%= Labels.get("buttons.ok")%></button>
                </div>

            </div>

        </div>
    </div>

    <div id="progress_modal" class="modal fade" role="dialog">
        <div class="modal-dialog modal-sm">

            <div class="modal-content">
                <div class="modal-header modal-header-info">
                    <button type="button" class="close" aria-label="close" data-dismiss="modal">
                        <span aria-hidden="true">&times;</span>
                    </button>

                    <div class="modal-title"> 
                        <h4 class="text-warning">
                            <span class="glyphicon glyphicon-alert"></span>
                            <span id="progress_modal_title">                      
                            </span>
                        </h4>
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

</div>