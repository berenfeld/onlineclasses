/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.entities;

import com.j256.ormlite.field.DatabaseField;
import com.onlineclasses.utils.CConfig;
import com.onlineclasses.utils.Config;

public class GoogleUser extends BasicEntity {

    public static final int GENDER_MALE = CConfig.getInt("website.gender.male");
    public static final int GENDER_FEMALE = CConfig.getInt("website.gender.female");

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

    @Override
    public String toString() {
        return display_name;
    }
}
