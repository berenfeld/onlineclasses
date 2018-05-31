/* global oc */

var start_teaching = {};

function start_teaching_userLoggedInCallback(user)
{
    google_clearUserLoggedinCallback();
    facebook_clearUserLoggedinCallback();
    
    start_teaching.google_id_token = user.google_id_token;
    start_teaching.facebook_access_token = user.facebook_access_token;

    $("#start_teaching_email_input").val(user.email);
    $("#start_teaching_display_name_input").val(user.name);
    $("#start_teaching_first_name_input").val(user.first_name);
    $("#start_teaching_last_name_input").val(user.last_name);
        
    google_signOut();
    facebook_signOut();
}

function start_teaching_select_degree_type(degree_type)
{
    $("#start_teaching_degree_type_button").html(degree_type);
    start_teaching.degree_type = degree_type;
}

function start_teaching_googleUserEmailExistsCallback(email_exists)
{
    if (email_exists)
    {
        alert_show(oc.clabels[ "start_teaching.login.email_exists.title"],
                oc.clabels[ "start_teaching.login.email_exists.text"]);
    }
}
function start_teaching_select_topic(topic_id)
{
    var checked = $("#start_teaching_topic_" + topic_id + "_checkbox").attr("checked");
    $("#start_teaching_topic_" + topic_id + "_checkbox").attr("checked", !checked);
}

function start_teaching_register_complete(response)
{
    if (response.rc !== 0) {
        alert_show(oc.clabels[ "start_teaching.register.failed.title"],
                oc.clabels[ "start_teaching.register.failed.message"] + ":" + response.message);
        return;
    }
    alert_show(oc.clabels[ "start_teaching.register.success.title"],
            oc.clabels[ "start_teaching.register.success.message"]);
    redirectAfter("/", 5);
}

function start_teaching_form_submit()
{
    if (!$("#start_teaching_accept_terms_checkbox").is(":checked")) {
        alert_show(oc.clabels[ "start_teaching.form.submit.terms_of_usage.please_accept"]);
        return;
    }

    if ( (start_teaching.google_id_token === null) && ( start_teaching.facebook_access_token === null) ) {
        alert_show(oc.clabels[ "start_teaching.form.submit.terms_of_usage.please_login"]);
        return;
    }

    var request = {};
    request.google_id_token = start_teaching.google_id_token;
    request.facebook_access_token = start_teaching.facebook_access_token;
    request.email = $("#start_teaching_email_input").val();
    request.first_name = $("#start_teaching_first_name_input").val();
    request.last_name = $("#start_teaching_last_name_input").val();
    request.display_name = $("#start_teaching_display_name_input").val();
    request.phone_number = $("#start_teaching_phone_number_input").val();
    request.phone_area = start_teaching.phone_area;
    request.day_of_birth = start_teaching.day_of_birth;
    request.institute_id = start_teaching.institute_id;
    request.institute_name = $("#start_teaching_institute_other_text").val();
    request.subject_id = start_teaching.subject_id;
    request.subject_name = $("#start_teaching_subject_0_text").val();
    request.degree_type = start_teaching.degree_type;
    request.price_per_hour = parseInt10($("#start_teaching_price_per_hour_input").val());
    request.paypal_email = $("#start_teaching_paypal_email_input").val();
    request.teaching_topics = [];
    
    $("#start_teaching_topics_card input[type='checkbox']").each(
            function (index, elem) {
                if (elem.checked) {
                    request.teaching_topics.push(parseInt10($("#" + elem.id).attr("data-topic-id")));
                }
            }
    );

    if ($("#start_teaching_gender_input_male").attr("checked")) {
        request.gender = parseInt10($("#start_teaching_gender_input_male").val());
    }
    if ($("#start_teaching_gender_input_female").attr("checked")) {
        request.gender = parseInt10($("#start_teaching_gender_input_female").val());
    }

    $.ajax("servlets/register_teacher",
            {
                type: "POST",
                data: JSON.stringify(request),
                dataType: "JSON",
                success: start_teaching_register_complete
            }
    );
}

function start_teaching_select_day_of_birth(dateText)
{
    start_teaching.day_of_birth = new Date(Date.parse(dateText));
}

function start_teaching_select_area_code(phone_area)
{
    start_teaching.phone_area = phone_area;
    $("#start_teaching_area_code_value").html(phone_area);
}

function start_teaching_select_institute_type(institute_type, institute_id)
{
    start_teaching.institute_type = institute_type;

    for (var i = 0; i <= oc.institute_type.length; i++)
    {
        $("#start_teaching_institute_" + i + "_label").addClass("d-none");
        $("#start_teaching_institute_" + i + "_div").addClass("d-none");
    }

    start_teaching.institute_id = 0;

    if (institute_type === 0) {
        $("#start_teaching_institute_type_button").html($("#start_teaching_institute_type_other").html());
        $("#start_teaching_institute_0_label").removeClass("d-none");
        $("#start_teaching_institute_0_div").removeClass("d-none");
    } else {
        $("#start_teaching_institute_type_button").html(oc.institute_type[institute_type - 1].name);
        $("#start_teaching_institute_" + institute_type + "_label").removeClass("d-none");
        $("#start_teaching_institute_" + institute_type + "_div").removeClass("d-none");
        if (institute_id !== 0) {
            start_teaching.institute_id = institute_id;
            $("#start_teaching_institute_" + institute_type + "_select").html(oc.institutes[institute_type][institute_id]);
        }
    }
}

function start_teaching_select_subject(subject_id)
{
    start_teaching.subject_id = subject_id;

    if (subject_id === 0) {
        start_teaching.subject_id = 0;
        $("#start_teaching_subject_0_div").removeClass("d-none");
        $("#start_teaching_subject_0_label").removeClass("d-none");
    } else {
        $("#start_teaching_subject_0_div").addClass("d-none");
        $("#start_teaching_subject_0_label").addClass("d-none");
        $("#start_teaching_subject_button").html(oc.subjects[subject_id - 1].name);
        start_teaching.subject_id = subject_id;
    }

}

function start_teaching_googleLogin()
{
    var googleUser = google_getLoggedInUser();
    if (googleUser === null) {
        google_setUserLoggedinCallback(start_teaching_userLoggedInCallback);
        google_signIn();
    } else {
        start_teaching_userLoggedInCallback(googleUser);
    }       
}

function start_teaching_facebookLogin()
{
    var facebookUser = facebook_getLoggedInUser();
    if (facebookUser === null) {
        facebook_setUserLoggedinCallback(start_teaching_userLoggedInCallback);
        facebook_signIn();
    } else {
        start_teaching_userLoggedInCallback(facebookUser);
        alert_modal( oc.clabels["start_teaching.login_successful"]);
    }       
}

function start_teaching_init()
{
    start_teaching.google_id_token = null;
    start_teaching.facebook_access_token = null;
   
    google_addEmailExistsCallback(start_teaching_googleUserEmailExistsCallback);

    $("#start_teaching_day_of_birth_input").datepicker({
        dayNames: oc.clabels[ "website.days.long" ].split(","),
        dayNamesMin: oc.clabels[ "website.days.short" ].split(","),
        monthNames: oc.clabels[ "website.months.long" ].split(","),
        monthNamesShort: oc.clabels[ "website.months.short" ].split(","),
        isRTL: true,
        changeYear: true,
        onSelect: start_teaching_select_day_of_birth
    });

    if (login_isLoggedIn())
    {
        alert_show(oc.clabels[ "start_teaching.login.already_logged_in.title"],
                oc.clabels[ "start_teaching.login.already_logged_in.text"]);
    }
}

start_teaching_init();