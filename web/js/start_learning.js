/* global online_classes */

var start_learning = {};

function start_learning_userLoggedInCallback(googleUser)
{
    start_learning.google_id_token = googleUser.google_id_token;

    $("#start_learning_email_input").val(googleUser.email);
    $("#start_learning_display_name_input").val(googleUser.name);
    $("#start_learning_first_name_input").val(googleUser.first_name);
    $("#start_learning_last_name_input").val(googleUser.last_name);
}

function start_learning_userLoggedOutCallback(googleUser)
{

}

function start_learning_googleUserEmailExistsCallback(email_exists)
{
    if (email_exists)
    {
        alert_show(online_classes.clabels[ "start_learning.login.email_exists.title"],
                online_classes.clabels[ "start_learning.login.email_exists.text"]);
    }
}
function start_learning_init()
{
    start_learning.google_id_token = null;
    login_showLoginModal('start_learning');
    google_addUserLoggedinCallback(start_learning_userLoggedInCallback);
    google_addUserLoggedOutCallback(start_learning_userLoggedOutCallback);
    google_addEmailExistsCallback(start_learning_googleUserEmailExistsCallback);


    $("#start_learning_day_of_birth_input").datepicker({
        dayNames: online_classes.clabels[ "website.days.long" ].split(","),
        dayNamesMin: online_classes.clabels[ "website.days.short" ].split(","),
        monthNames: online_classes.clabels[ "website.months.long" ].split(","),
        monthNamesShort: online_classes.clabels[ "website.months.short" ].split(","),
        isRTL: true,
        changeYear: true,
        onSelect: start_learning_select_day_of_birth
    });

    if (login_isLoggedIn())
    {
        alert_show(online_classes.clabels[ "start_learning.login.already_logged_in.title"],
                online_classes.clabels[ "start_learning.login.already_logged_in.text"]);
    }
}

function start_learning_register_complete(response)
{
    if (response.rc !== 0) {
        alert_show(online_classes.clabels[ "start_learning.register.failed.title"],
                online_classes.clabels[ "start_learning.register.failed.message"] + ":" + response.message);
        return;
    }
    alert_show(online_classes.clabels[ "start_learning.register.success.title"],
            online_classes.clabels[ "start_learning.register.success.message"]);
    redirectAfter("/", 5);
}

function start_learning_form_submit()
{
    if (!$("#start_learning_accept_terms_checkbox").is(":checked")) {
        alert_show(online_classes.clabels[ "start_learning.form.submit.terms_of_usage.please_accept"]);
        return;
    }

    if (start_learning.google_id_token === null) {
        alert_show(online_classes.clabels[ "start_learning.form.submit.terms_of_usage.please_login"]);
        return;
    }

    var request = {};
    request.google_id_token = start_learning.google_id_token;
    request.email = $("#start_learning_email_input").val();
    request.first_name = $("#start_learning_first_name_input").val();
    request.last_name = $("#start_learning_last_name_input").val();
    request.display_name = $("#start_learning_display_name_input").val();
    request.phone_number = $("#start_learning_phone_number_input").val();
    request.phone_area = start_learning.phone_area;
    request.day_of_birth = start_learning.day_of_birth;

    if ($("#start_learning_gender_input_male").attr("checked")) {
        request.gender = parseInt10($("#start_learning_gender_input_male").val());
    }
    if ($("#start_learning_gender_input_female").attr("checked")) {
        request.gender = parseInt10($("#start_learning_gender_input_female").val());
    }

    $.ajax("servlets/register_student",
            {
                type: "POST",
                data: JSON.stringify(request),
                dataType: "JSON",
                success: start_learning_register_complete
            }
    );
}

function start_learning_select_day_of_birth(dateText, datePicker)
{
    start_learning.day_of_birth = new Date(Date.parse(dateText));
}

function start_learning_select_area_code(phone_area)
{
    start_learning.phone_area = phone_area;
    $("#start_learning_area_code_value").html(phone_area);
}
start_learning_init();