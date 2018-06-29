/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.entities;

import com.j256.ormlite.field.DatabaseField;
import java.util.Date;

public class ClassComment extends BasicEntity {

    @DatabaseField(canBeNull = false)
    public String comment;

    public static final String OCLASS_FIELD = "oclass";
    @DatabaseField(canBeNull = false, foreign = true, columnName = OCLASS_FIELD)
    public OClass oclass;

    @DatabaseField(foreign = true)
    public Student student;

    @DatabaseField(foreign = true)
    public Teacher teacher;

    public static final String ADDED_FIELD = "added";
    @DatabaseField(canBeNull = false, columnName = ADDED_FIELD)
    public Date added;
}
