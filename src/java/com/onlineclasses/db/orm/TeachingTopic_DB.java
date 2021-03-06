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
import com.onlineclasses.entities.Teacher;
import com.onlineclasses.entities.TeachingTopic;
import java.sql.SQLException;
import java.util.List;

/**
 *
 * @author me
 */
public class TeachingTopic_DB extends Base_DB<TeachingTopic> {

    public TeachingTopic_DB(ConnectionSource connectionSource) throws SQLException {
        super(connectionSource, TeachingTopic.class);
        QueryBuilder<TeachingTopic, Integer> queryBuilder = _dao.queryBuilder();
        Where<TeachingTopic, Integer> where = queryBuilder.where();
        where.eq(TeachingTopic.TEACHER_ID_COLUMN, _getTeacherTeachingTopicsTeacherIdArg);
        _getTeacherTeachingTopicsQuery = queryBuilder.prepare();

        DeleteBuilder<TeachingTopic, Integer> deleteBuilder = _dao.deleteBuilder();
        where = deleteBuilder.where();
        where.eq(TeachingTopic.TEACHER_ID_COLUMN, _deleteTeacherTeachingTopicsTeacherIdArg);
        _deleteTeacherTeachingTopicsQuery = deleteBuilder.prepare();
    }

    private final SelectArg _getTeacherTeachingTopicsTeacherIdArg = new SelectArg();
    private final PreparedQuery<TeachingTopic> _getTeacherTeachingTopicsQuery;
    private final SelectArg _deleteTeacherTeachingTopicsTeacherIdArg = new SelectArg();
    private final PreparedDelete<TeachingTopic> _deleteTeacherTeachingTopicsQuery;

    public synchronized List<TeachingTopic> getTeacherTeachingTopics(Teacher teacher) throws SQLException {
        _getTeacherTeachingTopicsTeacherIdArg.setValue(teacher);
        return _dao.query(_getTeacherTeachingTopicsQuery);
    }

    public synchronized int deleteTeacherTeachingTopics(Teacher teacher) throws SQLException {
        _deleteTeacherTeachingTopicsTeacherIdArg.setValue(teacher);
        return _dao.delete(_deleteTeacherTeachingTopicsQuery);
    }
}
