/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.entities;

import com.j256.ormlite.field.DatabaseField;
import com.onlineclasses.utils.Config;
import java.util.Date;

public class ScheduledClass extends BasicEntity  {

    public static final String TEACHER_ID_COLUMN = "teacher_id";
    @DatabaseField(canBeNull = false, foreign = true, columnName = TEACHER_ID_COLUMN)
    public Teacher teacher;
    
    public static final String STUDENT_ID_COLUMN = "student_id";
    @DatabaseField(canBeNull = false, foreign = true, columnName = STUDENT_ID_COLUMN)
    public Student student;
    
    public static final String START_DATE_COLUMN = "start_date";
    @DatabaseField(canBeNull = false, columnName = START_DATE_COLUMN)
    public Date start_date;
    
    @DatabaseField(canBeNull = false)
    public int duration_minutes;
       
    @DatabaseField
    public int price_per_hour;
    
    @DatabaseField
    public String subject;
    
    @DatabaseField
    public String student_comment;
    
    @DatabaseField( canBeNull = false)
    public Date registered;
    
    public static final int STATUS_SCHEDULED = Config.getInt("website.scheduled_class.status.scheduled");
    public static final int STATUS_CANCELCED = Config.getInt("website.scheduled_class.status.canceled");
    public static final int STATUS_DONE = Config.getInt("website.scheduled_class.status.done");
    
    public static final String STATUS_COLUMN = "status";
    @DatabaseField( canBeNull = false, columnName = STATUS_COLUMN)
    public int status;
    
}
