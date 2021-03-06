/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.web;

import com.onlineclasses.db.DB;
import com.onlineclasses.utils.CConfig;
import com.onlineclasses.utils.Config;
import com.onlineclasses.utils.TasksManager;
import com.onlineclasses.utils.Utils;
import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

public class ContextListener implements ServletContextListener {

    
           
    @Override
    public void contextInitialized(ServletContextEvent sce) {        
        Utils.info("context init");

        System.setProperty("com.j256.ormlite.logger.type", "LOCAL");
        System.setProperty("com.j256.ormlite.logger.level", "ERROR");

        Config.init();
        CConfig.init();
        DB.init();
        TasksManager.init();

        Utils.SERVLET_CONTEXT = sce.getServletContext();
        
        Utils.info("context init done");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        Utils.info("context destory");

        TasksManager.close();
        DB.close();
        Utils.info("context destory done");
    }

}
