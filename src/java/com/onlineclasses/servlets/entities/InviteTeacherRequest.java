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
public class InviteTeacherRequest extends BasicRequest {

    public InviteTeacherRequest() {

    }

    public String teacher_name;
    public String teacher_email;
}
