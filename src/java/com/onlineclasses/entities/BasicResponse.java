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
public class BasicResponse {
    public BasicResponse()
    {
        
    }
    
    public BasicResponse( int rc, String message)
    {
        this.rc = rc;
        this.message = message;
    }
    
    public int rc;
    public String message;
}
