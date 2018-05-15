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
import com.onlineclasses.entities.ScheduledClassAttachedFile;
import java.sql.SQLException;
import java.util.List;

/**
 *
 * @author me
 */
public class ScheduledClassAttachedFile_DB extends Base_DB<ScheduledClassAttachedFile> {

    public ScheduledClassAttachedFile_DB(ConnectionSource connectionSource) throws SQLException {
        super(connectionSource, ScheduledClassAttachedFile.class);
        QueryBuilder<ScheduledClassAttachedFile, Integer> queryBuilder = _dao.queryBuilder();
        
        queryBuilder.where().eq(ScheduledClassAttachedFile.SCHEDULED_CLASS_FIELD, _getScheuduledClassAttachedFilesScheduledClassArg);
        queryBuilder.orderBy(ScheduledClassAttachedFile.ADDED_FIELD, true);
        _getScheuduledClassAttachedFiles = queryBuilder.prepare();        
    }
    
    private final PreparedQuery<ScheduledClassAttachedFile> _getScheuduledClassAttachedFiles;
    private final SelectArg _getScheuduledClassAttachedFilesScheduledClassArg = new SelectArg();
    
    public synchronized List<ScheduledClassAttachedFile> getScheuduledClassAttachedFiles(ScheduledClass scheduledClass) throws SQLException
    {
        _getScheuduledClassAttachedFilesScheduledClassArg.setValue(scheduledClass);
        return _dao.query(_getScheuduledClassAttachedFiles);
    }
}
