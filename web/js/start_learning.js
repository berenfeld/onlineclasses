/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

var start_learning = {}

function start_learning_userLoggedInCallback(googleUser)
{
    start_learning.google_id_token = googleUser.google_id_token

    $("#start_learning_email_input").val(googleUser.email);
    $("#start_learning_display_name_input").val(googleUser.name);
    $("#start_learning_first_name_input").val(googleUser.first_name);
    $("#start_learning_last_name_input").val(googleUser.last_name);
}

function start_learning_userLoggedOutCallback(googleUser)
{
    start_learning.google_id_token = null;
}
function start_learning_googleUserEmailExistsCallback(email_exists)
{
    if (email_exists)
    {
        alert_show(online_classes.clabels[ "start_learning.login.email_exists.title"],
                online_classes.clabels[ "start_learning.login.email_exists.text"]);
    }
}
function start_learning_init()
{
    start_learning.google_id_token = null;
    login_showLoginModal('start_learning');
    google_addUserLoggedinCallback(start_learning_userLoggedInCallback);
    google_addUserLoggedOutCallback(start_learning_userLoggedOutCallback);
    google_addEmailExistsCallback(start_learning_googleUserEmailExistsCallback)
    if (login_isLoggedIn())
    {
        alert_show(online_classes.clabels[ "start_learning.login.already_logged_in.title"],
                online_classes.clabels[ "start_learning.login.already_logged_in.text"]);
    }
}

function start_learning_form_submit()
{
    // form validation
    if (!$("#start_learning_accept_terms_checkbox").is(":checked")) {
        $("#start_learning_accept_terms_checkbox_div").addClass("alert alert-error");
        alert_show(online_classes.clabels[ "start_learning.form.submit.terms_of_usage.please_accept"]);
        $("#start_learning_accept_terms_checkbox").focus();
        return;
    }

    if (start_learning.google_id_token == null) {
        //$("#start_learning_login_div").addClass("alert alert-error");
        alert_show(online_classes.clabels[ "start_learning.form.submit.terms_of_usage.please_login"]);
        return;
    }

    var request = {};
    request.google_id_token = start_learning.google_id_token;
    request.email = $("#start_learning_email_input").val();
    request.first_name = $("#start_learning_first_name_input").val();
    request.last_name = $("#start_learning_last_name_input").val();
    request.display_name = $("#start_learning_display_name_input").val();

    $.ajax("servlets/register_student",
            {
                type: "POST",
                data: JSON.stringify(request),
                dataType: "JSON",
                success: login_loginRequestComplete
            }
    )
}

start_learning_init();