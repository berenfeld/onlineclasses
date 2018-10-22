/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.utils;

import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;

/**
 *
 * @author me
 */
public abstract class BaseTask {

    public BaseTask(String name) {
        this._name = name;
    }

    public String getName() {
        return _name;
    }
    private InternalTimerTask _timerTask;
    private long _period;

    private static class InternalTimerTask extends TimerTask {

        public InternalTimerTask(BaseTask baseTask) {
            _baseTask = baseTask;
        }

        private final BaseTask _baseTask;

        @Override
        public void run() {
            if (!Config.getBool("tasks." + _baseTask.getName() + ".enabled")) {
                Utils.warning("not running task '" + _baseTask.getName() + "' .task disabled");
                return;
            }
            _baseTask.run();
        }
    }

    private void scheduleAtFixedRate(Date firstDate, long period) {
        _period = period;
        if (_timerTask != null) {
            _timerTask.cancel();
        }
        _timerTask = new InternalTimerTask(this);
        _timer.scheduleAtFixedRate(_timerTask, firstDate, period);
    }

    public void schedule(long intervalInMinutes) {
        scheduleAtFixedRate(new Date(), intervalInMinutes * 60 * 1000);
    }

    public void schedule(Date start, int intervalInSeconds) {
        scheduleAtFixedRate(start, intervalInSeconds * 1000);
    }

    public void runNow() {
        scheduleAtFixedRate(new Date(), _period);
    }

    protected abstract void runTask() throws Exception;

    private synchronized void run() {
        try {
            Utils.info("start task " + _name);
            runTask();
        } catch (Exception ex) {
            Utils.warning("exception on task " + _name);
            Utils.exception(ex);
        }
        Utils.info("end task " + _name);
    }

    public static void init() {
        _timer = new Timer();
    }

    public static void close() {
        _timer.cancel();
        Utils.info("scheduled tasks terminated");
    }
    private static Timer _timer;
    private final String _name;
}
