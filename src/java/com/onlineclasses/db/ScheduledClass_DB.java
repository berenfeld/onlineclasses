/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.db;

import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.dao.DaoManager;
import com.j256.ormlite.stmt.PreparedQuery;
import com.j256.ormlite.stmt.QueryBuilder;
import com.j256.ormlite.stmt.SelectArg;
import com.j256.ormlite.stmt.Where;
import com.j256.ormlite.support.ConnectionSource;
import com.onlineclasses.entities.ScheduledClass;
import com.onlineclasses.entities.Student;
import com.onlineclasses.entities.Teacher;
import com.onlineclasses.entities.User;
import com.onlineclasses.web.Utils;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.sql.DataSource;

/**
 *
 * @author me
 */
public class ScheduledClass_DB {

    public ScheduledClass_DB(DataSource dataSource, ConnectionSource connectionSource) throws SQLException {
        _dataSource = dataSource;
        _scheduledClassesDao = DaoManager.createDao(connectionSource, ScheduledClass.class);        
    }

    private DataSource _dataSource;
    private static Dao<ScheduledClass, Integer> _scheduledClassesDao;
    

    public Dao dao() {
        return _scheduledClassesDao;
    }

    public void addScheduledClass(ScheduledClass scheduledClass) throws SQLException {
        _scheduledClassesDao.create(scheduledClass);
    }

    public static ScheduledClass getScheduledClass(int id) throws SQLException {
        return _scheduledClassesDao.queryForId(id);
    }
}
