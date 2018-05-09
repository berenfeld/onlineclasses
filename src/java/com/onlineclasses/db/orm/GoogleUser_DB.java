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
import com.onlineclasses.entities.GoogleUser;
import com.onlineclasses.entities.Teacher;
import com.onlineclasses.utils.Utils;
import java.sql.SQLException;

/**
 *
 * @author me
 */
public class GoogleUser_DB extends Base_DB<GoogleUser> {

    public GoogleUser_DB(ConnectionSource connectionSource) throws SQLException {
        super(connectionSource, GoogleUser.class);

        QueryBuilder<GoogleUser, Integer> queryBuilder = _dao.queryBuilder();
        queryBuilder.where().eq(Teacher.EMAIL_COLUMN, _queryByEmailArg);
        _queryByEmail = queryBuilder.prepare();

    }
    private final SelectArg _queryByEmailArg = new SelectArg();
    private final PreparedQuery<GoogleUser> _queryByEmail;

    public GoogleUser getGoogleUserByEmail(String email) {

        try {
            _queryByEmailArg.setValue(email);
            GoogleUser googleUser = _dao.queryForFirst(_queryByEmail);
            return googleUser;
        } catch (SQLException ex) {
            Utils.exception(ex);
            return null;
        }
    }
}
