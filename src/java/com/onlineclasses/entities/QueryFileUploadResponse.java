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
public class QueryFileUploadResponse extends BasicResponse {
    public QueryFileUploadResponse()
    {
        super(0,"");
    }
    
    public int uploaded;
    public int file_size;
}
