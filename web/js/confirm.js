/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

var confirm = {}

function confirm_ok()
{
    if (confirm.ok_cb) {
        confirm.ok_cb();
        confirm.ok_cb = null;
    }
}

function confirm_cancel()
{
    if (confirm.cancel_cb) {
        confirm.cancel_cb();
        confirm.cancel_cb = null;
    }
}

function confirm_show(title, message, ok_cb, cancel_cb)
{
    confirm.ok_cb = ok_cb;
    confirm.cancel_cb = cancel_cb;
    $("#confirm_modal_title").text(title);
    $("#confirm_modal_message").text(message);
    $("#confirm_modal").modal('show');
}