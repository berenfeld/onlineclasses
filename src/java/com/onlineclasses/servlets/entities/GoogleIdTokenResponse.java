/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.servlets.entities;

import com.onlineclasses.entities.BasicResponse;

/**
 *
 * @author me
 */
public class GoogleIdTokenResponse extends BasicResponse {

    public GoogleIdTokenResponse(boolean email_exists) {
        super(0, "");
        this.email_exists = email_exists;
    }

    public boolean email_exists;

}
