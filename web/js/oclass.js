/* global oc */

var oclass = {};

function schedule_class_add_comment()
{
    text_input_modal_hide_info();
    text_input_modal_show(oc.clabels[ "oclass.comments.modal.title"],
            oc.clabels[ "oclass.comments.modal.text"],
            oclass_add_comment_ok);
}

function oclass_add_comment_ok(comment)
{
    if (!stringNotEmpty(comment)) {
        text_input_modal_show_info(oc.clabels[ "oclass.comments.modal.comment_empty" ]);
        return;
    }
    text_input_modal_show_info(oc.clabels[ "oclass.comments.modal.adding_comment"]);
    var request = {};
    request.oclass_id = oclass.oclass.id;
    request.comment = comment;
    ajax_request("add_class_comment", request, oclass_add_comment_response);
}

function oclass_add_comment_response(response)
{
    if (response.rc === 0) {
        text_input_modal_show_info(oc.clabels[ "oclass.comments.modal.comment_added"]);
        reloadAfter(2);
    }
}

function oclass_pay()
{
    show_modal("schedule_class_payment_modal");
}

function oclass_paid_show_details()
{
    var payment = oclass.oclass.payment;
    alert_show( oc.clabels["oclass.payment_details.payment_details" ], oc.clabels["oclass.payment_details.amount" ]  + " " + parseAmount(payment.amount) + " " +
                oc.clabels["oclass.payment_details.paid_by" ] + " " + payment.payer + " " +
                oc.clabels["oclass.payment_details.at" ] + " " + parseDateLong(new Date(payment.date)));
}

function schedule_class_attach_file()
{
    $("#oclass_attach_file_modal").modal("show");
}

function oclass_update_chosen_file()
{
    filename = $("#oclass_attach_file_input").val();
    filename = filename.replace(/.*[\/\\]/, '');
    $("#oclass_attach_file_chosen_file_name").html(filename);
    oclass.file_name = filename;
    enableButtons($("#oclass_attach_file_submit_button"));
}

function oclass_check_file_status_response(response)
{
    if (response.rc !== 0) {
        // TODO handle timeout
        setTimeout(oclass_check_file_status, 1000);
        return;
    }
    $("#oclass_attach_file_info_text").html(
            oc.clabels["oclass.attach_file.uploaded"] +
            " " +
            response.uploaded +
            " " +
            oc.clabels["oclass.attach_file.bytes_out_of"] +
            " " +
            response.file_size);
    if (response.uploaded === response.file_size) {
        $("#oclass_attach_file_info_text").html(oc.clabels["oclass.attach_file.file_upload_done"]);
        reloadAfter(2);
        enableButtons($("#oclass_attach_file_submit_button"));
        return;
    }
    setTimeout(oclass_check_file_status, 1000);
}

function oclass_check_file_status()
{
    var request = {};
    request.oclass_id = oclass.oclass.id;
    request.file_name = oclass.file_name;
    ajax_request("query_file_upload_status", request, oclass_check_file_status_response);
}

function oclass_submit_file()
{
    if (oclass.file_name === null) {
        $("#oclass_attach_file_info_div").removeClass("d-none");
        $("#oclass_attach_file_info_text").html(oc.clabels["oclass.attach_file.please_choose_file"]);
        return;
    }
    $("#oclass_attach_file_info_div").removeClass("d-none");
    $("#oclass_attach_file_info_text").html(oc.clabels["oclass.attach_file.uploading_file"]);
    disableButtons($("#oclass_attach_file_submit_button"));
    oclass_check_file_status();
    return true;
}

function oclass_cancel_class_response(response)
{
    if (response.rc !== 0) {
        text_input_modal_show_info(oc.clabels["oclass.cancel_class.failed_to_cancel_class"]);
        return;
    }
    text_input_modal_show_info(oc.clabels["oclass.cancel_class.class_canceled"]);
    redirectAfter("/", 2);
}

function oclass_cancel_class_ok(comment)
{
    if (!stringNotEmpty(comment)) {
        text_input_modal_show_info(oc.clabels[ "oclass.cancel_class.comment_empty" ]);
        return;
    }
    text_input_modal_show_info(oc.clabels[ "oclass.cancel_class.canceling_class" ]);
    var request = {};
    request.oclass_id = oclass.oclass.id;
    request.comment = comment;
    ajax_request("cancel_class", request, oclass_cancel_class_response);
}

function schedule_class_cancel_click()
{
    text_input_modal_show(oc.clabels[ "oclass.cancel_class.title"],
            oc.clabels[ "oclass.cancel_class.text"],
            oclass_cancel_class_ok);
}

function oclass_update_price_click()
{
    text_input_modal_set_value(oclass.oclass.price);
    text_input_modal_show(oc.clabels[ "oclass.update_price.modal.title"], oc.clabels[ "oclass.update_price.modal.text"], oclass_update_price_changed);
}

function oclass_update_price_response(response)
{
    if (response.rc === 0) {
        alert_show(oc.clabels[ "oclass.update_price.modal.title"], oc.clabels[ "oclass.update_price.modal.price_updated"]);
        reloadAfter(2);
        return;
    }
    alert_show(oc.clabels[ "oclass.update_price.modal.title"], oc.clabels[ "oclass.update_price.modal.failed_to_update_price"] + " : " + response.message);
}

function oclass_update_price_changed(new_price_str)
{
    var new_price = parseInt10(new_price_str);
    if ((new_price === 0) || (!isDigits(new_price_str))) {
        text_input_modal_hide();
        alert_show(oc.clabels[ "oclass.update_price.modal.title"], oc.clabels[ "oclass.update_price.modal.illegal_price"]);
        return;
    }

    text_input_modal_hide();
    alert_show(oc.clabels[ "oclass.update_price.modal.title"], oc.clabels[ "oclass.update_price.modal.request_sent"]);

    var request = {};
    request.oclass_id = oclass.oclass.id;
    request.new_price = new_price;
    ajax_request("update_class_price", request, oclass_update_price_response);
}

function oclass_init()
{
    oclass.oclass.price = oclass.oclass.price_per_hour * oclass.oclass.duration_minutes / 60;
    oclass.file_name = null;
    var today = new Date();
    var start_date = new Date(Date.parse(oclass.oclass.start_date));
    var remainingMs = start_date.getTime() - today.getTime();
    $("#oclass_main_board_starting_in_value").text(parseRemainingMs(remainingMs));
    if (isInvalid(oclass.oclass.payment) && (login_isUser(oclass.student)) && (login_isStudent())) {
        alert_show(oc.clabels["oclass.payment_needed"],
                oc.clabels["oclass.payment_needed_text1"] + "&nbsp;" +
                createAnchor("javascript:oclass_pay()", oc.clabels["oclass.payment_needed_pay_now"]),
                oc.clabels["oclass.payment_needed_text2"]);
    }
}

$(document).ready(oclass_init);