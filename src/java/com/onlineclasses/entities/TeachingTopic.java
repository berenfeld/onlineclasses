/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.entities;

import com.j256.ormlite.field.DatabaseField;

public class TeachingTopic extends BasicEntity {
                
    @DatabaseField(foreign = true)
    public Topic topic;
    
    public static final String TEACHER_ID_COLUMN = "teacher_id";
    @DatabaseField(foreign = true, columnName = TEACHER_ID_COLUMN)
    public Teacher teacher;
}
