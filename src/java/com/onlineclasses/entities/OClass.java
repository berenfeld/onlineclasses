/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.entities;

import com.j256.ormlite.field.DatabaseField;
import com.onlineclasses.utils.CConfig;
import com.onlineclasses.utils.Config;
import com.onlineclasses.utils.Utils;
import java.util.Date;

public class OClass extends BasicEntity {

    public static final String TEACHER_COLUMN = "teacher";
    @DatabaseField(canBeNull = false, foreign = true, columnName = TEACHER_COLUMN)
    public Teacher teacher;

    public static final String STUDENT_COLUMN = "student";
    @DatabaseField(canBeNull = false, foreign = true, columnName = STUDENT_COLUMN)
    public Student student;

    public static final String START_DATE_COLUMN = "start_date";
    @DatabaseField(canBeNull = false, columnName = START_DATE_COLUMN)
    public Date start_date;

    @DatabaseField(canBeNull = false)
    public int duration_minutes;

    public static final String PRICE_PER_HOUR_COLUMN = "price_per_hour";
    @DatabaseField(columnName = PRICE_PER_HOUR_COLUMN)
    public int price_per_hour;

    @DatabaseField
    public String subject;

    public String student_comment;

    @DatabaseField(canBeNull = false)
    public Date registered;

    public static final int STATUS_SCHEDULED = Config.getInt("website.oclass.status.scheduled");
    public static final int STATUS_CANCELCED = Config.getInt("website.oclass.status.canceled");
    public static final int STATUS_DONE = Config.getInt("website.oclass.status.done");
    public static final int LOCATION_TEACHER = CConfig.getInt("website.location.teacher");
    public static final int LOCATION_STUDENT = CConfig.getInt("website.location.student");
 
    public static final String STATUS_COLUMN = "status";
    @DatabaseField(canBeNull = false, columnName = STATUS_COLUMN)
    public int status;

    public static final String PAYMENT_COLUMN = "payment";
    @DatabaseField(foreign = true, columnName = PAYMENT_COLUMN)
    public Payment payment;
    
    public static final String LOCATION_COLUMN = "location";
    @DatabaseField(canBeNull = false, columnName = LOCATION_COLUMN)
    public int location;
    
    @Override
    public String toString() {
        String result = "scheduled class";
        if (id != 0 ) {
            result += " " + id;
        }
        if (start_date != null) {
            result += " at " + Utils.formatDateTime(start_date);
        }
        if (teacher != null) {
            result += " teacher " + teacher;
        }
        if (student != null) {
            result += " student " + student;
        }
        if (Utils.isNotEmpty(subject)) {
            result += " subject " + subject;
        }
        return result;
    }

}
