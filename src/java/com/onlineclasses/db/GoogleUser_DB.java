/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.db;

import com.j256.ormlite.stmt.PreparedQuery;
import com.j256.ormlite.stmt.QueryBuilder;
import com.j256.ormlite.stmt.SelectArg;
import com.j256.ormlite.stmt.Where;
import com.j256.ormlite.support.ConnectionSource;
import com.onlineclasses.entities.GoogleUser;
import com.onlineclasses.entities.User;
import com.onlineclasses.web.Utils;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author me
 */
public class GoogleUser_DB extends Base_DB<GoogleUser> {

    public GoogleUser_DB(ConnectionSource connectionSource) throws SQLException {
        super(connectionSource, GoogleUser.class);

    }
}
