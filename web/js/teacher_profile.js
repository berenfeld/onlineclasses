/* global oc */

var teacher_profile = {};

function teacher_profile_check_img_loaded()
{
    $("#teacher_profile_image_loading").addClass("d-none");
    $("#teacher_profile_image_img").removeClass("d-none");
    $("#teacher_profile_image_img").attr("src", teacher_profile.loading_image_url);
    if (teacher_profile.social_image_url === teacher_profile.loading_image_url) {
        $("#teacher_profile_img_upload_reset_image").addClass("d-none");
    } else {
        $("#teacher_profile_img_upload_reset_image").removeClass("d-none");
    }
    teacher_profile.image_url = teacher_profile.loading_image_url;
    $("#teacher_profile_image_id").val(makeRandomString(16));
}

function teacher_profile_check_img_url_fail()
{
    setTimeout(teacher_profile_check_img_url, 1000);
}

function teacher_profile_reset_img_upload()
{
    $("#teacher_profile_image_loading").removeClass("d-none");
    $("#teacher_profile_image_img").addClass("d-none");
    teacher_profile.loading_image_url = teacher_profile.social_image_url;
    teacher_profile_check_img_url();
}

function teacher_profile_check_img_url()
{
    $.ajax(
            {
                url: teacher_profile.loading_image_url,
                success: teacher_profile_check_img_loaded,
                error: teacher_profile_check_img_url_fail
            }
    );
}

function teacher_profile_img_upload()
{
    $("#teacher_profile_image_upload_form").submit();
    $("#teacher_profile_image_loading").removeClass("d-none");
    $("#teacher_profile_image_img").addClass("d-none");
    teacher_profile.loading_image_url = "/" + oc.cconfig["website.file.upload.root"] +
            "/" + oc.cconfig["website.file.upload.images_root"] + "/" + $("#teacher_profile_image_id").val() + ".png";
    teacher_profile_check_img_url();
}

function teacher_profile_choose_topic()
{
    $(this).toggleClass("list-group-item-light");
    $(this).toggleClass("list-group-item-success");
    $(this).children("span.oi").toggleClass("d-none");
}

function teacher_profile_register_complete(response)
{
    if (response.rc !== 0) {
        alert_show(oc.clabels[ "teacher_profile.register.failed.title"],
                oc.clabels[ "teacher_profile.register.failed.message"] + ":" + response.message);
        return;
    }
    alert_show(oc.clabels[ "teacher_profile.register.success.title"],
            oc.clabels[ "teacher_profile.register.success.message"]);
}


function teacher_profile_form_validation(request)
{    
    $("#teacher_profile_form *").removeClass("border border-warning");

    if (stringEmpty(request.display_name)) {
        alert_show(oc.clabels[ "teacher_profile.form.submit.fill_in_display_name"]);
        $("#teacher_profile_display_name_input").addClass("border border-warning");
        teacher_profile_goto_tab("personal_information");
        return false;
    }
    
    if (stringEmpty(request.phone_number) || stringEmpty(request.phone_area)) {
        alert_show(oc.clabels[ "teacher_profile.form.submit.fill_in_phone"]);
        $("#teacher_profile_phone_number").addClass("border border-warning");
        teacher_profile_goto_tab("personal_information");
        return false;
    }

    if (!stringLengthBetween(request.phone_number, teacher_profile.min_phone_digits, teacher_profile.max_phone_digits)) {
        alert_show(oc.clabels[ "teacher_profile.form.submit.fill_in_phone"]);
        $("#teacher_profile_phone_number").addClass("border border-warning");
        teacher_profile_goto_tab("personal_information");
        return false;
    }

    if (request.city_id === 0) {
        alert_show(oc.clabels[ "teacher_profile.form.submit.fill_city"]);
        $("#teacher_profile_city_select").addClass("border border-warning");
        teacher_profile_goto_tab("personal_information");
        return false;
    }

    if (request.day_of_birth === null) {
        alert_show(oc.clabels[ "teacher_profile.form.submit.fill_day_of_birth"]);
        $("#teacher_profile_day_of_birth").addClass("border border-warning");
        teacher_profile_goto_tab("personal_information");
        return false;
    }

    if (stringEmpty(request.moto)) {
        alert_show(oc.clabels[ "teacher_profile.form.submit.fill_moto"]);
        $("#teacher_profile_moto").addClass("border border-warning");
        teacher_profile_goto_tab("profile");
        return false;
    }

    if (request.moto.length < teacher_profile.min_moto_length) {
        alert_show(oc.clabels[ "teacher_profile.form.submit.fill_moto"]);
        $("#teacher_profile_moto").addClass("border border-warning");
        teacher_profile_goto_tab("profile");
        return false;
    }

    if (request.price_per_hour === 0) {
        alert_show(oc.clabels[ "teacher_profile.form.submit.fill_price_per_hour"]);
        $("#teacher_profile_price_per_hour").addClass("border border-warning");
        teacher_profile_goto_tab("prices");
        return false;
    }

    if (!numberBetween(request.price_per_hour, teacher_profile.min_price_per_hour, teacher_profile.max_price_per_hour)) {
        alert_show(oc.clabels[ "teacher_profile.form.submit.invalid_price_per_hour"]);
        $("#teacher_profile_price_per_hour").addClass("border border-warning");
        teacher_profile_goto_tab("prices");
        return false;
    }

    return true;
}

function teacher_profile_form_submit()
{
    var request = {};
    request.display_name = $("#teacher_profile_display_name_input").val();
    request.email = $("#teacher_profile_email_input").val();
    request.image_url = teacher_profile.image_url;
    request.phone_number = $("#teacher_profile_phone_number_input").val();
    request.phone_area = $("#teacher_profile_phone_area_select").val();
    request.skype_name = $("#teacher_profile_skype_name_input").val();
    request.moto = $("#teacher_profile_moto_input").val();
    request.show_phone = $("#teacher_profile_show_phone").prop("checked");
    request.show_email = $("#teacher_profile_show_email").prop("checked");
    request.show_skype = $("#teacher_profile_show_skype").prop("checked");
    request.institute_id = teacher_profile.institute_id;
    request.institute_name = $("#teacher_profile_institute_other_text").val();
    request.subject_id = teacher_profile.subject_id;
    request.subject_name = $("#teacher_profile_subject_0_text").val();
    request.show_degree = $('#teacher_profile_show_degree').prop("checked");
    request.degree_type = $("#teacher_profile_degree_type_select").val();
    request.price_per_hour = parseInt10($("#teacher_profile_price_per_hour_input").val());
    request.available_times = teacher_profile.calendar.available_times;
    request.city_id = parseInt10($("#teacher_profile_city_select").val());
    request.feedback = $("#teacher_profile_feedback_input").val();
    request.min_class_length = parseInt10($("#teacher_profile_min_class_length").val());
    request.max_class_length = parseInt10($("#teacher_profile_max_class_length").val());
    request.teaching_topics = [];
    $("#teacher_profile_topic_list button.list-group-item").each(
            function () {
                if (!$(this).hasClass("list-group-item-light")) {
                    request.teaching_topics.push(parseInt10($(this).attr("data-topic-id")));
                }
            }
    );

    console.log(request);
    if (!teacher_profile_form_validation(request)) {
        return;
    }

    alert_show(oc.clabels[ "teacher_profile.update.updating.title"],
            oc.clabels[ "teacher_profile.update.updating.message"]);


    if ($("#teacher_profile_gender_input_male").prop("checked")) {
        request.gender = parseInt10($("#teacher_profile_gender_input_male").val());
    }
    if ($("#teacher_profile_gender_input_female").prop("checked")) {
        request.gender = parseInt10($("#teacher_profile_gender_input_female").val());
    }

    ajax_request( "teacher_profile", request, teacher_profile_register_complete);    
}

function teacher_profile_select_day_of_birth()
{
    teacher_profile.day_of_birth = $("#teacher_profile_day_of_birth_input").datepicker("getDate");
    teacher_profile_check_tabs();
    $("#teacher_profile_skype_name_input").focus();
}

function teacher_profile_select_institute()
{
    teacher_profile.institute_id = parseInt10($(this).val());
    if (teacher_profile.institute_id === 0)
    {
        teacher_profile.institute_type = 0;
        teacher_profile_institute_type_updated();
    }
}

function teacher_profile_select_institute_type()
{
    teacher_profile.institute_type = parseInt10($(this).val());
    teacher_profile_institute_type_updated();
}

function teacher_profile_institute_updated()
{
    $("#teacher_profile_institute_" + teacher_profile.institute_type + "_select").val(teacher_profile.institute_id);
}

function teacher_profile_institute_type_updated()
{
    for (var i = 0; i <= oc.institute_type.length; i++)
    {
        $("#teacher_profile_institute_" + i + "_label").addClass("d-none");
        $("#teacher_profile_institute_" + i + "_div").addClass("d-none");
    }

    if (teacher_profile.institute_type === 0) {
        teacher_profile.institute_id = 0;
        $("#teacher_profile_institute_0_label").removeClass("d-none");
        $("#teacher_profile_institute_0_div").removeClass("d-none");
    } else {
        $("#teacher_profile_institute_" + teacher_profile.institute_type + "_label").removeClass("d-none");
        $("#teacher_profile_institute_" + teacher_profile.institute_type + "_div").removeClass("d-none");
    }
}

function teacher_profile_select_subject()
{
    teacher_profile.subject_id = parseInt10($(this).val());
    teacher_profile_subject_selected()
}

function teacher_profile_subject_selected()
{
    if (teacher_profile.subject_id === 0) {
        $("#teacher_profile_subject_0_div").removeClass("d-none");
        $("#teacher_profile_subject_0_label").removeClass("d-none");
    } else {
        $("#teacher_profile_subject_0_div").addClass("d-none");
        $("#teacher_profile_subject_0_label").addClass("d-none");
    }
}

function teacher_profile_select_single_time(day, hour, minute)
{
    teacher_profile.calendar.last_select = {
        hour: hour,
        day: day,
        minute: minute
    };
    var hourElement = $("#teacher_profile_day_" + day + "_hour_" + hour + "_minute_" + minute);
    if (hourElement.hasClass("calendar_selected")) {
        hourElement.removeClass("calendar_selected");
        teacher_profile.calendar.last_select.add = false;
    } else {
        hourElement.addClass("calendar_selected");
        teacher_profile.calendar.last_select.add = true;
    }
    teacher_profile.calendar.last_element_selected = hourElement;
    teacher_profile_update_calendar();
}

function teacher_profile_select_time(event)
{
    event.preventDefault();
    event.stopPropagation();
    var elem = $("#" + event.target.id);
    var day = parseInt10(elem.attr("data-day"));
    var hour = parseInt10(elem.attr("data-hour"));
    var minute = parseInt10(elem.attr("data-minute"));
    if (!event.shiftKey) {
        teacher_profile_select_single_time(day, hour, minute);
        return false;
    }
    if (teacher_profile.calendar.last_select === null) {
        teacher_profile_select_single_time(day, hour, minute);
        return false;
    }

    if (day !== teacher_profile.calendar.last_select.day) {
        teacher_profile_select_single_time(day, hour, minute);
        return false;
    }

    var start_hour = teacher_profile.calendar.last_select.hour;
    var start_minute = teacher_profile.calendar.last_select.minute;
    var increasing = (start_hour < hour) || ((start_hour === hour) && (start_minute < minute));
    do {
        var hourElement = $("#teacher_profile_day_" + day + "_hour_" + start_hour + "_minute_" + start_minute);
        if (teacher_profile.calendar.last_select.add) {
            hourElement.addClass("calendar_selected");
        } else {
            hourElement.removeClass("calendar_selected");
        }
        if ((start_hour === hour) && (start_minute === minute)) {
            break;
        }
        if (increasing) {
            start_minute += teacher_profile.calendar.minutes_unit;
            if (start_minute === 60) {
                start_minute = 0;
                start_hour++;
            }
        } else {
            if (start_minute === 0) {
                start_minute = 60;
                start_hour--;
            }
            start_minute -= teacher_profile.calendar.minutes_unit;
        }
    } while (true);
    teacher_profile_update_calendar();
    return false;
}

function teacher_profile_init_calendar()
{
    console.log(teacher_profile.available_times);

    teacher_profile.calendar.available_times = teacher_profile.available_times;

    var available_text = "";

    for (var i = 0; i < teacher_profile.available_times.length; i++) {
        var available_time = teacher_profile.available_times[ i ];
        var day = available_time.day;
        var start_hour = available_time.start_hour;
        var end_hour = available_time.end_hour;
        var start_minute = available_time.start_minute;
        var end_minute = available_time.end_minute;

        available_text += teacher_profile.calendar.day_names_long[day - 1] + " : " +
                formatTime(end_hour, end_minute) + " - " + formatTime(start_hour, start_minute) + "<br/>";
        do {
            if ((start_hour === end_hour) && (start_minute === end_minute)) {
                break;
            }
            var hourElement = $("#teacher_profile_day_" + day + "_hour_" + start_hour + "_minute_" + start_minute);
            hourElement.addClass("calendar_selected");

            start_minute += teacher_profile.calendar.minutes_unit;
            if (start_minute === 60) {
                start_minute = 0;
                start_hour++;
            }

        } while (true);
    }
    $("#teacher_profile_selected_hours").html(available_text);
}

function teacher_profile_update_calendar()
{
    var start_working_hour = parseInt10(oc.cconfig[ "website.time.start_working_hour"]);
    var end_working_hour = parseInt10(oc.cconfig[ "website.time.end_working_hour"]);
    var start_available_time = false;
    var available_day, start_hour, start_minute, end_hour, end_minute;
    var available_text = "";
    teacher_profile.calendar.available_times = [];
    for (var day = 1; day <= 7; day++) {
        var hour = start_working_hour;
        var minute = 0;
        while (hour < end_working_hour) {
            var element = $("#teacher_profile_day_" + day + "_hour_" + hour + "_minute_" + minute);
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
                    available_text += teacher_profile.calendar.day_names_long[available_day - 1] + " : " +
                            formatTime(end_hour, end_minute) + " - " + formatTime(start_hour, start_minute) + "<br/>";
                    teacher_profile.calendar.available_times.push(
                            {
                                day: available_day,
                                start_hour: start_hour,
                                end_hour: end_hour,
                                start_minute: start_minute,
                                end_minute: end_minute
                            });
                }
            }
            minute += teacher_profile.calendar.minutes_unit;
            if (minute === 60) {
                minute = 0;
                hour++;
            }
        }
    }
    $("#teacher_profile_selected_hours").html(available_text);
}

function teacher_profile_clear_calendar()
{
    $("#teacher_profile_calendar_table td").removeClass("calendar_selected");
    teacher_profile_update_calendar();
}

function teacher_profile_goto_tab(tab_name)
{
    $("#teacher_profile_" + tab_name + "_link").tab('show');
}

function teacher_profile_check_tabs()
{
    // disable submit buttons
    disableButtons($("button.teacher_profile_form_submit_buttons"));
    
    $("#teacher_profile_tab_list a.nav-link").addClass("disabled");
    disableButtons($("button.teacher_profile_tabs_button"))

    if (oc.cconfig["teacher_profile.enable_all_tabs"] === "true") {
        $("#teacher_profile_tab_list a.nav-link").removeClass("disabled");
        enableButtons($("button.teacher_profile_tabs_button"));
    }

    $("#teacher_profile_personal_information_link").removeClass("disabled");
    enableButtons($("#teacher_profile_goto_tab_personal_information_button"));

    $("input.teacher_profile_required").removeClass("teacher_profile_required_filled");
    $("select.teacher_profile_required").removeClass("teacher_profile_required_filled");
    $("textarea.teacher_profile_required").removeClass("teacher_profile_required_filled");

    // if mandatory fields are present : display_name, phone, day of birth and city, can show profile tab
    var request = {};
    request.phone_number = $("#teacher_profile_phone_number_input").val();
    request.phone_area = $("#teacher_profile_phone_area_select").val();
    request.city_id = parseInt10($("#teacher_profile_city_select").val());
    request.display_name = $("#teacher_profile_display_name_input").val();

    var pass_to_profile = true;

    if (stringEmpty(request.display_name)) {
        pass_to_profile = false;
    } else {
        $("#teacher_profile_display_name_input").addClass("teacher_profile_required_filled");
    }
    
    if (stringEmpty(request.phone_number)) {
        pass_to_profile = false;
    } else {
        if (!stringLengthBetween(request.phone_number, teacher_profile.min_phone_digits, teacher_profile.max_phone_digits)) {
            pass_to_profile = false;
        } else {
            $("#teacher_profile_phone_number_input").addClass("teacher_profile_required_filled");
        }
    }

    if (stringEmpty(request.phone_area)) {
        pass_to_profile = false;
    } else {
        $("#teacher_profile_phone_area_select").addClass("teacher_profile_required_filled");
    }

    if (request.city_id === 0) {
        pass_to_profile = false;
    } else {
        $("#teacher_profile_city_select").addClass("teacher_profile_required_filled");
    }

    if (!pass_to_profile) {
        return;
    }
    $("#teacher_profile_profile_link").removeClass("disabled");
    enableButtons($("#teacher_profile_goto_tab_profile_button"));

    // if moto is filled - can go to education
    // TODO moto minimum length
    request.moto = $("#teacher_profile_moto_input").val();

    if (stringEmpty(request.moto)) {
        return;
    }
    if (request.moto.length < teacher_profile.min_moto_length) {
        return;
    }
    $("#teacher_profile_moto_input").addClass("teacher_profile_required_filled");

    // can move to education
    $("#teacher_profile_education_link").removeClass("disabled");
    enableButtons($("#teacher_profile_goto_tab_education_button"));

    // can move to teaching_topics
    $("#teacher_profile_teaching_topics_link").removeClass("disabled");
    enableButtons($("#teacher_profile_goto_tab_teaching_topics_button"));

    // can move to prices
    $("#teacher_profile_prices_link").removeClass("disabled");
    enableButtons($("#teacher_profile_goto_tab_prices_button"));

    var pass_to_teaching_hours = true;

    request.price_per_hour = parseInt10($("#teacher_profile_price_per_hour_input").val());
    if (request.price_per_hour === 0) {
        pass_to_teaching_hours = false;
    } else {
        if (!numberBetween(request.price_per_hour, teacher_profile.min_price_per_hour, teacher_profile.max_price_per_hour)) {
            pass_to_teaching_hours = false;
        } else {
            $("#teacher_profile_price_per_hour_input").addClass("teacher_profile_required_filled");
        }
    }

    if (!pass_to_teaching_hours) {
        return;
    }

    // can move to teaching_hours
    $("#teacher_profile_teaching_hours_link").removeClass("disabled");
    enableButtons($("#teacher_profile_goto_tab_teaching_hours_button"));

    $("#teacher_profile_accept_and_finish_link").removeClass("disabled");
    enableButtons($("#teacher_profile_goto_tab_accept_and_finish_button"));

    // can enable submit button
    enableButtons($("button.teacher_profile_form_submit_buttons"));
}

function teacher_profile_init()
{
    var teacher = teacher_profile.teacher;
    console.log(teacher);

    $("#teacher_profile_email_input").val(teacher.email);
    $("#teacher_profile_display_name_input").val(teacher.display_name);
    $("#teacher_profile_first_name_input").val(teacher.first_name);
    $("#teacher_profile_last_name_input").val(teacher.last_name);
    $("#teacher_profile_skype_name_input").val(teacher.skype_name);
    $("#teacher_profile_city_select").val(teacher.city.id);
    $("#teacher_profile_moto_input").val(teacher.moto);
    $("#teacher_profile_show_email").prop("checked", teacher.show_email);
    $("#teacher_profile_show_skype").prop("checked", teacher.show_skype);
    $("#teacher_profile_show_phone").prop("checked", teacher.show_phone);
    $("#teacher_profile_paypal_email_input").val(teacher.paypal_email);
    $("#teacher_profile_price_per_hour_input").val(teacher.price_per_hour);
    $("#teacher_profile_min_class_length").val(teacher.min_class_length);
    $("#teacher_profile_max_class_length").val(teacher.max_class_length);
    $("#teacher_profile_degree_type_select").val(teacher.degree_type);

    if (teacher.show_degree) {
        $('#teacher_profile_show_degree').prop("checked", true);
        $('#teacher_profile_degree_information_div').collapse("show");
    }

    teacher_profile.institute_id = 0;
    teacher_profile.institute_type = 0;
    if (teacher.institute !== undefined) {
        teacher_profile.institute_id = teacher.institute.id;
        teacher_profile.institute_type = teacher.institute.institute_type.id;
        $("#teacher_profile_institute_type_select").val(teacher_profile.institute_type);
        teacher_profile_institute_type_updated();
        teacher_profile_institute_updated();
    }
    if (teacher.institute_name !== undefined) {
        $("#teacher_profile_institute_type_select").val(teacher_profile.institute_type);
        $("#teacher_profile_institute_0_text").val(teacher.institute_name);
        teacher_profile_institute_type_updated();
    }

    teacher_profile.subject_id = 0;
    if (teacher.subject !== undefined) {
        teacher_profile.subject_id = teacher.subject.id;
        $("#teacher_profile_subject_select").val(teacher.subject.id);
    }
    if (teacher.subject_name !== undefined) {
        $("#teacher_profile_subject_0_text").val(teacher.subject_name);
        $("#teacher_profile_subject_select").val(0);
        teacher_profile_subject_selected();
    }

    if (teacher.gender === parseInt10($("#teacher_profile_gender_input_male").val())) {
        $("#teacher_profile_gender_input_male").prop("checked", true);
    }
    if (teacher.gender === parseInt10($("#teacher_profile_gender_input_female").val())) {
        $("#teacher_profile_gender_input_female").prop("checked", true);
    }
    $("#teacher_profile_phone_number_input").val(teacher.phone_number);
    $("#teacher_profile_phone_area_select").val(teacher.phone_area);

    console.log(teacher_profile.teaching_topics);

    for (var i = 0; i < teacher_profile.teaching_topics.length; i++) {
        var topic_id = teacher_profile.teaching_topics[i].id;
        $("button[data-topic-id=" + topic_id + "]").each(teacher_profile_choose_topic);
    }

    teacher_profile.day_of_birth = new Date(Date.parse(teacher.day_of_birth));
    teacher_profile.image_url = teacher.image_url;

    teacher_profile.calendar = {};
    teacher_profile.calendar.minutes_unit = parseInt10(oc.cconfig[ "website.time.unit.minutes"]);
    teacher_profile.calendar.day_names_long = oc.clabels[ "website.days.long" ].split(",");
    teacher_profile.calendar.last_select = null;
    teacher_profile.calendar.available_times = [];
    teacher_profile.min_teacher_age = parseInt10(oc.cconfig[ "teacher_profile.min_teacher_age"]);
    teacher_profile.max_teacher_age = parseInt10(oc.cconfig[ "teacher_profile.max_teacher_age"]);

    $("#teacher_profile_day_of_birth_input").datepicker({
        dayNames: teacher_profile.calendar.day_names_long,
        dayNamesMin: oc.clabels[ "website.days.short" ].split(","),
        monthNames: oc.clabels[ "website.months.long" ].split(","),
        monthNamesShort: oc.clabels[ "website.months.short" ].split(","),
        isRTL: true,
        changeYear: true,
        dateFormat: "dd/mm/yy",
        yearRange: "-"+ teacher_profile.max_teacher_age + ":-" + teacher_profile.min_teacher_age,
        onSelect: teacher_profile_select_day_of_birth
    });
    $("#teacher_profile_day_of_birth_input").datepicker("setDate", teacher_profile.day_of_birth);
    $("#teacher_profile_calendar_table td").disableSelection();

    teacher_profile_init_calendar();

    $("select.teacher_profile_institute_select").on("change", teacher_profile_select_institute);
    $("#teacher_profile_institute_type_select").on("change", teacher_profile_select_institute_type);
    $("#teacher_profile_subject_select").on("change", teacher_profile_select_subject);
    $("#teacher_profile_topic_list button.list-group-item").on("click", teacher_profile_choose_topic);
    $("#teacher_profile_image_id").val(makeRandomString(16));
    $("#teacher_profile_show_degree").click(
            function (e)
            {
                $("#teacher_profile_degree_information_div").collapse("toggle");
            });
    common_number_only_input($("#teacher_profile_phone_number"));
    common_number_only_input($("#teacher_profile_price_per_hour"));
    $("#teacher_profile_personal_information_link").on("shown.bs.tab",
            function (event)
            {
                $("#teacher_profile_phone_number_input").focus();
            });
    $("#teacher_profile_profile_link").on("shown.bs.tab",
            function (event)
            {
                $("#teacher_profile_moto_input").focus();
            });
    $("#teacher_profile_education_link").on("shown.bs.tab",
            function (event)
            {
                $("#teacher_profile_show_degree").focus();
            });
    $("#teacher_profile_prices_link").on("shown.bs.tab",
            function (event)
            {
                $("#teacher_profile_price_per_hour_input").focus();
            });
    $("#teacher_profile_calendar_table td").disableSelection();
    $("select.teacher_profile_institute_select").on("change", teacher_profile_select_institute);
    $("#teacher_profile_institute_type_select").on("change", teacher_profile_select_institute_type);
    $("#teacher_profile_subject_select").on("change", teacher_profile_select_subject);
    $("td.teacher_profile_calendar_time").on("click", teacher_profile_select_time);
    $("input.teacher_profile_required").on("change", teacher_profile_check_tabs);
    $("select.teacher_profile_required").on("change", teacher_profile_check_tabs);
    $("textarea.teacher_profile_required").on("change", teacher_profile_check_tabs);
    teacher_profile.min_teacher_age = parseInt10(oc.cconfig[ "teacher_profile.min_teacher_age"]);
    teacher_profile.max_teacher_age = parseInt10(oc.cconfig[ "teacher_profile.max_teacher_age"]);
    teacher_profile.min_phone_digits = parseInt10(oc.cconfig[ "website.phone.min_digits"]);
    teacher_profile.max_phone_digits = parseInt10(oc.cconfig[ "website.phone.max_digits"]);
    teacher_profile.min_moto_length = parseInt10(oc.cconfig[ "website.min_moto_length"]);
    teacher_profile.min_price_per_hour = parseInt10(oc.cconfig[ "website.price_per_hour.min"]);
    teacher_profile.max_price_per_hour = parseInt10(oc.cconfig[ "website.price_per_hour.max"]);
    teacher_profile_goto_tab("personal_information");
}

$(document).ready(teacher_profile_init);
