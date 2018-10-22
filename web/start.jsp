<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.onlineclasses.utils.Utils"%>
<%@page import="com.onlineclasses.servlets.BaseServlet"%>
<%@page import="com.onlineclasses.entities.User"%>
<%@page import="com.onlineclasses.utils.Labels"%>
<%@page import="com.onlineclasses.utils.Config"%>
<%
    BaseServlet.handleLoginInRequest(request);
    BaseServlet.handleLoginInResponse(request, response);
%>

