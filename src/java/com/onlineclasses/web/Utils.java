/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.web;

import com.onlineclasses.entities.AvailableTime;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author me
 */
public class Utils {

    public static void exception(Throwable ex) {
        String className = Thread.currentThread().getStackTrace()[1].getClassName();
        Logger.getLogger(className).warning("Exception : " + ex.getMessage());
        ex.printStackTrace();
    }

    public static void debug(String message) {
        log(Level.FINE, message);
    }

    public static void info(String message) {
        log(Level.INFO, message);
    }

    public static void warning(String message) {
        log(Level.WARNING, message);
    }

    public static StackTraceElement callingSTE() {
        for (StackTraceElement st : Thread.currentThread().getStackTrace()) {
            if (st.getFileName().equals("Thread.java")) {
                continue;
            }
            if (st.getFileName().equals("Utils.java")) {
                continue;
            }
            return st;

        }
        return null;
    }

    public static void log(Level level, String message) {

        StackTraceElement ste = callingSTE();
        Logger.getLogger(ste.getClassName()).log(level, ste.getFileName() + ":" + ste.getLineNumber() + " " + message);

    }

    public static boolean isEmpty(String str) {
        return (str == null) || (str.length() == 0);
    }

    public static boolean isNotEmpty(String str) {
        return (!isEmpty(str));
    }

    public static String nonNullString(String str) {
        if (isEmpty(str)) {
            return "";
        }
        return str;
    }

    public static int parseInt(String str, int defaultValue) {
        if (Utils.isEmpty(str)) {
            return defaultValue;
        }
        try {
            return Integer.valueOf(str);
        } catch (NumberFormatException ex) {
            return defaultValue;
        }
    }

    public static List<String> toList(String str) {
        return Arrays.asList(str.split(","));
    }

    public static String formatTime(int hour, int minute) {
        return String.format("%02d:%02d", hour, minute);
    }

    public static String formatDate(Date date) {
        SimpleDateFormat format = new SimpleDateFormat("dd/MM");
        return format.format(date);
    }

    public static final long MINUTES_IN_HOUR = 60;
    public static final long SECONDS_IN_MINUTE = 60;
    public static final long MS_IN_SECOND = 1000;
    public static final long MS_IN_HOUR = MS_IN_SECOND * SECONDS_IN_MINUTE * MINUTES_IN_HOUR;

    public static long durationInMinutes(AvailableTime availableTime) {
        return ((availableTime.end_hour - availableTime.start_hour) * MINUTES_IN_HOUR) + (availableTime.end_minute - availableTime.start_minute);
    }

    public static boolean overlappingEvents(long start1, long end1, long start2, long end2) {
        if (end2 < start1) {
            return false;
        }

        if (end1 < start2) {
            return false;
        }
        return true;
    }

    public static boolean overlappingEvents(Date start1, Date end1, Date start2, Date end2) {
        long start1ms = start1.getTime();
        long end1ms = end1.getTime();
        long start2ms = start2.getTime();
        long end2ms = end2.getTime();
        return overlappingEvents(start1ms, end1ms, start2ms, end2ms);
    }

    public static boolean overlappingEvents(Calendar start1, Calendar end1, Calendar start2, Calendar end2) {
        long start1ms = start1.getTimeInMillis();
        long end1ms = end1.getTimeInMillis();
        long start2ms = start2.getTimeInMillis();
        long end2ms = end2.getTimeInMillis();
        return overlappingEvents(start1ms, end1ms, start2ms, end2ms);
    }

    public static boolean available(List<AvailableTime> availableTimes, Date date) {
        Calendar eventDate = Calendar.getInstance();
        eventDate.setTime(date);

        Calendar start = Calendar.getInstance();
        start.setTime(date);

        Calendar end = Calendar.getInstance();
        end.setTime(date);

        for (AvailableTime availableTime : availableTimes) {
            start.set(Calendar.DAY_OF_WEEK, availableTime.day);
            start.set(Calendar.HOUR_OF_DAY, availableTime.start_hour);
            start.set(Calendar.MINUTE, availableTime.start_minute);

            end.set(Calendar.DAY_OF_WEEK, availableTime.day);
            end.set(Calendar.HOUR_OF_DAY, availableTime.end_hour);
            end.set(Calendar.MINUTE, availableTime.end_minute);

            if ((eventDate.getTimeInMillis() >= start.getTimeInMillis())
                    && eventDate.getTimeInMillis() <= end.getTimeInMillis()) {
                return true;
            }
        }
        return false;
    }
}
