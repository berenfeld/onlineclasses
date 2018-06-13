/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.servlets.entities;

import com.onlineclasses.entities.AvailableTime;
import com.onlineclasses.entities.BasicRequest;
import java.util.Date;
import java.util.List;

/**
 *
 * @author me
 */
public class UpdateTeacherRequest extends BasicRequest {

    public UpdateTeacherRequest() {
    }
    public String first_name;
    public String last_name;
    public String display_name;    
    public String skype_name;
    public String moto;
    public boolean show_phone;
    public boolean show_email;
    public boolean show_skype;
    public boolean show_degree;
    public String degree_type;
    public int institute_id;
    public String institute_name;
    public int subject_id;
    public String subject_name;
    public List<Integer> teaching_topics;
    public int price_per_hour;
    public List<AvailableTime> available_times;

}