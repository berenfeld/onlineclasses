/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.servlets.entities;

import com.onlineclasses.entities.BasicRequest;

/**
 *
 * @author me
 */
public class EmailUnsubscribeRequest extends BasicRequest {

    public EmailUnsubscribeRequest() {
    }
    public String email;
    public String hash;
}
