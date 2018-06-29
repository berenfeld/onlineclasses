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
import com.onlineclasses.entities.FacebookUser;
import com.onlineclasses.utils.Utils;
import java.sql.SQLException;

/**
 *
 * @author me
 */
public class FacebookUser_DB extends Base_DB<FacebookUser> {

    public FacebookUser_DB(ConnectionSource connectionSource) throws SQLException {
        super(connectionSource, FacebookUser.class);
        QueryBuilder<FacebookUser, Integer> queryBuilder = _dao.queryBuilder();
        queryBuilder.where().eq(FacebookUser.FACEBOOK_ID_COLUMN, _queryByFacebookIDArg);
        _queryByFacebookID = queryBuilder.prepare();

    }
    private final SelectArg _queryByFacebookIDArg = new SelectArg();
    private final PreparedQuery<FacebookUser> _queryByFacebookID;

    public FacebookUser getFacebookUserByFacebookID(String facebook_id) {

        try {
            _queryByFacebookIDArg.setValue(facebook_id);
            FacebookUser facebookUser = _dao.queryForFirst(_queryByFacebookID);
            return facebookUser;
        } catch (SQLException ex) {
            Utils.exception(ex);
            return null;
        }
    }
}
