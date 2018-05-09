/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.utils;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author me
 */
public class TasksManager {
    
    public static final int TASK_EMAIL = 1;
    public static void init()
    {
         BaseTask.init();
         _emailSeneder = new EmailSender();
         _emailSeneder.schedule(Config.getInt("mail.send_interval_minutes"));
         _tasks.add(_emailSeneder);
    }
    
    public static void close() {
        BaseTask.close();
    }
    
    
    public static void runNow(int task)
    {
        _tasks.get(task - 1).runNow();
    }
      
    private static List<BaseTask> _tasks = new ArrayList<>();
    private static EmailSender _emailSeneder;

    
}
