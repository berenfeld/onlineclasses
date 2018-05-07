/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.entities;

import com.j256.ormlite.field.DatabaseField;
import java.io.Serializable;
import javax.websocket.RemoteEndpoint;


public class BasicEntity implements Serializable {
        
    public static final String ID_COLUMN = "id";    
    @DatabaseField(generatedId = true, columnName = ID_COLUMN)
    public int id;   
    
    @Override
    public boolean equals(Object other)
    {
        return (other != null) && (other instanceof BasicEntity) && (((BasicEntity)other).id == id);
    }
}
