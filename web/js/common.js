/* global online_classes */

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

        // Move to a new location or you can do something else
        window.location.href = url;

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

    return days + " " + online_classes.clabels[ "language.days" ] + ", " +
            hours + " " + online_classes.clabels[ "language.hours" ] + ", " +
            minutes + " " + online_classes.clabels[ "language.minutes" ];
}

function emailIsValid(email) {
    var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(String(email).toLowerCase());
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
function invite_other_student()
{
    $("#invite_other_student_modal").modal("show");
}
function invite_other_student_response(response)
{
    if (response.rc === 0) {
        alert_show(online_classes.clabels["invite_friend.sent.modal.title"],
                online_classes.clabels["invite_friend.sent.modal.text1"] +
                " " +
                common.invite_student.name +
                " " +
                online_classes.clabels["invite_friend.sent.modal.text2"] +
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

    if (!emailIsValid(request.student_email)) {
        $("#invite_other_student_warning_text").html(online_classes.clabels[ "invite_friend.sent.modal.invalid_email" ]);
        $("#invite_other_student_warning").removeClass("d-none");
        return;
    }
    if (!stringNotEmpty(request.student_name))
    {
        $("#invite_other_student_warning_text").html(online_classes.clabels[ "invite_friend.sent.modal.invalid_name" ]);
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