var modal = {};

function modal_hide_all()
{
    $("div.modal").modal("hide");
}

function modal_alreadyShown(modal_name)
{
    for (var i = 0; i < modal.modals.length; i++) {
        if (modal.modals[i].attr("id") === modal_name) {
            return true;
        }
    }
    return false;
}

function modal_show(modal_name)
{
    if (modal_alreadyShown(modal_name)) {
        return;
    }
    var modalElement = $("#" + modal_name);

    modal_hide_all();

    modal.modals.push(modalElement);
    modalElement.modal('show');
}

function modal_remove(modal_name)
{
    for (var i = 0; i < modal.modals.length; i++) {
        if (modal.modals[i].attr("id") === modal_name) {
            modal.modals.splice(i, 1);
            break;
        }
    }
}

function modal_show_first()
{
    if (modal.modals.length === 0 ) {
        return;
    }
    modal.modals[modal.modals.length - 1].modal("show");
}

function modal_hide(modal_name)
{
    if (modal_name === undefined) {
        var modalElement = modal.modals[modal.modals.length - 1];
        modal.modals.spliace(modal.modals.length - 1, 1);
    } else {
        var modalElement = $("#" + modal_name);
        modal_remove(modal_name);
    }

    modalElement.modal('hide');

    if (modal.modals.length > 0) {
        modalElement = modal.modals[modal.modals.length - 1];
        modalElement.modal("show");
    }
}

function modal_shown()
{
    var modal_name = $(this).attr("id");
    if (modal_alreadyShown(modal_name)) {
        return;
    }
    modal_show(modal_name);
}

function modal_hidden()
{
    var modal_name = $(this).attr("id");
    modal_remove(modal_name);
    modal_show_first();
}

function modal_init()
{
    modal.modals = [];
    $("div.modal").on("shown.bs.modal", modal_shown);
    $("div.modal").on("hidden.bs.modal", modal_hidden);
}