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

function alert_show(title, message1, message2, ok_cb)
{
    alert_modal.ok_cb = ok_cb;
    
    $("#alert_modal_title").html(title);
    if (isValid(message1)) {
        $("#alert_modal_text1").html(message1);
    } else {
        $("#alert_modal_text1").html("");
    }
    if (isValid(message2)) {
        $("#alert_modal_text2").html(message2);
    } else {
        $("#alert_modal_text2").html("");
    }
    console.log("alert show " + message1);
    modal_show("alert_modal");    
    
}

function alert_modal_init()
{
    $("#alert_modal_button").on("click", alert_modal_ok );
}