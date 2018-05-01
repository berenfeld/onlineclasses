/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.entities;

import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;
import java.util.Date;

public class ScheduledClass extends BasicEntity  {

    public static final String TEACHER_ID_COLUMN = "teacher_id";
    @DatabaseField(canBeNull = false, foreign = true, columnName = TEACHER_ID_COLUMN)
    public Teacher teacher;
    
    public static final String STUDENT_ID_COLUMN = "student_id";
    @DatabaseField(canBeNull = false, foreign = true, columnName = STUDENT_ID_COLUMN)
    public Student student;
    
    @DatabaseField(canBeNull = false)
    public Date start_date;
    
    public int duration;
    
    public int price_per_hour;
    
    @DatabaseField
    public String subject;
    
    @DatabaseField
    public String student_comment;
}
