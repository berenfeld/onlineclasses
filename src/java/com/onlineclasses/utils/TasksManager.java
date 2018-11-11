/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.utils;

import com.onlineclasses.tasks.CancelUnPaidClassesTask;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author me
 */
public class TasksManager {

    public static void init() {
        BaseTask.init();
                        
        _emailSeneder = new EmailSender();
        addTask(_emailSeneder);
        
        _cancelUnPaidClasses = new CancelUnPaidClassesTask();
        addTask(_cancelUnPaidClasses);
        
    }

    public static void addTask(BaseTask task)
    {
        if ( _tasks.get(task.getName()) != null ) {
            throw new RuntimeException("Task " + task.getName() + " already added");
        }
        
        int interval = Config.getInt("tasks." + task.getName() + ".interval");
        if (interval > 0) {
            Utils.info("task " + task.getName() + " scheduled every " + interval + " seconds");
            task.schedule(interval);
        }
        _tasks.put(task.getName(), task);
    }
    
    public static void close() {
        BaseTask.close();
    }

    public static void runNow(String name) {
        _tasks.get(name).runNow();
    }

    private static final Map<String, BaseTask> _tasks = new HashMap<>();
   
    private static EmailSender _emailSeneder;
    private static CancelUnPaidClassesTask _cancelUnPaidClasses;    

}
