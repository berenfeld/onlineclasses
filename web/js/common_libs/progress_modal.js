/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

var progress_modal = {}

function progress_modal_ok()
{
    if (progress_modal.ok_cb) {
        progress_modal.ok_cb();
        progress_modal.ok_cb = null;
    }
}

function progress_modal_show(title, message, percent)
{
    if (percent < 100) {
        $("#progress_modal").modal('show');
    } else {
        $("#progress_modal").modal('hide');
    }
    $("#progress_modal_bar").css(
            {
                "width": percent + "%"
            }
    );
    $("#progress_modal_bar").attr('aria-valuenow', percent);
    $("#progress_modal_title").html(title);
    $("#progress_modal_text1").html(message);
    $("#progress_modal_percent").html(percent);

}

function progress_modal_init()
{
    
}