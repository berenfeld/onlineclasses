/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.utils;

import java.util.Locale;
import java.util.ResourceBundle;

/**
 *
 * @author me
 */
public class Labels {

    private static ResourceBundle labels = ResourceBundle.getBundle("labels", new Locale(Config.get("website.language"), Config.get("website.country")));

    public static String get(String key) {
        try {
            return labels.getString(key);
        } catch (java.util.MissingResourceException ex) {
            return "";
        }
    }
}
