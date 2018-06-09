/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.entities;

import com.j256.ormlite.field.DatabaseField;
import com.onlineclasses.utils.Config;
import java.io.Serializable;
import java.util.Date;

public class User extends BasicEntity implements Serializable {

    public static final int GENDER_MALE = Config.getInt("website.gender.male");
    public static final int GENDER_FEMALE = Config.getInt("website.gender.female");

    public static final String EMAIL_COLUMN = "email";
    @DatabaseField(canBeNull = false, unique = true, columnName = EMAIL_COLUMN)
    public String email;
    @DatabaseField
    public String first_name;
    @DatabaseField
    public String last_name;

    public static final String DISPLAY_NAME_COLUMN = "display_name";
    @DatabaseField(canBeNull = false, columnName = DISPLAY_NAME_COLUMN)
    public String display_name;

    @DatabaseField
    public String image_url;

    @DatabaseField
    public String phone_area;

    @DatabaseField
    public String phone_number;

    @DatabaseField
    public int gender;
    
    @DatabaseField(canBeNull = false)
    public Date registered;
    
    @DatabaseField
    public Date day_of_birth;
    
    @DatabaseField(foreign = true)
    public Institute institute;
    
    @DatabaseField
    public String institute_name;
    
    @DatabaseField(foreign = true)
    public Subject subject;
    
    @DatabaseField
    public String subject_name;
   
    @Override
    public String toString() {
        return display_name;
    }
    
    public boolean isMale() {
        return gender == GENDER_MALE;
    }
    public boolean isFemale() {
        return gender == GENDER_FEMALE;
    }
    
}
