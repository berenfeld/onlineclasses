/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

var text_input_modal = {};

function text_input_modal_ok()
{
    if (text_input_modal.ok_cb) {
        text_input_modal.ok_cb($("#text_input_modal_input").val());
        text_input_modal.ok_cb = null;
    }
}

function text_input_modal_hide()
{
    $("#text_input_modal").modal('hide');
}

function text_input_modal_show(title, message, ok_cb)
{
    text_input_modal_hide_info();
    text_input_modal.ok_cb = ok_cb;
    
    $("#text_input_modal_title").html(title);
    $("#text_input_modal_text1").html(message);
    $("#text_input_modal").modal('show');
}

function text_input_modal_hide_info()
{
    $("#text_input_modal_info_div").addClass("d-none");
}

function text_input_modal_show_info(info)
{
    $("#text_input_modal_info_div").removeClass("d-none");
    $("#text_input_modal_info_text").html(info);
}