<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@page import="com.onlineclasses.servlets.BaseServlet"%>
<%@page import="com.onlineclasses.entities.User"%>
<%@page import="com.onlineclasses.utils.Labels"%>
<%@page import="com.onlineclasses.utils.Config"%>
<%
    BaseServlet.handleLoginInRequest(request);
    BaseServlet.handleLoginInResponse(request, response);
%>

<meta name="google-signin-scope" content="profile email">
<meta name="google-signin-client_id" content="519288456292-7s5am7pffeu8sl4tvhcjmflcopm8dqkl.apps.googleusercontent.com">
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-WskhaSGFgHYWDcbwN70/dfYBj47jz9qbsMId/iRN3ewGhXQFZCSftd1LZCfmhktB" crossorigin="anonymous">
<link href="https://stackpath.bootstrapcdn.com/bootswatch/4.1.1/cosmo/bootstrap.min.css" rel="stylesheet" integrity="sha384-e5ln1YQrCh2KTj0GVDWxOfDZ53Fd5Uss2u08OZUtzZNrxWfeYC4P7VBWHRDPvJUk" crossorigin="anonymous">
<link rel="stylesheet" href="css/jquery-ui.css">
<% if ("rtl".equals(Config.get("website.direction"))) { %>        
<link rel="stylesheet" href="css/bootstrap-rtl.css">
<% }%>
<link rel="stylesheet" href="css/extras.css">
<link rel="stylesheet" href="css/common.css">
<link href="css/open-iconic.css" rel="stylesheet">
