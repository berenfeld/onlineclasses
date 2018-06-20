<%@page import="com.onlineclasses.utils.Utils"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@page import="com.onlineclasses.servlets.BaseServlet"%>
<%@page import="com.onlineclasses.entities.User"%>
<%@page import="com.onlineclasses.utils.Labels"%>
<%@page import="com.onlineclasses.utils.Config"%>
<%
    String hea_url = request.getRequestURI();
    String hea_pageName = hea_url.substring(hea_url.lastIndexOf("/") + 1);
    if (Utils.isEmpty(hea_pageName)) {
        hea_pageName = "index";
    }

    BaseServlet.handleLoginInRequest(request);
    BaseServlet.handleLoginInResponse(request, response);
%>

<meta name="google-signin-scope" content="profile email">
<meta name="google-signin-client_id" content="519288456292-7s5am7pffeu8sl4tvhcjmflcopm8dqkl.apps.googleusercontent.com">
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link href="css/lib/bootstrap.min.css" rel="stylesheet">
<link href="css/lib/bootstrap.min.cosmo.css" rel="stylesheet">
<link rel="stylesheet" href="css/jquery-ui.css">
<% if ("rtl".equals(Config.get("website.direction"))) { %>        
<link rel="stylesheet" href="css/bootstrap-rtl.css">
<% }%>
<link rel="stylesheet" href="css/extras.css">
<link rel="stylesheet" href="css/common.css">
<link rel="stylesheet" href="css/<%= hea_pageName %>.css">
<link href="css/open-iconic.css" rel="stylesheet">
