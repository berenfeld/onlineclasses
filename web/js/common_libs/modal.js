var modal = {};

function modal_hideAll()
{
     for (var i = 0; i < modal.modals.length; i++) {
         var modal_name = modal.modals[i];
         var modalElement = $("#" + modal_name);
         modalElement.modal("hide");
     }
}

function modal_show(modal_name)
{
    console.log("show modal " + modal_name);
    modal_hideAll();
    var modalElement = $("#" + modal_name);
    common_arrayAdd(modal.modals, modal_name);    
    modalElement.modal('show');
}

function modal_remove(modal_name)
{
    common_arrayRemove(modal.modals, modal_name);    
}

function modal_showLast()
{
    if (modal.modals.length === 0) {
        return;
    }
    var modal_name = modal.modals[modal.modals.length - 1];
    var modalElement = $("#" + modal_name);
    modalElement.modal("show");
    console.log("showing last modal " + modal_name + " from " + modal.modals.length);
}

function modal_hide(modal_name)
{
    console.log("hide modal " + modal_name);
    var modalElement = $("#" + modal_name);
    modal_remove(modal_name);
    modalElement.modal('hide');
    modal_showLast();
}

function modal_shown()
{
    var modal_name = $(this).attr("id");
    console.log("modal " + modal_name + " shown");
}

function modal_hidden()
{
    var modal_name = $(this).attr("id");
    console.log("modal " + modal_name + " hidden");
    
    var length = modal.modals.length;
    if (length === 0 ) {
        return;
    }
    if (common_arrayIndexOf(modal.modals, modal_name) === (length - 1))
    {    
        modal_remove(modal_name);
        modal_showLast();
    }
}

function modal_init()
{
    modal.modals = [];
    $("div.modal").on("shown.bs.modal", modal_shown);
    $("div.modal").on("hidden.bs.modal", modal_hidden);
}