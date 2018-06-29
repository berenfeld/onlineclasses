/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.entities;

/**
 *
 * @author me
 */
public class LoginRequest extends BasicRequest {

    public LoginRequest() {

    }

    public String google_id_token;
    public String facebook_access_token;
}
