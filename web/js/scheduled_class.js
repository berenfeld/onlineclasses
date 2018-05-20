/* global online_classes */

scheduled_class = {};

function schedule_class_add_comment()
{
    text_input_modal_hide_info();
    text_input_modal_show(online_classes.clabels[ "scheduled.class.comments.modal.title"],
            online_classes.clabels[ "scheduled.class.comments.modal.text"],
            scheduled_class_add_comment_ok);
}

function scheduled_class_add_comment_ok(comment)
{
    if (!stringNotEmpty(comment)) {
        text_input_modal_show_info(online_classes.clabels[ "scheduled.class.comments.modal.comment_empty" ]);
        return;
    }
    text_input_modal_show_info(online_classes.clabels[ "scheduled.class.comments.modal.adding_comment"]);
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
    if (response.rc === 0) {
        text_input_modal_show_info(online_classes.clabels[ "scheduled.class.comments.modal.comment_added"]);
        reloadAfter(2);
    }
}
function scheduled_class_pay()
{
    $("#schedule_class_payment_modal").modal("show");
}
function schedule_class_attach_file()
{
    $("#scheduled_class_attach_file_modal").modal("show");
}

function scheduled_class_cancel_class_response(response)
{
    if (response.rc !== 0) {
        text_input_modal_show_info("failed to cancel class");
        return;
    }
    text_input_modal_show_info("class canceled. You are forwarded to the main page");
    redirectAfter("/", 2);
}

function scheduled_class_cancel_class_ok(comment)
{
    if (!stringNotEmpty(comment)) {
        text_input_modal_show_info(online_classes.clabels[ "scheduled.class.cancel_class.comment_empty" ]);
        return;
    }
    text_input_modal_show_info("calceling class request sent");
    var request = {};
    request.scheduled_class_id = scheduled_class.scheduled_class.id;
    request.comment = comment;
    $.ajax("servlets/cancel_class",
            {
                type: "POST",
                data: JSON.stringify(request),
                dataType: "JSON",
                success: scheduled_class_cancel_class_response
            });
}

function schedule_class_cancel_click()
{
    text_input_modal_show(online_classes.clabels[ "scheduled.class.cancel_class.title"],
            online_classes.clabels[ "scheduled.class.cancel_class.text"],
            scheduled_class_cancel_class_ok);
}
function scheduled_class_init()
{
    var today = new Date();
    var start_date = new Date(Date.parse(scheduled_class.scheduled_class.start_date));
    var remainingMs = start_date.getTime() - today.getTime();
    $("#scheduled_class_main_board_starting_in_value").text(parseRemainingMs(remainingMs));
}


