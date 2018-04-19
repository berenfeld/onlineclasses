<%@page import="com.onlineclasses.entities.AvailableTime"%>
<%@page import="java.util.List"%>
<%@page import="com.onlineclasses.entities.Teacher"%>
<%@page import="com.onlineclasses.db.DB"%>
<%@page import="com.onlineclasses.web.Utils"%>
<%@page import="com.onlineclasses.web.CConfig"%>
<%@page import="com.onlineclasses.web.Config"%>
<%@page import="com.onlineclasses.web.Labels"%>

<%
    int minPrice = Utils.parseInt(request.getParameter("price_min"), CConfig.getInt("find_teachers.price.min"));
    int maxPrice = Utils.parseInt(request.getParameter("price_max"), CConfig.getInt("find_teachers.price.max"));
    String displayName = Utils.nonNullString(request.getParameter("display_name"));
    int availableDay = Utils.parseInt(request.getParameter("available_day"), 0);

    List<Teacher> teachers = DB.findTeachers(minPrice, maxPrice, displayName);
    for (Teacher teacher : teachers) {
        teacher.available_time = DB.getTeacherAvailableTime(teacher);
        Utils.info("teacher " + teacher.display_name + " avail " + teacher.available_time.size());
    }
    List<String> dayNamesLong = Utils.toList(CLabels.get("website.days.long"));
    List<String> dayNamesShort = Utils.toList(CLabels.get("website.days.short"));
%>

<!DOCTYPE html>
<html lang="<%= Config.get("website.html_language")%>">
    <head>
        <%@include file="header.jsp" %>
    </head>
    <body>
        <%@include file="body.jsp" %>   
        <div class="container">
            <div id="schedule_class_modal" class="modal fade" role="dialog">
                <div class="modal-dialog modal-md">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" aria-label="close" data-dismiss="modal">
                                <span aria-hidden="true">&times;</span>
                            </button>
                            <h4 id="schedule_class_modal_title" class="modal-title">
                                <%= Labels.get("schedule.class.modal.title")%>
                                <span id="schedule_class_modal_title_teacher_anchor"></span>
                            </h4>
                        </div>
                        <div class="modal-body">
                            <form>
                                <div class="form-group row">
                                    <label for="start_day_input" class="col-sm-2 col-form-label">
                                        <%= Labels.get("schedule.class.modal.day")%>
                                    </label>
                                    <div class="col-sm-4">   
                                        <input type="email" class="form-control" name="start_day_input" 
                                               id="start_day_input" 
                                               placeholder="<%= Labels.get("schedule.class.modal.day_placeholder")%>">
                                    </div>
                                    <div class="col-sm-6">  </div>
                                </div>
                                <div class="form-group row">
                                    <label for="schedule_class_start_hour" class="col-sm-2 col-form-label">
                                        <%= Labels.get("schedule.class.modal.start_hour")%>
                                    </label>
                                    <div class="col-sm-4">   
                                        <select name="schedule_class_start_hour"  id="schedule_class_start_hour">
                                            <option>22:00</option>
                                            <option>23:00</option>
                                            <option>22:00</option>
                                            <option>23:00</option>
                                        </select>
                                    </div>
                                    <label for="schedule_class_end_hour" class="col-sm-2 col-form-label">
                                        <%= Labels.get("schedule.class.modal.end_hour")%>
                                    </label>
                                    <div  class="col-sm-4">  
                                        <select name="schedule_class_end_hour" id="schedule_class_end_hour">
                                            <option>22:00</option>
                                            <option>23:00</option>
                                            <option>22:00</option>
                                            <option>23:00</option>
                                        </select>
                                    </div>
                                </div>
                            </form>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-success" onclick="schedule_class_confirm()" data-dismiss="modal"><%= Labels.get("schedule.class.modal.confirm_button")%></button>
                                <button type="button" class="btn btn-default" onclick="schedule_class_cancel()" data-dismiss="modal"><%= Labels.get("buttons.cancel")%></button>
                            </div>
                        </div>

                    </div>
                </div>
            </div>

            <div class="container">

                <div class="well col-md-4 container">

                    <h4 class="text-info">                        
                        <%= Labels.get("find_teachers.sidebar.title")%>                                
                    </h4>
                    <form>
                        <div class="form-group">
                            <label for="find_teachers_price_per_hour_slider">
                                <%= Labels.get("find_teachers.sidebar.price_per_hour")%> :
                            </label>                        
                            <span dir="LTR">
                                <span id="find_teachers_price_per_hour_value_min">
                                    <%= minPrice%>                                
                                </span>
                                <%= CLabels.get("website.currency")%>                                
                                &nbsp;-&nbsp;
                                <span id="find_teachers_price_per_hour_value_max">                                
                                    <%= maxPrice%>                                
                                </span>
                                <%= CLabels.get("website.currency")%>
                            </span>

                            <div id="find_teachers_price_per_hour_slider"></div>
                        </div>
                        <div class="form-group">
                            <label for="find_teachers_display_name_input" >
                                <%= Labels.get("find_teachers.sidebar.name.text")%>           
                            </label>

                            <input type="text" class="form-control" id="find_teachers_display_name_input" 
                                   placeholder="<%= Labels.get("find_teachers.sidebar.name.text")%>" 
                                   value="<%= displayName%>">
                        </div>
                        <div class="form-group">
                            <label for="find_teachers_available_in_days">
                                <%= Labels.get("find_teachers.sidebar.available_in_days")%>           
                            </label>
                            <select class="form-control" id="find_teachers_available_in_days">
                                <option value="0" <% if (availableDay == 0) { %> selected <% }%>>
                                    <%= Labels.get("find_teachers.sidebar.all_days")%>  
                                </option>
                                <%
                                    for (int i = 0; i < dayNamesLong.size(); i++) {
                                %>
                                <option value="<%= i + 1%>" <% if (availableDay == (i + 1)) { %> selected <% }%>>
                                    <%=dayNamesLong.get(i)%>
                                </option>
                                <%
                                    }
                                %>
                            </select>
                        </div>

                        <div class="form-group">
                            <button type="button" class="btn btn-primary col-1" 
                                    id="find_teachers.sidebar.refresh_button"
                                    onclick="find_teachers_refresh_results()" >
                                <span class="glyphicon glyphicon-refresh"></span>
                                &nbsp;
                                <%= Labels.get("find_teachers.sidebar.update_button.text")%>
                            </button>    

                            <button type="button" class="btn btn-info col-1" 
                                    id="find_teachers.sidebar.clear_button">
                                <span class="glyphicon glyphicon-refresh"></span>
                                &nbsp;
                                <%= Labels.get("find_teachers.sidebar.clear_button.text")%>
                            </button>

                        </div>
                    </form>
                </div>

                <div class="col-md-8 container">
                    <h3>
                        <%= Labels.get("find_teachers.list.title")%>
                    </h3>

                    <div class="table-responsive">
                        <table class="table table-striped table-borderless table-hover table-sm">
                            <thead>
                            <th style="width: 20%">
                                <%= Labels.get("find_teachers.list.header.teacher_name")%>
                            </th>
                            <th style="width: 60%">
                                <%= Labels.get("find_teachers.list.header.teacher_details")%>
                            </th>
                            <th style="width: 20%">
                                <%= Labels.get("find_teachers.list.header.price_and_actions")%>
                            </th>
                            </thead>
                            <tbody>
                                <%
                                    for (Teacher teacher : teachers) {
                                %>
                                <tr>
                                    <td>
                                        <figure class="figure">
                                            <img height="128" src="<%= teacher.image_url%>" class="img-fluid figure-img rounded"/>
                                            <figcaption class="figure-caption text-center">
                                                <%= teacher.display_name%>
                                            </figcaption>
                                        </figure>
                                    </td>
                                    <td>
                                        <cite>
                                            <%= teacher.moto%>
                                        </cite>

                                        <p>
                                            <a class="info" data-toggle="collapse" href="#find_teacher_details_teacher_<%= teacher.id%>" 
                                               role="button" aria-expanded="false" aria-controls="find_teacher_details_teacher_<%= teacher.id%>">
                                                <%= Labels.get("find_teachers.list.body.show_more_details")%>
                                            </a>
                                        </p>
                                        <div class="well collapse" id="find_teacher_details_teacher_<%= teacher.id%>">
                                            <h5 class="text-info">
                                                <%= Labels.get("find_teachers.list.body.available_hours")%>
                                            </h5>
                                            <%
                                                for (AvailableTime availableTime : teacher.available_time) {
                                            %>

                                            <%= dayNamesLong.get(availableTime.day - 1)%>
                                            <span style="direction: ltr; unicode-bidi: bidi-override;">                                        
                                                <%= String.format("%02d:%02d", availableTime.start_hour, availableTime.start_minute)%>                                    
                                                &nbsp;-&nbsp;
                                                <%= String.format("%02d:%02d", availableTime.end_hour, availableTime.end_minute)%>                                    
                                            </span>
                                            <br/>

                                            <%
                                                }
                                            %>  

                                        </div>

                                    </td>
                                    <td>
                                        <h5 class="text-info">
                                            <%= Labels.get("find_teachers.list.body.price_per_hour")%>
                                            &nbsp;:&nbsp;
                                            <%= teacher.price_per_hour%>
                                            <%= CLabels.get("website.currency")%>
                                        </h5>
                                        <button id="schedule_class_button_<%= teacher.id%>" data-teacher-id="<%= teacher.id%>" 
                                                data-teacher-display-name="<%= teacher.display_name%>" onclick="schedule_class_button_clicked()" class="btn btn-primary">
                                            <%= Labels.get("find_teachers.list.body.schedule_class_button")%>
                                        </button>
                                    </td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <%@include file="footer.jsp" %>    
    </body>

</html>
