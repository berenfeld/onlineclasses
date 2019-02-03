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
        $("#navbar_image_url_img").attr( "src", login.user.image_url);
    } else {

    }
}

function login_loginRequestComplete(response)
{
    if (response.rc === 0) {
        login.user = response.user;
        hide_all_modals();
        alert_show(oc.clabels["login.progress.success"], oc.clabels["login.progress.success"]);
        login_updatePage();
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

function hide_all_modals()
{
    $("div.modal").modal("hide");
}

function show_modal(modal_name)
{
    hide_all_modals();
    $("#" + modal_name).modal('show');
}

function login_showLoginModal()
{
    $("#login_modal_student_register_info").addClass("d-none");
    $("#login_modal_title").text(oc.clabels[ "login.modal.title"]);
    show_modal("login_modal");
    login.student_register = false;
}

function login_registerStudent()
{
    $("#login_modal_student_register_info").removeClass("d-none");
    $("#login_modal_title").text(oc.clabels[ "login.modal.title.register.student"]);
    show_modal("login_modal");
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

function login_init()
{
    login.user = oc.user;
}
