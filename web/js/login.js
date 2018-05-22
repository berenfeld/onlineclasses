/* global online_classes */

var login = {};

function login_showLoginDialog()
{
    $("#login_dialog").dialog();
}

function login_googleLoggedIn(googleUser)
{
    if (login.reason === "login_modal") {                        
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
}

function login_loginRequestComplete(response)
{
    if (response.rc === 0)
    {
        $("#login_modal_info_text").html(oc.clabels["login.progress.success"]);
        $("#login_modal_info_div").removeClass("d-none");
        reloadAfter(1);
    }    
    login.reason = null;
    
}

function login_googleLoggedOut()
{
    console.log("google user logged out");
}

function login_isLoggedIn() {
    return login.user !== null;
}

function login_showLoginModal(reason)
{
    login.reason = reason;
    if (reason === "login_modal")
    {
        $("#login_modal").modal('show');
    }
}

function logout_logoutRequestComplete(response)
{
    $("#login_modal").modal('hide');
    google_signOut();
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

function login_init()
{
    login.user = oc.user;

    google_addUserLoggedinCallback(login_googleLoggedIn);
    google_addUserLoggedOutCallback(login_googleLoggedOut);
}

login_init();