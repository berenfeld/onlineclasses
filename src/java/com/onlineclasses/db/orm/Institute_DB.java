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
import com.onlineclasses.entities.Institute;
import com.onlineclasses.entities.InstituteType;
import com.onlineclasses.utils.Utils;
import java.sql.SQLException;
import java.util.List;

/**
 *
 * @author me
 */
public class Institute_DB extends Base_DB<Institute> {

    public Institute_DB(ConnectionSource connectionSource) throws SQLException {
        super(connectionSource, Institute.class);
        QueryBuilder<Institute, Integer> queryBuilder = _dao.queryBuilder();
        queryBuilder.where().eq(Institute.INSTITUTE_TYPE_FIELD, _queryByInstituteTypeArg);
        _queryByInstituteType = queryBuilder.prepare();
        
        queryBuilder.reset();
        queryBuilder.where().eq(Institute.INSTITUTE_NAME_FIELD, _queryByNameArg);
        _queryByName = queryBuilder.prepare();
        
    }

    private final SelectArg _queryByInstituteTypeArg = new SelectArg();
    private final PreparedQuery<Institute> _queryByInstituteType;
    
    private final SelectArg _queryByNameArg = new SelectArg();
    private final PreparedQuery<Institute> _queryByName;

    public synchronized List<Institute> getInstitutes(InstituteType instituteType) throws SQLException {
        _queryByInstituteTypeArg.setValue(instituteType);
        return _dao.query(_queryByInstituteType);
    }
    
    public synchronized Institute getInstituteByName(String name) throws SQLException {
        _queryByNameArg.setValue(name);
        return Utils.getFirstElement(_dao.query(_queryByName));
    }
}
