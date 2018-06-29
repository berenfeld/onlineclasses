/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.utils;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.ResourceBundle;

/**
 *
 * @author me
 */
public class CLabels {

    private static ResourceBundle labels = ResourceBundle.getBundle("clabels", new Locale(Config.get("website.language"), Config.get("website.country")));

    public static Map<String, String> getAll() {
        Map<String, String> result = new HashMap();
        for (String key : labels.keySet()) {
            result.put(key, get(key));
        }
        return result;
    }

    public static String get(String key) {
        try {
            return labels.getString(key);
        } catch (java.util.MissingResourceException ex) {
            return "";
        }
    }
}
