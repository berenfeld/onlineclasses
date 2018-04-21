<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.onlineclasses.web.ServletBase"%>
<%@page import="com.onlineclasses.entities.User"%>

<%@page import="com.onlineclasses.web.Labels"%>
<%@page import="com.onlineclasses.web.Config"%>

<meta name="google-signin-scope" content="profile email">
<meta name="google-signin-client_id" content="519288456292-7s5am7pffeu8sl4tvhcjmflcopm8dqkl.apps.googleusercontent.com">
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" crossorigin="anonymous">
<link rel="stylesheet" href="css/jquery-ui.css">
<% if ("rtl".equals(Config.get("website.direction"))) { %>        
    <link rel='stylesheet' href='css/bootstrap-rtl.css'>
<% }%>
<link rel="stylesheet" href="css/extras.css">
<link rel="stylesheet" href="css/common.css">

<title><%= Labels.get("website.title")%> | <%= Labels.get("index.title")%></title>
