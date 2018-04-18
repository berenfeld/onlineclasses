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
import com.onlineclasses.entities.AvailableTime;
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
public class AvailableTime_DB {

    public AvailableTime_DB(DataSource dataSource, ConnectionSource connectionSource) throws SQLException {
        _availableTimeDao = DaoManager.createDao(connectionSource, AvailableTime.class);
        QueryBuilder<AvailableTime, Integer> queryBuilder = _availableTimeDao.queryBuilder();
        Where<AvailableTime, Integer> where = queryBuilder.where();
        where.eq(AvailableTime.TEACHER_ID_COLUMN, _getTeacherAvailableTimeTeacherIdArg);        
        queryBuilder.orderBy(AvailableTime.DAY_COLUMN, true);
        _getTeacherAvailableTimeQuery = queryBuilder.prepare();
    }

    private DataSource _dataSource;
    private Dao<AvailableTime, Integer> _availableTimeDao;
    private SelectArg _getTeacherAvailableTimeTeacherIdArg = new SelectArg();
    private static PreparedQuery<AvailableTime> _getTeacherAvailableTimeQuery;
 
    public void addAvailableTime(AvailableTime availableTime) throws SQLException {
        _availableTimeDao.create(availableTime);
    }
    
    public synchronized List<AvailableTime> getTeacherAvailableTime(Teacher teacher) {        
        try {
            _getTeacherAvailableTimeTeacherIdArg.setValue(teacher);
            return _availableTimeDao.query(_getTeacherAvailableTimeQuery);
        } catch (SQLException ex) {
            Utils.exception(ex);
            return new ArrayList<AvailableTime>();
        }
    }
 
}
