/* global oc */

var start_learning = {};

function start_learning_userLoggedInCallback(user)
{
    google_clearUserLoggedinCallback();   

    start_learning.google_id_token = user.google_id_token;

    $("#start_learning_email_input").val(user.email);
    $("#start_learning_display_name_input").val(user.name);
    $("#start_learning_first_name_input").val(user.first_name);
    $("#start_learning_last_name_input").val(user.last_name);

    google_signOut();
}

function start_learning_googleUserEmailExistsCallback(email_exists)
{
    if (email_exists)
    {
        alert_show(oc.clabels[ "start_learning.login.email_exists.title"],
                oc.clabels[ "start_learning.login.email_exists.text"]);
    }
}

function start_learning_register_complete(response)
{
    if (response.rc !== 0) {
        alert_show(oc.clabels[ "start_learning.register.failed.title"],
                oc.clabels[ "start_learning.register.failed.message"] + ":" + response.message);
        return;
    }
    alert_show(oc.clabels[ "start_learning.register.success.title"],
            oc.clabels[ "start_learning.register.success.message"]);
    redirectAfter("/", 5);
}

function start_learning_form_submit()
{
    if (!$("#start_learning_accept_terms_checkbox").is(":checked")) {
        alert_show(oc.clabels[ "start_learning.form.submit.terms_of_usage.please_accept"]);
        return;
    }

    if (start_learning.google_id_token === null) {
        alert_show(oc.clabels[ "start_learning.form.submit.terms_of_usage.please_login"]);
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
    request.institute_id = start_learning.institute_id;
    request.institute_name = $("#start_learning_institute_other_text").val();
    request.subject_id = start_learning.subject_id;
    request.subject_name = $("#start_learning_subject_0_text").val();

    if ($("#start_learning_gender_input_male").prop("checked")) {
        request.gender = parseInt10($("#start_learning_gender_input_male").val());
    }
    if ($("#start_learning_gender_input_female").prop("checked")) {
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

function start_learning_select_day_of_birth(dateText)
{
    start_learning.day_of_birth = new Date(Date.parse(dateText));
}

function start_learning_select_area_code(phone_area)
{
    start_learning.phone_area = phone_area;
    $("#start_learning_area_code_value").html(phone_area);
}

function start_learning_select_institute_type(institute_type, institute_id)
{
    start_learning.institute_type = institute_type;

    for (var i = 0; i <= oc.institute_type.length; i++)
    {
        $("#start_learning_institute_" + i + "_label").addClass("d-none");
        $("#start_learning_institute_" + i + "_div").addClass("d-none");
    }

    start_learning.institute_id = 0;

    if (institute_type === 0) {
        $("#start_learning_institute_type_button").html($("#start_learning_institute_type_other").html());
        $("#start_learning_institute_0_label").removeClass("d-none");
        $("#start_learning_institute_0_div").removeClass("d-none");
    } else {
        $("#start_learning_institute_type_button").html(oc.institute_type[institute_type - 1].name);
        $("#start_learning_institute_" + institute_type + "_label").removeClass("d-none");
        $("#start_learning_institute_" + institute_type + "_div").removeClass("d-none");
        if (institute_id !== 0) {
            start_learning.institute_id = institute_id;
            $("#start_learning_institute_" + institute_type + "_select").html(oc.institutes[institute_type][institute_id]);
        }
    }
}

function start_learning_select_subject(subject_id)
{
    start_learning.subject_id = subject_id;

    if (subject_id === 0) {
        start_learning.subject_id = 0;
        $("#start_learning_subject_0_div").removeClass("d-none");
        $("#start_learning_subject_0_label").removeClass("d-none");
    } else {
        $("#start_learning_subject_0_div").addClass("d-none");
        $("#start_learning_subject_0_label").addClass("d-none");
        $("#start_learning_subject_button").html(oc.subjects[subject_id - 1].name);
        start_learning.subject_id = subject_id;
    }

}

function start_learning_googleLogin()
{
    var googleUser = google_getLoggedInUser();
    if (googleUser === null) {
        google_setUserLoggedinCallback(start_learning_userLoggedInCallback);
        google_signIn();
    } else {
        start_learning_userLoggedInCallback(googleUser);
    }
}

function start_learning_init()
{
    start_learning.google_id_token = null;

    google_addEmailExistsCallback(start_learning_googleUserEmailExistsCallback);

    $("#start_learning_day_of_birth_input").datepicker({
        dayNames: oc.clabels[ "website.days.long" ].split(","),
        dayNamesMin: oc.clabels[ "website.days.short" ].split(","),
        monthNames: oc.clabels[ "website.months.long" ].split(","),
        monthNamesShort: oc.clabels[ "website.months.short" ].split(","),
        isRTL: true,
        changeYear: true,
        onSelect: start_learning_select_day_of_birth
    });

    if (login_isLoggedIn())
    {
        alert_show(oc.clabels[ "start_learning.login.already_logged_in.title"],
                oc.clabels[ "start_learning.login.already_logged_in.text"]);
    }
}

$(document).ready( start_learning_init );