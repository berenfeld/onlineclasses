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
    window.setTimeout(function(){

        // Move to a new location or you can do something else
        window.location.href = url;

    }, seconds * 1000);

}