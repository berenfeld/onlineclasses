<%@page import="com.onlineclasses.utils.Config"%>
<%@page import="com.onlineclasses.utils.Labels"%>
<%@page import="com.onlineclasses.utils.Utils"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="com.onlineclasses.utils.CConfig"%>
<%@page import="com.onlineclasses.utils.CLabels"%>
<%@page import="com.onlineclasses.servlets.BaseServlet"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="com.onlineclasses.entities.User"%>

<%
    User user_footer = BaseServlet.getUser(request);
    String userGson = Utils.gson().toJson(user_footer);
    String url_footer = request.getRequestURI();
    String pageName = url_footer.substring(url_footer.lastIndexOf("/") + 1);
    if (Utils.isEmpty(pageName)) {
        pageName = "index";
    }
    String parametersJson = Utils.gson().toJson(request.getParameterMap());
%>

<div class="container">
    <nav class="navbar navbar-expand-lg navbar-expand-md navbar-black bg-white border-top text-black">           
        <div class="navbar-nav">
            <li class="nav-item">
                <div class="nav-link">                    
                    copyright &#169;
                    &nbsp;
                    <%= Labels.get("navbar.copyright")%>
                </div>
            </li>
            <li class="nav-item d-xl-block d-lg-block d-md-block d-sm-none d-none">
                <div class="nav-link">      
                    |
                </div>
            </li>
            <li class="nav-item"> 
                <div class="nav-link">    
                    <%= Labels.get("navbar.contact_us")%>
                    &nbsp;
                    <a href="mailto:<%= Config.get("website.admin_email")%>">
                        <%= Config.get("website.admin_email")%>
                    </a>
                </div>
            </li>
            <li class="nav-item d-xl-block d-lg-block d-md-block d-sm-none d-none">
                <div class="nav-link">      
                    |
                </div>
            </li>
            <li class="nav-item ">      
                <div class="nav-link">    
                    <a href="about_us">
                        <%= Labels.get("navbar.created_by")%>
                    </a>
                    &nbsp;
                    <%= Labels.get("navbar.version")%>
                </div>
            </li>
        </div>
    </nav>
</div>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="js/lib/jquery-ui.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.bundle.min.js" integrity="sha384-u/bQvRA/1bobcXlcEYpsEdFVK/vJs3+T+nXLsBYJthmdBuavHvAW6UsmqO2Gd/F9" crossorigin="anonymous"></script>
<script src="https://apis.google.com/js/platform.js?onload=google_loaded" async defer></script>

<script>
    var oc = {};
    oc.user = <%= userGson%>;
    oc.clabels = <%= Utils.gson().toJson(CLabels.getAll())%>;
    oc.cconfig = <%= Utils.gson().toJson(CConfig.getAll())%>;
    oc.parameters = <%= parametersJson%>;
</script>

<script src="js/lib/md5.js"></script>
<script src="js/common.js"></script>
<script src="js/confirm.js"></script>
<script src="js/progress_modal.js"></script>
<script src="js/alert_modal.js"></script>
<script src="js/text_input_modal.js"></script>
<script src="js/google.js"></script>
<script src="js/facebook.js"></script>
<script src="js/login.js"></script>
<script src="js/<%= pageName%>.js"></script>
