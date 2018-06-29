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
public class JsErrorRequest extends BasicRequest {

    public JsErrorRequest() {

    }
    public String location_href;
    public String message;
    public String url;
    public int line_number;
    public String error_object;
}
