/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.servlets.entities;

import com.onlineclasses.entities.BasicRequest;
import java.util.Date;

/**
 *
 * @author me
 */
public class RegisterStudentRequest extends BasicRequest {
    public RegisterStudentRequest()
    {
    }
    public String google_id_token;    
    public String email;
    public String first_name;
    public String last_name;
    public String display_name;
    public String phone_number;
    public String phone_area;
    public int gender;
    public Date day_of_birth;   
    public int institute_id;
    public String institute_name;
}
