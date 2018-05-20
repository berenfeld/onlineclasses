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
import com.onlineclasses.entities.AttachedFile;
import java.sql.SQLException;
import java.util.List;

/**
 *
 * @author me
 */
public class AttachedFile_DB extends Base_DB<AttachedFile> {

    public AttachedFile_DB(ConnectionSource connectionSource) throws SQLException {
        super(connectionSource, AttachedFile.class);
        QueryBuilder<AttachedFile, Integer> queryBuilder = _dao.queryBuilder();
        
        queryBuilder.where().eq(AttachedFile.SCHEDULED_CLASS_FIELD, _getClassAttachedFilesScheduledClassArg);
        queryBuilder.orderBy(AttachedFile.ADDED_FIELD, true);
        _getClassAttachedFiles = queryBuilder.prepare();        
    }
    
    private final PreparedQuery<AttachedFile> _getClassAttachedFiles;
    private final SelectArg _getClassAttachedFilesScheduledClassArg = new SelectArg();
    
    public synchronized List<AttachedFile> getClassAttachedFiles(OClass scheduledClass) throws SQLException
    {
        _getClassAttachedFilesScheduledClassArg.setValue(scheduledClass);
        return _dao.query(_getClassAttachedFiles);
    }
}
