/* global oc */

var index = {};

function index_find_teachers_submit()
{
    var topic_name = $("#index_topic_name").val();
    location.href = "find_teachers?topic_name=" + encodeURIComponent(topic_name);
}

function index_init()
{
    index.all_topics_names = [];

    for (var topic_id in index.all_topics) {
        var topic = index.all_topics[topic_id];
        index.all_topics_names.push(topic.name);
    }
    $("#index_topic_name").autocomplete({
        source: index.all_topics_names
    });
    $("#index_topic_name").keyup(
            function (event) {
                if (event.keyCode === 13) {
                    index_find_teachers_submit();
                    return false;
                }                
            });
}
