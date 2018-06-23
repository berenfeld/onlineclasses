/* global oc */

find_teachers = {};

function find_teachers_price_per_hour_changed(event, ui)
{
    var value = ui.value;
    if (ui.handleIndex === 0)
    {
        $("#find_teachers_price_per_hour_value_min").text(value);
        find_teachers.price_min = value;
    } else {
        $("#find_teachers_price_per_hour_value_max").text(value);
        find_teachers.price_max = value;
    }
}

function find_teachers_clear_display_name()
{
    $("#find_teachers_display_name_input").val("");
    find_teachers_refresh_results();
}

function find_teachers_clear_price()
{
    find_teachers.price_min = find_teachers.default_min_value;
    find_teachers.price_max = find_teachers.default_max_value;
    find_teachers_refresh_results();
}

function find_teachers_clear_topic_name()
{
    $("#find_teachers_topic_name_input").val("");
    find_teachers_refresh_results();
}

function find_teachers_refresh_results()
{
    find_teachers.available_day = parseInt10($("#find_teachers_available_in_days").val());
    find_teachers.display_name = $("#find_teachers_display_name_input").val();
    find_teachers.topic_name = $("#find_teachers_topic_name_input").val();

    var search_string = "";
    if (find_teachers.price_min !== find_teachers.default_min_value) {
        search_string = appendToSearchString(search_string, "price_min=" + find_teachers.price_min);
    }
    if (find_teachers.price_max !== find_teachers.default_max_value) {
        search_string = appendToSearchString(search_string, "price_max=" + find_teachers.price_max);
    }
    if (stringNotEmpty(find_teachers.display_name)) {
        search_string = appendToSearchString(search_string, "display_name=" + encodeURIComponent(find_teachers.display_name));
    }
    if (stringNotEmpty(find_teachers.topic_name)) {
        search_string = appendToSearchString(search_string, "topic_name=" + encodeURIComponent(find_teachers.topic_name));
    }
    if (find_teachers.available_day !== 0) {
        search_string = appendToSearchString(search_string, "available_day=" + find_teachers.available_day);
    }

    location.search = search_string;
}

function schedule_class_button_clicked(source)
{
    if (!login_isLoggedIn())
    {
        if (oc.cconfig["schedule_class.allow_schedule_if_not_logged_in"] === "false") {
            alert_show(oc.clabels["schedule_class.failed_to_schedule_class_alert.title"],
                    oc.clabels["schedule_class.failed_to_schedule_class_alert.not_logged_in"]);
            return;
        }
    }

    if (login_isTeacher()) {
        alert_show(oc.clabels["schedule_class.failed_to_schedule_class_alert.title"],
                oc.clabels["schedule_class.failed_to_schedule_class_alert.teacher_cant_schedule_class"]);
        return;
    }

    var teacher_button = $("#" + event.target.id);
    find_teachers.teacher_id = parseInt10(teacher_button.attr("data-teacher-id"));
    var request = {};
    request.teacher_id = find_teachers.teacher_id;
    $.ajax("servlets/teacher_calendar",
            {
                type: "POST",
                data: JSON.stringify(request),
                dataType: "JSON",
                success: schedule_class_received_teacher_calendar
            });
}

function schedule_class_previous_week()
{
    var date = find_teachers.calendar.first_date;
    addDays(date, -7);
    schedule_class_goto_date(date);
}

function schedule_class_next_week()
{
    var date = find_teachers.calendar.first_date;
    addDays(date, 7);
    schedule_class_goto_date(date);
}

function schedule_class_goto_date(date)
{
    var today = new Date();
    var start_working_hour = parseInt10(oc.cconfig[ "website.time.start_working_hour"]);
    var end_working_hour = parseInt10(oc.cconfig[ "website.time.end_working_hour"]);

    var first_day = new Date(date.getTime());
    while (first_day.getDay() !== 0) {
        substractDay(first_day);
    }
    find_teachers.calendar.first_date = first_day;

    var weekDay = new Date(find_teachers.calendar.first_date.getTime());
    $("#schedule_class_calendar_table td").removeClass("calendar_today");
    $("#schedule_class_calendar_table td").removeClass("calendar_available");
    $("#schedule_class_calendar_table td").removeClass("calendar_busy");

    for (var day = 1; day <= 7; day++) {
        var element = $("#schedule_class_day_" + day);
        element.html(parseDate(weekDay));
        var minute = 0;
        var hour = start_working_hour;
        while (hour < end_working_hour) {
            var element = $("#schedule_class_day_" + day + "_hour_" + hour + "_minute_" + minute);
            minute += find_teachers.calendar.minutes_unit;
            if (minute === 60) {
                minute = 0;
                hour++;
            }
            if (sameDay(weekDay, today)) {
                element.addClass("calendar_today");
            }
        }
        addDay(weekDay);
    }

    find_teachers.calendar.last_date = new Date(find_teachers.calendar.first_date.getTime());
    find_teachers.calendar.week_days = [];
    for (var i = 0; i < 7; i++)
    {
        find_teachers.calendar.week_days[i] = new Date(find_teachers.calendar.first_date.getTime());
        addDays(find_teachers.calendar.week_days[i], i);
    }
    addDays(find_teachers.calendar.last_date, 6);

    var first_day = find_teachers.calendar.first_date;
    var last_day = find_teachers.calendar.last_date;
    $("#schedule_class_current_week_start").html(parseDateLong(first_day));
    $("#schedule_class_current_week_end").html(parseDateLong(last_day));

    for (var i = 0; i < find_teachers.available_times.length; i++)
    {
        var available_time = find_teachers.available_times[i];
        var hour = available_time.start_hour;
        var minute = available_time.start_minute;

        while ((hour < available_time.end_hour) ||
                (((hour === available_time.end_hour) && (minute < available_time.end_minute)))) {
            var element = $("#schedule_class_day_" + available_time.day + "_hour_" + hour + "_minute_" + minute);
            element.addClass("calendar_available");
            minute += find_teachers.calendar.minutes_unit;
            if (minute === 60) {
                hour++;
                minute = 0;
            }
        }
    }

    for (var i = 0; i < find_teachers.oclasses.length; i++)
    {
        var oclass = find_teachers.oclasses[i];
        var start_date = new Date(Date.parse(oclass.start_date));
        var day = (start_date.getDay() + 1);

        if (!sameDay(find_teachers.calendar.week_days[day - 1], start_date)) {
            continue;
        }
        var end_date = new Date(Date.parse(oclass.start_date));
        addMinutes(end_date, oclass.duration_minutes);


        var start_hour = start_date.getHours();
        var start_minute = start_date.getMinutes();
        var end_hour = end_date.getHours();
        var end_minute = end_date.getMinutes();

        var hour = start_hour;
        var minute = start_minute;

        while ((hour < end_hour) ||
                (((hour === end_hour) && (minute < end_minute)))) {
            var element = $("#schedule_class_day_" + day + "_hour_" + hour + "_minute_" + minute);
            element.addClass("calendar_busy");
            minute += find_teachers.calendar.minutes_unit;
            if (minute === 60) {
                hour++;
                minute = 0;
            }
        }
    }
    schedule_class_update_calendar();
}
function schedule_class_received_teacher_calendar(response)
{
    find_teachers.teacher = response.teacher;
    find_teachers.available_times = response.available_times;
    find_teachers.oclasses = response.oclasses;
    var today = new Date();
    schedule_class_goto_date(today);

    $("#schedule_class_modal").modal("show");
    $("#schedule_class_modal_title_teacher_anchor").text(find_teachers.teacher.display_name);
}

function schedule_class_login()
{
    $("#schedule_class_not_logged_in_modal").modal("hide");
}

function schedule_class_update_calendar()
{
    $("#schedule_class_calendar_table td").removeClass("calendar_selected");

    var start_hour = parseInt10($("#schedule_class_start_hour").text(), -1);
    var start_minute = parseInt10($("#schedule_class_start_minute").text(), -1);
    var duration = parseInt10($("#schedule_class_duration_input").text(), -1);

    if ((start_hour === -1) || (start_minute === -1) || (duration === -1))
    {
        return;
    }
    if (find_teachers.calendar.selected_day === null)
    {
        return;
    }

    var day = find_teachers.calendar.selected_day.getDay() + 1;
    if (!sameDay(find_teachers.calendar.week_days[day - 1], find_teachers.calendar.selected_day)) {
        return;
    }

    var minute = start_minute;
    var hour = start_hour;
    var minutes = 0;
    while (minutes < duration) {
        var element = $("#schedule_class_day_" + day + "_hour_" + hour + "_minute_" + minute);
        element.addClass("calendar_selected");
        minute += find_teachers.calendar.minutes_unit;
        if (minute === 60) {
            ++hour;
            minute = 0;
        }
        minutes += find_teachers.calendar.minutes_unit;
    }

}

function schedule_class_select_minute(minute)
{
    $("#schedule_class_start_minute").text(padZeroes(minute, 2));
    schedule_class_update_calendar();
}

function schedule_class_select_hour(hour)
{
    $("#schedule_class_start_hour").text(padZeroes(hour, 2));
    schedule_class_update_calendar();
}

function schedule_class_select_duration(duration)
{
    $("#schedule_class_duration").text(duration);
    schedule_class_update_calendar();
}

function schedule_class_select_date(dateText, datePicker)
{
    find_teachers.calendar.selected_day = new Date(Date.parse(dateText));
    schedule_class_goto_date(find_teachers.calendar.selected_day);
    schedule_class_update_calendar();
}

function schedule_class_select_time(element)
{
    var elem = $("#" + element.id);
    var day = parseInt10(elem.attr("data-day"));
    var hour = parseInt10(elem.attr("data-hour"));
    var minute = parseInt10(elem.attr("data-minute"));

    find_teachers.calendar.selected_day = new Date(find_teachers.calendar.week_days[day].getTime());
    $("#start_schedule_class_day_input").datepicker('setDate', find_teachers.calendar.selected_day);
    $("#schedule_class_start_hour").text(padZeroes(hour, 2));
    $("#schedule_class_start_minute").text(padZeroes(minute, 2));

    schedule_class_update_calendar();
}

function schedule_class_confirm()
{
    $("#schedule_class_warning_a").addClass("d-none");
    $("#schedule_class_warning_a_not_logged_in").addClass("d-none");
    $("#schedule_class_warning_div").addClass("d-none");
    $("#schedule_class_info_div").addClass("d-none");

    if (!login_isLoggedIn())
    {
        $("#schedule_class_warning").html(oc.clabels[ "oclass.modal.not_logged_in"]);
        $("#schedule_class_warning_div").removeClass("d-none");
        $("#schedule_class_warning_a").attr("href", "start_learning");
        $("#schedule_class_warning_a").html(oc.clabels[ "oclass.modal.register_here"]);
        $("#schedule_class_warning_a").removeClass("d-none");
        $("#schedule_class_warning_a_not_logged_in").html(oc.clabels[ "oclass.modal.click_here_to_connect"]);
        $("#schedule_class_warning_a_not_logged_in").removeClass("d-none");
        return;
    }

    var start_hour = parseInt10($("#schedule_class_start_hour").text(), -1);
    var start_minute = parseInt10($("#schedule_class_start_minute").text(), -1);
    var duration = parseInt10($("#schedule_class_duration_input").text(), -1);

    if ((start_hour === -1) || (start_minute === -1) || (duration === -1))
    {
        $("#schedule_class_warning").html(oc.clabels[ "oclass.modal.please_choose_time"]);
        $("#schedule_class_warning_div").removeClass("d-none");
        return;
    }
    if (find_teachers.calendar.selected_day === null)
    {
        $("#schedule_class_warning").html(oc.clabels[ "oclass.modal.please_choose_day"]);
        $("#schedule_class_warning_div").removeClass("d-none");
        return;
    }

    var start_date = new Date(find_teachers.calendar.selected_day.getTime());
    start_date.setHours(start_hour);
    start_date.setMinutes(start_minute);

    // check if too late
    var earliestDateToScheduleClass = new Date();
    addHours(earliestDateToScheduleClass, parseInt10(oc.cconfig[ "website.time.min_time_before_schedule_class_start_hours" ]));
    if (earliestDateToScheduleClass.getTime() > start_date.getTime()) {
        $("#schedule_class_warning").html(oc.clabels[ "oclass.modal.too_late_for_class"]);
        $("#schedule_class_warning_div").removeClass("d-none");
        return;
    }

    // check if available
    var day = find_teachers.calendar.selected_day.getDay() + 1;
    var hour = start_hour;
    var minute = start_minute;
    var minutes = 0;

    while (minutes < duration) {
        var element = $("#schedule_class_day_" + day + "_hour_" + hour + "_minute_" + minute);
        if (!element.hasClass("calendar_available")) {
            $("#schedule_class_warning").html(oc.clabels[ "oclass.modal.teacher_not_available"]);
            $("#schedule_class_warning_div").removeClass("d-none");
            return;
        }
        minute += find_teachers.calendar.minutes_unit;
        minutes += find_teachers.calendar.minutes_unit;
        if (minute === 60) {
            minute = 0;
            hour++;
        }
    }

    // check subject
    var subject = $("#start_schedule_class_subject_input").val();
    if (!subject)
    {
        $("#schedule_class_warning").text(oc.clabels[ "oclass.modal.please_provide_title" ]);
        $("#schedule_class_warning_div").removeClass("d-none");
        return;
    }

    // check duration
    if (duration < find_teachers.teacher.min_class_length) {
        $("#schedule_class_warning").text(oc.clabels["schedule_class.failed_to_schedule_class_alert.duration_too_short"]);
        $("#schedule_class_warning_div").removeClass("d-none");
        return;
    }

    if (duration > find_teachers.teacher.min_class_length) {
        $("#schedule_class_warning").text(oc.clabels["schedule_class.failed_to_schedule_class_alert.duration_too_long"]);
        $("#schedule_class_warning_div").removeClass("d-none");
        return;
    }

    var request = {};
    request.teacher_id = find_teachers.teacher_id;
    request.start_date = start_date;
    request.duration_minutes = duration;
    request.subject = subject;
    request.student_comment = $("#start_schedule_class_student_comment_input").val();

    $("#schedule_class_info_div").removeClass("d-none");
    $("#schedule_class_info").text(oc.clabels["oclass.modal.schedule_class_request_sent"]);

    $.ajax("servlets/schedule_class",
            {
                type: "POST",
                data: JSON.stringify(request),
                dataType: "JSON",
                success: schedule_class_response
            });
}

function schedule_class_response(response)
{
    if (response.rc !== 0) {
        $("#schedule_class_info").text(oc.clabels["oclass.modal.schedule_class_response_error"]);
    } else {
        $("#schedule_class_info").text(oc.clabels["oclass.modal.schedule_class_response_ok"]);
        redirectAfter("/oclass?id=" + response.class_id, 3);
    }

}

function schedule_class_comments_focus()
{
    if (!find_teachers.calendar.comments_clicked) {
        $("#start_schedule_class_comments_input").text("");
        find_teachers.calendar.comments_clicked = true;
    }
}

function find_teachers_reset_results()
{
    location = remove_search_from_location();
}

function schedule_class_login_clicked()
{
    $("#schedule_class_modal").modal("hide");
}


function find_teachers_init()
{
    find_teachers.calendar = {};
    find_teachers.calendar.selected_day = null;
    find_teachers.calendar.minutes_unit = parseInt10(oc.cconfig[ "website.time.unit.minutes"]);
    find_teachers.calendar.comments_clicked = false;

    var duration = parseInt10(oc.cconfig[ "website.time.unit.default_class_duration"]);
    $("#schedule_class_duration").text(duration + " " + oc.clabels[ "language.minutes"]);

    schedule_class_update_calendar();

    find_teachers.default_min_value = parseInt(oc.cconfig[ "find_teachers.price.min" ]);
    find_teachers.default_max_value = parseInt(oc.cconfig[ "find_teachers.price.max" ]);

    find_teachers.price_min = parseInt10(oc.parameters[ "price_min" ], find_teachers.default_min_value);
    find_teachers.price_max = parseInt10(oc.parameters[ "price_max" ], find_teachers.default_max_value);
    find_teachers.available_day = parseInt10(oc.parameters[ "available_day" ], 0);
    find_teachers.display_name = $("#find_teachers_display_name_input").val();
    find_teachers.topic_name = $("#find_teachers_topic_name_input").val();

    $("#find_teachers_price_per_hour_slider").slider(
            {
                range: true,
                min: find_teachers.default_min_value,
                max: find_teachers.default_max_value,
                values: [find_teachers.price_min, find_teachers.price_max],
                slide: find_teachers_price_per_hour_changed,
                step: 10
            }
    );
    $("#find_teachers_price_per_hour_value_min").text(find_teachers.default_min_value);
    $("#find_teachers_price_per_hour_value_max").text(find_teachers.default_max_value);

    $("#start_schedule_class_day_input").datepicker({
        dayNames: oc.clabels[ "website.days.long" ].split(","),
        dayNamesMin: oc.clabels[ "website.days.short" ].split(","),
        monthNames: oc.clabels[ "website.months.long" ].split(","),
        monthNamesShort: oc.clabels[ "website.months.short" ].split(","),
        isRTL: true,
        changeYear: true,
        onSelect: schedule_class_select_date
    });

    find_teachers.all_topics_names = [];
    find_teachers.days_long = oc.clabels["website.days.long" ].split(",");

    for (var topic_id in find_teachers.all_topics) {
        var topic = find_teachers.all_topics[topic_id];
        find_teachers.all_topics_names.push(topic.name);
    }
    $("#find_teachers_topic_name_input").autocomplete({
        source: find_teachers.all_topics_names
    });
    $("#find_teachers_form input").keyup(
            function (event) {
                if (event.keyCode === 13) {
                    find_teachers_refresh_results();
                }
            });
}

$(document).ready(find_teachers_init);