/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* global gapi */

var google = {};

function google_init()
{
    google.user = null;
    google.userLoggedInCallback = null;
    google.userLoggedOutCallbacks = [];
    google.emailExistsCallbacks = [];
}

function google_signOut() {
    google.auth2.signOut();
    google.auth2.disconnect();
}

function google_signIn()
{
    google.auth2.signIn();
}

function google_getLoggedInUser() {
    if (!google_isLoaded()) {
        return null;
    }
    return google.user;
}

function google_isLoaded() {
    return google.loaded;
}

function google_setLoadedCallback(loadedCallback) {
    google.loadedCallback = loadedCallback;
}


function google_setUserLoggedinCallback(userLoggedInCallback)
{
    google.userLoggedInCallback = userLoggedInCallback;
}

function google_clearUserLoggedinCallback(userLoggedInCallback)
{
    google.userLoggedInCallback = null;
}

function google_addEmailExistsCallback(emailExistsCallback)
{
    google.emailExistsCallbacks.push(emailExistsCallback);
}

function google_idTokenResponse(response)
{
    google.email_exists = response.email_exists;
    for (var i = 0; i < google.emailExistsCallbacks.length; i++) {
        google.emailExistsCallbacks[i](google.email_exists);
    }
}

function google_signInChanged()
{
    if (!google.auth2.isSignedIn.get()) {
        google.user = null;
        return;
    }

    var googleUser = google.auth2.currentUser.get();
    if ( googleUser === null) {
        google.user = null;
        return;
    }
    
    request = {};
    request.google_id_token = googleUser.getAuthResponse().id_token;
    $.ajax("servlets/google_id_token",
            {
                type: "POST",
                data: JSON.stringify(request),
                dataType: "JSON",
                success: google_idTokenResponse
            }
    );

    var profile = googleUser.getBasicProfile();
    var user = {};
    user.name = profile.getName();
    user.first_name = profile.getGivenName();
    user.last_name = profile.getFamilyName();
    user.image_url = profile.getImageUrl();
    user.email = profile.getEmail();
    user.google_id_token = googleUser.getAuthResponse().id_token;

    google.user = user;
    if (google.userLoggedInCallback !== null) {
        google.userLoggedInCallback(google.user);
    }
}

function google_loaded()
{
    gapi.load('auth2', google_load_finished);
}

function google_load_finished()
{
    gapi.auth2.init();
    google.loaded = true;
    google.auth2 = gapi.auth2.getAuthInstance();
    google.auth2.isSignedIn.listen(google_signInChanged);
    $("button.google-login-button").each(
            function (index, elem) {
                gapi.signin2.render(elem.id, { theme: "dark", longtitle: true } );
                $("#" + elem.id).attr("disabled", false);
            }
    );
    
}

google_init();