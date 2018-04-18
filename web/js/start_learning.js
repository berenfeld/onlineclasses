/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function start_learning_userLoggedInCallback(googleUser)
{
    console.log(googleUser);
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

start_learning_init();