/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.db;

import com.onlineclasses.db.DB;
import com.onlineclasses.entities.AvailableTime;
import com.onlineclasses.entities.InstituteType;
import com.onlineclasses.entities.Student;
import com.onlineclasses.entities.Teacher;
import com.onlineclasses.entities.User;
import com.onlineclasses.web.Labels;
import com.onlineclasses.web.Utils;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Date;
import java.util.List;
import java.util.Random;

/**
 *
 * @author me
 */
public class TestDB {

    public static void create() throws Exception {
        Utils.warning("using test database");
        addStudents();
        addTeachers();
        addInstituteTypes();
    }

    public static void addStudents() throws Exception {
        Student student = new Student();
        student.display_name = "רן ברנפלד";
        student.first_name = "רן";
        student.last_name = "ברנפלד";
        student.email = "ichess@ichess.co.il";
        student.image_url = "https://lh4.googleusercontent.com/-RvMyRqrpEIM/AAAAAAAAAAI/AAAAAAAAAT4/jewL_O1LF_8/s96-c/photo.jpg";
        student.registered = new Date();
        student.gender = User.GENDER_MALE;
        
        DB.addStudent(student);
    }

    public static void addTeachers() throws Exception {
        Teacher teacher = new Teacher();
        teacher.display_name = "רן ברנפלד";
        teacher.first_name = "רן";
        teacher.last_name = "ברנפלד";
        teacher.email = "berenfeldran@gmail.com";
        teacher.paypal_email = "berenfeldran@gmail.com";
        teacher.price_per_hour = 140;
        teacher.image_url = "https://lh4.googleusercontent.com/-MVyHXq7jv-0/AAAAAAAAAAI/AAAAAAAAAAA/ACLGyWBUQArTT9nKI7bjZHlRM48qDYygCA/s96-c/photo.jpg";
        teacher.moto = "מהנדס מערכות זמן אמת בעל 15 שנות נסיון, בעל תואר שני מהאוניבסיטה העברית במדעי המחשב ומתמטיקה. אשמח להוביל אתכם להצלחה.";
        teacher.phone_area = "054";
        teacher.phone_number = "7476526";
        teacher.registered = new Date();
        teacher.gender = User.GENDER_FEMALE;
        DB.addTeacher(teacher);

        AvailableTime availableTime = new AvailableTime();
        availableTime.teacher = teacher;
        availableTime.day = 1;
        availableTime.start_hour = 21;
        availableTime.start_minute = 0;
        availableTime.end_hour = 23;
        availableTime.end_minute = 0;

        for (int i = 1; i <= 5; i++) {
            availableTime.day = i;
            DB.addAvailableTime(availableTime);
        }

        Random random = new Random();
        
        for (int i = 0; i < 10; i++) {
            teacher = new Teacher();
            teacher.display_name = "מורה בדיקה " + i;
            teacher.first_name = "מורה";
            teacher.last_name = "בדיקה";
            teacher.email = "test" + i + "@gmail.com";
            teacher.paypal_email = "test" + i + "@gmail.com";
            teacher.price_per_hour = 50 + random.nextInt(100);
            teacher.image_url = "https://lh4.googleusercontent.com/-MVyHXq7jv-0/AAAAAAAAAAI/AAAAAAAAAAA/ACLGyWBUQArTT9nKI7bjZHlRM48qDYygCA/s96-c/photo.jpg";
            teacher.moto = "מוטו " + i;
            teacher.phone_area = "054";
            teacher.phone_number = "7476526";
            teacher.registered = new Date();
            teacher.gender = User.GENDER_FEMALE;
            DB.addTeacher(teacher);

            for (int j = 1; j <= 7; j++) {
                availableTime = new AvailableTime();
                availableTime.teacher = teacher;
                availableTime.day = j;
                availableTime.start_hour = random.nextInt(20);
                availableTime.start_minute = random.nextInt(30);
                availableTime.end_hour = availableTime.start_hour + random.nextInt(4);
                availableTime.end_minute = availableTime.start_minute + random.nextInt(30);
                DB.addAvailableTime(availableTime);
            }
        }
    }
    
    private static void addInstituteTypes() throws SQLException
    {
        String instituteTypes = Labels.get("db.institute_type");
        List<String> instituteTypeList = Utils.toList(instituteTypes);
        InstituteType instituteType = new InstituteType();
        for (String instituteTypeName : instituteTypeList) {
            instituteType.name = instituteTypeName;
            DB.addInstituteType(instituteType);
        }
    }

}
