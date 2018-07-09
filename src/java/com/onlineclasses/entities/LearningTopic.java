/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.entities;

import com.j256.ormlite.field.DatabaseField;

public class LearningTopic extends BasicEntity {

    @DatabaseField(foreign = true)
    public Topic topic;

    public static final String STUDENT_ID_COLUMN = "student_id";
    @DatabaseField(foreign = true, columnName = STUDENT_ID_COLUMN)
    public Student student;

    @Override
    public String toString() {
        String result = "unknown topic";
        if (topic != null) {
            result = " topic " + topic;
        }
        if (student != null) {
            result += " of student " + student;
        }
        return result;
    }
}
