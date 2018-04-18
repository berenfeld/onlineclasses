/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.entities;

import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

public class User extends BasicEntity  {

    @DatabaseField(canBeNull = false, unique = true)
    public String email;
    @DatabaseField
    public String first_name;
    @DatabaseField
    public String last_name;
    
    public static final String DISPLAY_NAME_COLUMN = "display_name";
    @DatabaseField(canBeNull = false, columnName = DISPLAY_NAME_COLUMN)
    public String display_name;
    
    public static final String GOOGLE_ID_COLUMN = "google_id";
    @DatabaseField(canBeNull = true, unique = true, columnName = GOOGLE_ID_COLUMN)
    public String google_id;

    @DatabaseField
    public String image_url;
    
    @DatabaseField
    public String phone_area;
    
    @DatabaseField
    public String phone_number;
}
