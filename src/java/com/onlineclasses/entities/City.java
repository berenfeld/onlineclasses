/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.entities;

import com.j256.ormlite.field.DatabaseField;

public class City extends BasicEntity {

    @DatabaseField(canBeNull = false)
    public String name;

    @Override
    public String toString() {
        String result = "id " + id;
        if (name != null) {
            result += " " + name;
        }
        return result;
    }
}
