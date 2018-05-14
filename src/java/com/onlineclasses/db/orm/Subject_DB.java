/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.db.orm;

import com.j256.ormlite.support.ConnectionSource;
import com.onlineclasses.entities.Email;
import com.onlineclasses.entities.Subject;
import java.sql.SQLException;

/**
 *
 * @author me
 */
public class Subject_DB extends Base_DB<Subject> {

    public Subject_DB(ConnectionSource connectionSource) throws SQLException {
        super(connectionSource, Subject.class);
    }
}
