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
public class LoginResponse extends BasicResponse {

    public LoginResponse(User user) {
        super(0, "");
        this.user = user;
    }

    public User user;
}
