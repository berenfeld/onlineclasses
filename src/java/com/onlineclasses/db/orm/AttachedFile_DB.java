/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.db.orm;

import com.j256.ormlite.stmt.PreparedQuery;
import com.j256.ormlite.stmt.QueryBuilder;
import com.j256.ormlite.stmt.SelectArg;
import com.j256.ormlite.stmt.UpdateBuilder;
import com.j256.ormlite.stmt.Where;
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

        queryBuilder.where().eq(AttachedFile.OCLASS_FIELD, _getClassAttachedFilesClassArg);
        queryBuilder.orderBy(AttachedFile.ADDED_FIELD, true);
        _getClassAttachedFiles = queryBuilder.prepare();
        
        queryBuilder.reset();
        Where<AttachedFile, Integer> where = queryBuilder.where();
        where.eq(AttachedFile.OCLASS_FIELD, _getClassAttachedFileByNameClassArg);
        where.and();
        where.eq(AttachedFile.NAME_FIELD, _getClassAttachedFileByNameFileNameArg);        
        _getClassAttachedFileByName = queryBuilder.prepare();
    }

    private final PreparedQuery<AttachedFile> _getClassAttachedFiles;
    private final SelectArg _getClassAttachedFilesClassArg = new SelectArg();

    private final PreparedQuery<AttachedFile> _getClassAttachedFileByName;
    private final SelectArg _getClassAttachedFileByNameClassArg = new SelectArg();
    private final SelectArg _getClassAttachedFileByNameFileNameArg = new SelectArg();
    
    public synchronized List<AttachedFile> getClassAttachedFiles(OClass oClass) throws SQLException {
        _getClassAttachedFilesClassArg.setValue(oClass);
        return _dao.query(_getClassAttachedFiles);
    }

    public int updateAttachedFileUploadedBytes(AttachedFile attachedFile) throws SQLException {
        UpdateBuilder<AttachedFile, Integer> updateBuilder = _dao.updateBuilder();
        updateBuilder.where().idEq(attachedFile.id);
        updateBuilder.updateColumnValue(AttachedFile.UPLOADED_FIELD, attachedFile.uploaded);
        return updateBuilder.update();
    }
    
    public synchronized AttachedFile getClassAttachedFile(OClass oClass, String fileName) throws SQLException {
        _getClassAttachedFileByNameClassArg.setValue(oClass);
        _getClassAttachedFileByNameFileNameArg.setValue(fileName);
        return _dao.queryForFirst(_getClassAttachedFileByName);
    }
}
