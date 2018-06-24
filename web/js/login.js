/* global oc */

var login = {};

function login_showLoginDialog()
{
    $("#login_dialog").dialog();
}

function login_googleLoggedIn(googleUser)
{
    google_clearUserLoggedinCallback();

    $("#login_modal_info_text").html(oc.clabels["login.progress.start"]);
    $("#login_modal_info_div").removeClass("d-none");

    var request = {};
    request.google_id_token = googleUser.google_id_token;
    $.ajax("servlets/login",
            {
                type: "POST",
                data: JSON.stringify(request),
                dataType: "JSON",
                success: login_loginRequestComplete
            });

}

function login_facebookLoggedIn(facebookUser)
{
    facebook_clearUserLoggedinCallback();

    $("#login_modal_info_text").html(oc.clabels["login.progress.start"]);
    $("#login_modal_info_div").removeClass("d-none");

    var request = {};
    request.facebook_access_token = facebookUser.facebook_access_token;
    $.ajax("servlets/login",
            {
                type: "POST",
                data: JSON.stringify(request),
                dataType: "JSON",
                success: login_loginRequestComplete
            });

}

function login_loginRequestComplete(response)
{
    if (response.rc === 0) {
        $("#login_modal_info_text").html(oc.clabels["login.progress.success"]);
        $("#login_modal_info_div").removeClass("d-none");
        reloadAfter(1);
    } else {
        $("#login_modal_info_text").html(
                oc.clabels["login.progress.failed"] + " : " +
                response.message);
        google_signOut();
        facebook_signOut();
    }
}

function login_googleLoggedOut()
{

}

function login_isLoggedIn() {
    return login.user !== null;
}

function login_showLoginModal()
{
    $("#login_modal").modal('show');
}

function logout_logoutRequestComplete(response)
{
    $("#login_modal").modal('hide');
    google_signOut();
    facebook_signOut();
    location.reload();
}

function login_logoutFromNavBar()
{
    confirm_show(oc.clabels[ "website.logout.confirm.title" ],
            oc.clabels[ "website.logout.confirm.message" ],
            login_logoutFromNavBarConfirmed);
}

function login_logoutFromNavBarConfirmed()
{
    login.reason = "navbar";
    $.ajax("servlets/logout",
            {
                type: "POST",
                dataType: "JSON",
                success: logout_logoutRequestComplete
            });

}

function login_googleLogin()
{
    var googleUser = google_getLoggedInUser();
    if (googleUser === null) {
        google_setUserLoggedinCallback(login_googleLoggedIn);
        google_signIn();
    } else {
        login_googleLoggedIn(googleUser);
    }
}


function login_isTeacher()
{
    return oc.is_teacher;
}

function login_facebookLogin()
{
    var facebookUser = facebook_getLoggedInUser();
    if (facebookUser === null) {
        facebook_setUserLoggedinCallback(login_facebookLoggedIn);
        facebook_signIn();
    } else {
        login_facebookLoggedIn(facebookUser);
    }
}

function login_init()
{
    login.user = oc.user;
}

$(document).ready(login_init);