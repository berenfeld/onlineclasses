<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="com.onlineclasses.web.CConfig"%>
<%@page import="com.onlineclasses.web.CLabels"%>
<%@page import="com.onlineclasses.web.ServletBase"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="com.onlineclasses.entities.User"%>

<%
    User user_footer = ServletBase.getUser(request);
    Gson gson_footer = new Gson();
    String userGson = gson_footer.toJson(user_footer);
    String url_footer = request.getRequestURI();
    String pageName_footer = url_footer.substring(url_footer.lastIndexOf("/") + 1);
    String parametersJson = gson_footer.toJson(request.getParameterMap());
%>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="js/lib/jquery-ui.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" crossorigin="anonymous"></script>
<script src="https://apis.google.com/js/platform.js?onload=google_loaded" async defer></script>

<script>
    online_classes = {};
    online_classes.user = <%= userGson %>;
    online_classes.clabels = <%= gson_footer.toJson(CLabels.getAll()) %>;    
    online_classes.cconfig = <%= gson_footer.toJson(CConfig.getAll()) %>;
    online_classes.parameters = <%= parametersJson %>;
</script>

<script src="js/lib/md5.js"></script>
<script src="js/common.js"></script>
<script src="js/confirm.js"></script>
<script src="js/alert_modal.js"></script>
<script src="js/google.js"></script>
<script src="js/login.js"></script>
<script src="js/<%= pageName_footer %>.js"></script>

<%
    ServletBase.handleLoginInResponse(request, response);    
%>

<a href="javascript:google_signOut()">GOOGLE SIGNOUT (DEBUG)</a>