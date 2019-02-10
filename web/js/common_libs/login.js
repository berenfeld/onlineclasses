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
    request.student_register = login.student_register;
    ajax_request("login", request, login_loginRequestComplete);
}

function login_facebookLoggedIn(facebookUser)
{
    facebook_clearUserLoggedinCallback();

    $("#login_modal_info_text").html(oc.clabels["login.progress.start"]);
    $("#login_modal_info_div").removeClass("d-none");

    var request = {};
    request.facebook_access_token = facebookUser.facebook_access_token;
    request.student_register = login.student_register;
    ajax_request("login", request, login_loginRequestComplete);
}

function login_hideWhenLoggedOut(element)
{
    if (login_isLoggedIn()) {
        element.removeClass("d-none");
    } else {
        element.addClass("d-none");
    }
}


function login_hideWhenLoggedIn(element)
{
    if (login_isLoggedIn()) {
        element.addClass("d-none");
    } else {
        element.removeClass("d-none");
    }
}

function login_updatePage()
{
    login_hideWhenLoggedIn($("#navbar_login_register_student_li"));
    login_hideWhenLoggedIn($("#navbar_login_register_teacher_li"));
    login_hideWhenLoggedIn($("#navbar_login_li"));
    login_hideWhenLoggedOut($("#navbar_user_menu_li"));
    login_hideWhenLoggedOut($("#navbar_image_url_li"));

    if (login_isLoggedIn()) {
        $("#navbar_display_name_span").text(login.user.display_name);
        $("#navbar_image_url_img").attr("src", login.user.image_url);
        if (login_isStudent()) {
            $("navbar_update_details_a").href = "student_update";
        } else {
            $("navbar_update_details_a").href = "teacher_profile";
        }
    } else {

    }


}

function login_loginRequestComplete(response)
{
    if (response.rc === 0) {        
        modal_hide("login_modal");
        login.user = response.user;
        if (response.student_register) {
            alert_show(oc.clabels["login.progress.success"], oc.clabels["login.progress.success.details"],
                    oc.clabels["login.progress.success.student_register"] + "&nbsp;" +
                    createAnchor("student_update", oc.clabels["login.progress.success.student_update_page"]));
        } else {
            alert_show(oc.clabels["login.progress.success"], oc.clabels["login.progress.success.details"]);
        }
        login_updatePage();
        login_userLoggedIn();
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

function login_isAdmin() {
    if (!login_isLoggedIn()) {
        return false;
    }
    return login.user.admin === true;
}

function login_showLoginModal()
{
    $("#login_modal_info_div").addClass("d-none");
    $("#login_modal_student_register_info").addClass("d-none");
    $("#login_modal_title").text(oc.clabels[ "login.modal.title"]);
    modal_show("login_modal");
    login.student_register = false;
}

function login_registerStudent()
{
    $("#login_modal_info_div").addClass("d-none");
    $("#login_modal_student_register_info").removeClass("d-none");
    $("#login_modal_title").text(oc.clabels[ "login.modal.title.register.student"]);
    modal_show("login_modal");
    login.student_register = true;
}

function login_hideLoginModal()
{
    $("#login_modal").modal('hide');
}

function login_logoutRequestComplete(response)
{
    google_signOut();
    facebook_signOut();
    if (response.rc === 0) {
        alert_show(oc.clabels[ "website.logout.complete.title" ],
                oc.clabels[ "website.logout.complete.message" ], null);
        login.user = null;
        login_updatePage();
        login_userLoggedOut();
    }
}

function login_logoutFromNavBar()
{
    confirm_show(oc.clabels[ "website.logout.confirm.title" ],
            oc.clabels[ "website.logout.confirm.message" ],
            login_logoutFromNavBarConfirmed);
}

function login_logoutFromNavBarConfirmed()
{
    ajax_request("logout", {}, login_logoutRequestComplete);
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

function login_isStudent()
{
    return !(oc.is_teacher);
}

function login_isUser(user)
{
    if (!login_isLoggedIn()) {
        return false;
    }
    return login.user.id === user.id;
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

function login_userLoggedIn()
{
    for (var i = 0; i < login.login_callbacks.length; i++) {
        login.login_callbacks[ i ](login.user);
    }
}

function login_userLoggedOut()
{
    for (var i = 0; i < login.logout_callbacks.length; i++) {
        login.logout_callbacks[ i ]();
    }
}
function login_addLoginCallback(login_callback)
{
    common_arrayAdd(login.login_callbacks, login_callback);
}

function login_removeLoginCallback(login_callback)
{
    common_arrayRemove(login.login_callbacks, login_callback);
}

function login_addLogoutCallback(logout_callback)
{
    common_arrayAdd(login.logout_callbacks, logout_callback);
}

function login_removeLogoutCallback(logout_callback)
{
    common_arrayRemove(login.logout_callbacks, logout_callback);
}


function login_init()
{
    login.user = oc.user;
    login.student_register = false;
    login.login_callbacks = [];
    login.logout_callbacks = [];
}
