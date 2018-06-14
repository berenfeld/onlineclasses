/* global online_classes */

var scheduled_class = {};

function schedule_class_add_comment()
{
    text_input_modal_hide_info();
    text_input_modal_show(oc.clabels[ "scheduled.class.comments.modal.title"],
            oc.clabels[ "scheduled.class.comments.modal.text"],
            scheduled_class_add_comment_ok);
}

function scheduled_class_add_comment_ok(comment)
{
    if (!stringNotEmpty(comment)) {
        text_input_modal_show_info(oc.clabels[ "scheduled.class.comments.modal.comment_empty" ]);
        return;
    }
    text_input_modal_show_info(oc.clabels[ "scheduled.class.comments.modal.adding_comment"]);
    var request = {};
    request.oclass_id = scheduled_class.scheduled_class.id;
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
        text_input_modal_show_info(oc.clabels[ "scheduled.class.comments.modal.comment_added"]);
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

function scheduled_class_update_chosen_file()
{
    filename = $("#scheduled_class_attach_file_input").val();
    filename = filename.replace(/.*[\/\\]/, '');
    $("#scheduled_class_attach_file_chosen_file_name").html(filename);
    scheduled_class.file_name = filename;
}

function scheduled_class_check_file_status_response(response)
{
    if (response.rc !== 0) {
        // TODO handle timeout
        setTimeout(scheduled_class_check_file_status, 1000);
        return;
    }
    $("#scheduled_class_attach_file_info_text").html(
            oc.clabels["scheduled.class.attach_file.uploaded"] +
            " " +
            response.uploaded +
            " " +
            oc.clabels["scheduled.class.attach_file.bytes_out_of"] +
            " " +
            response.file_size);
    if (response.uploaded === response.file_size) {
        $("#scheduled_class_attach_file_info_text").html( oc.clabels["scheduled.class.attach_file.file_upload_done"] );
        $("#scheduled_class_attach_file_submit_button").attr("disabled", false);
        reloadAfter(2);
        return;
    }
    setTimeout(scheduled_class_check_file_status, 1000);
}

function scheduled_class_check_file_status()
{
    var request = {};
    request.oclass_id = scheduled_class.scheduled_class.id;
    request.file_name = scheduled_class.file_name;

    $.ajax("servlets/query_file_upload_status",
            {
                type: "POST",
                data: JSON.stringify(request),
                dataType: "JSON",
                success: scheduled_class_check_file_status_response
            });
}
function scheduled_class_submit_file()
{
    if (scheduled_class.file_name === null) {
        $("#scheduled_class_attach_file_info_div").removeClass("d-none");
        $("#scheduled_class_attach_file_info_text").html(oc.clabels["scheduled.class.attach_file.please_choose_file"]);
        return;
    }
    $("#scheduled_class_attach_file_info_div").removeClass("d-none");
    $("#scheduled_class_attach_file_info_text").html(oc.clabels["scheduled.class.attach_file.uploading_file"]);
    $("#scheduled_class_attach_file_submit_button").attr("disabled", true);
    scheduled_class_check_file_status();
    return true;
}

function scheduled_class_cancel_class_response(response)
{
    if (response.rc !== 0) {
        text_input_modal_show_info(oc.clabels["scheduled.class.cancel_class.failed_to_cancel_class"]);
        return;
    }
    text_input_modal_show_info(oc.clabels["scheduled.class.cancel_class.class_canceled"]);
    redirectAfter("/", 2);
}

function scheduled_class_cancel_class_ok(comment)
{
    if (!stringNotEmpty(comment)) {
        text_input_modal_show_info(oc.clabels[ "scheduled.class.cancel_class.comment_empty" ]);
        return;
    }
    text_input_modal_show_info(oc.clabels[ "scheduled.class.cancel_class.canceling_class" ]);
    var request = {};
    request.oclass_id = scheduled_class.scheduled_class.id;
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
    text_input_modal_show(oc.clabels[ "scheduled.class.cancel_class.title"],
            oc.clabels[ "scheduled.class.cancel_class.text"],
            scheduled_class_cancel_class_ok);
}

function scheduled_class_init()
{
    scheduled_class.file_name = null;
    var today = new Date();
    var start_date = new Date(Date.parse(scheduled_class.scheduled_class.start_date));
    var remainingMs = start_date.getTime() - today.getTime();
    $("#scheduled_class_main_board_starting_in_value").text(parseRemainingMs(remainingMs));
}

$(document).ready( scheduled_class_init );