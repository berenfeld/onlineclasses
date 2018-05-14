/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.utils;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.onlineclasses.entities.AvailableTime;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletContext;
import javax.xml.bind.DatatypeConverter;

/**
 *
 * @author me
 */
public class Utils {

    public static void exception(Throwable ex) {
        String className = Thread.currentThread().getStackTrace()[1].getClassName();
        Logger.getLogger(className).log(Level.WARNING, "Exception : {0}", ex.getMessage());
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

    public static String md5(String hashString)
    {
        MessageDigest md;
        try {
            md = MessageDigest.getInstance("MD5");        
        }catch (NoSuchAlgorithmException ex) {
            Utils.exception(ex);
            Utils.warning("failed calculating hash of " + hashString);
            return "";
        }
        md.update(hashString.getBytes());
        String hash = DatatypeConverter.printHexBinary(md.digest());
        return hash;
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
        Logger.getLogger(ste.getClassName()).log(level, "{0}:{1} {2}", new Object[]{ste.getFileName(), ste.getLineNumber(), message});

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

    public static String formatDateTime(Date date) {
        Calendar dateCalendar = Calendar.getInstance();
        dateCalendar.setTime(date);
        SimpleDateFormat format = new SimpleDateFormat("dd/MM, HH:mm");
        return  dayNameLong(dateCalendar.get(Calendar.DAY_OF_WEEK)) + ", " + format.format(date);
    }
    
    public static final long MINUTES_IN_HOUR = 60;
    public static final long SECONDS_IN_MINUTE = 60;
    public static final long MS_IN_SECOND = 1000;
    public static final long MS_IN_HOUR = MS_IN_SECOND * SECONDS_IN_MINUTE * MINUTES_IN_HOUR;

    public static long durationInMinutes(AvailableTime availableTime) {
        return ((availableTime.end_hour - availableTime.start_hour) * MINUTES_IN_HOUR) + (availableTime.end_minute - availableTime.start_minute);
    }

    public static boolean nonOverlappingEvents(long start1, long end1, long start2, long end2) {
        return (start1>=end2)||(start2>=end1);
    }
    
    public static boolean overlappingEvents(long start1, long end1, long start2, long end2) {
        return ! nonOverlappingEvents(start1,end1,start2,end2);
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

    public static String dayNameLong(int day) {
        return toList(CLabels.get("website.days.long")).get(day-1);
    }
    
    private static final Gson GSON = new GsonBuilder().registerTypeAdapter(Date.class, new GsonUTCDateAdapter()).create();

    public static Gson gson() {
        return GSON;
    }
    
    public static Date xHoursFromNow( int hours)
    {
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.HOUR, hours);
        return calendar.getTime();
    }
    
    public static String getStringFromInputStream(ServletContext context, String fileName) {
        InputStream is = context.getResourceAsStream(fileName);
        BufferedReader br;
        StringBuilder sb = new StringBuilder();

        String line;
        try {

            br = new BufferedReader(new InputStreamReader(is, "UTF-8"));
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }

        } catch (IOException e) {
            return "";
        }

        return sb.toString();

    }

    public static String formatPrice(float price)
    {
        return String.format("%.2f", price);
    }
    
    public static String buildWebsiteURL(String path, String ... params)
    {
        String url = Config.get("website.url") + "/"+ path;
        boolean firstParam = true;
        for (String param : params) {
            if ( firstParam) {
                url += "?";
                firstParam = false;
            } else {
                url += "&";
            }
            url += param;
        }
        return url;
    }
}
