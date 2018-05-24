/* global oc */

contact = {};

function contact_submit_response(response)
{
    if (response.rc === 0 ){
        alert_show("thank you");
    }
}

function contact_submit_form()
{
    var request = {};
    request.name = $("#contact_name_input").val();
    request.email = $("#contact_email_input").val();
    request.phone = $("#contact_phone_input").val();
    request.reason = $("#contact_reason_input").val();
    request.message = $("#contact_message_input").val();
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

}

contact_init();