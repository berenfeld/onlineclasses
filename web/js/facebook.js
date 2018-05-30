/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* global FB */

var facebook = {};

function facebook_load()
{
    window.fbAsyncInit = function () {
        FB.init({
            appId: '550017225356873',
            cookie: true,
            xfbml: true,
            version: 'v3.0'
        });

        FB.getLoginStatus(facebook_loginStatusChanged);
        facebook.init_done = true;
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
    if (! facbook_isLoaded()) {
        return false;
    }
    FB.getLoginStatus(facebook_loginStatusChanged);
}

function facbook_isLoaded()
{
    return facebook.init_done;
}

function facebook_init()
{
    facebook_load();
}

facebook_init();