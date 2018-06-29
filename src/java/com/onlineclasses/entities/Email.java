/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.entities;

import static com.j256.ormlite.field.DataType.LONG_STRING;
import com.j256.ormlite.field.DatabaseField;

public class Email extends BasicEntity {

    @DatabaseField(canBeNull = false)
    public String subject;

    @DatabaseField(canBeNull = false)
    public String to;

    @DatabaseField(canBeNull = false, dataType = LONG_STRING)
    public String message;
}
