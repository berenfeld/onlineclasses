/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* global FB, oc */

var facebook = {};

function facebook_signIn() 
{
    FB.login(facebook_loginResponse);
}

function facebook_logoutResponse()
{
    
}

function facebook_signOut() 
{
    if (facebook.auth !== null) {
        FB.logout(facebook_logoutResponse);
    }
}

function facebook_loginResponse(response)
{
    if (response.authResponse) {
        facebook.auth = response.authResponse;
        facebook.uid = response.authResponse.userID;
        facebook.accessToken = response.authResponse.accessToken;
        FB.api("/me?fields=" + oc.cconfig[ "facebook.fields" ], facebook_getPersonalInformation);
    }
}

function facebook_accessTokenResponse(response)
{
    
}

function facebook_setUserLoggedinCallback(userLoggedInCallback)
{
    facebook.userLoggedInCallback = userLoggedInCallback;
}

function facebook_clearUserLoggedinCallback(userLoggedInCallback)
{
    facebook.userLoggedInCallback = null;
}

function facebook_getPersonalInformation(response)
{   
    console.log(response);
    var facebookUser = {};
    facebookUser.name = response.name;
    facebookUser.first_name = response.first_name;
    facebookUser.last_name = response.last_name;
    facebookUser.gender = response.gender;
    facebookUser.email = response.email;
    facebookUser.facebook_access_token = facebook.accessToken;
    facebookUser.facebook_id_token = null;
    facebook.user = facebookUser;
    
    if (! login_isLoggedIn())
    {
        if ( oc.cconfig[ "facebook.send_token_to_server" ] === "true" ) {
            var request = {};
            request.facebook_access_token = facebook.accessToken;
            $.ajax("servlets/facebook_access_token",
                    {
                        type: "POST",
                        data: JSON.stringify(request),
                        dataType: "JSON",
                        success: facebook_accessTokenResponse
                    }
            );
        }
    }
    
    if (facebook.userLoggedInCallback !== null) {
        facebook.userLoggedInCallback (facebookUser);
    }
}

function facebook_gotLoginStatus(response)
{        
    if (response.status === 'connected') {
        // the user is logged in and has authenticated your
        // app, and response.authResponse supplies
        // the user's ID, a valid access token, a signed
        // request, and the time the access token 
        // and signed request each expire        
        FB.api("/me?fields=" + oc.cconfig[ "facebook.fields" ], facebook_getPersonalInformation);
        facebook.auth = response.authResponse;
        facebook.uid = response.authResponse.userID;
        facebook.accessToken = response.authResponse.accessToken;
    } else if (response.status === 'not_authorized') {
        facebook.user = null;
        // the user must go through the login flow
        // to authorize your app or renew authorization
    } else {
        facebook.user = null;
        // the user is not logged in
    }
    
}
function facebook_load()
{
    window.fbAsyncInit = function () {
        FB.init({
            appId: '550017225356873',
            cookie: true,
            xfbml: false,
            status: true,
            version: 'v2.12'
        });     
        FB.getLoginStatus(facebook_gotLoginStatus);
        facebook.init_done = true;        
        $("div.facebook_login_button_placeholder").addClass("d-none");
        $("div.facebook_login_button").removeClass("d-none");
    };

    (function (d, s, id) {
        var js, fjs = d.getElementsByTagName(s)[0];
        if (d.getElementById(id)) {
            return;
        }
        js = d.createElement(s);
        js.id = id;
        js.src = "https://connect.facebook.net/he_IL/sdk.js";
        fjs.parentNode.insertBefore(js, fjs);
    }(document, 'script', 'facebook-jssdk'));
}

function facebook_loginStatusChanged(response)
{
    if (response.status === "unknown") {
        facebook.user = null;
        return;
    }
}

function facebook_getLoggedInUser()
{
    if (!facbook_isLoaded()) {
        return null;
    }
    return facebook.user;
}

function facbook_isLoaded()
{
    return facebook.init_done;
}

function facebook_init()
{    
    facebook.auth = null;
    facebook.user = null;
    facebook.userLoggedInCallback = null;
    facebook_load();
}

facebook_init();