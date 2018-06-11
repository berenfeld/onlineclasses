/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.db;

import com.onlineclasses.entities.AvailableTime;
import com.onlineclasses.entities.Institute;
import com.onlineclasses.entities.InstituteType;
import com.onlineclasses.entities.Student;
import com.onlineclasses.entities.Subject;
import com.onlineclasses.entities.Teacher;
import com.onlineclasses.entities.TeachingTopic;
import com.onlineclasses.entities.Topic;
import com.onlineclasses.entities.User;
import com.onlineclasses.utils.CConfig;
import com.onlineclasses.utils.Config;
import com.onlineclasses.utils.Labels;
import com.onlineclasses.utils.Utils;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Random;

/**
 *
 * @author me
 */
public class TestDB {

    public static void create() throws Exception {
        Utils.warning("creating test database");
        addStudents();
        addInstituteTypes();
        addInstitutes();
        addSubjects();
        addTopics();
        addTeachingTopics();
        addTeachers();
    }

    public static void addStudents() throws Exception {
        if (!Config.getBool("db.test.students")) {
            return;
        }
        Student student = new Student();
        student.display_name = "רן ברנפלד תלמיד";
        student.first_name = "רן";
        student.last_name = "ברנפלד";
        student.email = "ichess@ichess.co.il";
        student.image_url = "https://lh4.googleusercontent.com/-RvMyRqrpEIM/AAAAAAAAAAI/AAAAAAAAAT4/jewL_O1LF_8/s96-c/photo.jpg";
        student.registered = new Date();
        student.gender = User.GENDER_MALE;
        student.emails_enabled = true;

        DB.add(student);
    }

    public static void addTeachers() throws Exception {
        if (!Config.getBool("db.test.teachers")) {
            return;
        }

        List<Institute> allInstitues = DB.getAll(Institute.class);
        List<Subject> allSubjects = DB.getAll(Subject.class);
        String degreeTypesList = Labels.get("db.degree_type");
        List<String> degreeTypes = Utils.toList(degreeTypesList);

        Teacher teacher = new Teacher();
        teacher.display_name = "רן ברנפלד מורה";
        teacher.first_name = "רן";
        teacher.last_name = "ברנפלד";
        teacher.email = "berenfeldran@gmail.com";
        teacher.gender = User.GENDER_MALE;
        teacher.day_of_birth = Utils.parseDateWithFullYear("23/05/1977");
        teacher.paypal_email = "berenfeldran@gmail.com";
        teacher.price_per_hour = 140;
        teacher.image_url = "https://lh4.googleusercontent.com/-MVyHXq7jv-0/AAAAAAAAAAI/AAAAAAAAAAA/ACLGyWBUQArTT9nKI7bjZHlRM48qDYygCA/s96-c/photo.jpg";
        teacher.moto = "מהנדס מערכות זמן אמת בעל 15 שנות נסיון, בעל תואר שני מהאוניבסיטה העברית במדעי המחשב ומתמטיקה. אשמח להוביל אתכם להצלחה.";
        teacher.phone_area = "054";
        teacher.phone_number = "7476526";
        teacher.registered = new Date();
        teacher.show_email = true;
        teacher.show_phone = true;
        teacher.show_skype = true;
        teacher.skype_name = "ran.berenfeld";
        teacher.show_degree = true;
        teacher.institute = allInstitues.get(0);
        teacher.subject = allSubjects.get(0);
        teacher.degree_type = degreeTypes.get(0);

        DB.add(teacher);

        List<Topic> allTopics = DB.getAll(Topic.class);
        for (Topic topic : allTopics) {
            TeachingTopic teachingTopic = new TeachingTopic();
            teachingTopic.teacher = teacher;
            teachingTopic.topic = topic;
            DB.add(teachingTopic);
        }
        AvailableTime availableTime = new AvailableTime();
        availableTime.teacher = teacher;
        availableTime.day = 1;
        availableTime.start_hour = 21;
        availableTime.start_minute = 0;
        availableTime.end_hour = 23;
        availableTime.end_minute = 0;

        for (int i = 1; i <= 5; i++) {
            availableTime.day = i;
            DB.add(availableTime);
        }

        Random random = new Random();

        for (int i = 0; i < 5; i++) {
            teacher = new Teacher();
            teacher.display_name = "מורה בדיקה " + i;
            teacher.first_name = "מורה";
            teacher.last_name = "בדיקה";
            teacher.email = "test" + i + "@gmail.com";
            teacher.paypal_email = "test" + i + "@gmail.com";
            teacher.show_email = true;
            teacher.show_phone = true;
            teacher.show_skype = true;
            teacher.skype_name = "test" + i;
            teacher.price_per_hour = 50 + random.nextInt(100);
            teacher.image_url = "https://lh4.googleusercontent.com/-MVyHXq7jv-0/AAAAAAAAAAI/AAAAAAAAAAA/ACLGyWBUQArTT9nKI7bjZHlRM48qDYygCA/s96-c/photo.jpg";
            teacher.moto = "Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin. Cras purus odio, vestibulum in vulputate at, tempus viverra turpis. Fusce condimentum nunc ac nisi vulputate fringilla. Donec lacinia congue felis in faucibus. " + i;
            teacher.phone_area = "054";
            teacher.phone_number = "7476526";
            teacher.registered = new Date();
            teacher.gender = User.GENDER_FEMALE;
            DB.add(teacher);

            int minutesUnit = CConfig.getInt("website.time.unit.minutes");
            int startWorkingHour = CConfig.getInt("website.time.start_working_hour");
            int endWorkingHour = CConfig.getInt("website.time.end_working_hour");
            int hoursInDay = endWorkingHour - startWorkingHour;
            int unitsInHour = 60 / minutesUnit;
            for (int j = 1; j <= 5; j++) {
                availableTime = new AvailableTime();
                availableTime.teacher = teacher;
                availableTime.day = j;
                availableTime.start_hour = startWorkingHour + random.nextInt(hoursInDay - 8);
                availableTime.start_minute = random.nextInt(unitsInHour) * minutesUnit;
                availableTime.end_hour = availableTime.start_hour + random.nextInt(7) + 1;
                availableTime.end_minute = random.nextInt(unitsInHour) * minutesUnit;
                DB.add(availableTime);
            }
        }
    }

    private static void addInstituteTypes() throws SQLException {
        String instituteTypes = Labels.get("db.institute_type");
        List<String> instituteTypeList = Utils.toList(instituteTypes);
        InstituteType instituteType = new InstituteType();
        for (String instituteTypeName : instituteTypeList) {
            instituteType.name = instituteTypeName;
            DB.add(instituteType);
        }
    }

    private static void addInstitutes() throws SQLException {
        List<InstituteType> instituteTypes = DB.getAll(InstituteType.class);
        for (InstituteType instituteType : instituteTypes) {
            List<String> instituteNames = Utils.toList(Labels.get("db.institutes." + instituteType.id));
            for (String instituteName : instituteNames) {
                Institute institute = new Institute();
                institute.institute_type = instituteType;
                institute.name = instituteName;
                DB.add(institute);
            }

        }
    }

    private static void addSubjects() throws SQLException {
        String subjects = Labels.get("db.subjects");
        List<String> subjectList = Utils.toList(subjects);
        for (String subjectName : subjectList) {
            Subject subject = new Subject();
            subject.name = subjectName;
            DB.add(subject);
        }
    }

    private static void addTopics() throws SQLException {
        List<Subject> subjects = DB.getAll(Subject.class);
        int i = 1;
        for (Subject subject : subjects) {
            String topics = Labels.get("db.topics." + i);
            List<String> topicNames = Utils.toList(topics);
            for (String topicName : topicNames) {
                Topic topic = new Topic();
                topic.name = topicName;
                topic.subject = subject;
                DB.add(topic);
            }
            i++;
        }
    }

    public static void addTeachingTopics() throws Exception {
        List<Teacher> teachers = DB.getAll(Teacher.class);
        List<Topic> topics = DB.getAll(Topic.class);
        Random r = new Random();
        for (Teacher teacher : teachers) {
            int numberOfTopics = r.nextInt(topics.size());
            List<Topic> topicsCopy = new ArrayList<>(topics);
            for (int i = 0; i < numberOfTopics; i++) {
                TeachingTopic teachingTopic = new TeachingTopic();
                int index = r.nextInt(topicsCopy.size());
                teachingTopic.topic = topicsCopy.remove(index);
                teachingTopic.teacher = teacher;
                DB.add(teachingTopic);
            }
        }
    }
}
