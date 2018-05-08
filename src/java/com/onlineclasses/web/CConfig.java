/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.web;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

/**
 *
 * @author me
 */
public class CConfig {

    private static Properties _properties;

    public static void init() {
        _properties = new Properties();
        try {
            _properties.load(CConfig.class.getClassLoader().getResourceAsStream("cconfig.properties"));
            Utils.info("Configuration loaded : ");
            for (Object key : _properties.keySet()) {
                Utils.info(key + "=" + _properties.get(key));
            }
        } catch (IOException ex) {
            Utils.exception(ex);
        }
    }

    public static Map<Object, Object> getAll() {
        Map<Object, Object> result = new HashMap();
        for (Object key : _properties.keySet()) {
            result.put(key, getObject(key));
        }
        return result;
    }

    public static Object getObject(Object property) {
        return _properties.get(property);
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
