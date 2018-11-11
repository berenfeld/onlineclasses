/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.db;

import com.onlineclasses.entities.AvailableTime;
import com.onlineclasses.entities.City;
import com.onlineclasses.entities.Institute;
import com.onlineclasses.entities.InstituteType;
import com.onlineclasses.entities.OClass;
import com.onlineclasses.entities.Payment;
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
import java.util.ArrayList;
import java.util.Calendar;
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
        addInstituteTypes();
        addInstitutes();
        addSubjects();
        addCities();
        addTopics();
        addTeachingTopics();
        addStudents();
        addTeachers();
        addScheduledClasses();
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
        student.image_url = "https://lh3.googleusercontent.com/-RvMyRqrpEIM/AAAAAAAAAAI/AAAAAAAAAAA/ABtNlbCWZEJKtWJcJdRFft7k6QacI1-msA/s96-c-mo/photo.jpg";
        student.registered = new Date();
        student.gender = User.GENDER_MALE;
        student.emails_enabled = true;
        student.admin = true;

        DB.add(student);
    }

    public static void addTeachers() throws Exception {
        addRanB();
        addMosheB();        
        addTestTeachers();
    }

    private static void addRanB() throws Exception {        
        List<Subject> allSubjects = DB.getAll(Subject.class);
        String degreeTypesList = Labels.get("db.degree_type");        

        Teacher teacher = new Teacher();
        teacher.display_name = "רן ברנפלד";
        teacher.first_name = "רן";
        teacher.last_name = "ברנפלד";
        teacher.email = "berenfeldran@gmail.com";
        teacher.gender = User.GENDER_MALE;
        teacher.day_of_birth = Utils.parseDateWithFullYear("23/05/1977");
        teacher.paypal_email = "berenfeldran@gmail.com";
        teacher.price_per_hour = 130;
        teacher.image_url = "https://lh3.googleusercontent.com/-MVyHXq7jv-0/AAAAAAAAAAI/AAAAAAAAAAA/ABtNlbA_jkl-lkg5QSRlr4ICIbdA5RlpQg/s96-c-mo/photo.jpg";
        teacher.moto = "שלום לכולם שמי רן ברנפלד. אני מהנדס מערכות זמן אמת וראש צוות פיתוח כ 20 שנה ובעל 5 שנות נסיון בלימוד מקצועות מדעי המחשב לסטודנטים. אני בעל תואר שני במדעי המחשב מטעם האוניברסיטה העברית ואני גם המייסד של האתר.. אשמח להוביל גם אתכם להצלחה !";
        teacher.phone_area = "054";
        teacher.phone_number = "7476526";
        teacher.registered = new Date();
        teacher.show_email = true;
        teacher.show_phone = true;
        teacher.show_skype = true;
        teacher.skype_name = "ran.berenfeld";
        teacher.show_degree = true;
        teacher.institute = DB.getInstituteByName("האוניברסיטה העברית בירושלים");
        teacher.subject = Utils.getRandomElement(allSubjects);
        teacher.degree_type = "תואר שני";
        teacher.rating = 5;
        teacher.city = DB.getCityByName("נס ציונה");
        teacher.admin = true;
        teacher.min_class_length = 120;
        teacher.max_class_length = 120;

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
            availableTime.start_hour = 21;
            availableTime.start_minute = 00;
            availableTime.end_hour = 23;
            availableTime.end_minute = 00;
            DB.add(availableTime);
        }

        availableTime = new AvailableTime();
        availableTime.teacher = teacher;
        availableTime.day = 6;
        availableTime.start_hour = 14;
        availableTime.start_minute = 30;
        availableTime.end_hour = 16;
        availableTime.end_minute = 30;
        DB.add(availableTime);
    }

    private static void addMosheB() throws Exception {
        Teacher teacher = new Teacher();
        teacher.display_name = "משה בן אבו";
        teacher.first_name = "משה";
        teacher.last_name = "בן אבו";
        teacher.email = "moshebenabu@gmail.com";
        teacher.gender = User.GENDER_MALE;
        teacher.day_of_birth = Utils.parseDateWithFullYear("01/01/1982");
        teacher.paypal_email = "moshebenabu@gmail.com";
        teacher.price_per_hour = 120;
        teacher.image_url = "";
        teacher.moto = "בעל 8 שנות נסיון תעסוקתי בפיתוח תוכנה במגוון טכנולוגיות ושפות תכנות. כ 3 שנות נסיון כמורה לתכנות. שנתיים נסיון במתן שיעורים פרטיים.";
        teacher.phone_area = "054";
        teacher.phone_number = "4917396";
        teacher.registered = new Date();
        teacher.show_email = true;
        teacher.show_phone = true;
        teacher.show_skype = false;
        teacher.show_degree = false;
        teacher.rating = 5;
        teacher.city = DB.getCityByName("נס ציונה");
        teacher.min_class_length = 60;
        teacher.max_class_length = 120;

        DB.add(teacher);

        String[] topics = {"תכנות בשפת ג'אוה", "תכנות בשפת פייטון", "תכנות בשפת C", "אלגוריתמים", "חישוביות", "סי שארפ"};
        for (String topicName : topics) {
            TeachingTopic teachingTopic = new TeachingTopic();
            teachingTopic.teacher = teacher;
            teachingTopic.topic = DB.getTopicByName(topicName);
            if ( teachingTopic.topic == null ) {
                Utils.warning("can't find topic '" + topicName + "'");
                continue;
            }
            DB.add(teachingTopic);
        }

        AvailableTime availableTime = new AvailableTime();
        availableTime.teacher = teacher;
        availableTime.day = 6;
        availableTime.start_hour = 8;
        availableTime.start_minute = 30;
        availableTime.end_hour = 11;
        availableTime.end_minute = 30;
        DB.add(availableTime);
    }

    private static void addTestTeachers() throws Exception {
        if (!Config.getBool("db.test.teachers")) {
            return;
        }
        List<Institute> allInstitues = DB.getAll(Institute.class);
        List<Subject> allSubjects = DB.getAll(Subject.class);
        List<City> allCities = DB.getAll(City.class);
        String degreeTypesList = Labels.get("db.degree_type");
        List<String> allDegreeTypes = Utils.toList(degreeTypesList);
        List<Topic> allTopics = DB.getAll(Topic.class);

        Random random = new Random();

        for (int i = 0; i < 5; i++) {
            Teacher teacher = new Teacher();
            teacher.display_name = "מורה בדיקה " + i;
            teacher.first_name = "מורה";
            teacher.last_name = "בדיקה";
            teacher.gender = User.GENDER_MALE;
            teacher.email = "test" + i + "@gmail.com";
            teacher.gender = User.GENDER_MALE;
            teacher.paypal_email = "test" + i + "@gmail.com";
            teacher.show_email = true;
            teacher.show_phone = true;
            teacher.show_skype = true;
            teacher.skype_name = "test" + i;
            teacher.price_per_hour = 50 + random.nextInt(100);
            teacher.image_url = "";
            teacher.moto = "Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin. Cras purus odio, vestibulum in vulputate at, tempus viverra turpis. Fusce condimentum nunc ac nisi vulputate fringilla. Donec lacinia congue felis in faucibus. " + i;
            teacher.phone_area = "007";
            teacher.phone_number = "7777777";
            String dob = "01/01/" + String.valueOf(2000 - random.nextInt(60));
            teacher.day_of_birth = Utils.parseDateWithFullYear(dob);
            teacher.registered = new Date();
            teacher.rating = ((float) random.nextInt(100)) / 20.0f;
            teacher.city = Utils.getRandomElement(allCities);
            teacher.show_degree = true;
            switch (random.nextInt(3)) {
                case 0:
                    teacher.institute = Utils.getRandomElement(allInstitues);
                    teacher.subject = Utils.getRandomElement(allSubjects);
                    teacher.degree_type = Utils.getRandomElement(allDegreeTypes);
                    break;
                case 1:
                    teacher.institute_name = "institute " + i;
                    teacher.subject_name = "subject " + i;
                    teacher.degree_type = "degree " + i;
                    break;
            }

            teacher.min_class_length = 30;
            teacher.max_class_length = 120;

            DB.add(teacher);

            int minutesUnit = CConfig.getInt("website.time.unit.minutes");
            int startWorkingHour = CConfig.getInt("website.time.start_working_hour");
            int endWorkingHour = CConfig.getInt("website.time.end_working_hour");
            int hoursInDay = endWorkingHour - startWorkingHour;
            int unitsInHour = 60 / minutesUnit;
            for (int j = 1; j <= 5; j++) {
                AvailableTime availableTime = new AvailableTime();
                availableTime.teacher = teacher;
                availableTime.day = j;
                availableTime.start_hour = startWorkingHour + random.nextInt(hoursInDay - 8);
                availableTime.start_minute = random.nextInt(unitsInHour) * minutesUnit;
                availableTime.end_hour = availableTime.start_hour + random.nextInt(7) + 1;
                availableTime.end_minute = random.nextInt(unitsInHour) * minutesUnit;
                DB.add(availableTime);
            }

            int topics = random.nextInt(20);
            for (int j = 0; j < topics; j++) {
                TeachingTopic teachingTopic = new TeachingTopic();
                teachingTopic.teacher = teacher;
                teachingTopic.topic = Utils.getRandomElement(allTopics);
                DB.add(teachingTopic);
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

    public static void addScheduledClasses() throws Exception {
        if (!Config.getBool("db.test.scheduled_classes")) {
            return;
        }
        
        Teacher teacher = (Teacher) DB.getUserByEmail("berenfeldran@gmail.com");;
        List<AvailableTime> availableTimes = DB.getTeacherAvailableTime(teacher);
        
        Random random = new Random();
        OClass oClass = new OClass();
        oClass.teacher = teacher;
        oClass.student = (Student) DB.getUserByEmail("ichess@ichess.co.il");
        
        AvailableTime availableTime = Utils.getRandomElement(availableTimes);       
        Calendar startDate = Calendar.getInstance();
        startDate.set(Calendar.DAY_OF_WEEK, availableTime.day);
        startDate.set(Calendar.HOUR_OF_DAY, availableTime.start_hour);
        startDate.set(Calendar.MINUTE, availableTime.start_minute);
        startDate.set(Calendar.SECOND, 0);
        startDate.set(Calendar.MILLISECOND, 0);        
        oClass.start_date = startDate.getTime();
        
        oClass.registered = new Date();
        oClass.status = OClass.STATUS_SCHEDULED;
        oClass.price_per_hour = 10;
        oClass.duration_minutes = 30;
        oClass.subject = "שיעור נסיון לא שולם";
        DB.add(oClass);
        
        
        oClass = new OClass();
        oClass.teacher =  teacher;
        oClass.student = (Student) DB.getUserByEmail("ichess@ichess.co.il");
                
        availableTime = Utils.getRandomElement(availableTimes);       
        startDate = Calendar.getInstance();
        startDate.set(Calendar.DAY_OF_WEEK, availableTime.day);
        startDate.set(Calendar.HOUR_OF_DAY, availableTime.start_hour);
        startDate.set(Calendar.MINUTE, availableTime.start_minute);
        startDate.set(Calendar.SECOND, 0);
        startDate.set(Calendar.MILLISECOND, 0);
        oClass.start_date = startDate.getTime();
        
        oClass.registered = new Date();
        oClass.status = OClass.STATUS_SCHEDULED;
        oClass.price_per_hour = oClass.teacher.price_per_hour;
        oClass.duration_minutes = teacher.min_class_length;
        
        oClass.subject = "שיעור נסיון שולם";
        DB.add(oClass);
        
        Payment payment = new Payment();
        payment.date = new Date();
        payment.amount = ( oClass.price_per_hour * oClass.duration_minutes ) / 60;
        payment.payer = "ichess@ichess.co.il";
        payment.oclass = oClass;
        DB.add(payment);
        
        
        oClass = new OClass();
        oClass.teacher =  teacher;
        oClass.student = (Student) DB.getUserByEmail("ichess@ichess.co.il");
                
        availableTime = Utils.getRandomElement(availableTimes);       
        startDate = Calendar.getInstance();
        startDate.set(Calendar.DAY_OF_WEEK, availableTime.day);
        startDate.set(Calendar.HOUR_OF_DAY, availableTime.start_hour);
        startDate.set(Calendar.MINUTE, availableTime.start_minute);
        startDate.set(Calendar.SECOND, 0);
        startDate.set(Calendar.MILLISECOND, 0);
        startDate.add(Calendar.DAY_OF_WEEK, -7);
        oClass.start_date = startDate.getTime();
        
        oClass.registered = new Date();
        oClass.status = OClass.STATUS_SCHEDULED;
        oClass.price_per_hour = oClass.teacher.price_per_hour;
        oClass.duration_minutes = teacher.min_class_length;
        
        oClass.subject = "שיעור נסיון לא שולם בזמן";
        DB.add(oClass);
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

    private static void addCities() throws SQLException {
        String subjects = Labels.get("db.cities");
        List<String> citiesList = Utils.toList(subjects);
        for (String cityName : citiesList) {
            City city = new City();
            city.name = cityName;
            DB.add(city);
        }
    }

    private static void addTopics() throws SQLException {
        List<Subject> subjects = DB.getAll(Subject.class);
        int subjectNumber = 1;
        for (Subject subject : subjects) {
            int topicNumber = 1;
            do {
                String topicName = Labels.get("db.topics." + subjectNumber + "." + topicNumber);
                if (Utils.isEmpty(topicName)) {
                    break;
                }
                String topicDescription = Labels.get("db.topics." + subjectNumber + "." + topicNumber + ".description");

                Topic topic = new Topic();
                topic.name = topicName;
                topic.subject = subject;
                topic.description = topicDescription;
                DB.add(topic);
                ++topicNumber;
            } while (true);
            ++subjectNumber;
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
