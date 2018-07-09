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
import com.onlineclasses.entities.Student;
import com.onlineclasses.entities.LearningTopic;
import java.sql.SQLException;
import java.util.List;

/**
 *
 * @author me
 */
public class LearningTopic_DB extends Base_DB<LearningTopic> {

    public LearningTopic_DB(ConnectionSource connectionSource) throws SQLException {
        super(connectionSource, LearningTopic.class);
        QueryBuilder<LearningTopic, Integer> queryBuilder = _dao.queryBuilder();
        Where<LearningTopic, Integer> where = queryBuilder.where();
        where.eq(LearningTopic.STUDENT_ID_COLUMN, _getStudentLearningTopicsStudentIdArg);
        _getStudentLearningTopicsQuery = queryBuilder.prepare();

        DeleteBuilder<LearningTopic, Integer> deleteBuilder = _dao.deleteBuilder();
        where = deleteBuilder.where();
        where.eq(LearningTopic.STUDENT_ID_COLUMN, _deleteStudentLearningTopicsStudentIdArg);
        _deleteStudentLearningTopicsQuery = deleteBuilder.prepare();
    }

    private final SelectArg _getStudentLearningTopicsStudentIdArg = new SelectArg();
    private final PreparedQuery<LearningTopic> _getStudentLearningTopicsQuery;
    private final SelectArg _deleteStudentLearningTopicsStudentIdArg = new SelectArg();
    private final PreparedDelete<LearningTopic> _deleteStudentLearningTopicsQuery;

    public synchronized List<LearningTopic> getStudentLearningTopics(Student teacher) throws SQLException {
        _getStudentLearningTopicsStudentIdArg.setValue(teacher);
        return _dao.query(_getStudentLearningTopicsQuery);
    }

    public synchronized int deleteStudentLearningTopics(Student teacher) throws SQLException {
        _deleteStudentLearningTopicsStudentIdArg.setValue(teacher);
        return _dao.delete(_deleteStudentLearningTopicsQuery);
    }
}
