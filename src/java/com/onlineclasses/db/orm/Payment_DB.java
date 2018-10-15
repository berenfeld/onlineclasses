/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.db.orm;

import com.j256.ormlite.stmt.PreparedQuery;
import com.j256.ormlite.stmt.QueryBuilder;
import com.j256.ormlite.stmt.SelectArg;
import com.j256.ormlite.stmt.Where;
import com.j256.ormlite.support.ConnectionSource;
import com.onlineclasses.entities.OClass;
import com.onlineclasses.entities.Payment;
import com.onlineclasses.utils.Utils;
import java.sql.SQLException;

/**
 *
 * @author me
 */
public class Payment_DB extends Base_DB<Payment> {

    public Payment_DB(ConnectionSource connectionSource) throws SQLException {
        super(connectionSource, Payment.class);
        
        QueryBuilder<Payment, Integer> queryBuilder = _dao.queryBuilder();
        Where<Payment, Integer> where = queryBuilder.where();
        where.eq(Payment.OCLASS_COLUMN, _getPaymentOfClassArg);
        _getPaymentOfClass = queryBuilder.prepare();
    }
    
    private final PreparedQuery<Payment> _getPaymentOfClass;
    private final SelectArg _getPaymentOfClassArg = new SelectArg();
    
    public Payment getPaymentOfClass(OClass oClass) throws SQLException
    {
        _getPaymentOfClassArg.setValue(oClass);
        return Utils.getFirstElement(_dao.query(_getPaymentOfClass));
    }
}
