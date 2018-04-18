/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.web;

import com.onlineclasses.db.DB;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;


public class ContextListener implements ServletContextListener {
    

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        Utils.info("context init");
        Config.init();
        CConfig.init();
        DB.init();
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
         Utils.info("context destroy");
        
    }
    
}
