/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

var alert_modal = {}

function alert_modal_ok()
{
    if (alert_modal.ok_cb) {
        alert_modal.ok_cb();
        alert_modal.ok_cb = null;
    }
}

function alert_show(title, message, ok_cb, cancel_cb)
{
    alert_modal.ok_cb = ok_cb;
    alert_modal.cancel_cb = cancel_cb;
    
    $("#alert_modal_title").html(title);
    $("#alert_modal_text1").html(message);
    $("#alert_modal").modal('show');
}

function alert_modal_init()
{
    
}