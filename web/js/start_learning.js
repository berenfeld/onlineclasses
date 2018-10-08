/* global oc */

var start_learning = {};

function start_learning_userLoggedInCallback(user)
{
    google_clearUserLoggedinCallback();
    facebook_clearUserLoggedinCallback();
    start_learning.google_id_token = user.google_id_token;
    start_learning.facebook_access_token = user.facebook_access_token;
    start_learning.social_image_url = user.image_url;    
    start_learning.image_url = user.image_url;    

    $("#start_learning_email_input").val(user.email);
    $("#start_learning_display_name_input").val(user.name);
    $("#start_learning_first_name_input").val(user.first_name);
    $("#start_learning_last_name_input").val(user.last_name);
    $("#start_learning_display_name_input").prop("disabled", false);
    $("#start_learning_first_name_input").prop("disabled", false);
    $("#start_learning_last_name_input").prop("disabled", false);
    $("#start_learning_image_img").prop("src", user.image_url);

    google_signOut();
    facebook_signOut();
    start_learning_check_tabs();
    start_learning_goto_tab("personal_information");
    // TODO this does not work, probably need to wait for the divs to show/hide
    $("#start_learning_display_name_input").focus();
}

function start_learning_googleUserEmailExistsCallback(email_exists)
{
    if (email_exists)
    {
        alert_show(oc.clabels[ "start_learning.login.email_exists.title"],
                oc.clabels[ "start_learning.login.email_exists.text"]);
    }
}

function start_learning_check_img_loaded()
{
    $("#start_learning_image_loading").addClass("d-none");
    $("#start_learning_image_img").removeClass("d-none");
    $("#start_learning_image_img").attr("src", start_learning.loading_image_url);
    if (start_learning.social_image_url === start_learning.loading_image_url) {
        $("#start_learning_img_upload_reset_image").addClass("d-none");
    } else {
        $("#start_learning_img_upload_reset_image").removeClass("d-none");
    }
    start_learning.image_url = start_learning.loading_image_url;
    $("#start_learning_image_id").val(makeRandomString(16));
}

function start_learning_check_img_url_fail()
{
    setTimeout(start_learning_check_img_url, 1000);
}

function start_learning_reset_img_upload()
{
    $("#start_learning_image_loading").removeClass("d-none");
    $("#start_learning_image_img").addClass("d-none");
    start_learning.loading_image_url = start_learning.social_image_url;
    start_learning_check_img_url();
}

function start_learning_check_img_url()
{
    $.ajax(
            {
                url: start_learning.loading_image_url,
                success: start_learning_check_img_loaded,
                error: start_learning_check_img_url_fail
            }
    );
}

function start_learning_img_upload()
{
    $("#start_learning_image_upload_form").submit();
    $("#start_learning_image_loading").removeClass("d-none");
    $("#start_learning_image_img").addClass("d-none");
    start_learning.loading_image_url = oc.cconfig["website.file.files_root"] +
            "/" + oc.cconfig["website.file.upload.images_root"] + "/" + $("#start_learning_image_id").val() + ".png";
    start_learning_check_img_url();
}

function start_learning_choose_topic()
{
    $(this).toggleClass("list-group-item-light");
    $(this).toggleClass("list-group-item-success");
    $(this).children("span.oi").toggleClass("d-none");
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

function start_learning_form_validation(request)
{
    $("#start_learning_form *").removeClass("border border-warning");

    if ((start_learning.google_id_token === null) && (start_learning.facebook_access_token === null)) {
        alert_show(oc.clabels[ "start_learning.form.submit.terms_of_usage.please_login"]);
        $("#start_learning_google_login").addClass("border border-warning");
        start_learning_goto_tab("personal_information");
        return false;
    }

    if (!$("#start_learning_accept_terms_checkbox").is(":checked")) {
        alert_show(oc.clabels[ "start_learning.form.submit.terms_of_usage.please_accept"]);
        $("#start_learning_accept_terms_checkbox_div").addClass("border border-warning");
        start_learning_goto_tab("accept_and_finish");
        return false;
    }

    return true;
}

function start_learning_form_submit()
{
    var request = {};
    request.google_id_token = start_learning.google_id_token;
    request.facebook_access_token = start_learning.facebook_access_token;
    request.email = $("#start_learning_email_input").val();
    request.first_name = $("#start_learning_first_name_input").val();
    request.last_name = $("#start_learning_last_name_input").val();
    request.display_name = $("#start_learning_display_name_input").val();
    request.image_url = start_learning.image_url;
    request.phone_number = $("#start_learning_phone_number_input").val();
    request.phone_area = $("#start_learning_phone_area_select").val();
    request.day_of_birth = start_learning.day_of_birth;
    request.institute_id = start_learning.institute_id;
    request.institute_name = $("#start_learning_institute_other_text").val();
    request.subject_id = start_learning.subject_id;
    request.subject_name = $("#start_learning_subject_0_text").val();
    request.degree_type = $("#start_learning_degree_type_select").val();    
    request.city_id = parseInt10($("#start_learning_city_select").val());
    request.feedback = $("#start_learning_feedback_input").val();
    request.learning_topics = [];
    $("#start_learning_topic_list button.list-group-item").each(
            function () {
                if (!$(this).hasClass("list-group-item-light")) {
                    request.learning_topics.push(parseInt10($(this).attr("data-topic-id")));
                }
            }
    );
    if ($("#start_learning_gender_input_male").prop("checked")) {
        request.gender = parseInt10($("#start_learning_gender_input_male").val());
    }
    if ($("#start_learning_gender_input_female").prop("checked")) {
        request.gender = parseInt10($("#start_learning_gender_input_female").val());
    }
    if (!start_learning_form_validation(request)) {
        return;
    }

    alert_show(oc.clabels[ "start_learning.register.registering"],
            oc.clabels[ "start_learning.register.registering_message"]);

    ajax_request( "register_student", request, start_learning_register_complete);    
}

function start_learning_select_day_of_birth()
{
    start_learning.day_of_birth = $("#start_learning_day_of_birth_input").datepicker("getDate");
    start_learning_check_tabs();
    $("#start_learning_city_select").focus();
}

function start_learning_select_institute()
{
    start_learning.institute_id = parseInt10($(this).val());
}

function start_learning_select_institute_type()
{
    start_learning.institute_type = parseInt10($(this).val());
    for (var i = 0; i <= oc.institute_type.length; i++)
    {
        $("#start_learning_institute_" + i + "_label").addClass("d-none");
        $("#start_learning_institute_" + i + "_div").addClass("d-none");
    }

    if (start_learning.institute_type === 0) {
        start_learning.institute_id = 0;
        $("#start_learning_institute_0_label").removeClass("d-none");
        $("#start_learning_institute_0_div").removeClass("d-none");
    } else {
        $("#start_learning_institute_" + start_learning.institute_type + "_label").removeClass("d-none");
        $("#start_learning_institute_" + start_learning.institute_type + "_div").removeClass("d-none");
    }
}

function start_learning_select_subject()
{
    start_learning.subject_id = parseInt10($(this).val());

    if (start_learning.subject_id === 0) {
        $("#start_learning_subject_0_div").removeClass("d-none");
        $("#start_learning_subject_0_label").removeClass("d-none");
    } else {
        $("#start_learning_subject_0_div").addClass("d-none");
        $("#start_learning_subject_0_label").addClass("d-none");
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

function start_learning_facebookLogin()
{
    var facebookUser = facebook_getLoggedInUser();
    if (facebookUser === null) {
        facebook_setUserLoggedinCallback(start_learning_userLoggedInCallback);
        facebook_signIn();
    } else {
        start_learning_userLoggedInCallback(facebookUser);
    }
}

function start_learning_goto_tab(tab_name)
{
    $("#start_learning_" + tab_name + "_link").tab('show');
}

function start_learning_check_tabs()
{
    $("#start_learning_tab_list a.nav-link").addClass("disabled");
    disableButtons($("button.start_learning_tabs_button"));

    if (oc.cconfig["start_learning.enable_all_tabs"] === "true") {
        $("#start_learning_tab_list a.nav-link").removeClass("disabled");
        enableButtons($("button.start_learning_tabs_button"));
    }

    // google login tab always enabled
    $("#start_learning_login_link").removeClass("disabled");

    // if logged in, show personal information
    if ((start_learning.google_id_token === null) && (start_learning.facebook_access_token === null)) {
        return;
    }

    $("#start_learning_personal_information_link").removeClass("disabled");
    enableButtons($("#start_learning_goto_tab_personal_information_button"));

    $("input.start_learning_required").removeClass("start_learning_required_filled");
    $("select.start_learning_required").removeClass("start_learning_required_filled");
    $("textarea.start_learning_required").removeClass("start_learning_required_filled");

    // if mandatory fields are present : display_name, phone, day of birth and city, can show education tab
    var request = {};  
    request.display_name = $("#start_learning_display_name_input").val();

    var pass_to_education = true;

    if (stringEmpty(request.display_name)) {
        pass_to_education = false;
    } else {
        $("#start_learning_display_name_input").addClass("start_learning_required_filled");
    }
    
    if (!pass_to_education) {
        return;
    }    

    // can move to education
    $("#start_learning_education_link").removeClass("disabled");
    enableButtons($("#start_learning_goto_tab_education_button"));
    
    // can move to learning_topics
    $("#start_learning_learning_topics_link").removeClass("disabled");
    enableButtons($("#start_learning_goto_tab_learning_topics_button"));

    // can move to accept_and_finish
    $("#start_learning_accept_and_finish_link").removeClass("disabled");
    enableButtons($("#start_learning_goto_tab_accept_and_finish_button"));

    if (!$("#start_learning_accept_terms_checkbox").is(":checked")) {
        return;
    }

    if (!start_learning.read_terms_of_usage) {
        return;
    }
    // can enable submit button
    enableButtons($("#start_learning_form_submit_button"));
}

function start_learning_terms_of_usage()
{
    window.open('terms_of_usage', 'terms_of_usage', 'width=1280,height=720');
    start_learning.read_terms_of_usage = true;
    start_learning_check_tabs();
}

function start_learning_init()
{
    start_learning.read_terms_of_usage = false;
    start_learning.google_id_token = null;
    start_learning.facebook_access_token = null;
    start_learning.day_of_birth = null;
    start_learning.city_id = 0;
    start_learning.subject_id = 0;

    start_learning.calendar = {};
    start_learning.calendar.minutes_unit = parseInt10(oc.cconfig[ "website.time.unit.minutes"]);
    start_learning.calendar.day_names_long = oc.clabels[ "website.days.long" ].split(",");
    start_learning.calendar.last_select = null;
    start_learning.calendar.available_times = [];
    start_learning.min_phone_digits = parseInt10(oc.cconfig[ "website.phone.min_digits"]);
    start_learning.max_phone_digits = parseInt10(oc.cconfig[ "website.phone.max_digits"]);
    start_learning.average_student_age = 25;
    
    google_addEmailExistsCallback(start_learning_googleUserEmailExistsCallback);
    $("#start_learning_day_of_birth_input").datepicker({
        dayNames: start_learning.calendar.day_names_long,
        dayNamesMin: oc.clabels[ "website.days.short" ].split(","),
        monthNames: oc.clabels[ "website.months.long" ].split(","),
        monthNamesShort: oc.clabels[ "website.months.short" ].split(","),
        isRTL: true,
        changeYear: true,
        defaultDate: "-" + ( start_learning.average_student_age ) + "y",
        dateFormat: "dd/mm/yy",
        yearRange: "-"+ start_learning.average_student_age + ":+0",
        onSelect: start_learning_select_day_of_birth
    });
    if (login_isLoggedIn())
    {
        alert_show(oc.clabels[ "start_learning.login.already_logged_in.title"],
                oc.clabels[ "start_learning.login.already_logged_in.text"]);
    }

    $("#start_learning_calendar_table td").disableSelection();
    $("select.start_learning_institute_select").on("change", start_learning_select_institute);
    $("#start_learning_institute_type_select").on("change", start_learning_select_institute_type);
    $("#start_learning_subject_select").on("change", start_learning_select_subject);
    $("#start_learning_topic_list button.list-group-item").on("click", start_learning_choose_topic);
    $("input.start_learning_required").on("change", start_learning_check_tabs);
    $("select.start_learning_required").on("change", start_learning_check_tabs);
    $("textarea.start_learning_required").on("change", start_learning_check_tabs);

    $("#start_learning_personal_information_link").on("shown.bs.tab",
            function (event)
            {
                $("#start_learning_display_name_input").focus();
            });
    $("#start_learning_profile_link").on("shown.bs.tab",
            function (event)
            {
                $("#start_learning_moto_input").focus();
            });
    $("#start_learning_education_link").on("shown.bs.tab",
            function (event)
            {
                $("#start_learning_degree_type_select").focus();
            });
    common_number_only_input($("#start_learning_phone_number"));

    start_learning_check_tabs();
    $("#start_learning_image_id").val(makeRandomString(16));
}

$(document).ready(start_learning_init);