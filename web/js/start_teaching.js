/* global oc */

var start_teaching = {};

function start_teaching_userLoggedInCallback(user)
{
    alert_show(oc.clabels["start_teaching.login_successful"] + " " + user.email);
    google_clearUserLoggedinCallback();
    facebook_clearUserLoggedinCallback();
    start_teaching.google_id_token = user.google_id_token;
    start_teaching.facebook_access_token = user.facebook_access_token;
    
    $("#start_teaching_email_input").val(user.email);
    $("#start_teaching_display_name_input").val(user.name);
    $("#start_teaching_first_name_input").val(user.first_name);
    $("#start_teaching_last_name_input").val(user.last_name);
    $("#start_teaching_display_name_input").attr("disabled", false);
    $("#start_teaching_first_name_input").attr("disabled", false);
    $("#start_teaching_last_name_input").attr("disabled", false);
    google_signOut();
    facebook_signOut();
}

function start_teaching_googleUserEmailExistsCallback(email_exists)
{
    if (email_exists)
    {
        alert_show(oc.clabels[ "start_teaching.login.email_exists.title"],
                oc.clabels[ "start_teaching.login.email_exists.text"]);
    }
}

function start_teaching_choose_topic()
{
    $(this).toggleClass("list-group-item-light");
    $(this).toggleClass("list-group-item-success");
    $(this).children("span.oi").toggleClass("d-none");
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

function start_teaching_scroll_to(element)
{
    $('html, body').scrollTop($("#" + element).offset().top);
}

function start_teaching_form_validation(request)
{
    $("#start_teaching_form *").removeClass("border border-warning");    
    
    if ((start_teaching.google_id_token === null) && (start_teaching.facebook_access_token === null)) {
        alert_show(oc.clabels[ "start_teaching.form.submit.terms_of_usage.please_login"]);
        $("#start_teaching_google_login").addClass("border border-warning");
        start_teaching_scroll_to("start_teaching_google_login");
        start_teaching_goto_tab("personal_information");
        return false;
    }

    if (!$("#start_teaching_accept_terms_checkbox").is(":checked")) {
        alert_show(oc.clabels[ "start_teaching.form.submit.terms_of_usage.please_accept"]);
        $("#start_teaching_accept_terms_checkbox_div").addClass("border border-warning");
        start_teaching_scroll_to("start_teaching_accept_terms_checkbox_div");
        start_teaching_goto_tab("accept_and_finish");
        return false;
    }

    if (stringEmpty(request.phone_number) || stringEmpty(request.phone_area)) {
        alert_show(oc.clabels[ "start_teaching.form.submit.fill_in_phone"]);
        $("#start_teaching_phone_number").addClass("border border-warning");
        start_teaching_scroll_to("start_teaching_phone_number");
        start_teaching_goto_tab("personal_information");
        return false;
    }

    if (request.city_id === 0) {
        alert_show(oc.clabels[ "start_teaching.form.submit.fill_city"]);
        $("#start_teaching_city_select").addClass("border border-warning");
        start_teaching_scroll_to("start_teaching_city");
        start_teaching_goto_tab("personal_information");
        return false;
    }

    if (request.day_of_birth === null) {
        alert_show(oc.clabels[ "start_teaching.form.submit.fill_day_of_birth"]);
        $("#start_teaching_day_of_birth").addClass("border border-warning");
        start_teaching_scroll_to("start_teaching_day_of_birth");
        start_teaching_goto_tab("personal_information");
        return false;
    }

    if (stringEmpty(request.moto)) {
        alert_show(oc.clabels[ "start_teaching.form.submit.fill_moto"]);
        $("#start_teaching_moto").addClass("border border-warning");
        start_teaching_scroll_to("start_teaching_moto");
        start_teaching_goto_tab("profile");
        return false;
    }

    if (stringEmpty(request.paypal_email)) {
        alert_show(oc.clabels[ "start_teaching.form.submit.fill_paypal_email"]);
        $("#start_teaching_paypal_email").addClass("border border-warning");
        start_teaching_scroll_to("start_teaching_paypal_email");
        start_teaching_goto_tab("prices");
        return false;
    }

    if (!emailIsValid(request.paypal_email)) {
        alert_show(oc.clabels[ "start_teaching.form.submit.illegal_paypal_email"]);
        $("#start_teaching_paypal_email").addClass("border border-warning");
        start_teaching_scroll_to("start_teaching_paypal_email");
        start_teaching_goto_tab("prices");
        return false;
    }

    if (request.price_per_hour === 0) {
        alert_show(oc.clabels[ "start_teaching.form.submit.fill_price_per_hour"]);
        $("#start_teaching_price_per_hour").addClass("border border-warning");
        start_teaching_scroll_to("start_teaching_price_per_hour");
        start_teaching_goto_tab("prices");
        return false;
    }
    
    return true;
}

function start_teaching_form_submit()
{
    var request = {};
    request.google_id_token = start_teaching.google_id_token;
    request.facebook_access_token = start_teaching.facebook_access_token;
    request.email = $("#start_teaching_email_input").val();
    request.first_name = $("#start_teaching_first_name_input").val();
    request.last_name = $("#start_teaching_last_name_input").val();
    request.display_name = $("#start_teaching_display_name_input").val();
    request.phone_number = $("#start_teaching_phone_number_input").val();
    request.phone_area = $("#start_teaching_phone_area_select").val();
    request.day_of_birth = start_teaching.day_of_birth;
    request.skype_name = $("#start_teaching_skype_name_input").val();
    request.moto = $("#start_teaching_moto_input").val();
    request.show_phone = $("#start_teaching_show_phone").prop("checked");
    request.show_email = $("#start_teaching_show_email").prop("checked");
    request.show_skype = $("#start_teaching_show_skype").prop("checked");
    request.institute_id = start_teaching.institute_id;
    request.institute_name = $("#start_teaching_institute_other_text").val();
    request.subject_id = start_teaching.subject_id;
    request.subject_name = $("#start_teaching_subject_0_text").val();
    request.show_degree = $("#start_teaching_topic_show_degree").prop("checked");
    request.degree_type = $("#start_teaching_degree_type_select").val();
    request.price_per_hour = parseInt10($("#start_teaching_price_per_hour_input").val());
    request.paypal_email = $("#start_teaching_paypal_email_input").val();
    request.available_times = start_teaching.calendar.available_times;
    request.city_id = parseInt10($("#start_teaching_city_select").val());
    request.feedback = $("#start_teaching_feedback_input").val();
    request.min_class_length = parseInt10($("start_teaching_min_class_length").val());
    request.max_class_length = parseInt10($("start_teaching_max_class_length").val());
    request.teaching_topics = [];
    $("#start_teaching_topic_list button.list-group-item").each(
            function () {
                if (!$(this).hasClass("list-group-item-light")) {
                    request.teaching_topics.push(parseInt10($(this).attr("data-topic-id")));
                }
            }
    );

    console.log(request);
    if (!start_teaching_form_validation(request)) {
        return;
    }

    alert_show(oc.clabels[ "start_teaching.register.registering"],
            oc.clabels[ "start_teaching.register.registering_message"]);


    if ($("#start_teaching_gender_input_male").prop("checked")) {
        request.gender = parseInt10($("#start_teaching_gender_input_male").val());
    }
    if ($("#start_teaching_gender_input_female").prop("checked")) {
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
    start_teaching.day_of_birth = $("#start_teaching_day_of_birth_input").datepicker("getDate");
}

function start_teaching_select_institute()
{
    start_teaching.institute_id = parseInt10($(this).val());
}

function start_teaching_select_institute_type()
{
    start_teaching.institute_type = parseInt10($(this).val());
    for (var i = 0; i <= oc.institute_type.length; i++)
    {
        $("#start_teaching_institute_" + i + "_label").addClass("d-none");
        $("#start_teaching_institute_" + i + "_div").addClass("d-none");
    }

    if (start_teaching.institute_type === 0) {
        start_teaching.institute_id = 0;
        $("#start_teaching_institute_0_label").removeClass("d-none");
        $("#start_teaching_institute_0_div").removeClass("d-none");
    } else {
        $("#start_teaching_institute_" + start_teaching.institute_type + "_label").removeClass("d-none");
        $("#start_teaching_institute_" + start_teaching.institute_type + "_div").removeClass("d-none");
    }
}

function start_teaching_select_subject()
{
    start_teaching.subject_id = parseInt10($(this).val());

    if (start_teaching.subject_id === 0) {
        $("#start_teaching_subject_0_div").removeClass("d-none");
        $("#start_teaching_subject_0_label").removeClass("d-none");
    } else {
        $("#start_teaching_subject_0_div").addClass("d-none");
        $("#start_teaching_subject_0_label").addClass("d-none");
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
    }
}

function start_teaching_select_single_time(day, hour, minute)
{
    start_teaching.calendar.last_select = {
        hour: hour,
        day: day,
        minute: minute
    };
    var hourElement = $("#start_teaching_day_" + day + "_hour_" + hour + "_minute_" + minute);
    if (hourElement.hasClass("calendar_selected")) {
        hourElement.removeClass("calendar_selected");
        start_teaching.calendar.last_select.add = false;
    } else {
        hourElement.addClass("calendar_selected");
        start_teaching.calendar.last_select.add = true;
    }
    start_teaching.calendar.last_element_selected = hourElement;
    start_teaching_update_calendar();
}

function start_teaching_select_time(event)
{
    event.preventDefault();
    event.stopPropagation();
    var elem = $("#" + event.target.id);
    var day = parseInt10(elem.attr("data-day"));
    var hour = parseInt10(elem.attr("data-hour"));
    var minute = parseInt10(elem.attr("data-minute"));
    if (!event.shiftKey) {
        start_teaching_select_single_time(day, hour, minute);
        return false;
    }
    if (start_teaching.calendar.last_select === null) {
        start_teaching_select_single_time(day, hour, minute);
        return false;
    }

    if (day !== start_teaching.calendar.last_select.day) {
        start_teaching_select_single_time(day, hour, minute);
        return false;
    }

    var start_hour = start_teaching.calendar.last_select.hour;
    var start_minute = start_teaching.calendar.last_select.minute;
    var increasing = (start_hour < hour) || ((start_hour === hour) && (start_minute < minute));
    do {
        var hourElement = $("#start_teaching_day_" + day + "_hour_" + start_hour + "_minute_" + start_minute);
        if (start_teaching.calendar.last_select.add) {
            hourElement.addClass("calendar_selected");
        } else {
            hourElement.removeClass("calendar_selected");
        }
        if ((start_hour === hour) && (start_minute === minute)) {
            break;
        }
        if (increasing) {
            start_minute += start_teaching.calendar.minutes_unit;
            if (start_minute === 60) {
                start_minute = 0;
                start_hour++;
            }
        } else {
            if (start_minute === 0) {
                start_minute = 60;
                start_hour--;
            }
            start_minute -= start_teaching.calendar.minutes_unit;
        }
    } while (true);
    start_teaching_update_calendar();
    return false;
}

function start_teaching_update_calendar()
{
    var start_working_hour = parseInt10(oc.cconfig[ "website.time.start_working_hour"]);
    var end_working_hour = parseInt10(oc.cconfig[ "website.time.end_working_hour"]);
    var start_available_time = false;
    var available_day, start_hour, start_minute, end_hour, end_minute;
    var available_text = "";
    start_teaching.calendar.available_times = [];
    for (var day = 1; day <= 7; day++) {
        var hour = start_working_hour;
        var minute = 0;
        while (hour < end_working_hour) {
            var element = $("#start_teaching_day_" + day + "_hour_" + hour + "_minute_" + minute);
            if (!start_available_time) {
                if (element.hasClass("calendar_selected"))
                {
                    start_available_time = true;
                    available_day = day;
                    start_hour = hour;
                    start_minute = minute;
                }
            } else {
                if (!element.hasClass("calendar_selected"))
                {
                    start_available_time = false;
                    end_hour = hour;
                    end_minute = minute;
                    available_text += start_teaching.calendar.day_names_long[available_day - 1] + " : " +
                            formatTime(end_hour, end_minute) + " - " + formatTime(start_hour, start_minute) + "<br/>";
                    start_teaching.calendar.available_times.push(
                            {
                                day: available_day,
                                start_hour: start_hour,
                                end_hour: end_hour,
                                start_minute: start_minute,
                                end_minute: end_minute
                            });
                }
            }
            minute += start_teaching.calendar.minutes_unit;
            if (minute === 60) {
                minute = 0;
                hour++;
            }
        }
    }
    $("#start_teaching_selected_hours").html(available_text);
}

function start_teaching_clear_calendar()
{
    $("#start_teaching_calendar_table td").removeClass("calendar_selected");
    start_teaching_update_calendar();
}

function start_teaching_goto_tab(tab_name)
{
    $("#start_teaching_" + tab_name + "_link").tab('show');
}

function start_teaching_init()
{
    start_teaching.google_id_token = null;
    start_teaching.facebook_access_token = null;
    start_teaching.day_of_birth = null;
    start_teaching.city_id = 0;
    start_teaching.subject_id = 0;    
    
    start_teaching.calendar = {};
    start_teaching.calendar.minutes_unit = parseInt10(oc.cconfig[ "website.time.unit.minutes"]);
    start_teaching.calendar.day_names_long = oc.clabels[ "website.days.long" ].split(",");
    start_teaching.calendar.last_select = null;
    start_teaching.calendar.available_times = [];
    start_teaching.min_teacher_age = parseInt10(oc.cconfig[ "start_teaching.min_teacher_age"]);
    start_teaching.max_teacher_age = parseInt10(oc.cconfig[ "start_teaching.max_teacher_age"]);
    google_addEmailExistsCallback(start_teaching_googleUserEmailExistsCallback);
    var current_year = new Date().getFullYear();
    var default_year = new Date();
    default_year.setFullYear(current_year - start_teaching.min_teacher_age);
    $("#start_teaching_day_of_birth_input").datepicker({
        dayNames: start_teaching.calendar.day_names_long,
        dayNamesMin: oc.clabels[ "website.days.short" ].split(","),
        monthNames: oc.clabels[ "website.months.long" ].split(","),
        monthNamesShort: oc.clabels[ "website.months.short" ].split(","),
        isRTL: true,
        changeYear: true,
        defaultDate: default_year,
        dateFormat: "dd/mm/yy",
        yearRange: (current_year - start_teaching.max_teacher_age) + ":" + (current_year - start_teaching.min_teacher_age),
        onSelect: start_teaching_select_day_of_birth
    });
    if (login_isLoggedIn())
    {
        alert_show(oc.clabels[ "start_teaching.login.already_logged_in.title"],
                oc.clabels[ "start_teaching.login.already_logged_in.text"]);
    }

    $('#start_teaching_topic_show_degree').on('click', function (e) {
        event.preventDefault();
    });
    $('#start_teaching_degree_information_div').on('hide.bs.collapse', function ()
    {
        $('#start_teaching_topic_show_degree').prop("checked", false);
    });
    $('#start_teaching_degree_information_div').on('show.bs.collapse', function ()
    {
        $('#start_teaching_topic_show_degree').prop("checked", true);
    });

    $("#start_teaching_calendar_table td").disableSelection();
    $("select.start_teaching_institute_select").on("change", start_teaching_select_institute);
    $("#start_teaching_institute_type_select").on("change", start_teaching_select_institute_type);
    $("#start_teaching_subject_select").on("change", start_teaching_select_subject);
    $("#start_teaching_topic_list button.list-group-item").on("click", start_teaching_choose_topic);
    $("td.start_teaching_calendar_time").on("click", start_teaching_select_time);
}

$(document).ready(start_teaching_init);