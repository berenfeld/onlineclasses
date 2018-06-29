/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.db.orm;

import com.j256.ormlite.support.ConnectionSource;
import com.onlineclasses.entities.City;
import com.onlineclasses.utils.Utils;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author me
 */
public class City_DB extends Base_DB<City> {

    public City_DB(ConnectionSource connectionSource) throws SQLException {
        super(connectionSource, City.class);
    }

    public City getCityByName(String name) throws SQLException {
        Map<String, Object> fieldValues = new HashMap();
        fieldValues.put(City.NAME_COLUMN, name);
        return Utils.getFirstElement(_dao.queryForFieldValues(fieldValues));
    }
}
