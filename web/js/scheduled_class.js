/* global online_classes */

scheduled_class = {};

function schedule_class_add_comment()
{
    text_input_modal_show(online_classes.clabels[ "scheduled.class.comments.modal.title"],
            online_classes.clabels[ "scheduled.class.comments.modal.text"],
            scheduled_class_add_comment_ok);
}

function scheduled_class_add_comment_ok(comment)
{
    var request = {};
    request.scheduled_class_id = scheduled_class.scheduled_class.id;
    request.comment = comment;
    $.ajax("servlets/add_class_comment",
            {
                type: "POST",
                data: JSON.stringify(request),
                dataType: "JSON",
                success: scheduled_class_add_comment_response
            });
}

function scheduled_class_add_comment_response(response)
{
    
}
function scheduled_class_pay()
{
    $("#schedule_class_payment_modal").modal("show");
}
function scheduled_class_init()
{    
    var today = new Date();
    var start_date = new Date(Date.parse(scheduled_class.scheduled_class.start_date));
    var remainingMs = start_date.getTime() - today.getTime();
    $("#scheduled_class_main_board_starting_in_value").text(parseRemainingMs(remainingMs));
}


