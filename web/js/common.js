/* global online_classes */

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
    date.setTime(date.getTime() + (minutes * 1000 * 60 ));
}

function addHours(date, hours)
{
    date.setTime(date.getTime() + (hours * 1000 * 60 * 60 ));
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
    var minutes = Math.floor(remainingMs / ( 1000 * 60 ));
    var hours = Math.floor(minutes / 60);
    var days = Math.floor(hours / 24);
    minutes = minutes - (hours * 60);
    hours = hours - (days * 24);
    
    return days + " " + online_classes.clabels[ "language.days" ] + ", " +
            hours + " " + online_classes.clabels[ "language.hours" ] + ", " +
            minutes + " " + online_classes.clabels[ "language.minutes" ];
}
