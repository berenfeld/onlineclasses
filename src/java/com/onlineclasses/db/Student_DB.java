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
import com.j256.ormlite.support.ConnectionSource;
import com.j256.ormlite.table.TableUtils;
import com.onlineclasses.entities.Student;
import com.onlineclasses.entities.User;
import com.onlineclasses.web.Utils;
import java.sql.Connection;
import java.sql.SQLException;
import javax.sql.DataSource;

/**
 *
 * @author me
 */
public class Student_DB extends Base_DB<Student> {

    public Student_DB(ConnectionSource connectionSource) throws SQLException {
        super(connectionSource, Student.class);
        QueryBuilder<Student, Integer> queryBuilder = dao().queryBuilder();
        queryBuilder.where().eq(Student.EMAIL_COLUMN, _userQueryByEmailArg);
        _userQueryByEmail = queryBuilder.prepare();
    }

    private SelectArg _userQueryByEmailArg = new SelectArg();
    private PreparedQuery<Student> _userQueryByEmail;
    
    public User getUserByEmail(String email) {

        try {
            _userQueryByEmailArg.setValue(email);

            User user = dao().queryForFirst(_userQueryByEmail);
            // TODO can also be a teacher
            return user;
        } catch (SQLException ex) {
            Utils.exception(ex);
            return null;
        }
    }

    public User getUser(int id) {
        try {
            User user = dao().queryForId(id);
            return user;
        } catch (SQLException ex) {
            Utils.exception(ex);
            return null;
        }
    }   
}
