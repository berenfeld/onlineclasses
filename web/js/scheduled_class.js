/* global online_classes */

scheduled_class = {};

function scheduled_class_init()
{    
    var today = new Date();
    var start_date = new Date(Date.parse(scheduled_class.scheduled_class.start_date));
    var remainingMs = start_date.getTime() - today.getTime();
    $("#scheduled_class_main_board_starting_in_value").text(parseRemainingMs(remainingMs));
}


