/* global oc */

contact = {};

function contact_submit_response(response)
{
    if (response.rc === 0) {
        alert_show(oc.clabels[ "contact.response.title" ], oc.clabels[ "contact.response.text"]);
        redirectAfter("/", 2);
    }
}

function contact_submit_form()
{
    var request = {};
    request.name = $("#contact_name_input").val();
    request.email = $("#contact_email_input").val();
    request.phone = $("#contact_phone_input").val();
    request.subject = $("#contact_subject_input").val();
    request.message = $("#contact_message_input").val();

    if (stringEmpty(request.name)) {
        alert_show(oc.clabels[ "contact.request.title" ], oc.clabels[ "contact.request.name_empty"]);
        return;
    }
    if (stringEmpty(request.email)) {
        alert_show(oc.clabels[ "contact.request.title" ], oc.clabels[ "contact.request.email_empty"]);
        return;
    }
    if (stringEmpty(request.subject)) {
        alert_show(oc.clabels[ "contact.request.title" ], oc.clabels[ "contact.request.subject_empty"]);
        return;
    }
    if (stringEmpty(request.message)) {
        alert_show(oc.clabels[ "contact.request.title" ], oc.clabels[ "contact.request.message_empty"]);
        return;
    }

    $.ajax("servlets/contact",
            {
                type: "POST",
                data: JSON.stringify(request),
                dataType: "JSON",
                success: contact_submit_response
            });
}

function contact_init()
{
    $("#contact_form input").keyup(
            function (event) {
                if (event.keyCode === 13) {
                    contact_submit_form();
                    return false;
                }
            });
}

contact_init();