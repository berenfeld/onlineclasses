/* global oc */

var common = {};

function parseInt10(str, defaultValue)
{
    if (defaultValue === undefined) {
        defaultValue = 0;
    }
    n = parseInt(str, 10);
    if (isNaN(n)) {
        return defaultValue;
    }
    return n;
}

function makeRandomString(length) {
    var result = "";
    var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

    for (var i = 0; i < length; i++)
        result += possible.charAt(Math.floor(Math.random() * possible.length));

    return result;
}

function isDigits(str)
{
    return /^\d+$/.test(str);
}

function redirectAfter(url, seconds)
{
    window.setTimeout(function () {
        window.location.href = url;
    }, seconds * 1000);

}

function stringLengthBetween(str, min_length, max_length)
{
    return ( ( str.length >= min_length ) && ( str.length <= max_length ) );
}

function numberBetween(x, min,max)
{
    return ( ( x >= min ) && ( x <= max ) );
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

function formatTime(hours, minutes)
{
    return padZeroes(hours, 2) + ":" + padZeroes(minutes, 2);
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

function xYearsFromNow(years) {
    var date = new Date();
    date.setFullYear(date.getFullYear() + years);
    return date;
}

function parseAmount(amount)
{
    var n = amount.toFixed(2);
    return n.toString() + " " + oc.clabels["website.currency"];    
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

function invite_student()
{
    $("#invite_student_warning").addClass("d-none");
    modal_show("invite_student_modal");
}

function invite_student_response(response)
{
    if (response.rc === 0) {
        alert_show(oc.clabels["invite_student.sent.modal.title"],
                oc.clabels["invite_student.sent.modal.text1"] +
                " " +
                common.invite_student.name +
                " " +
                oc.clabels["invite_student.sent.modal.text2"] +
                " " +
                common.invite_student.email
                );
    }
    modal_hide("invite_student_modal");
}

function invite_student_modal_hide()
{
    $("#invite_student_warning").addClass("d-none");
}

function invite_student_send()
{
    common.invite_student = {};
    common.invite_student.name = $("#invite_student_name").val();
    common.invite_student.email = $("#invite_student_email").val();

    var request = {};
    request.student_name = common.invite_student.name;
    request.student_email = common.invite_student.email;

    invite_student_modal_hide();

    if (!emailIsValid(request.student_email)) {
        $("#invite_student_warning_text").html(oc.clabels[ "invite_student.sent.modal.invalid_email" ]);
        $("#invite_student_warning").removeClass("d-none");
        return;
    }
    if (!stringNotEmpty(request.student_name))
    {
        $("#invite_student_warning_text").html(oc.clabels[ "invite_student.sent.modal.invalid_name" ]);
        $("#invite_student_warning").removeClass("d-none");
        return;
    }
    ajax_request( "invite_student", request, invite_student_response);    
}

function invite_teacher()
{
    $("#invite_teacher_warning").addClass("d-none");
    modal_show("invite_teacher_modal");
}

function invite_teacher_response(response)
{
    if (response.rc === 0) {
        alert_show(oc.clabels["invite_teacher.sent.modal.title"],
                oc.clabels["invite_teacher.sent.modal.text1"] +
                " " +
                common.invite_teacher.name +
                " " +
                oc.clabels["invite_teacher.sent.modal.text2"] +
                " " +
                common.invite_teacher.email
                );
    }
    modal_hide("invite_teacher_modal");
}

function invite_teacher_modal_hide()
{
    $("#invite_teacher_warning").addClass("d-none");
}

function invite_teacher_send()
{
    common.invite_teacher = {};
    common.invite_teacher.name = $("#invite_teacher_name").val();
    common.invite_teacher.email = $("#invite_teacher_email").val();

    var request = {};
    request.teacher_name = common.invite_teacher.name;
    request.teacher_email = common.invite_teacher.email;

    invite_teacher_modal_hide();

    if (!emailIsValid(request.teacher_email)) {
        $("#invite_teacher_warning_text").html(oc.clabels[ "invite_teacher.sent.modal.invalid_email" ]);
        $("#invite_teacher_warning").removeClass("d-none");
        return;
    }
    if (!stringNotEmpty(request.teacher_name))
    {
        $("#invite_teacher_warning_text").html(oc.clabels[ "invite_teacher.sent.modal.invalid_name" ]);
        $("#invite_teacher_warning").removeClass("d-none");
        return;
    }
    ajax_request( "invite_teacher", request, invite_teacher_response);    
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

function createAnchor(href, message)
{
    return "<a href='" + href + "'>" + message + "</a>";
}

function createEmailAnchor(email)
{
    return createAnchor("mailto:" + email, email);    
}

function createLoginAnchor(message)
{
    return createAnchor("javascript:login_showLoginModal()", message );
}

function createStartLearningAnchor(message)
{
    return createAnchor("javascript:login_registerStudent()", message );
}

function createContactUsAnchor()
{
    return createAnchor("contact", oc.clabels["language.contact_us_for_more_details"] );
}

function remove_search_from_location()
{
    var uri = window.location.toString();
    if (uri.indexOf("?") > 0) {
        uri = uri.substring(0, uri.indexOf("?"));

    }
    return uri;
}

function common_js_error_response(response)
{
}

function common_js_error(message, url, line_number, column_number, error_object)
{
    var request = {};
    request.location_href = document.location.href;
    request.message = message;
    request.url = url;
    request.line_number = line_number;
    request.error_object = JSON.stringify(error_object);

    ajax_request( "js_error", request, common_js_error_response);    

}

function common_number_only_input(element)
{
    element.keydown(
            function (e) {
                // Allow: backspace, delete, tab, escape, enter and .
                if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 190]) !== -1) {
                    return;
                }

                // Allow: Ctrl/cmd+A
                if (e.keyCode === 65 && (e.ctrlKey === true || e.metaKey === true)) {
                    return;
                }

                // Allow: Ctrl/cmd+C
                if (e.keyCode === 67 && (e.ctrlKey === true || e.metaKey === true)) {
                    return;
                }
                // Allow: Ctrl/cmd+X
                if (e.keyCode === 88 && (e.ctrlKey === true || e.metaKey === true)) {
                    return;
                }
                // Allow: home, end, left, right
                if (e.keyCode >= 35 && e.keyCode <= 39) {
                    return;
                }

                // Ensure that it is a number and stop the keypress
                if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
                    e.preventDefault();
                }
            }
    );
}

function disableButtons(buttons)
{
    buttons.addClass("disabled");
    buttons.prop("disabled", true);
}

function enableButtons(buttons)
{
    buttons.removeClass("disabled");
    buttons.prop("disabled", false);
}

function isValid(object)
{
    return  ( object !== null ) && ( object !== undefined );
}

function isInvalid(object)
{
    return  ( object === null ) || ( object === undefined );
}

function common_arrayContains(arr, element)
{
    for (var i = 0; i <arr.length;i++) {
        if (arr[i]===element) {
            return true;
        }
    }
    return false;
}

function common_arrayIndexOf(arr, element)
{
    for (var i = 0; i <arr.length;i++) {
        if (arr[i]===element) {
            return i;
        }
    }
    return -1;
}

function common_arrayAdd(arr, element)
{
    if(common_arrayContains(arr, element)) {
        return;
    }
    arr.push(element);
}


function common_arrayRemove(arr, element)
{
    for (var i = 0; i <arr.length;i++) {
        if (arr[i]===element) {
            arr.splice(i,1);
            return true;
        }
    }
    return false;
}

function common_textValidationInput(elem_name, regExp)
{
    var elem = $("#" + elem_name);    
    elem.on("change", function(event) {
        var elem = $("#" + event.target.id);
        if ( ! regExp.test(elem.val()) ) {
            elem.addClass("border border-warning");
        } else {
            elem.removeClass("border border-warning");
        }
        return true;
    });
}

function common_init()
{
    $(".modal").draggable({
        handle: "div.modal-header"
    });
    window.onerror = common_js_error;
}

function online_classes_init()
{
    common_init();
    modal_init();
    ajax_init();
    confirm_init();
    alert_modal_init();
    progress_modal_init();
    login_init();
    facebook_init();
    google_init();
}