/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.utils;

import java.io.IOException;
import java.util.Properties;

/**
 *
 * @author me
 */
public class Config {

    private static Properties _properties;

    public static void init() {
        _properties = new Properties();
        try {
            _properties.load(Config.class.getClassLoader().getResourceAsStream("config.properties"));
            Utils.info("Configuration loaded : ");
            for (Object key : _properties.keySet()) {
                Utils.info(key + "=" + _properties.get(key));
            }
        } catch (IOException ex) {
            Utils.exception(ex);
        }
    }

    public static String get(String property) {
        return (String) _properties.get(property);
    }

    public static boolean getBool(String property) {
        return Boolean.valueOf(get(property));
    }

    public static int getInt(String property) {
        return Integer.valueOf(get(property));
    }    
}
