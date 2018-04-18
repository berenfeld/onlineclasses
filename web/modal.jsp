<%@page import="com.onlineclasses.web.Labels"%>

<div class="container">
    <div id="login_modal" class="modal fade" role="dialog">
        <div class="modal-dialog modal-md">

            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" aria-label="close" data-dismiss="modal">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title"><%= Labels.get("login.modal.title")%></h4>
                </div>
                <div class="modal-body">
                    <h5>
                        <%= Labels.get("login.modal.text1")%>
                    </h5>
                    <div class="g-signin2" data-theme="dark"></div>                    
                    <hr>
                    <div class="alert alert-success">
                        <h5>
                            <%= Labels.get("login.modal.text2")%>                    
                            &nbsp;

                            <a class="alert-link" href="start_learning"><%= Labels.get("login.modal.register.student")%></a>

                            &nbsp;

                            <a class="alert-link" href="start_teaching"><%= Labels.get("login.modal.register.teacher")%></a>
                        </h5>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal"><%= Labels.get("buttons.cancel")%></button>
                </div>
                <div class="progress">
                    <div id="login_modal_progress" class="progress-bar bg-success" role="progressbar" style="width: 0%" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                </div>

            </div>

        </div>
    </div>

    <div id="confirm_modal" class="modal fade" role="dialog">
        <div class="modal-dialog modal-md">

            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" aria-label="close" data-dismiss="modal">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 id="confirm_modal_title" class="modal-title"><%= Labels.get("confirm.modal.title")%></h4>
                </div>
                <div class="modal-body">
                    <h5 id="confirm_modal_text1">
                        <%= Labels.get("confirm.modal.text1")%>
                    </h5>                    
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" onclick="confirm_cancel()" data-dismiss="modal"><%= Labels.get("buttons.cancel")%></button>
                    <button type="button" class="btn btn-success" onclick="confirm_ok()" data-dismiss="modal"><%= Labels.get("buttons.ok")%></button>
                </div>


            </div>

        </div>
    </div>

</div>