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
import com.onlineclasses.entities.InstituteType;
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

public class ScheduledClass_DB extends Base_DB<ScheduledClass>{

    public ScheduledClass_DB(ConnectionSource connectionSource) throws SQLException {
        super(connectionSource, ScheduledClass.class);        
        
        QueryBuilder<ScheduledClass, Integer> queryBuilder = dao().queryBuilder();
        
        Where<ScheduledClass, Integer> where = queryBuilder.where();
        where.eq(ScheduledClass.TEACHER_ID_COLUMN, _getTeacherClassesTeacherArg);
        _getTeacherClasses = queryBuilder.prepare();          
    }
    
    private final PreparedQuery<ScheduledClass> _getTeacherClasses;
    private final SelectArg _getTeacherClassesTeacherArg = new SelectArg();
    
    public synchronized List<ScheduledClass> getTeacherScheduledClasses(Teacher teacher) throws SQLException
    {
        _getTeacherClassesTeacherArg.setValue(teacher);
        return dao().query(_getTeacherClasses);
    }
}
