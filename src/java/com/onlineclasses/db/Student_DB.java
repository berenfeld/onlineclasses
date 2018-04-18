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
public class Student_DB {

    public Student_DB(DataSource dataSource, ConnectionSource connectionSource) throws SQLException {
        _studentsDao = DaoManager.createDao(connectionSource, Student.class);
        QueryBuilder<Student, Integer> queryBuilder = _studentsDao.queryBuilder();
        queryBuilder.where().eq(Student.GOOGLE_ID_COLUMN, _userQueryByGoogleIdArg1);
        _userQueryByGoogleId = queryBuilder.prepare();
    }

    private DataSource _dataSource;
    private Dao<Student, Integer> _studentsDao;
    private SelectArg _userQueryByGoogleIdArg1 = new SelectArg();
    private PreparedQuery<Student> _userQueryByGoogleId;

    public User getUserByGoogleID(String google_id) {

        try {
            Connection connection = _dataSource.getConnection();
            _userQueryByGoogleIdArg1.setValue(google_id);

            User user = _studentsDao.queryForFirst(_userQueryByGoogleId);
            // TODO can also be a teacher
            return user;
        } catch (SQLException ex) {
            Utils.exception(ex);
            return null;
        }
    }

    public User getUser(int id) {
        try {
            User user = _studentsDao.queryForId(id);
            return user;
        } catch (SQLException ex) {
            Utils.exception(ex);
            return null;
        }
    }
    
    public void addStudent(Student student) throws SQLException {
        _studentsDao.create(student);
    }
}
