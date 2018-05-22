/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.db.orm;

import com.j256.ormlite.support.ConnectionSource;
import com.onlineclasses.entities.Email;
import com.onlineclasses.entities.Subject;
import com.onlineclasses.entities.Topic;
import java.sql.SQLException;

/**
 *
 * @author me
 */
public class Topic_DB extends Base_DB<Topic> {

    public Topic_DB(ConnectionSource connectionSource) throws SQLException {
        super(connectionSource, Topic.class);
    }
}
