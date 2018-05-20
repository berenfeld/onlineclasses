<%@page import="com.onlineclasses.utils.Utils"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="com.onlineclasses.utils.CConfig"%>
<%@page import="com.onlineclasses.utils.CLabels"%>
<%@page import="com.onlineclasses.servlets.ServletBase"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="com.onlineclasses.entities.User"%>

<%
    User user_footer = ServletBase.getUser(request);
    String userGson = Utils.gson().toJson(user_footer);
    String url_footer = request.getRequestURI();
    String pageName_footer = url_footer.substring(url_footer.lastIndexOf("/") + 1);
    String parametersJson = Utils.gson().toJson(request.getParameterMap());
%>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="js/lib/jquery-ui.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<script src="https://apis.google.com/js/platform.js?onload=google_loaded" async defer></script>

<script>
    online_classes = {};
    online_classes.user = <%= userGson %>;
    online_classes.clabels = <%= Utils.gson().toJson(CLabels.getAll()) %>;    
    online_classes.cconfig = <%= Utils.gson().toJson(CConfig.getAll()) %>;
    online_classes.parameters = <%= parametersJson %>;
</script>

<script src="js/lib/md5.js"></script>
<script src="js/common.js"></script>
<script src="js/confirm.js"></script>
<script src="js/progress_modal.js"></script>
<script src="js/alert_modal.js"></script>
<script src="js/text_input_modal.js"></script>
<script src="js/google.js"></script>
<script src="js/login.js"></script>
<script src="js/<%= pageName_footer %>.js"></script>
