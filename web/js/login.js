/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

var login = {}

function login_showLoginDialog()
{
    $("#login_dialog").dialog();
}

function login_googleLoggedIn(googleUser)
{
    if (login.reason == "login_modal") {

        $('#login_modal_progress').css('width', '33%').attr('aria-valuenow', 33);

        var request = {};
        request.google_id = googleUser.google_id;
        request.hash = md5(googleUser.google_id + "." + googleUser.email);
        $.ajax("servlets/login",
                {
                    type: "POST",
                    data: JSON.stringify(request),
                    dataType: "JSON",
                    success: login_loginRequestComplete
                })
    } else {
        google_signOut();
    }
}

function login_loginRequestComplete(response)
{
    console.log(response);
    if (login.reason == "login_modal") {
        $('#login_modal_progress').css('width', '100%').attr('aria-valuenow', 100);
        $("#login_modal").modal('hide');
        login.reason = null;
        location.reload();
    }

}

function login_googleLoggedOut()
{
    console.log("google user logged out");
}

function login_isLoggedIn() {
    return login.user != null;
}

function login_showLoginModal( reason )
{
    login.reason = reason;
    if ( reason == "login_modal")
    {    
        $("#login_modal").modal('show');
    }
}

function logout_logoutRequestComplete(response)
{
    console.log(response);
    $("#login_modal").modal('hide');
    location.reload();
}

function login_logoutFromNavBar()
{
    confirm_show("text", login_logoutFromNavBarConfirmed);
}

function login_logoutFromNavBarConfirmed()
{
    login.reason = "navbar";
    $.ajax("servlets/logout",
            {
                type: "POST",
                dataType: "JSON",
                success: logout_logoutRequestComplete
            })

}

function login_init()
{
    login.user = online_classes.user;

    google_addUserLoggedinCallback(login_googleLoggedIn);
    google_addUserLoggedOutCallback(login_googleLoggedOut);
}

login_init();