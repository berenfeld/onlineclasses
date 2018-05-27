/* global oc */

var common = {};

function parseInt10(str, defaultValue)
{
    n = parseInt(str);
    if (isNaN(n)) {
        return defaultValue;
    }
    return n;
}

function redirectAfter(url, seconds)
{
    window.setTimeout(function () {
        window.location.href = url;
    }, seconds * 1000);

}

function reloadAfter(seconds)
{
    window.setTimeout(function () {
        window.location.reload();

    }, seconds * 1000);

}

function padZeroes(number, toLength)
{
    var result = number.toString();
    while (result.length < toLength)
    {
        result = "0" + result;
    }
    return result;
}

function addDay(date)
{
    addDays(date, 1);
}

function substractDay(date)
{
    addDays(date, -1);
}

function addDays(date, days)
{
    date.setTime(date.getTime() + (days * 1000 * 60 * 60 * 24));
}

function addMinutes(date, minutes)
{
    date.setTime(date.getTime() + (minutes * 1000 * 60));
}

function addHours(date, hours)
{
    date.setTime(date.getTime() + (hours * 1000 * 60 * 60));
}

function sameDay(date1, date2) {
    return (date1.getMonth() === date2.getMonth()) &&
            (date1.getFullYear() === date2.getFullYear()) &&
            (date1.getDate() === date2.getDate());
}

function parseDate(date) {
    return date.getDate() + "/" + (date.getMonth() + 1);
}

function parseDateLong(date) {
    return date.getDate() + "/" + (date.getMonth() + 1 + "/" + date.getFullYear());
}

function parseRemainingMs(remainingMs) {
    var minutes = Math.floor(remainingMs / (1000 * 60));
    var hours = Math.floor(minutes / 60);
    var days = Math.floor(hours / 24);
    minutes = minutes - (hours * 60);
    hours = hours - (days * 24);

    return days + " " + oc.clabels[ "language.days" ] + ", " +
            hours + " " + oc.clabels[ "language.hours" ] + ", " +
            minutes + " " + oc.clabels[ "language.minutes" ];
}

function emailIsValid(email) {
    var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(String(email).toLowerCase());
}

function stringEmpty(str) {
    if (!str) {
        return true;
    }
    if ((str.replace(/\s/g, '').length) === 0) {
        return true;
    }
    return false;
}

function stringNotEmpty(str) {
    if (!str) {
        return false;
    }
    if ((str.replace(/\s/g, '').length) === 0) {
        return false;
    }
    return true;
}

function isNumberKey(event)
{
    var charCode = (event.which) ? event.which : event.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57))
        return false;

    return true;
}

function invite_other_student()
{
    $("#invite_other_student_warning").addClass("d-none");
    $("#invite_other_student_modal").modal("show");
}

function invite_other_student_response(response)
{
    if (response.rc === 0) {
        alert_show(oc.clabels["invite_friend.sent.modal.title"],
                oc.clabels["invite_friend.sent.modal.text1"] +
                " " +
                common.invite_student.name +
                " " +
                oc.clabels["invite_friend.sent.modal.text2"] +
                " " +
                common.invite_student.email
                );
    }
    $("#invite_other_student_modal").modal("hide");
}

function invite_other_student_modal_hide()
{
    $("#invite_other_student_warning").addClass("d-none");
}

function invite_other_student_send()
{
    common.invite_student = {};
    common.invite_student.name = $("#invite_other_student_name").val();
    common.invite_student.email = $("#invite_other_student_email").val();

    var request = {};
    request.student_name = common.invite_student.name;
    request.student_email = common.invite_student.email;

    invite_other_student_modal_hide();

    if (!emailIsValid(request.student_email)) {
        $("#invite_other_student_warning_text").html(oc.clabels[ "invite_friend.sent.modal.invalid_email" ]);
        $("#invite_other_student_warning").removeClass("d-none");
        return;
    }
    if (!stringNotEmpty(request.student_name))
    {
        $("#invite_other_student_warning_text").html(oc.clabels[ "invite_friend.sent.modal.invalid_name" ]);
        $("#invite_other_student_warning").removeClass("d-none");
        return;
    }
    $.ajax("servlets/invite_student",
            {
                type: "POST",
                data: JSON.stringify(request),
                dataType: "JSON",
                success: invite_other_student_response
            });
}

function appendToSearchString(search_string, token)
{
    if (!search_string) {
        search_string = token;
    } else {
        search_string = search_string + "&" + token;
    }
    return search_string;
}

function start_teaching()
{
    alert_show(oc.clabels["navbar.start_teaching.title"],
            oc.clabels["navbar.start_teaching.text"] + createEmailAnchor(oc.clabels["website.admin.email"]));
}

function createEmailAnchor(email)
{
    return "<a href='mailto:" + email + "'>" + email + "</a>";
}

function remove_search_from_location()
{
    var uri = window.location.toString();
    if (uri.indexOf("?") > 0) {
        uri = uri.substring(0, uri.indexOf("?"));

    }
    return uri;
}

function common_init()
{
    $(".modal").draggable({
        handle: "div.modal-header"
    });
}

common_init();