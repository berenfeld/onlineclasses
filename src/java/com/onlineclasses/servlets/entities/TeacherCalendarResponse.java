/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.servlets.entities;

import com.onlineclasses.entities.AvailableTime;
import com.onlineclasses.entities.BasicResponse;
import com.onlineclasses.entities.OClass;
import com.onlineclasses.entities.Teacher;
import java.util.List;

/**
 *
 * @author me
 */
public class TeacherCalendarResponse extends BasicResponse {

    public TeacherCalendarResponse() {

    }

    public Teacher teacher;
    public List<AvailableTime> available_times;
    public List<OClass> oclasses;

}
