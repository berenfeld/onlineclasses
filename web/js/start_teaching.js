/* global oc */

var start_teaching = {};

function start_teaching_userLoggedInCallback(googleUser)
{
    start_teaching.google_id_token = googleUser.google_id_token;

    $("#start_teaching_email_input").val(googleUser.email);
    $("#start_teaching_display_name_input").val(googleUser.name);
    $("#start_teaching_first_name_input").val(googleUser.first_name);
    $("#start_teaching_last_name_input").val(googleUser.last_name);
}

function start_teaching_userLoggedOutCallback(googleUser)
{

}

function start_teaching_select_degree_type(degree_type)
{
    $("#start_teaching_degree_type_button").html(degree_type);    
}

function start_teaching_googleUserEmailExistsCallback(email_exists)
{
    if (email_exists)
    {
        alert_show(oc.clabels[ "start_teaching.login.email_exists.title"],
                oc.clabels[ "start_teaching.login.email_exists.text"]);
    }
}

function start_teaching_register_complete(response)
{
    if (response.rc !== 0) {
        alert_show(oc.clabels[ "start_teaching.register.failed.title"],
                oc.clabels[ "start_teaching.register.failed.message"] + ":" + response.message);
        return;
    }
    alert_show(oc.clabels[ "start_teaching.register.success.title"],
            oc.clabels[ "start_teaching.register.success.message"]);
    redirectAfter("/", 5);
}

function start_teaching_form_submit()
{
    if (!$("#start_teaching_accept_terms_checkbox").is(":checked")) {
        alert_show(oc.clabels[ "start_teaching.form.submit.terms_of_usage.please_accept"]);
        return;
    }

    if (start_teaching.google_id_token === null) {
        alert_show(oc.clabels[ "start_teaching.form.submit.terms_of_usage.please_login"]);
        return;
    }

    var request = {};
    request.google_id_token = start_teaching.google_id_token;
    request.email = $("#start_teaching_email_input").val();
    request.first_name = $("#start_teaching_first_name_input").val();
    request.last_name = $("#start_teaching_last_name_input").val();
    request.display_name = $("#start_teaching_display_name_input").val();
    request.phone_number = $("#start_teaching_phone_number_input").val();
    request.phone_area = start_teaching.phone_area;
    request.day_of_birth = start_teaching.day_of_birth;
    request.institute_id = start_teaching.institute_id;
    request.institute_name = $("#start_teaching_institute_other_text").val();
    request.subject_id = start_teaching.subject_id;
    request.subject_name = $("#start_teaching_subject_0_text").val();
    
    if ($("#start_teaching_gender_input_male").attr("checked")) {
        request.gender = parseInt10($("#start_teaching_gender_input_male").val());
    }
    if ($("#start_teaching_gender_input_female").attr("checked")) {
        request.gender = parseInt10($("#start_teaching_gender_input_female").val());
    }

    $.ajax("servlets/register_student",
            {
                type: "POST",
                data: JSON.stringify(request),
                dataType: "JSON",
                success: start_teaching_register_complete
            }
    );
}

function start_teaching_select_day_of_birth(dateText)
{
    start_teaching.day_of_birth = new Date(Date.parse(dateText));
}

function start_teaching_select_area_code(phone_area)
{
    start_teaching.phone_area = phone_area;
    $("#start_teaching_area_code_value").html(phone_area);
}

function start_teaching_select_institute_type(institute_type, institute_id)
{    
    start_teaching.institute_type = institute_type;
     
    for (var i=0;i<=oc.institute_type.length;i++)
    {
        $("#start_teaching_institute_" + i + "_label").addClass("d-none");
        $("#start_teaching_institute_" + i + "_div").addClass("d-none");
    }
    
    start_teaching.institute_id = 0;
    
    if (institute_type === 0 ) {        
        $("#start_teaching_institute_type_button").html($("#start_teaching_institute_type_other").html());
        $("#start_teaching_institute_0_label").removeClass("d-none");
        $("#start_teaching_institute_0_div").removeClass("d-none");                
    } else {        
        $("#start_teaching_institute_type_button").html(oc.institute_type[institute_type - 1].name);
        $("#start_teaching_institute_" + institute_type + "_label").removeClass("d-none");
        $("#start_teaching_institute_" + institute_type + "_div").removeClass("d-none");        
        if (institute_id !== 0) {
            start_teaching.institute_id = institute_id;
            $("#start_teaching_institute_" + institute_type + "_select").html(oc.institutes[institute_type][institute_id]);
        }
    }
}

function start_teaching_select_subject(subject_id)
{
    start_teaching.subject_id = subject_id;
    
    if (subject_id === 0 ) {
        start_teaching.subject_id = 0;
        $("#start_teaching_subject_0_div").removeClass("d-none");
        $("#start_teaching_subject_0_label").removeClass("d-none");
    } else {
        $("#start_teaching_subject_0_div").addClass("d-none");
        $("#start_teaching_subject_0_label").addClass("d-none");
        $("#start_teaching_subject_button").html(oc.subjects[subject_id - 1].name);
        start_teaching.subject_id = subject_id;
    }
    
}

function start_teaching_init()
{
    start_teaching.google_id_token = null;
    login_showLoginModal('start_teaching');
    google_addUserLoggedinCallback(start_teaching_userLoggedInCallback);
    google_addUserLoggedOutCallback(start_teaching_userLoggedOutCallback);
    google_addEmailExistsCallback(start_teaching_googleUserEmailExistsCallback);


    $("#start_teaching_day_of_birth_input").datepicker({
        dayNames: oc.clabels[ "website.days.long" ].split(","),
        dayNamesMin: oc.clabels[ "website.days.short" ].split(","),
        monthNames: oc.clabels[ "website.months.long" ].split(","),
        monthNamesShort: oc.clabels[ "website.months.short" ].split(","),
        isRTL: true,
        changeYear: true,
        onSelect: start_teaching_select_day_of_birth
    });

    if (login_isLoggedIn())
    {
        alert_show(oc.clabels[ "start_teaching.login.already_logged_in.title"],
                oc.clabels[ "start_teaching.login.already_logged_in.text"]);
    }
}

start_teaching_init();