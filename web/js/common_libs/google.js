/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* global gapi, oc */

var google = {};

function google_init()
{
    google.user = null;
    google.userLoggedInCallback = null;
    google.userLoggedOutCallbacks = [];
    google.emailExistsCallbacks = [];
}

function google_signOut() {
    if (!google_isLoaded()) {
        return;
    }
    google.auth2.signOut();
    google.auth2.disconnect();
}

function google_signIn()
{
    if (!google_isLoaded()) {
        return;
    }
    try {
        google.auth2.signIn();
    } catch(err) {
        console.log("google login canceled");
    }
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
    if (googleUser === null) {
        google.user = null;
        return;
    }

    if (!login_isLoggedIn()) {
        if (oc.cconfig[ "google.send_token_to_server" ] === "true") {
            var request = {};
            request.google_id_token = googleUser.getAuthResponse().id_token;
            ajax_request( "google_id_token", request, google_idTokenResponse);    
        }
    }

    var profile = googleUser.getBasicProfile();
    var user = {};
    user.name = profile.getName();
    user.first_name = profile.getGivenName();
    user.last_name = profile.getFamilyName();
    user.image_url = profile.getImageUrl();
    user.email = profile.getEmail();
    user.google_id_token = googleUser.getAuthResponse().id_token;
    user.facebook_access_token = null;

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
    $("div.google_login_button_placeholder").addClass("d-none");
    $("div.google_login_button").removeClass("d-none");
    
    gapi.auth2.init();
    google.loaded = true;
    google.auth2 = gapi.auth2.getAuthInstance();
    google.auth2.isSignedIn.listen(google_signInChanged);    
}