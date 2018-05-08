/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.entities;

import com.j256.ormlite.field.DatabaseField;

public class AvailableTime extends BasicEntity  {

    public static final String TEACHER_ID_COLUMN = "teacher_id";
    @DatabaseField(canBeNull = false, foreign = true, columnName = TEACHER_ID_COLUMN)
    public Teacher teacher;
    
    public static final String DAY_COLUMN = "day";
    @DatabaseField(canBeNull = false, columnName = DAY_COLUMN)
    public int day;
    
    @DatabaseField(canBeNull = false)
    public int start_hour;
    
    @DatabaseField(canBeNull = false)
    public int start_minute;
    
    @DatabaseField(canBeNull = false)
    public int end_hour;
    
    @DatabaseField(canBeNull = false)
    public int end_minute;
}
