/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.entities;

import com.j256.ormlite.field.DatabaseField;

public class Feedback extends BasicEntity {

    @DatabaseField(canBeNull = false)
    public String from;

    @DatabaseField(canBeNull = false)
    public String email;

    @DatabaseField(canBeNull = false)
    public String message;

    @Override
    public String toString() {
        String result = "id " + id;
        if (from != null) {
            result += " from " + from;
        }
        if (email != null) {
            result += " email " + email;
        }
        if (message != null) {
            result += " message " + message;
        }
        return result;
    }
}
