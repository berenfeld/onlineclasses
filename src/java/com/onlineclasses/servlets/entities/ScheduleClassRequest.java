/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.servlets.entities;

import com.onlineclasses.entities.BasicRequest;
import java.util.Date;

/**
 *
 * @author me
 */
public class ScheduleClassRequest extends BasicRequest {

    public ScheduleClassRequest() {
    }
    public int teacher_id;
    public Date start_date;
    public int duration_minutes;
    public String subject;
    public String student_comment;
}
