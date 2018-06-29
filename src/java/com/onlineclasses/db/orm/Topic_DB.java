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
import com.onlineclasses.entities.Email;
import com.onlineclasses.entities.Subject;
import com.onlineclasses.entities.Topic;
import java.sql.SQLException;
import java.util.List;

/**
 *
 * @author me
 */
public class Topic_DB extends Base_DB<Topic> {

    public Topic_DB(ConnectionSource connectionSource) throws SQLException {
        super(connectionSource, Topic.class);
        QueryBuilder<Topic, Integer> queryBuilder = _dao.queryBuilder();
        Where<Topic, Integer> where = queryBuilder.where();
        where.like(Topic.NAME_COLUMN, "%" + _getTopicsByNameArg + "%");
        _getTopicsByName = queryBuilder.prepare();
    }

    private final SelectArg _getTopicsByNameArg = new SelectArg();
    private final PreparedQuery<Topic> _getTopicsByName;

    public synchronized List<Topic> getTopicsByName(String name) throws SQLException {
        _getTopicsByNameArg.setValue(name);
        return _dao.query(_getTopicsByName);
    }
}
