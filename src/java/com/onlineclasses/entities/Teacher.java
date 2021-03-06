/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.entities;

import com.j256.ormlite.field.DataType;
import com.j256.ormlite.field.DatabaseField;
import java.util.List;

public class Teacher extends User {

    @DatabaseField(canBeNull = false, unique = true)
    public String paypal_email;

    public static final String PRICE_PER_HOUR_TEACHER_COLUMN = "price_per_hour_teacher";
    @DatabaseField(canBeNull = false, columnName = PRICE_PER_HOUR_TEACHER_COLUMN)
    public int price_per_hour_teacher;

    public static final String PRICE_PER_HOUR_STUDENT_COLUMN = "price_per_hour_student";
    @DatabaseField(canBeNull = false, columnName = PRICE_PER_HOUR_STUDENT_COLUMN)
    public int price_per_hour_student;
    
    @DatabaseField
    public String skype_name;

    @DatabaseField( dataType = DataType.LONG_STRING )
    public String moto;

    @DatabaseField
    public boolean show_phone;

    @DatabaseField
    public boolean show_email;

    @DatabaseField
    public boolean show_skype;

    @DatabaseField
    public boolean show_degree;

    @DatabaseField
    public float rating;

    @DatabaseField
    public int min_class_length;

    @DatabaseField
    public int max_class_length;

    public List<AvailableTime> available_time;

    public List<Topic> teaching_topics;

}
