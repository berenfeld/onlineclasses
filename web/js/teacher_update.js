/* global oc */

var teacher_update = {};

function teacher_update_userLoggedInCallback(user)
{
    alert_show(oc.clabels["teacher_update.login_successful"]);

    $("#teacher_update_email_input").val(user.email);
    $("#teacher_update_display_name_input").val(user.name);
    $("#teacher_update_first_name_input").val(user.first_name);
    $("#teacher_update_last_name_input").val(user.last_name);

    $("#teacher_update_display_name_input").attr("disabled", false);
    $("#teacher_update_first_name_input").attr("disabled", false);
    $("#teacher_update_last_name_input").attr("disabled", false);
}

function teacher_update_select_degree_type(degree_type)
{
    $("#teacher_update_degree_type_button").html(degree_type);
    teacher_update.degree_type = degree_type;
}

function teacher_update_select_topic(topic_id)
{
    var checked = $("#teacher_update_topic_" + topic_id + "_checkbox").prop("checked");
    $("#teacher_update_topic_" + topic_id + "_checkbox").prop("checked", !checked);
}

function teacher_update_request_complete(response)
{
    if (response.rc !== 0) {
        alert_show(oc.clabels[ "teacher_update.register.failed.title"],
                oc.clabels[ "teacher_update.register.failed.message"] + ":" + response.message);
        return;
    }
    alert_show(oc.clabels[ "teacher_update.register.success.title"],
            oc.clabels[ "teacher_update.register.success.message"]);
}

function teacher_update_submit_warning(text)
{
    $("#teacher_update_warning_text").html(text);
    $("#teacher_update_warning_div").removeClass("d-none");
}

function teacher_update_scroll_to(element)
{
    $('html, body').scrollTop($("#" + element).offset().top);
}

function teacher_update_form_validation(request)
{
    $("#teacher_update_form *").removeClass("border border-warning");

    if (stringEmpty(request.moto)) {
        alert_show(oc.clabels[ "teacher_update.form.submit.fill_moto"]);
        $("#teacher_update_moto").addClass("border border-warning");
        teacher_update_scroll_to("teacher_update_moto");
        return false;
    }

    if (request.price_per_hour === 0) {
        alert_show(oc.clabels[ "teacher_update.form.submit.fill_price_per_hour"]);
        $("#teacher_update_price_per_hour").addClass("border border-warning");
        teacher_update_scroll_to("teacher_update_price_per_hour");
        return false;
    }

    return true;
}

function teacher_update_form_submit()
{
    var request = {};
    request.first_name = $("#teacher_update_first_name_input").val();
    request.last_name = $("#teacher_update_last_name_input").val();
    request.display_name = $("#teacher_update_display_name_input").val();
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
    request.degree_type = teacher_update.degree_type;
    request.price_per_hour = parseInt10($("#teacher_update_price_per_hour_input").val());
    request.teaching_topics = [];
    request.available_times = teacher_update.calendar.available_times;

    if (!teacher_update_form_validation(request)) {
        return;
    }

    $("#teacher_update_topics_card input[type='checkbox']").each(
            function (index, elem) {
                if (elem.checked) {
                    request.teaching_topics.push(parseInt10($("#" + elem.id).attr("data-topic-id")));
                }
            }
    );

    alert_show(oc.clabels[ "teacher_update.update.updating.title"],
            oc.clabels[ "teacher_update.update.updating.message"]);

    $.ajax("servlets/update_teacher",
            {
                type: "POST",
                data: JSON.stringify(request),
                dataType: "JSON",
                success: teacher_update_request_complete
            }
    );
}

function teacher_update_select_day_of_birth(dateText)
{
    teacher_update.day_of_birth = new Date(Date.parse(dateText));
}

function teacher_update_select_area_code(phone_area)
{
    teacher_update.phone_area = phone_area;
    $("#teacher_update_area_code_value").html(phone_area);
}

function teacher_update_select_institute_type(institute_type, institute_id)
{
    teacher_update.institute_type = institute_type;

    for (var i = 0; i <= oc.institute_type.length; i++)
    {
        $("#teacher_update_institute_" + i + "_label").addClass("d-none");
        $("#teacher_update_institute_" + i + "_div").addClass("d-none");
    }

    teacher_update.institute_id = 0;

    if (institute_type === 0) {
        $("#teacher_update_institute_type_button").html($("#teacher_update_institute_type_other").html());
        $("#teacher_update_institute_0_label").removeClass("d-none");
        $("#teacher_update_institute_0_div").removeClass("d-none");
    } else {
        $("#teacher_update_institute_type_button").html(oc.institute_type[institute_type - 1].name);
        $("#teacher_update_institute_" + institute_type + "_label").removeClass("d-none");
        $("#teacher_update_institute_" + institute_type + "_div").removeClass("d-none");
        if (institute_id !== 0) {
            teacher_update.institute_id = institute_id;
            $("#teacher_update_institute_" + institute_type + "_select").html(oc.institutes[institute_type][institute_id]);
        }
    }
}

function teacher_update_select_subject(subject_id)
{
    teacher_update.subject_id = subject_id;

    if (subject_id === 0) {
        teacher_update.subject_id = 0;
        $("#teacher_update_subject_0_div").removeClass("d-none");
        $("#teacher_update_subject_0_label").removeClass("d-none");
    } else {
        $("#teacher_update_subject_0_div").addClass("d-none");
        $("#teacher_update_subject_0_label").addClass("d-none");
        $("#teacher_update_subject_button").html(oc.subjects[subject_id - 1].name);
        teacher_update.subject_id = subject_id;
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

function teacher_update_select_time()
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
    teacher_update.calendar.available_times = teacher_update.available_time;

    var available_text = "";

    for (var i = 0; i < teacher_update.available_time.length; i++) {
        var available_time = teacher_update.available_time[ i ];
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

function teacher_update_init()
{
    teacher_update.day_of_birth = null;

    teacher_update.calendar = {};
    teacher_update.calendar.minutes_unit = parseInt10(oc.cconfig[ "website.time.unit.minutes"]);
    teacher_update.calendar.day_names_long = oc.clabels[ "website.days.long" ].split(",");
    teacher_update.calendar.last_select = null;
    teacher_update.calendar.available_times = [];
    teacher_update.min_teacher_age = parseInt10(oc.cconfig[ "teacher_update.min_teacher_age"]);
    teacher_update.max_teacher_age = parseInt10(oc.cconfig[ "teacher_update.max_teacher_age"]);

    var current_year = new Date().getFullYear();
    var default_year = new Date();
    default_year.setFullYear(current_year - teacher_update.min_teacher_age);

    $("#teacher_update_day_of_birth_input").datepicker({
        dayNames: teacher_update.calendar.day_names_long,
        dayNamesMin: oc.clabels[ "website.days.short" ].split(","),
        monthNames: oc.clabels[ "website.months.long" ].split(","),
        monthNamesShort: oc.clabels[ "website.months.short" ].split(","),
        isRTL: true,
        changeYear: true,
        defaultDate: teacher_update.teacher.day_of_birth,
        yearRange: (current_year - teacher_update.max_teacher_age) + ":" + (current_year - teacher_update.min_teacher_age),
        onSelect: teacher_update_select_day_of_birth
    });

    $('#teacher_update_topic_show_degree').on('click', function (e) {
        event.preventDefault();
    });
    $('#teacher_update_degree_information_div').on('hide.bs.collapse', function ()
    {
        $('#teacher_update_topic_show_degree').prop("checked", false);
    });
    $('#teacher_update_degree_information_div').on('show.bs.collapse', function ()
    {
        $('#teacher_update_topic_show_degree').prop("checked", true);
    });
    if (teacher_update.teacher.show_degree) {
        $('#teacher_update_topic_show_degree').prop("checked", true);
        $('#teacher_update_degree_information_div').collapse("show");
    }
    $("#teacher_update_calendar_table td").disableSelection();

    teacher_update_init_calendar();
    if (teacher_update.teacher.institute !== undefined) {
        teacher_update_select_institute_type(teacher_update.teacher.institute.institute_type.id);
    }
}

$(document).ready( teacher_update_init );
