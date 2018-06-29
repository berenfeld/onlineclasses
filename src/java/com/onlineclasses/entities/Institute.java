/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.entities;

import com.j256.ormlite.field.DatabaseField;

public class Institute extends BasicEntity {

    @DatabaseField
    public String name;

    public static final String INSTITUTE_TYPE_FIELD = "institute_type";
    @DatabaseField(foreign = true, columnName = INSTITUTE_TYPE_FIELD)
    public InstituteType institute_type;
}
