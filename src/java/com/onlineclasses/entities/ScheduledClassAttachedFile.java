/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.entities;

import com.j256.ormlite.field.DatabaseField;
import java.util.Date;

public class ScheduledClassAttachedFile extends BasicEntity {

    public static final String SCHEDULED_CLASS_FIELD = "scheduled_class";
    @DatabaseField(canBeNull = false, foreign = true, columnName = SCHEDULED_CLASS_FIELD)
    public ScheduledClass scheduled_class;

    @DatabaseField(canBeNull = false)
    public String name;

    @DatabaseField
    public boolean removed;

    @DatabaseField(foreign = true)
    public Student student;

    @DatabaseField(foreign = true)
    public Teacher teacher;

    public static final String ADDED_FIELD = "added";
    @DatabaseField(columnName = ADDED_FIELD, canBeNull = false)
    public Date added;
}