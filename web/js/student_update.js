/* global oc */

var student_update = {};

function student_update_userLoggedInCallback(user)
{
    google_clearUserLoggedinCallback();
    facebook_clearUserLoggedinCallback();
    student_update.google_id_token = user.google_id_token;
    student_update.facebook_access_token = user.facebook_access_token;
    student_update.social_image_url = user.image_url;
    student_update.image_url = user.image_url;

    $("#student_update_email_input").val(user.email);
    $("#student_update_display_name_input").val(user.display_name);
    $("#student_update_first_name_input").val(user.first_name);
    $("#student_update_last_name_input").val(user.last_name);
    $("#student_update_display_name_input").prop("disabled", false);
    $("#student_update_first_name_input").prop("disabled", false);
    $("#student_update_last_name_input").prop("disabled", false);
    $("#student_update_image_img").prop("src", user.image_url);

    google_signOut();
    facebook_signOut();
    student_update_check_tabs();
    student_update_goto_tab("personal_information");
    // TODO this does not work, probably need to wait for the divs to show/hide
    $("#student_update_display_name_input").focus();
}

function student_update_googleUserEmailExistsCallback(email_exists)
{
    if (email_exists)
    {
        alert_show(oc.clabels[ "student_update.login.email_exists.title"],
                oc.clabels[ "student_update.login.email_exists.text"]);
    }
}

function student_update_check_img_loaded()
{
    $("#student_update_image_loading").addClass("d-none");
    $("#student_update_image_img").removeClass("d-none");
    $("#student_update_image_img").attr("src", student_update.loading_image_url);
    if (student_update.social_image_url === student_update.loading_image_url) {
        $("#student_update_img_upload_reset_image").addClass("d-none");
    } else {
        $("#student_update_img_upload_reset_image").removeClass("d-none");
    }
    student_update.image_url = student_update.loading_image_url;
    $("#student_update_image_id").val(makeRandomString(16));
}

function student_update_check_img_url_fail()
{
    setTimeout(student_update_check_img_url, 1000);
}

function student_update_reset_img_upload()
{
    $("#student_update_image_loading").removeClass("d-none");
    $("#student_update_image_img").addClass("d-none");
    student_update.loading_image_url = student_update.social_image_url;
    student_update_check_img_url();
}

function student_update_check_img_url()
{
    $.ajax(
            {
                url: student_update.loading_image_url,
                success: student_update_check_img_loaded,
                error: student_update_check_img_url_fail
            }
    );
}

function student_update_img_upload()
{
    $("#student_update_image_upload_form").submit();
    $("#student_update_image_loading").removeClass("d-none");
    $("#student_update_image_img").addClass("d-none");
    student_update.loading_image_url = oc.cconfig["website.file.files_root"] +
            "/" + oc.cconfig["website.file.upload.images_root"] + "/" + $("#student_update_image_id").val() + ".png";
    student_update_check_img_url();
}

function student_update_choose_topic()
{
    $(this).toggleClass("list-group-item-light");
    $(this).toggleClass("list-group-item-success");
    $(this).children("span.oi").toggleClass("d-none");
}

function student_update_register_complete(response)
{
    if (response.rc !== 0) {
        alert_show(oc.clabels[ "student_update.register.failed.title"],
                oc.clabels[ "student_update.register.failed.message"] + ":" + response.message);
        return;
    }
    alert_show(oc.clabels[ "student_update.register.success.title"],
            oc.clabels[ "student_update.register.success.message"],
            student_update_complete_ok);
    redirectAfter("/", 5);
}

function student_update_complete_ok()
{
    location.href = "/";
}

function student_update_form_validation(request)
{
    $("#student_update_form *").removeClass("border border-warning");

    if ((student_update.google_id_token === null) && (student_update.facebook_access_token === null)) {
        alert_show(oc.clabels[ "student_update.form.submit.terms_of_usage.please_login"]);
        $("#student_update_google_login").addClass("border border-warning");
        student_update_goto_tab("personal_information");
        return false;
    }

    if (!$("#student_update_accept_terms_checkbox").is(":checked")) {
        alert_show(oc.clabels[ "student_update.form.submit.terms_of_usage.please_accept"]);
        $("#student_update_accept_terms_checkbox_div").addClass("border border-warning");
        student_update_goto_tab("accept_and_finish");
        return false;
    }

    return true;
}

function student_update_form_submit()
{
    var request = {};
    request.google_id_token = student_update.google_id_token;
    request.facebook_access_token = student_update.facebook_access_token;
    request.email = $("#student_update_email_input").val();
    request.first_name = $("#student_update_first_name_input").val();
    request.last_name = $("#student_update_last_name_input").val();
    request.display_name = $("#student_update_display_name_input").val();
    request.image_url = student_update.image_url;
    request.phone_number = $("#student_update_phone_number_input").val();
    request.phone_area = $("#student_update_phone_area_select").val();
    request.day_of_birth = student_update.day_of_birth;
    request.institute_id = student_update.institute_id;
    request.institute_name = $("#student_update_institute_other_text").val();
    request.subject_id = student_update.subject_id;
    request.subject_name = $("#student_update_subject_0_text").val();
    request.degree_type = $("#student_update_degree_type_select").val();
    request.city_id = parseInt10($("#student_update_city_select").val());
    request.feedback = $("#student_update_feedback_input").val();
    request.learning_topics = [];
    $("#student_update_topic_list button.list-group-item").each(
            function () {
                if (!$(this).hasClass("list-group-item-light")) {
                    request.learning_topics.push(parseInt10($(this).attr("data-topic-id")));
                }
            }
    );
    if ($("#student_update_gender_input_male").prop("checked")) {
        request.gender = parseInt10($("#student_update_gender_input_male").val());
    }
    if ($("#student_update_gender_input_female").prop("checked")) {
        request.gender = parseInt10($("#student_update_gender_input_female").val());
    }
    if (!student_update_form_validation(request)) {
        return;
    }

    alert_show(oc.clabels[ "student_update.register.registering"],
            oc.clabels[ "student_update.register.registering_message"]);

    ajax_request("register_student", request, student_update_register_complete);
}

function student_update_select_day_of_birth()
{
    student_update.day_of_birth = $("#student_update_day_of_birth_input").datepicker("getDate");
    student_update_check_tabs();
    $("#student_update_city_select").focus();
}

function student_update_select_institute()
{
    student_update.institute_id = parseInt10($(this).val());
    if (student_update.institute_id === 0) {
        student_update.institute_type = 0;
        for (var i = 0; i <= oc.institute_type.length; i++)
        {
            $("#student_update_institute_" + i + "_label").addClass("d-none");
            $("#student_update_institute_" + i + "_div").addClass("d-none");
        }
        $("#student_update_institute_0_label").removeClass("d-none");
        $("#student_update_institute_0_div").removeClass("d-none");
    }
}

function student_update_select_institute_type()
{
    student_update.institute_type = parseInt10($(this).val());
    for (var i = 0; i <= oc.institute_type.length; i++)
    {
        $("#student_update_institute_" + i + "_label").addClass("d-none");
        $("#student_update_institute_" + i + "_div").addClass("d-none");
    }

    if (student_update.institute_type === 0) {
        student_update.institute_id = 0;
        $("#student_update_institute_0_label").removeClass("d-none");
        $("#student_update_institute_0_div").removeClass("d-none");
    } else {
        $("#student_update_institute_" + student_update.institute_type + "_label").removeClass("d-none");
        $("#student_update_institute_" + student_update.institute_type + "_div").removeClass("d-none");
    }
}

function student_update_select_subject()
{
    student_update.subject_id = parseInt10($(this).val());

    if (student_update.subject_id === 0) {
        $("#student_update_subject_0_div").removeClass("d-none");
        $("#student_update_subject_0_label").removeClass("d-none");
    } else {
        $("#student_update_subject_0_div").addClass("d-none");
        $("#student_update_subject_0_label").addClass("d-none");
    }
}

function student_update_googleLogin()
{
    var googleUser = google_getLoggedInUser();
    if (googleUser === null) {
        google_setUserLoggedinCallback(student_update_userLoggedInCallback);
        google_signIn();
    } else {
        student_update_userLoggedInCallback(googleUser);
    }
}

function student_update_facebookLogin()
{
    var facebookUser = facebook_getLoggedInUser();
    if (facebookUser === null) {
        facebook_setUserLoggedinCallback(student_update_userLoggedInCallback);
        facebook_signIn();
    } else {
        student_update_userLoggedInCallback(facebookUser);
    }
}

function student_update_goto_tab(tab_name)
{
    $("#student_update_" + tab_name + "_link").tab('show');
}

function student_update_check_tabs()
{
    $("#student_update_tab_list a.nav-link").addClass("disabled");
    disableButtons($("button.student_update_tabs_button"));

    if (oc.cconfig["student_update.enable_all_tabs"] === "true") {
        $("#student_update_tab_list a.nav-link").removeClass("disabled");
        enableButtons($("button.student_update_tabs_button"));
    }

    // google login tab always enabled
    $("#student_update_login_link").removeClass("disabled");

    // if logged in, show personal information
    if ((student_update.google_id_token === null) && (student_update.facebook_access_token === null)) {
        return;
    }

    $("#student_update_personal_information_link").removeClass("disabled");
    enableButtons($("#student_update_goto_tab_personal_information_button"));

    $("input.student_update_required").removeClass("student_update_required_filled");
    $("select.student_update_required").removeClass("student_update_required_filled");
    $("textarea.student_update_required").removeClass("student_update_required_filled");

    // if mandatory fields are present : display_name, phone, day of birth and city, can show education tab
    var request = {};
    request.display_name = $("#student_update_display_name_input").val();

    var pass_to_education = true;

    if (stringEmpty(request.display_name)) {
        pass_to_education = false;
    } else {
        $("#student_update_display_name_input").addClass("student_update_required_filled");
    }

    if (!pass_to_education) {
        return;
    }

    // can move to education
    $("#student_update_education_link").removeClass("disabled");
    enableButtons($("#student_update_goto_tab_education_button"));

    // can move to learning_topics
    $("#student_update_learning_topics_link").removeClass("disabled");
    enableButtons($("#student_update_goto_tab_learning_topics_button"));

    // can move to accept_and_finish
    $("#student_update_accept_and_finish_link").removeClass("disabled");
    enableButtons($("#student_update_goto_tab_accept_and_finish_button"));

    if (!$("#student_update_accept_terms_checkbox").is(":checked")) {
        return;
    }

    if (!student_update.read_terms_of_usage) {
        return;
    }
    // can enable submit button
    enableButtons($("#student_update_form_submit_button"));
}

function student_update_terms_of_usage()
{
    window.open('terms_of_usage', 'terms_of_usage', 'width=1280,height=720');
    student_update.read_terms_of_usage = true;
    student_update_check_tabs();
}

function student_update_init()
{
    student_update.read_terms_of_usage = false;
    student_update.google_id_token = null;
    student_update.facebook_access_token = null;
    student_update.day_of_birth = null;
    student_update.city_id = 0;
    student_update.subject_id = 0;

    student_update.calendar = {};
    student_update.calendar.minutes_unit = parseInt10(oc.cconfig[ "website.time.unit.minutes"]);
    student_update.calendar.day_names_long = oc.clabels[ "website.days.long" ].split(",");
    student_update.calendar.last_select = null;
    student_update.calendar.available_times = [];
    student_update.min_phone_digits = parseInt10(oc.cconfig[ "website.phone.min_digits"]);
    student_update.max_phone_digits = parseInt10(oc.cconfig[ "website.phone.max_digits"]);
    student_update.average_student_age = 25;

    google_addEmailExistsCallback(student_update_googleUserEmailExistsCallback);
    $("#student_update_day_of_birth_input").datepicker({
        dayNames: student_update.calendar.day_names_long,
        dayNamesMin: oc.clabels[ "website.days.short" ].split(","),
        monthNames: oc.clabels[ "website.months.long" ].split(","),
        monthNamesShort: oc.clabels[ "website.months.short" ].split(","),
        isRTL: true,
        changeYear: true,
        defaultDate: "-" + (student_update.average_student_age) + "y",
        dateFormat: "dd/mm/yy",
        yearRange: "-" + student_update.average_student_age + ":+0",
        onSelect: student_update_select_day_of_birth
    });

    $("#student_update_calendar_table td").disableSelection();
    $("select.student_update_institute_select").on("change", student_update_select_institute);
    $("#student_update_institute_type_select").on("change", student_update_select_institute_type);

    $("#student_update_subject_select").on("change", student_update_select_subject);
    $("#student_update_topic_list button.list-group-item").on("click", student_update_choose_topic);
    $("input.student_update_required").on("change", student_update_check_tabs);
    $("select.student_update_required").on("change", student_update_check_tabs);
    $("textarea.student_update_required").on("change", student_update_check_tabs);

    $("#student_update_personal_information_link").on("shown.bs.tab",
            function ()
            {
                $("#student_update_display_name_input").focus();
            });
    $("#student_update_profile_link").on("shown.bs.tab",
            function ()
            {
                $("#student_update_moto_input").focus();
            });
    $("#student_update_education_link").on("shown.bs.tab",
            function ()
            {
                $("#student_update_degree_type_select").focus();
            });
    common_number_only_input($("#student_update_phone_number"));

    student_update_check_tabs();
    $("#student_update_image_id").val(makeRandomString(16));

    if (!login_isLoggedIn()) {
        login_registerStudent();
    } else {
        student_update_userLoggedInCallback(oc.user);
    }

}

$(document).ready(student_update_init);