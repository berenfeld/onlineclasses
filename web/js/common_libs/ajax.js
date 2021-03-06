/* global oc */

var ajax = {};

function ajax_init()
{
    ajax.console_logs = ( oc.cconfig[ "website.debug.ajax.console_logs" ] === "true" );
}

function ajax_success(response)
{
    if ( ajax.console_logs ) {
        console.log("post reply " + this.oc_url + " reply " + JSON.stringify(response));
    }
    this.oc_cb(response);
}

function ajax_error(xhr, status, response)
{
    if ( ajax.console_logs ) {
        console.log("post error " + this.oc_url + " status " + status + " response " + response);
    }
}

function ajax_request( url, request_object, success_cb)
{
    var json_string = JSON.stringify(request_object);
    var servlet_url = "servlets/" + url;
    if ( ajax.console_logs ) {
        console.log("post request " + servlet_url + " data " + json_string);
    }
    $.ajax( servlet_url,
            {
                type: "post",
                data: json_string,
                dataType: "json",
                contentType: "application/json",
                oc_url : servlet_url,
                oc_data: json_string,
                oc_cb : success_cb,
                success: ajax_success,
                error: ajax_error
            });
}
