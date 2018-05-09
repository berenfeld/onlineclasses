/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.db.orm;

import com.j256.ormlite.stmt.PreparedQuery;
import com.j256.ormlite.stmt.QueryBuilder;
import com.j256.ormlite.stmt.SelectArg;
import com.j256.ormlite.stmt.Where;
import com.j256.ormlite.support.ConnectionSource;
import com.onlineclasses.entities.ScheduledClass;
import com.onlineclasses.entities.Teacher;
import java.sql.SQLException;
import java.util.List;

public class ScheduledClass_DB extends Base_DB<ScheduledClass>{

    public ScheduledClass_DB(ConnectionSource connectionSource) throws SQLException {
        super(connectionSource, ScheduledClass.class);        
        
        QueryBuilder<ScheduledClass, Integer> queryBuilder = _dao.queryBuilder();
        
        Where<ScheduledClass, Integer> where = queryBuilder.where();
        where.eq(ScheduledClass.TEACHER_ID_COLUMN, _getTeacherClassesTeacherArg);
        where.and();
        where.ne(ScheduledClass.STATUS_COLUMN, ScheduledClass.STATUS_CANCELCED);
        _getTeacherNotCanceledClasses = queryBuilder.prepare();          
    }
    
    private final PreparedQuery<ScheduledClass> _getTeacherNotCanceledClasses;
    private final SelectArg _getTeacherClassesTeacherArg = new SelectArg();
    
    public synchronized List<ScheduledClass> getTeacherNotCanceledScheduledClasses(Teacher teacher) throws SQLException
    {
        _getTeacherClassesTeacherArg.setValue(teacher);
        return _dao.query(_getTeacherNotCanceledClasses);
    }
}
