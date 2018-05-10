/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.entities;

import static com.j256.ormlite.field.DataType.LONG_STRING;
import com.j256.ormlite.field.DatabaseField;
import java.util.Date;


public class Payment extends BasicEntity {
        
    @DatabaseField(canBeNull = false)
    public Date date;
    
    @DatabaseField
    public ScheduledClass scheduled_class;
    
    @DatabaseField
    public int amount;
    
    @DatabaseField(canBeNull = false)
    public String payer;
}