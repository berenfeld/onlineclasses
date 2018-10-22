/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.utils;

import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author me
 */
public class TasksManager {

    public static final int TASK_EMAIL = 1;

    public static void init() {
        BaseTask.init();
        
        _emailSeneder = new EmailSender();
        _emailSeneder.schedule(Config.getInt("mail.send_interval_minutes"));
        addTask(_emailSeneder);
        
    }

    public static void addTask(BaseTask task)
    {
        if ( _tasks.get(task.getName()) != null ) {
            throw new RuntimeException("Task " + task.getName() + " already added");
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

}
