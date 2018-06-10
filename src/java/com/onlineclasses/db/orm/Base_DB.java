/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.db.orm;

import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.dao.DaoManager;
import com.j256.ormlite.support.ConnectionSource;
import com.j256.ormlite.table.TableUtils;
import com.onlineclasses.entities.BasicEntity;
import com.onlineclasses.utils.Utils;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import static javafx.scene.input.KeyCode.T;

public class Base_DB<T> {

    public Base_DB(ConnectionSource connectionSource, Class<T> clazz) throws SQLException {
        _dao = DaoManager.createDao(connectionSource, clazz);
    }

    protected final Dao<T, Integer> _dao;

    public void createTable() throws SQLException {
        Utils.info("dropping and creating table " + _dao.getTableName());
        TableUtils.dropTable(_dao, true);
        TableUtils.createTable(_dao);
    }
    
    public int add(T t) throws SQLException {
        return _dao.create(t);
    }

    public List<T> getAll() throws SQLException {
        return _dao.queryForAll();
    }

    public T get(int id) throws SQLException {
        return _dao.queryForId(id);
    }
    
    public int delete(T t)throws SQLException {
        return _dao.delete(t);
    }    
    
    public Map<Integer, T> getAllMap() throws SQLException {
        List<T> all = getAll();
        Map<Integer, T > allMap = new HashMap<>();
        for (T t : all) {
            int id = ((BasicEntity)t).id;
            allMap.put(id, t);
        }
        return allMap;
    }

}
