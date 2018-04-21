/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

var start_learning = {}
function start_learning_userLoggedInCallback(googleUser)
{
    start_learning.google_id_token = google_id_token

    $("#start_learning_email_input").val(googleUser.email);
    $("#start_learning_display_name_input").val(googleUser.name);
    $("#start_learning_first_name_input").val(googleUser.first_name);
    $("#start_learning_last_name_input").val(googleUser.last_name);
}

function start_learning_init()
{
    login_showLoginModal('start_learning');
    google_addUserLoggedinCallback(start_learning_userLoggedInCallback);
}

function start_learning_form_submit()
{
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