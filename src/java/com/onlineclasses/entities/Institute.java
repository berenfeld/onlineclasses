/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.entities;

import com.j256.ormlite.field.DatabaseField;

public class Institute extends BasicEntity {

    public static final String INSTITUTE_NAME_FIELD = "name";
    @DatabaseField( columnName = INSTITUTE_NAME_FIELD)
    public String name;

    public static final String INSTITUTE_TYPE_FIELD = "institute_type";
    @DatabaseField(foreign = true, columnName = INSTITUTE_TYPE_FIELD, foreignAutoRefresh = true)
    public InstituteType institute_type;

    @Override
    public String toString() {
        String result = "institute ";
        if (id != 0) {
            result += "id " + id + " ";
        }
        if (name != null) {
            result += "name " + name + " ";
        }
        return result;
    }
}
