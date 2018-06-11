/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.db.orm;

import com.j256.ormlite.stmt.DeleteBuilder;
import com.j256.ormlite.stmt.PreparedDelete;
import com.j256.ormlite.stmt.PreparedQuery;
import com.j256.ormlite.stmt.QueryBuilder;
import com.j256.ormlite.stmt.SelectArg;
import com.j256.ormlite.stmt.Where;
import com.j256.ormlite.support.ConnectionSource;
import com.onlineclasses.entities.AvailableTime;
import com.onlineclasses.entities.Teacher;
import java.sql.SQLException;
import java.util.List;

/**
 *
 * @author me
 */
public class AvailableTime_DB extends Base_DB<AvailableTime> {

    public AvailableTime_DB(ConnectionSource connectionSource) throws SQLException {
        super(connectionSource, AvailableTime.class);
        
        QueryBuilder<AvailableTime, Integer> queryBuilder = _dao.queryBuilder();
        Where<AvailableTime, Integer> where = queryBuilder.where();
        where.eq(AvailableTime.TEACHER_ID_COLUMN, _getTeacherAvailableTimeTeacherIdArg);        
        queryBuilder.orderBy(AvailableTime.DAY_COLUMN, true);
        _getTeacherAvailableTimeQuery = queryBuilder.prepare();
        
        DeleteBuilder<AvailableTime, Integer> deleteBuilder = _dao.deleteBuilder();
        where = deleteBuilder.where();
        where.eq(AvailableTime.TEACHER_ID_COLUMN, _getTeacherAvailableTimeTeacherIdArg);        
        _deleteTeacherAvailableTimeQuery = deleteBuilder.prepare();
        
    }


    private final SelectArg _getTeacherAvailableTimeTeacherIdArg = new SelectArg();
    private final PreparedQuery<AvailableTime> _getTeacherAvailableTimeQuery;
    private final SelectArg _deleteTeacherAvailableTimeTeacherIdArg = new SelectArg();
    private final PreparedDelete<AvailableTime> _deleteTeacherAvailableTimeQuery;
    
    public synchronized List<AvailableTime> getTeacherAvailableTime(Teacher teacher) throws SQLException {        
        _getTeacherAvailableTimeTeacherIdArg.setValue(teacher);
        return _dao.query(_getTeacherAvailableTimeQuery);
    }
 
    public synchronized int deleteTeacherAvailableTime(Teacher teacher) throws SQLException {        
        _deleteTeacherAvailableTimeTeacherIdArg.setValue(teacher);
        return _dao.delete(_deleteTeacherAvailableTimeQuery);
    }
    
}
