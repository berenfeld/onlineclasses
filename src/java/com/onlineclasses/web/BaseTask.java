/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.web;

import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;

/**
 *
 * @author me
 */
public abstract class BaseTask extends TimerTask {
    BaseTask(String name)
    {
        this.name = name;        
    }
        
    public void schedule(int intervalInMinutes)
    {
        timer.scheduleAtFixedRate(this, new Date(), intervalInMinutes * 60 * 1000);
    }
    
    public void schedule(Date start, int intervalInSeconds)
    {
        timer.scheduleAtFixedRate(this, start, intervalInSeconds * 1000);
    }
        
    protected abstract void runTask() throws Exception;

    public void run() {
        try {
            Utils.info("start task " + name);
        } catch (Exception ex) {
            Utils.warning("exception on timer " + name);
            Utils.exception(ex);
        }
        Utils.info("end task " + name);
    }
    
    public static void init()
    {
        timer = new Timer();
    }
    
    public static void close()
    {
        timer.cancel();
        Utils.info("scheduled tasks terminated");
    }
    private static Timer timer;    
    private String name;
}
