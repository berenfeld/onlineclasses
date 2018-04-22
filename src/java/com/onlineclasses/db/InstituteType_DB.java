/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.db;

import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.dao.DaoManager;
import com.j256.ormlite.stmt.PreparedQuery;
import com.j256.ormlite.stmt.QueryBuilder;
import com.j256.ormlite.stmt.SelectArg;
import com.j256.ormlite.stmt.Where;
import com.j256.ormlite.support.ConnectionSource;
import com.onlineclasses.entities.InstituteType;
import com.onlineclasses.entities.Student;
import com.onlineclasses.entities.Teacher;
import com.onlineclasses.entities.User;
import com.onlineclasses.web.Utils;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.sql.DataSource;

/**
 *
 * @author me
 */
public class InstituteType_DB {

    public InstituteType_DB(DataSource dataSource, ConnectionSource connectionSource) throws SQLException {
        _dataSource = dataSource;
        _instituteTypeDao = DaoManager.createDao(connectionSource, InstituteType.class);
    }

    private DataSource _dataSource;
    private Dao<InstituteType, Integer> _instituteTypeDao;

    public Dao dao() {
        return _instituteTypeDao;
    }

    public void addInstituteType(InstituteType instituteType) throws SQLException {
        _instituteTypeDao.create(instituteType);
    }

}
