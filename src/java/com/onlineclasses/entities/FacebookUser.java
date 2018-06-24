/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.entities;

import com.j256.ormlite.field.DatabaseField;

public class FacebookUser extends BasicEntity { 
       
    public static final String EMAIL_COLUMN = "email";
    @DatabaseField(canBeNull = true, unique = true, columnName = EMAIL_COLUMN)
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
    
    public static final String FACEBOOK_ID_COLUMN = "facebook_id";
    @DatabaseField(unique = true, canBeNull = false, columnName = FACEBOOK_ID_COLUMN)
    public String facebook_id;
    
    @Override
    public String toString() {
        return display_name;
    }
}
