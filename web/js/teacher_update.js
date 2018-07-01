/* global oc */

var teacher_update = {};

function teacher_update_check_img_loaded()
{
    $("#teacher_update_image_loading").addClass("d-none");
    $("#teacher_update_image_img").removeClass("d-none");
    $("#teacher_update_image_img").attr("src", teacher_update.loading_image_url);
    if (teacher_update.social_image_url === teacher_update.loading_image_url) {
        $("#teacher_update_img_upload_reset_image").addClass("d-none");
    } else {
        $("#teacher_update_img_upload_reset_image").removeClass("d-none");
    }
    teacher_update.image_url = teacher_update.loading_image_url;
    $("#teacher_update_image_id").val(makeRandomString(16));
}

function teacher_update_check_img_url_fail()
{
    setTimeout(teacher_update_check_img_url, 1000);
}

function teacher_update_reset_img_upload()
{
    $("#teacher_update_image_loading").removeClass("d-none");
    $("#teacher_update_image_img").addClass("d-none");
    teacher_update.loading_image_url = teacher_update.social_image_url;
    teacher_update_check_img_url();
}

function teacher_update_check_img_url()
{
    $.ajax(
            {
                url: teacher_update.loading_image_url,
                success: teacher_update_check_img_loaded,
                error: teacher_update_check_img_url_fail
            }
    );
}

function teacher_update_img_upload()
{
    $("#teacher_update_image_upload_form").submit();
    $("#teacher_update_image_loading").removeClass("d-none");
    $("#teacher_update_image_img").addClass("d-none");
    teacher_update.loading_image_url = "/" + oc.cconfig["website.file.upload.root"] +
            "/" + oc.cconfig["website.file.upload.images_root"] + "/" + $("#teacher_update_image_id").val() + ".png";
    teacher_update_check_img_url();
}

function teacher_update_choose_topic()
{
    $(this).toggleClass("list-group-item-light");
    $(this).toggleClass("list-group-item-success");
    $(this).children("span.oi").toggleClass("d-none");
}

function teacher_update_register_complete(response)
{
    if (response.rc !== 0) {
        alert_show(oc.clabels[ "teacher_update.register.failed.title"],
                oc.clabels[ "teacher_update.register.failed.message"] + ":" + response.message);
        return;
    }
    alert_show(oc.clabels[ "teacher_update.register.success.title"],
            oc.clabels[ "teacher_update.register.success.message"]);
    redirectAfter("/", 5);
}


function teacher_update_form_validation(request)
{
    $("#teacher_update_form *").removeClass("border border-warning");

    if (!$("#teacher_update_accept_terms_checkbox").is(":checked")) {
        alert_show(oc.clabels[ "teacher_update.form.submit.terms_of_usage.please_accept"]);
        $("#teacher_update_accept_terms_checkbox_div").addClass("border border-warning");
        teacher_update_goto_tab("accept_and_finish");
        return false;
    }

    if (stringEmpty(request.phone_number) || stringEmpty(request.phone_area)) {
        alert_show(oc.clabels[ "teacher_update.form.submit.fill_in_phone"]);
        $("#teacher_update_phone_number").addClass("border border-warning");
        teacher_update_goto_tab("personal_information");
        return false;
    }

    if (!stringLengthBetween(request.phone_number, teacher_update.min_phone_digits, teacher_update.max_phone_digits)) {
        alert_show(oc.clabels[ "teacher_update.form.submit.fill_in_phone"]);
        $("#teacher_update_phone_number").addClass("border border-warning");
        teacher_update_goto_tab("personal_information");
        return false;
    }

    if (request.city_id === 0) {
        alert_show(oc.clabels[ "teacher_update.form.submit.fill_city"]);
        $("#teacher_update_city_select").addClass("border border-warning");
        teacher_update_goto_tab("personal_information");
        return false;
    }

    if (request.day_of_birth === null) {
        alert_show(oc.clabels[ "teacher_update.form.submit.fill_day_of_birth"]);
        $("#teacher_update_day_of_birth").addClass("border border-warning");
        teacher_update_goto_tab("personal_information");
        return false;
    }

    if (stringEmpty(request.moto)) {
        alert_show(oc.clabels[ "teacher_update.form.submit.fill_moto"]);
        $("#teacher_update_moto").addClass("border border-warning");
        teacher_update_goto_tab("profile");
        return false;
    }

    if (request.moto.length < teacher_update.min_moto_length) {
        alert_show(oc.clabels[ "teacher_update.form.submit.fill_moto"]);
        $("#teacher_update_moto").addClass("border border-warning");
        teacher_update_goto_tab("profile");
        return false;
    }

    if (stringEmpty(request.paypal_email)) {
        alert_show(oc.clabels[ "teacher_update.form.submit.fill_paypal_email"]);
        $("#teacher_update_paypal_email").addClass("border border-warning");
        teacher_update_goto_tab("prices");
        return false;
    }

    if (!emailIsValid(request.paypal_email)) {
        alert_show(oc.clabels[ "teacher_update.form.submit.illegal_paypal_email"]);
        $("#teacher_update_paypal_email").addClass("border border-warning");
        teacher_update_goto_tab("prices");
        return false;
    }

    if (request.price_per_hour === 0) {
        alert_show(oc.clabels[ "teacher_update.form.submit.fill_price_per_hour"]);
        $("#teacher_update_price_per_hour").addClass("border border-warning");
        teacher_update_goto_tab("prices");
        return false;
    }

    if (!numberBetween(request.price_per_hour, teacher_update.min_price_per_hour, teacher_update.max_price_per_hour)) {
        alert_show(oc.clabels[ "teacher_update.form.submit.invalid_price_per_hour"]);
        $("#teacher_update_price_per_hour").addClass("border border-warning");
        teacher_update_goto_tab("prices");
        return false;
    }

    return true;
}

function teacher_update_form_submit()
{
    var request = {};
    request.email = $("#teacher_update_email_input").val();
    request.first_name = $("#teacher_update_first_name_input").val();
    request.last_name = $("#teacher_update_last_name_input").val();    
    request.image_url = teacher_update.image_url;
    request.phone_number = $("#teacher_update_phone_number_input").val();
    request.phone_area = $("#teacher_update_phone_area_select").val();    
    request.skype_name = $("#teacher_update_skype_name_input").val();
    request.moto = $("#teacher_update_moto_input").val();
    request.show_phone = $("#teacher_update_show_phone").prop("checked");
    request.show_email = $("#teacher_update_show_email").prop("checked");
    request.show_skype = $("#teacher_update_show_skype").prop("checked");
    request.institute_id = teacher_update.institute_id;
    request.institute_name = $("#teacher_update_institute_other_text").val();
    request.subject_id = teacher_update.subject_id;
    request.subject_name = $("#teacher_update_subject_0_text").val();
    request.show_degree = $("#teacher_update_topic_show_degree").prop("checked");
    request.degree_type = $("#teacher_update_degree_type_select").val();
    request.price_per_hour = parseInt10($("#teacher_update_price_per_hour_input").val());
    request.paypal_email = $("#teacher_update_paypal_email_input").val();
    request.available_times = teacher_update.calendar.available_times;
    request.city_id = parseInt10($("#teacher_update_city_select").val());
    request.feedback = $("#teacher_update_feedback_input").val();
    request.min_class_length = parseInt10($("teacher_update_min_class_length").val());
    request.max_class_length = parseInt10($("teacher_update_max_class_length").val());
    request.teaching_topics = [];
    $("#teacher_update_topic_list button.list-group-item").each(
            function () {
                if (!$(this).hasClass("list-group-item-light")) {
                    request.teaching_topics.push(parseInt10($(this).attr("data-topic-id")));
                }
            }
    );

    console.log(request);
    if (!teacher_update_form_validation(request)) {
        return;
    }

    alert_show(oc.clabels[ "teacher_update.register.registering"],
            oc.clabels[ "teacher_update.register.registering_message"]);


    if ($("#teacher_update_gender_input_male").prop("checked")) {
        request.gender = parseInt10($("#teacher_update_gender_input_male").val());
    }
    if ($("#teacher_update_gender_input_female").prop("checked")) {
        request.gender = parseInt10($("#teacher_update_gender_input_female").val());
    }

    $.ajax("servlets/update_teacher",
            {
                type: "POST",
                data: JSON.stringify(request),
                dataType: "JSON",
                success: teacher_update_register_complete
            }
    );
}

function teacher_update_select_day_of_birth()
{
    teacher_update.day_of_birth = $("#teacher_update_day_of_birth_input").datepicker("getDate");
    teacher_update_check_tabs();
    $("#teacher_update_skype_name_input").focus();
}

function teacher_update_select_institute()
{
    teacher_update.institute_id = parseInt10($(this).val());
    if (teacher_update.institute_id === 0 )
    {
        teacher_update.institute_type = 0;
        teacher_update_institute_type_updated();
    }
}
 
function teacher_update_select_institute_type()
{
    teacher_update.institute_type = parseInt10($(this).val());
    teacher_update_institute_type_updated();
}

function teacher_update_institute_updated()
{
    $("#teacher_update_institute_" + teacher_update.institute_type + "_select").val(teacher_update.institute_id);
}

function teacher_update_institute_type_updated()
{
    for (var i = 0; i <= oc.institute_type.length; i++)
    {
        $("#teacher_update_institute_" + i + "_label").addClass("d-none");
        $("#teacher_update_institute_" + i + "_div").addClass("d-none");
    }

    if (teacher_update.institute_type === 0) {
        teacher_update.institute_id = 0;
        $("#teacher_update_institute_0_label").removeClass("d-none");
        $("#teacher_update_institute_0_div").removeClass("d-none");
    } else {
        $("#teacher_update_institute_" + teacher_update.institute_type + "_label").removeClass("d-none");
        $("#teacher_update_institute_" + teacher_update.institute_type + "_div").removeClass("d-none");
    }
}

function teacher_update_select_subject()
{
    teacher_update.subject_id = parseInt10($(this).val());
    teacher_update_subject_selected()
}

function teacher_update_subject_selected() 
{
    if (teacher_update.subject_id === 0) {
        $("#teacher_update_subject_0_div").removeClass("d-none");
        $("#teacher_update_subject_0_label").removeClass("d-none");
    } else {
        $("#teacher_update_subject_0_div").addClass("d-none");
        $("#teacher_update_subject_0_label").addClass("d-none");
    }
}

function teacher_update_select_single_time(day, hour, minute)
{
    teacher_update.calendar.last_select = {
        hour: hour,
        day: day,
        minute: minute
    };
    var hourElement = $("#teacher_update_day_" + day + "_hour_" + hour + "_minute_" + minute);
    if (hourElement.hasClass("calendar_selected")) {
        hourElement.removeClass("calendar_selected");
        teacher_update.calendar.last_select.add = false;
    } else {
        hourElement.addClass("calendar_selected");
        teacher_update.calendar.last_select.add = true;
    }
    teacher_update.calendar.last_element_selected = hourElement;
    teacher_update_update_calendar();
}

function teacher_update_select_time(event)
{
    event.preventDefault();
    event.stopPropagation();
    var elem = $("#" + event.target.id);
    var day = parseInt10(elem.attr("data-day"));
    var hour = parseInt10(elem.attr("data-hour"));
    var minute = parseInt10(elem.attr("data-minute"));
    if (!event.shiftKey) {
        teacher_update_select_single_time(day, hour, minute);
        return false;
    }
    if (teacher_update.calendar.last_select === null) {
        teacher_update_select_single_time(day, hour, minute);
        return false;
    }

    if (day !== teacher_update.calendar.last_select.day) {
        teacher_update_select_single_time(day, hour, minute);
        return false;
    }

    var start_hour = teacher_update.calendar.last_select.hour;
    var start_minute = teacher_update.calendar.last_select.minute;
    var increasing = (start_hour < hour) || ((start_hour === hour) && (start_minute < minute));
    do {
        var hourElement = $("#teacher_update_day_" + day + "_hour_" + start_hour + "_minute_" + start_minute);
        if (teacher_update.calendar.last_select.add) {
            hourElement.addClass("calendar_selected");
        } else {
            hourElement.removeClass("calendar_selected");
        }
        if ((start_hour === hour) && (start_minute === minute)) {
            break;
        }
        if (increasing) {
            start_minute += teacher_update.calendar.minutes_unit;
            if (start_minute === 60) {
                start_minute = 0;
                start_hour++;
            }
        } else {
            if (start_minute === 0) {
                start_minute = 60;
                start_hour--;
            }
            start_minute -= teacher_update.calendar.minutes_unit;
        }
    } while (true);
    teacher_update_update_calendar();
    return false;
}

function teacher_update_init_calendar()
{
    console.log(teacher_update.available_times);
    
    teacher_update.calendar.available_times = teacher_update.available_times;

    var available_text = "";

    for (var i = 0; i < teacher_update.available_times.length; i++) {
        var available_time = teacher_update.available_times[ i ];
        var day = available_time.day;
        var start_hour = available_time.start_hour;
        var end_hour = available_time.end_hour;
        var start_minute = available_time.start_minute;
        var end_minute = available_time.end_minute;

        available_text += teacher_update.calendar.day_names_long[day - 1] + " : " +
                formatTime(end_hour, end_minute) + " - " + formatTime(start_hour, start_minute) + "<br/>";
        do {
            if ((start_hour === end_hour) && (start_minute === end_minute)) {
                break;
            }
            var hourElement = $("#teacher_update_day_" + day + "_hour_" + start_hour + "_minute_" + start_minute);
            hourElement.addClass("calendar_selected");

            start_minute += teacher_update.calendar.minutes_unit;
            if (start_minute === 60) {
                start_minute = 0;
                start_hour++;
            }

        } while (true);
    }
    $("#teacher_update_selected_hours").html(available_text);
}

function teacher_update_update_calendar()
{
    var start_working_hour = parseInt10(oc.cconfig[ "website.time.start_working_hour"]);
    var end_working_hour = parseInt10(oc.cconfig[ "website.time.end_working_hour"]);
    var start_available_time = false;
    var available_day, start_hour, start_minute, end_hour, end_minute;
    var available_text = "";
    teacher_update.calendar.available_times = [];
    for (var day = 1; day <= 7; day++) {
        var hour = start_working_hour;
        var minute = 0;
        while (hour < end_working_hour) {
            var element = $("#teacher_update_day_" + day + "_hour_" + hour + "_minute_" + minute);
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
                    available_text += teacher_update.calendar.day_names_long[available_day - 1] + " : " +
                            formatTime(end_hour, end_minute) + " - " + formatTime(start_hour, start_minute) + "<br/>";
                    teacher_update.calendar.available_times.push(
                            {
                                day: available_day,
                                start_hour: start_hour,
                                end_hour: end_hour,
                                start_minute: start_minute,
                                end_minute: end_minute
                            });
                }
            }
            minute += teacher_update.calendar.minutes_unit;
            if (minute === 60) {
                minute = 0;
                hour++;
            }
        }
    }
    $("#teacher_update_selected_hours").html(available_text);
}

function teacher_update_clear_calendar()
{
    $("#teacher_update_calendar_table td").removeClass("calendar_selected");
    teacher_update_update_calendar();
}

function teacher_update_goto_tab(tab_name)
{
    $("#teacher_update_" + tab_name + "_link").tab('show');
}

function teacher_update_check_tabs()
{
    $("#teacher_update_tab_list a.nav-link").addClass("disabled");
    $("button.teacher_update_tabs_button").addClass("disabled");

    if (oc.cconfig["teacher_update.enable_all_tabs"] === "true") {
        $("#teacher_update_tab_list a.nav-link").removeClass("disabled");
        $("button.teacher_update_tabs_button").removeClass("disabled");
    }

    $("#teacher_update_personal_information_link").removeClass("disabled");
    $("#teacher_update_goto_tab_personal_information_button").removeClass("disabled");

    $("input.teacher_update_required").removeClass("teacher_update_required_filled");
    $("select.teacher_update_required").removeClass("teacher_update_required_filled");

    // if mandatory fields are present : display_name, phone, day of birth and city, can show profile tab
    var request = {};
    request.phone_number = $("#teacher_update_phone_number_input").val();
    request.phone_area = $("#teacher_update_phone_area_select").val();
    request.city_id = parseInt10($("#teacher_update_city_select").val());

    var pass_to_profile = true;

    if (stringEmpty(request.phone_number)) {
        pass_to_profile = false;
    } else {
        if (!stringLengthBetween(request.phone_number, teacher_update.min_phone_digits, teacher_update.max_phone_digits)) {
            pass_to_profile = false;
        } else {
            $("#teacher_update_phone_number_input").addClass("teacher_update_required_filled");
        }
    }

    if (stringEmpty(request.phone_area)) {
        pass_to_profile = false;
    } else {
        $("#teacher_update_phone_area_select").addClass("teacher_update_required_filled");
    }

    if (request.city_id === 0) {
        pass_to_profile = false;
    } else {
        $("#teacher_update_city_select").addClass("teacher_update_required_filled");
    }

    if (!pass_to_profile) {
        return;
    }
    $("#teacher_update_profile_link").removeClass("disabled");
    $("#teacher_update_goto_tab_profile_button").removeClass("disabled");

    // if moto is filled - can go to education
    // TODO moto minimum length
    request.moto = $("#teacher_update_moto_input").val();

    if (stringEmpty(request.moto)) {
        return;
    }
    if (request.moto.length < teacher_update.min_moto_length) {
        return;
    }
    $("#teacher_update_moto_input").addClass("teacher_update_required_filled");

    // can move to education
    $("#teacher_update_education_link").removeClass("disabled");
    $("#teacher_update_goto_tab_education_button").removeClass("disabled");

    // can move to teaching_topics
    $("#teacher_update_teaching_topics_link").removeClass("disabled");
    $("#teacher_update_goto_tab_teaching_topics_button").removeClass("disabled");

    // can move to prices
    $("#teacher_update_prices_link").removeClass("disabled");
    $("#teacher_update_goto_tab_prices_button").removeClass("disabled");

    var pass_to_teaching_hours = true;

    request.paypal_email = $("#teacher_update_paypal_email_input").val();
    if (!emailIsValid(request.paypal_email)) {
        pass_to_teaching_hours = false;
    } else {
        $("#teacher_update_paypal_email_input").addClass("teacher_update_required_filled");
    }

    request.price_per_hour = parseInt10($("#teacher_update_price_per_hour_input").val());
    if (request.price_per_hour === 0) {
        pass_to_teaching_hours = false;
    } else {
        if (!numberBetween(request.price_per_hour, teacher_update.min_price_per_hour, teacher_update.max_price_per_hour)) {
            pass_to_teaching_hours = false;
        } else {
            $("#teacher_update_price_per_hour_input").addClass("teacher_update_required_filled");
        }
    }

    if (!pass_to_teaching_hours) {
        return;
    }

    // can move to teaching_hours
    $("#teacher_update_teaching_hours_link").removeClass("disabled");
    $("#teacher_update_goto_tab_teaching_hours_button").removeClass("disabled");

    $("#teacher_update_accept_and_finish_link").removeClass("disabled");
    $("#teacher_update_goto_tab_accept_and_finish_button").removeClass("disabled");

    if (!$("#teacher_update_accept_terms_checkbox").is(":checked")) {
        return;
    }

    if (!teacher_update.read_terms_of_usage) {
        return;
    }
    // can enable submit button
    $("#teacher_update_form_submit_button").removeClass("disabled");
}

function teacher_update_terms_of_usage()
{
    window.open('terms_of_usage', 'terms_of_usage', 'width=1280,height=720');
    teacher_update.read_terms_of_usage = true;
    teacher_update_check_tabs();
}

function teacher_update_init()
{
    var teacher = teacher_update.teacher;
    console.log(teacher);

    $("#teacher_update_email_input").val(teacher.email);
    $("#teacher_update_display_name_input").val(teacher.display_name);
    $("#teacher_update_first_name_input").val(teacher.first_name);
    $("#teacher_update_last_name_input").val(teacher.last_name);
    $("#teacher_update_skype_name_input").val(teacher.skype_name);
    $("#teacher_update_city_select").val(teacher.city.id);
    $("#teacher_update_moto_input").val(teacher.moto);
    $("#teacher_update_show_email").prop("checked", teacher.show_email);
    $("#teacher_update_show_skype").prop("checked", teacher.show_skype);
    $("#teacher_update_show_phone").prop("checked", teacher.show_phone);
    $("#teacher_update_paypal_email_input").val(teacher.paypal_email);
    $("#teacher_update_price_per_hour_input").val(teacher.price_per_hour);

    if (teacher.show_degree) {
        $('#teacher_update_show_degree').prop("checked", true);
        $('#teacher_update_degree_information_div').collapse("show");
    }

    teacher_update.institute_id = 0;
    teacher_update.institute_type = 0;
    if (teacher.institute !== undefined) {
        teacher_update.institute_id = teacher.institute.id;
        teacher_update.institute_type = teacher.institute.institute_type.id;
        $("#teacher_update_institute_type_select").val(teacher_update.institute_type);
        teacher_update_institute_type_updated();
        teacher_update_institute_updated();
    }
    if (teacher.institute_name !== undefined) {
        $("#teacher_update_institute_type_select").val(teacher_update.institute_type);
        $("#teacher_update_institute_0_text").val(teacher.institute_name);
        teacher_update_institute_type_updated();
    }

    teacher_update.subject_id = 0;
    if (teacher.subject !== undefined) {
        teacher_update.subject_id = teacher.subject.id;
        $("#teacher_update_subject_select").val(teacher.subject.id);
    }
    if (teacher.subject_name !== undefined) {
        $("#teacher_update_subject_0_text").val(teacher.subject_name);
        $("#teacher_update_subject_select").val(0);
        teacher_update_subject_selected();
    }

    if (teacher.gender === parseInt10($("#teacher_update_gender_input_male").val())) {
        $("#teacher_update_gender_input_male").prop("checked", true);
    }
    if (teacher.gender === parseInt10($("#teacher_update_gender_input_female").val())) {
        $("#teacher_update_gender_input_female").prop("checked", true);
    }
    $("#teacher_update_phone_number_input").val(teacher.phone_number);
    $("#teacher_update_phone_area_select").val(teacher.phone_area);

    console.log(teacher_update.teaching_topics);

    for (var i = 0; i < teacher_update.teaching_topics.length; i++) {
        var topic_id = teacher_update.teaching_topics[i].id;
        $("button[data-topic-id=" + topic_id + "]").each(teacher_update_choose_topic);
    }

    teacher_update.day_of_birth = new Date(Date.parse(teacher.day_of_birth));
    teacher_update.iamge_url = teacher.image_url;

    teacher_update.calendar = {};
    teacher_update.calendar.minutes_unit = parseInt10(oc.cconfig[ "website.time.unit.minutes"]);
    teacher_update.calendar.day_names_long = oc.clabels[ "website.days.long" ].split(",");
    teacher_update.calendar.last_select = null;
    teacher_update.calendar.available_times = [];
    teacher_update.min_teacher_age = parseInt10(oc.cconfig[ "teacher_update.min_teacher_age"]);
    teacher_update.max_teacher_age = parseInt10(oc.cconfig[ "teacher_update.max_teacher_age"]);
    
    var current_year = new Date().getFullYear();

    $("#teacher_update_day_of_birth_input").datepicker({
        dayNames: teacher_update.calendar.day_names_long,
        dayNamesMin: oc.clabels[ "website.days.short" ].split(","),
        monthNames: oc.clabels[ "website.months.long" ].split(","),
        monthNamesShort: oc.clabels[ "website.months.short" ].split(","),
        isRTL: true,
        changeYear: true,
        dateFormat: "dd/mm/yy",
        yearRange: (current_year - teacher_update.max_teacher_age) + ":" + (current_year - teacher_update.min_teacher_age),
        onSelect: teacher_update_select_day_of_birth
    });
    $("#teacher_update_day_of_birth_input").datepicker("setDate", teacher_update.day_of_birth);
    $("#teacher_update_calendar_table td").disableSelection();

    teacher_update_init_calendar();

    $("select.teacher_update_institute_select").on("change", teacher_update_select_institute);
    $("#teacher_update_institute_type_select").on("change", teacher_update_select_institute_type);
    $("#teacher_update_subject_select").on("change", teacher_update_select_subject);
    $("#teacher_update_topic_list button.list-group-item").on("click", teacher_update_choose_topic);
    $("#teacher_update_image_id").val(makeRandomString(16));
    $("#teacher_update_show_degree").click(
            function (e)
            {
                $("#teacher_update_degree_information_div").collapse("toggle");
            });
    common_number_only_input($("#teacher_update_phone_number"));
    common_number_only_input($("#teacher_update_price_per_hour"));
    $("#teacher_update_personal_information_link").on("shown.bs.tab",
            function (event)
            {
                $("#teacher_update_phone_number_input").focus();
            });
    $("#teacher_update_profile_link").on("shown.bs.tab",
            function (event)
            {
                $("#teacher_update_moto_input").focus();
            });
    $("#teacher_update_education_link").on("shown.bs.tab",
            function (event)
            {
                $("#teacher_update_show_degree").focus();
            });
    $("#teacher_update_prices_link").on("shown.bs.tab",
            function (event)
            {
                $("#teacher_update_paypal_email_input").focus();
            });
    $("#teacher_update_calendar_table td").disableSelection();
    $("select.teacher_update_institute_select").on("change", teacher_update_select_institute);
    $("#teacher_update_institute_type_select").on("change", teacher_update_select_institute_type);
    $("#teacher_update_subject_select").on("change", teacher_update_select_subject);
    $("#teacher_update_topic_list button.list-group-item").on("click", teacher_update_choose_topic);
    $("td.teacher_update_calendar_time").on("click", teacher_update_select_time);
    $("input.teacher_update_required").on("change", teacher_update_check_tabs);
    $("select.teacher_update_required").on("change", teacher_update_check_tabs);
    $("textarea.teacher_update_required").on("change", teacher_update_check_tabs);
    teacher_update.min_teacher_age = parseInt10(oc.cconfig[ "teacher_update.min_teacher_age"]);
    teacher_update.max_teacher_age = parseInt10(oc.cconfig[ "teacher_update.max_teacher_age"]);
    teacher_update.min_phone_digits = parseInt10(oc.cconfig[ "website.phone.min_digits"]);
    teacher_update.max_phone_digits = parseInt10(oc.cconfig[ "website.phone.max_digits"]);
    teacher_update.min_moto_length = parseInt10(oc.cconfig[ "teacher_update.min_moto_length"]);
    teacher_update.min_price_per_hour = parseInt10(oc.cconfig[ "website.price_per_hour.min"]);
    teacher_update.max_price_per_hour = parseInt10(oc.cconfig[ "website.price_per_hour.max"]);        
    teacher_update_goto_tab("personal_information");
}

$(document).ready(teacher_update_init);
