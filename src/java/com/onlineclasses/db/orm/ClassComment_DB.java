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
import com.onlineclasses.entities.OClass;
import com.onlineclasses.entities.ClassComment;
import java.sql.SQLException;
import java.util.List;

/**
 *
 * @author me
 */
public class ClassComment_DB extends Base_DB<ClassComment> {

    public ClassComment_DB(ConnectionSource connectionSource) throws SQLException {
        super(connectionSource, ClassComment.class);
        QueryBuilder<ClassComment, Integer> queryBuilder = _dao.queryBuilder();

        queryBuilder.where().eq(ClassComment.OCLASS_FIELD, _getScheuduledClassCommentsScheduledClassArg);
        queryBuilder.orderBy(ClassComment.ADDED_FIELD, true);
        _getScheuduledClassComments = queryBuilder.prepare();
    }

    private final PreparedQuery<ClassComment> _getScheuduledClassComments;
    private final SelectArg _getScheuduledClassCommentsScheduledClassArg = new SelectArg();

    public synchronized List<ClassComment> getScheuduledClassComments(OClass oClass) throws SQLException {
        _getScheuduledClassCommentsScheduledClassArg.setValue(oClass);
        return _dao.query(_getScheuduledClassComments);
    }
}
