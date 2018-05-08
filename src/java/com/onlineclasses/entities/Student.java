/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.entities;

import com.j256.ormlite.field.DataType;
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

public class Student extends User {
    public static final String EMAILS_ENABLED_COLUMN = "emails_enabled";
    @DatabaseField( columnName = EMAILS_ENABLED_COLUMN )
    public boolean emails_enabled;
}
