<%@page import="com.onlineclasses.entities.Teacher"%>
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
    User foo_user = BaseServlet.getUser(request);
    String userGson = Utils.gson().toJson(foo_user);
    String foo_url = request.getRequestURI();
    String foo_pageName = foo_url.substring(foo_url.lastIndexOf("/") + 1);
    if (Utils.isEmpty(foo_pageName)) {
        foo_pageName = "index";
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

<script>
    var oc = {};
    oc.user = <%= userGson%>;
    oc.is_teacher = <%= foo_user instanceof Teacher %>;
    oc.clabels = <%= Utils.gson().toJson(CLabels.getAll())%>;
    oc.cconfig = <%= Utils.gson().toJson(CConfig.getAll())%>;
    oc.parameters = <%= parametersJson%>;
</script>

<script src="js/lib/jquery.min.js"></script>
<script src="js/lib/jquery-ui.js"></script>
<script src="js/lib/bootstrap.bundle.min.js"></script>
<script src="https://apis.google.com/js/platform.js?onload=google_loaded" async defer></script>
<script src="js/lib/md5.js"></script>
<script src="js/common_libs/online_classes.js"></script>
<script src="js/<%= foo_pageName %>.js"></script>
