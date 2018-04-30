/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

find_teachers = {};

function find_teachers_price_per_hour_changed(event, ui)
{
    var value = ui.value;
    if (ui.handleIndex == 0)
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
        if (online_classes.cconfig["schedule_class.allow_schedule_if_not_logged_in"] == "false") {
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
            })
}

function schedule_class_received_teacher_calendar(response)
{
    var teacher = response.teacher;
    var available_times = response.available_times;
    for (var i=0; i< available_times.length; i++)
    {
        var available_time = available_times[i];
        var hour = available_time.start_hour;
                
        while (hour <= available_time.end_hour) {
            var element = $("#day_" + available_time.day + "_hour_" + String(hour));
            element.addClass("calendar_available");
            element.removeClass("calendar_free");
            hour++;
        }
    }
    $("#schedule_class_modal").modal("show");
    $("#schedule_class_modal_title_teacher_anchor").text(teacher.display_name);
}

function schedule_class_login()
{
    $("#schedule_class_not_logged_in_modal").modal("hide");
    login_showLoginModal("login_modal");
}

function schedule_class_select_minute(minute)
{
    $("#schedule_class_start_minute").text(minute);
}

function schedule_class_select_hour(hour)
{
    $("#schedule_class_start_hour").text(hour);
}

function schedule_class_select_duration(duration)
{
    $("#schedule_class_duration_input").text(duration);
}
function find_teachers_init()
{
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

    $("#start_day_input").datepicker({
        "dayNames": online_classes.clabels[ "website.days.long" ].split(","),
        "dayNamesMin": online_classes.clabels[ "website.days.short" ].split(","),
        "monthNames": online_classes.clabels[ "website.months.long" ].split(","),
        "monthNamesShort": online_classes.clabels[ "website.months.short" ].split(","),
        "isRTL": true,
        "changeYear": true,
    });

}

find_teachers_init();

