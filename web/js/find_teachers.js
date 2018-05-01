/* global online_classes */

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

function find_teachers_refresh_results()
{
    find_teachers.available_day = $("#find_teachers_available_in_days").val();
    find_teachers.display_name = $("#find_teachers_display_name_input").val();
    location.search = "price_min=" + find_teachers.price_min.toString() +
            "&price_max=" + find_teachers.price_max.toString() +
            "&display_name=" + encodeURIComponent(find_teachers.display_name) +
            "&available_day=" + parseInt10(find_teachers.available_day);
}

function schedule_class_button_clicked(source)
{
    if (!login_isLoggedIn())
    {
        if (online_classes.cconfig["schedule_class.allow_schedule_if_not_logged_in"] === "false") {
            $("#schedule_class_not_logged_in_modal").modal("show");
            return;
        }
    }
    var teacher_button = $("#" + event.target.id);
    var teacher_id = parseInt10(teacher_button.attr("data-teacher-id"));
    var request = {};
    request.teacher_id = teacher_id;
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
    var start_working_hour = parseInt10(online_classes.cconfig[ "website.time.start_working_hour"]);
    var end_working_hour = parseInt10(online_classes.cconfig[ "website.time.end_working_hour"]);

    var first_day = new Date(date.getTime());
    while (first_day.getDay() !== 0) {
        substractDay(first_day);
    }
    find_teachers.calendar.first_date = first_day;

    var weekDay = new Date(find_teachers.calendar.first_date.getTime());
    $("#schedule_class_calendar_table td").removeClass("calendar_today");
    $("#schedule_class_calendar_table td").removeClass("calendar_available");
    for (var day = 1; day <= 7; day++) {
        var element = $("#schedule_class_day_" + day);
        element.html(parseDate(weekDay));
        for (var hour = start_working_hour; hour <= end_working_hour; hour++) {
            var element = $("#schedule_class_day_" + day + "_hour_" + hour);            
            if (sameDay(weekDay, today)) {
                element.addClass("calendar_today");
            }
        }
        addDay(weekDay);
    }
    
    find_teachers.calendar.last_date = new Date(find_teachers.calendar.first_date.getTime());
    addDays(find_teachers.calendar.last_date, 7);

    $("#schedule_class_current_week_start").html(parseDateLong(find_teachers.calendar.first_date))
    $("#schedule_class_current_week_end").html(parseDateLong(find_teachers.calendar.last_date))

    for (var i = 0; i < find_teachers.available_times.length; i++)
    {
        var available_time = find_teachers.available_times[i];
        var hour = available_time.start_hour;

        while (hour <= available_time.end_hour) {
            var element = $("#schedule_class_day_" + available_time.day + "_hour_" + hour);
            element.addClass("calendar_available");
            hour++;
        }
    }
}
function schedule_class_received_teacher_calendar(response)
{
    find_teachers.teacher = response.teacher;
    find_teachers.available_times = response.available_times;
    var today = new Date();
    schedule_class_goto_date(today);

    $("#schedule_class_modal").modal("show");
    $("#schedule_class_modal_title_teacher_anchor").text(find_teachers.teacher.display_name);
}

function schedule_class_login()
{
    $("#schedule_class_not_logged_in_modal").modal("hide");
    login_showLoginModal("login_modal");
}

function schedule_class_update_calendar()
{
    var start_hour = parseInt10($("#schedule_class_start_hour").text(), -1);
    var start_minute = parseInt10($("#schedule_class_start_minute").text(), -1);
    var duration = parseInt10($("#schedule_class_duration_input").text(), -1);
    if ((start_hour === -1) || (start_minute === -1) || (duration === -1))
    {
        // TODO clear selected date
        return;
    }
    if (find_teachers.calendar.selected_day === null )
    {
        return;
    }
    
    var day = find_teachers.calendar.selected_day.getDay() + 1;
    var element = $("#schedule_class_day_" + day + "_hour_" + start_hour);   
    element.addClass("calendar_selected");
}

function schedule_class_select_minute(minute)
{
    $("#schedule_class_start_minute").text(minute);
    schedule_class_update_calendar();
}

function schedule_class_select_hour(hour)
{
    $("#schedule_class_start_hour").text(hour);
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

function find_teachers_init()
{
    find_teachers.calendar = {};
    find_teachers.calendar.selected_day = null;
    
    var min_value = parseInt(online_classes.cconfig[ "find_teachers.price.min" ]);
    var max_value = parseInt(online_classes.cconfig[ "find_teachers.price.max" ]);

    find_teachers.price_min = parseInt10(online_classes.parameters[ "price_min" ], min_value);
    find_teachers.price_max = parseInt10(online_classes.parameters[ "price_max" ], max_value);
    find_teachers.available_day = parseInt10(online_classes.parameters[ "available_day" ], 0);
    find_teachers.display_name = $("#find_teachers_display_name_input").val();

    $("#find_teachers_price_per_hour_slider").slider(
            {
                range: true,
                min: min_value,
                max: max_value,
                values: [find_teachers.price_min, find_teachers.price_max],
                slide: find_teachers_price_per_hour_changed,
                step: 10
            }
    );
    $("#find_teachers_price_per_hour_value_min").text(min_value);
    $("#find_teachers_price_per_hour_value_max").text(max_value);

    $("#start_schedule_class_day_input").datepicker({
        dayNames: online_classes.clabels[ "website.days.long" ].split(","),
        dayNamesMin: online_classes.clabels[ "website.days.short" ].split(","),
        monthNames: online_classes.clabels[ "website.months.long" ].split(","),
        monthNamesShort: online_classes.clabels[ "website.months.short" ].split(","),
        isRTL: true,
        changeYear: true,
        onSelect: schedule_class_select_date
    });

}

find_teachers_init();

