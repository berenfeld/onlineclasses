var confirm = {};

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

function confirm_hide()
{
    $("#confirm_modal").modal('hide');
}

function confirm_init()
{
    
}