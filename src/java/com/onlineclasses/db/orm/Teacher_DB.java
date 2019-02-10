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
import com.onlineclasses.entities.Teacher;
import com.onlineclasses.entities.User;
import com.onlineclasses.utils.Utils;
import java.sql.SQLException;
import java.util.List;

/**
 *
 * @author me
 */
public class Teacher_DB extends Base_DB<Teacher> {

    public Teacher_DB(ConnectionSource connectionSource) throws SQLException {
        super(connectionSource, Teacher.class);
        QueryBuilder<Teacher, Integer> queryBuilder = _dao.queryBuilder();
        Where<Teacher, Integer> where = queryBuilder.where();
        where.ge(Teacher.PRICE_PER_HOUR_TEACHER_COLUMN, _teacherFindQueryMinPriceArg);
        where.and();
        where.le(Teacher.PRICE_PER_HOUR_TEACHER_COLUMN, _teacherFindQueryMaxPriceArg);
        where.and();
        where.like(User.DISPLAY_NAME_COLUMN, _teacherFindQueryNameArg);
        _teacherFindQuery = queryBuilder.prepare();
        queryBuilder.reset();
        queryBuilder.where().eq(Teacher.EMAIL_COLUMN, _queryByEmailArg);
        _queryByEmail = queryBuilder.prepare();
    }

    private static SelectArg _teacherFindQueryMinPriceArg = new SelectArg();
    private static SelectArg _teacherFindQueryMaxPriceArg = new SelectArg();
    private static SelectArg _teacherFindQueryNameArg = new SelectArg();
    private static PreparedQuery<Teacher> _teacherFindQuery;
    private final SelectArg _queryByEmailArg = new SelectArg();
    private final PreparedQuery<Teacher> _queryByEmail;

    public synchronized List<Teacher> findTeachers(int minPrice, int maxPrice, String displayName) throws SQLException {
        _teacherFindQueryMinPriceArg.setValue(minPrice);
        _teacherFindQueryMaxPriceArg.setValue(maxPrice);
        _teacherFindQueryNameArg.setValue("%" + displayName + "%");
        Utils.debug("find teacher with args min price " + minPrice + " max price " + maxPrice + " display name " + displayName);
        return _dao.query(_teacherFindQuery);
    }

    public synchronized Teacher getTeacherByEmail(String email) throws SQLException {
        _queryByEmailArg.setValue(email);
        return _dao.queryForFirst(_queryByEmail);
    }
}
