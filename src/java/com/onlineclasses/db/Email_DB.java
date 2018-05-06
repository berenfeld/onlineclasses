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
import com.j256.ormlite.support.ConnectionSource;
import com.j256.ormlite.table.TableUtils;
import com.onlineclasses.entities.Email;
import com.onlineclasses.entities.Student;
import com.onlineclasses.entities.User;
import com.onlineclasses.web.Utils;
import java.sql.Connection;
import java.sql.SQLException;
import javax.sql.DataSource;

/**
 *
 * @author me
 */
public class Email_DB extends Base_DB<Email> {

    public Email_DB(ConnectionSource connectionSource) throws SQLException {
        super(connectionSource, Email.class);
    }
}
