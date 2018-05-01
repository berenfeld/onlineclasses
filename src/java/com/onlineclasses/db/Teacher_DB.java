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
public class Teacher_DB extends Base_DB<Teacher>{

    public Teacher_DB(ConnectionSource connectionSource) throws SQLException {
        super(connectionSource, Teacher.class);
        QueryBuilder<Teacher, Integer> queryBuilder = dao().queryBuilder();
        Where<Teacher, Integer> where = queryBuilder.where();
        where.ge(Teacher.PRICE_PER_HOUR_COLUMN, _teacherFindQueryMinPriceArg);
        where.and();
        where.le(Teacher.PRICE_PER_HOUR_COLUMN, _teacherFindQueryMaxPriceArg);
        where.and();
        where.like(User.DISPLAY_NAME_COLUMN, _teacherFindQueryNameArg);
        _teacherFindQuery = queryBuilder.prepare();
    }

    private static SelectArg _teacherFindQueryMinPriceArg = new SelectArg();
    private static SelectArg _teacherFindQueryMaxPriceArg = new SelectArg();
    private static SelectArg _teacherFindQueryNameArg = new SelectArg();
    private static PreparedQuery<Teacher> _teacherFindQuery;

    public synchronized List<Teacher> findTeachers(int minPrice, int maxPrice, String displayName) {
        try {
            _teacherFindQueryMinPriceArg.setValue(minPrice);
            _teacherFindQueryMaxPriceArg.setValue(maxPrice);
            _teacherFindQueryNameArg.setValue("%" + displayName + "%");
            Utils.info("find teacher with args min price " + minPrice + " max price " + maxPrice + " display name " + displayName);
            return dao().query(_teacherFindQuery);
        } catch (SQLException ex) {
            Utils.exception(ex);
            return new ArrayList<Teacher>();
        }
    }   
}
