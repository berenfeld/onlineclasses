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
public class RegisterStudentRequest extends BasicRequest {
    public RegisterStudentRequest()
    {
    }
    public String google_id_token;    
    public String first_name;
    public String last_name;
    public String display_name;
    public String phone_number;
    public int gender;
}
