/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

var google = {}

function google_init()
{
    google.userLoggedInCallbacks = [];
    google.userLoggedOutCallbacks = [];
}

function google_signOut() {
    google.auth2.signOut();
    google.auth2.disconnect();
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

function google_signinChanged(value)
{

}

function google_addUserLoggedinCallback(userLoggedInCallback)
{
    google.userLoggedInCallbacks.push(userLoggedInCallback);
}

function google_addUserLoggedOutCallback(userLoggedOutCallback)
{
    google.userLoggedOutCallbacks.push(userLoggedOutCallback);
}
function google_idTokenSent()
{

}

function google_userChanged(value)
{
    if (!google.auth2.isSignedIn.get()) {
        google.user = null;
        for (var i = 0; i < google.userLoggedOutCallbacks.length; i++) {
            google.userLoggedOutCallbacks[i]();
        }
        return;
    }

    var googleUser = google.auth2.currentUser.get();
    request = {};
    request.google_id_token = googleUser.getAuthResponse().id_token;
    $.ajax("servlets/google_id_token",
            {
                type: "POST",
                data: JSON.stringify(request),
                dataType: "JSON",
                success: google_idTokenSent
            }
    );

    var profile = googleUser.getBasicProfile();
    var user = {}
    user.name = profile.getName();
    user.first_name = profile.getGivenName();
    user.last_name = profile.getFamilyName();
    user.image_url = profile.getImageUrl();
    user.email = profile.getEmail();
    user.google_id_token = googleUser.getAuthResponse().id_token;

    console.log(user);
    google.user = user;
    for (var i = 0; i < google.userLoggedInCallbacks.length; i++) {
        google.userLoggedInCallbacks[i](google.user);
    }
}

function google_loaded()
{
    google.loaded = true;
    google.auth2 = gapi.auth2.getAuthInstance();
    google.auth2.isSignedIn.listen(google_signinChanged);
    google.auth2.currentUser.listen(google_userChanged);
}

google_init();