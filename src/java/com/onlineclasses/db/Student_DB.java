/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.db;

import com.j256.ormlite.stmt.PreparedQuery;
import com.j256.ormlite.stmt.QueryBuilder;
import com.j256.ormlite.stmt.SelectArg;
import com.j256.ormlite.stmt.UpdateBuilder;
import com.j256.ormlite.support.ConnectionSource;
import com.onlineclasses.entities.Student;
import com.onlineclasses.entities.User;
import com.onlineclasses.web.Utils;
import java.sql.SQLException;

/**
 *
 * @author me
 */
public class Student_DB extends Base_DB<Student> {

    public Student_DB(ConnectionSource connectionSource) throws SQLException {
        super(connectionSource, Student.class);
        QueryBuilder<Student, Integer> queryBuilder = _dao.queryBuilder();
        queryBuilder.where().eq(Student.EMAIL_COLUMN, _queryByEmailArg);
        _queryByEmail = queryBuilder.prepare();                
    }

    private final SelectArg _queryByEmailArg = new SelectArg();
    private final PreparedQuery<Student> _queryByEmail;
    
    public Student getStudentByEmail(String email) {

        try {
            _queryByEmailArg.setValue(email);

            Student student = _dao.queryForFirst(_queryByEmail);
            // TODO can also be a teacher
            return student;
        } catch (SQLException ex) {
            Utils.exception(ex);
            return null;
        }
    }

    public User getUser(int id) {
        try {
            User user = _dao.queryForId(id);
            return user;
        } catch (SQLException ex) {
            Utils.exception(ex);
            return null;
        }
    }   
    
    public int updateEmailEnabled(Student student) throws SQLException
    {
        UpdateBuilder<Student, Integer> updateBuilder = _dao.updateBuilder();
        updateBuilder.where().idEq(student.id);
        updateBuilder.updateColumnValue( Student.EMAILS_ENABLED_COLUMN, student.emails_enabled);
        return updateBuilder.update();
    }
}
