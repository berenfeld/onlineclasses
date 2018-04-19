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
    var teacher_button = $("#" + event.target.id);
    var teacher_id = teacher_button.attr("data-teacher-id");
    var teacher_display_name = teacher_button.attr("data-teacher-display-name");
    $("#schedule_class_modal").modal("show");
    $("#schedule_class_modal_title_teacher_anchor").text(teacher_display_name);


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
        "isRTL": true
    });
    $("#schedule_class_start_hour").selectmenu({
        open: function(event, ui) {
            $('.ui-selectmenu-menu').css({'z-index':'9999', 'overflow':'auto'});
            //$(".ui-selectmenu-button").hide();
        }
    });

    $("#schedule_class_end_hour").selectmenu({
        open: function (event, ui) {
            $('.ui-selectmenu-menu').css({'z-index': '9999', 'overflow': 'auto'});
            //$(".ui-selectmenu-icon").hide();
        }
    }
    );
}

find_teachers_init();

