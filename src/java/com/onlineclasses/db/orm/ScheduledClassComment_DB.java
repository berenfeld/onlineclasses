/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.db.orm;

import com.j256.ormlite.stmt.PreparedQuery;
import com.j256.ormlite.stmt.QueryBuilder;
import com.j256.ormlite.stmt.SelectArg;
import com.j256.ormlite.support.ConnectionSource;
import com.onlineclasses.entities.Email;
import com.onlineclasses.entities.ScheduledClass;
import com.onlineclasses.entities.ScheduledClassComment;
import java.sql.SQLException;
import java.util.List;

/**
 *
 * @author me
 */
public class ScheduledClassComment_DB extends Base_DB<ScheduledClassComment> {

    public ScheduledClassComment_DB(ConnectionSource connectionSource) throws SQLException {
        super(connectionSource, ScheduledClassComment.class);
        QueryBuilder<ScheduledClassComment, Integer> queryBuilder = _dao.queryBuilder();
        
        queryBuilder.where().eq(ScheduledClassComment.SCHEDULED_CLASS_FIELD, _getScheuduledClassCommentsScheduledClassArg);
        queryBuilder.orderBy(ScheduledClassComment.ADDED_FIELD, true);
        _getScheuduledClassComments = queryBuilder.prepare();        
    }
    
    private final PreparedQuery<ScheduledClassComment> _getScheuduledClassComments;
    private final SelectArg _getScheuduledClassCommentsScheduledClassArg = new SelectArg();
    
    public synchronized List<ScheduledClassComment> getScheuduledClassComments(ScheduledClass scheduledClass) throws SQLException
    {
        _getScheuduledClassCommentsScheduledClassArg.setValue(scheduledClass);
        return _dao.query(_getScheuduledClassComments);
    }
}
