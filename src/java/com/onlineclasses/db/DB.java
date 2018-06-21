/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.db;

import com.j256.ormlite.jdbc.JdbcPooledConnectionSource;
import com.mysql.jdbc.AbandonedConnectionCleanupThread;
import com.onlineclasses.db.orm.AvailableTime_DB;
import com.onlineclasses.db.orm.Base_DB;
import com.onlineclasses.db.orm.Email_DB;
import com.onlineclasses.db.orm.GoogleUser_DB;
import com.onlineclasses.db.orm.InstituteType_DB;
import com.onlineclasses.db.orm.Institute_DB;
import com.onlineclasses.db.orm.Payment_DB;
import com.onlineclasses.db.orm.AttachedFile_DB;
import com.onlineclasses.db.orm.City_DB;
import com.onlineclasses.db.orm.ClassComment_DB;
import com.onlineclasses.db.orm.Feedback_DB;
import com.onlineclasses.db.orm.OClass_DB;
import com.onlineclasses.db.orm.Student_DB;
import com.onlineclasses.db.orm.Subject_DB;
import com.onlineclasses.db.orm.Teacher_DB;
import com.onlineclasses.db.orm.TeachingTopic_DB;
import com.onlineclasses.db.orm.Topic_DB;
import com.onlineclasses.entities.AvailableTime;
import com.onlineclasses.entities.Email;
import com.onlineclasses.entities.GoogleUser;
import com.onlineclasses.entities.Institute;
import com.onlineclasses.entities.InstituteType;
import com.onlineclasses.entities.Payment;
import com.onlineclasses.entities.OClass;
import com.onlineclasses.entities.AttachedFile;
import com.onlineclasses.entities.City;
import com.onlineclasses.entities.ClassComment;
import com.onlineclasses.entities.Feedback;
import com.onlineclasses.entities.Student;
import com.onlineclasses.entities.Subject;
import com.onlineclasses.entities.Teacher;
import com.onlineclasses.entities.TeachingTopic;
import com.onlineclasses.entities.Topic;
import com.onlineclasses.entities.User;
import com.onlineclasses.utils.Config;
import com.onlineclasses.utils.Utils;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.naming.Context;
import javax.naming.InitialContext;
import org.apache.tomcat.jdbc.pool.DataSource;
import org.apache.tomcat.jdbc.pool.PoolProperties;

/**
 *
 * @author me
 */
public class DB {

    private static DataSource _dataSource;
    private static JdbcPooledConnectionSource _connectionSource;

    public static void initDBCP(String dbURL, String username, String password) {
        PoolProperties p = new PoolProperties();
        p.setUrl(dbURL);
        p.setDriverClassName("com.mysql.jdbc.Driver");
        p.setUsername(username);
        p.setPassword(password);
        p.setJmxEnabled(true);
        p.setTestWhileIdle(false);
        p.setTestOnBorrow(true);
        p.setValidationQuery("SELECT 1");
        p.setTestOnReturn(false);
        p.setValidationInterval(30000);
        p.setTimeBetweenEvictionRunsMillis(30000);
        p.setMaxActive(100);
        p.setInitialSize(10);
        p.setMaxWait(10000);
        p.setRemoveAbandonedTimeout(60);
        p.setMinEvictableIdleTimeMillis(30000);
        p.setMinIdle(10);
        p.setLogAbandoned(true);
        p.setRemoveAbandoned(true);
        p.setJdbcInterceptors(
                "org.apache.tomcat.jdbc.pool.interceptor.ConnectionState;"
                + "org.apache.tomcat.jdbc.pool.interceptor.StatementFinalizer");
        _dataSource = new DataSource();
        _dataSource.setPoolProperties(p);

    }

    public static void init() {
        try {
            Context initialContext = new InitialContext();
            String dbUser = Config.get("db.username");
            String dbPassword = Config.get("db.password");
            String dbName = Config.get("db.name");
            String dbUrl = "jdbc:mysql://localhost:3306/" + dbName
                    + "?useUnicode=true"
                    + "&characterEncoding=utf-8"
                    + "&useSSL=false";
            Utils.info("DB URL is '" + dbUrl + "'");
            initDBCP(dbUrl, dbUser, dbPassword);
            initORM(dbUrl, dbUser, dbPassword);
            if (Config.getBool("db.create")) {
                createAllTables();
            }
            if (Config.getBool("db.test")) {
                TestDB.create();
            }
        } catch (Exception ex) {
            Utils.exception(ex);
        }
    }

    public static void close() {        
        try {
            AbandonedConnectionCleanupThread.checkedShutdown();
            _dataSource.close();
            _connectionSource.close();            
        } catch (Exception ex) {
            Utils.exception(ex);
        }
    }

    private static Student_DB _student_db;
    private static Teacher_DB _teacher_db;
    private static AvailableTime_DB _availableTime_db;
    private static InstituteType_DB _instituteType_db;
    private static Institute_DB _institute_db;
    private static OClass_DB _oclass_db;
    private static Email_DB _email_db;
    private static GoogleUser_DB _googleUser_db;
    private static ClassComment_DB _classComment_DB;
    private static AttachedFile_DB _attachedFile_DB;
    private static Payment_DB _payment_DB;
    private static Subject_DB _subject_DB;
    private static Feedback_DB _feedback_DB;
    private static Topic_DB _topic_DB;
    private static TeachingTopic_DB _teachingTopic_DB;
    private static City_DB _city_DB;

    private static final Map<Class, Base_DB> ORM_ENTITIES = new HashMap<>();

    private static void initORM(String dbUrl, String dbUser, String dbPassword) throws SQLException {
        _connectionSource = new JdbcPooledConnectionSource(dbUrl, dbUser, dbPassword);
        _connectionSource.setTestBeforeGet(true);
        _student_db = new Student_DB(_connectionSource);
        _teacher_db = new Teacher_DB(_connectionSource);
        _availableTime_db = new AvailableTime_DB(_connectionSource);
        _instituteType_db = new InstituteType_DB(_connectionSource);
        _institute_db = new Institute_DB(_connectionSource);
        _oclass_db = new OClass_DB(_connectionSource);
        _email_db = new Email_DB(_connectionSource);
        _googleUser_db = new GoogleUser_DB(_connectionSource);
        _classComment_DB = new ClassComment_DB(_connectionSource);
        _attachedFile_DB = new AttachedFile_DB(_connectionSource);
        _payment_DB = new Payment_DB(_connectionSource);
        _feedback_DB = new Feedback_DB(_connectionSource);
        _subject_DB = new Subject_DB(_connectionSource);
        _topic_DB = new Topic_DB(_connectionSource);
        _teachingTopic_DB = new TeachingTopic_DB(_connectionSource);
        _city_DB = new City_DB(_connectionSource);

        ORM_ENTITIES.put(Student.class, _student_db);
        ORM_ENTITIES.put(Teacher.class, _teacher_db);
        ORM_ENTITIES.put(AvailableTime.class, _availableTime_db);
        ORM_ENTITIES.put(InstituteType.class, _instituteType_db);
        ORM_ENTITIES.put(Institute.class, _institute_db);
        ORM_ENTITIES.put(OClass.class, _oclass_db);
        ORM_ENTITIES.put(Email.class, _email_db);
        ORM_ENTITIES.put(GoogleUser.class, _googleUser_db);
        ORM_ENTITIES.put(ClassComment.class, _classComment_DB);
        ORM_ENTITIES.put(AttachedFile.class, _attachedFile_DB);
        ORM_ENTITIES.put(Payment.class, _payment_DB);
        ORM_ENTITIES.put(Subject.class, _subject_DB);
        ORM_ENTITIES.put(Feedback.class, _feedback_DB);
        ORM_ENTITIES.put(Topic.class, _topic_DB);
        ORM_ENTITIES.put(TeachingTopic.class, _teachingTopic_DB);
        ORM_ENTITIES.put(City.class, _city_DB);
    }

    public static Connection getConnection() throws SQLException {
        return _dataSource.getConnection();
    }

    public static Statement getConnectionAndStatement() throws SQLException {
        Connection connection = getConnection();
        Statement statement = connection.createStatement();
        return statement;
    }

    public static void executeQuery(String sql) throws SQLException {
        Statement statement = getConnectionAndStatement();
        statement.execute(sql);
        closeStatementAndConnection(statement);
    }

    private static void createAllTables() throws SQLException {
        for (Base_DB baseDB : ORM_ENTITIES.values()) {
            baseDB.createTable();
        }
    }

    public static User getUserByEmail(String email) throws SQLException {
        Student student = _student_db.getStudentByEmail(email);
        if (student != null) {
            return student;
        }
        Teacher teacher = _teacher_db.getTeacherByEmail(email);
        if (teacher != null) {
            return teacher;
        }
        return null;
    }

    public static Student getStudentByEmail(String email) throws SQLException {
        return _student_db.getStudentByEmail(email);
    }

    static PreparedStatement openPreparedStatement(String sql) throws SQLException {
        Connection connection = _dataSource.getConnection();
        PreparedStatement st = connection.prepareStatement(sql);
        return st;
    }

    static void closeStatementAndConnection(Statement statement) throws SQLException {
        Connection connection = statement.getConnection();
        statement.close();
        connection.close();
    }

    static void closeAll(ResultSet rs) throws SQLException {
        Statement st = rs.getStatement();
        Connection conn = st.getConnection();
        rs.close();
        st.close();
        conn.close();
    }

    public static User getUser(int id) throws SQLException {
        return _student_db.getUser(id);
    }

    public static Student getStudent(int id) throws SQLException {
        return _student_db.get(id);
    }

    public static Teacher getTeacher(int id) throws SQLException {
        return _teacher_db.get(id);
    }

    public static List<Teacher> findTeachers(int minPrice, int maxPrice, String displayName, String topicName) throws SQLException {
        List<Teacher> teachers = _teacher_db.findTeachers(minPrice, maxPrice, displayName);
        if (Utils.isEmpty(topicName)) {
            return teachers;
        }
        Map<Integer, Topic> topics = getAllMap(Topic.class);
        List<Teacher> matchedTeachers = new ArrayList<>();

        for (Teacher teacher : teachers) {
            List<TeachingTopic> teachingTopics = _teachingTopic_DB.getTeacherTeachingTopics(teacher);
            boolean foundTopic = false;
            for (TeachingTopic teachingTopic : teachingTopics) {
                Topic topic = topics.get(teachingTopic.topic.id);
                if (topic.name.toLowerCase().contains(topicName.toLowerCase())) {
                    foundTopic = true;
                    break;
                }
            }
            if (foundTopic) {
                matchedTeachers.add(teacher);
            }
        }
        return matchedTeachers;
    }

    public static List<AvailableTime> getTeacherAvailableTime(Teacher teacher) throws SQLException {
        List<AvailableTime> availableTimes = _availableTime_db.getTeacherAvailableTime(teacher);
        for (AvailableTime availableTime : availableTimes) {
            availableTime.teacher = null;
        }
        return availableTimes;
    }

    public static int deleteTeacherAvailableTime(Teacher teacher) throws SQLException {
        return _availableTime_db.deleteTeacherAvailableTime(teacher);
    }

    public static List<Topic> getTeacherTeachingTopics(Teacher teacher) throws SQLException {

        List<TeachingTopic> teacherTeachingTopics = _teachingTopic_DB.getTeacherTeachingTopics(teacher);
        List<Topic> teachingTopics = new ArrayList<>();
        for (TeachingTopic teachingTopic : teacherTeachingTopics) {
            teachingTopics.add(get(teachingTopic.topic.id, Topic.class));
        }
        return teachingTopics;
    }

    public static int deleteTeacherTeachingTopics(Teacher teacher) throws SQLException {

        return _teachingTopic_DB.deleteTeacherTeachingTopics(teacher);
    }

    public static List<Institute> getInstitutes(InstituteType instituteType) throws SQLException {
        return _institute_db.getInstitutes(instituteType);
    }

    public static List<OClass> getTeacherScheduledClasses(Teacher teacher) throws SQLException {
        return _oclass_db.getTeacherNotCanceledScheduledClasses(teacher);
    }

    public static OClass getOClass(int id) throws SQLException {
        OClass oClass = _oclass_db.get(id);
        oClass.teacher = getTeacher(oClass.teacher.id);
        oClass.student = getStudent(oClass.student.id);
        return oClass;
    }

    public static int updateUserEmailEnabled(Student student) throws SQLException {
        return _student_db.updateEmailEnabled(student);
    }

    public static GoogleUser getGoogleUserByEmail(String email) throws SQLException {
        return _googleUser_db.getGoogleUserByEmail(email);
    }

    public static List<OClass> getStudentUpcomingClasses(Student student) throws SQLException {
        return _oclass_db.getStudentUpcomingClasses(student);
    }

    public static List<OClass> getTeacherUpcomingClasses(Teacher teacher) throws SQLException {
        return _oclass_db.getTeacherUpcomingClasses(teacher);
    }
        
    public static <T> int add(T t) throws SQLException {
        return ORM_ENTITIES.get(t.getClass()).add(t);
    }

    public static <T> int delete(T t) throws SQLException {
        return ORM_ENTITIES.get(t.getClass()).delete(t);
    }

    public static <T> int update(T t) throws SQLException {
        return ORM_ENTITIES.get(t.getClass()).update(t);
    }

    public static <T> List<T> getAll(Class cls) throws SQLException {
        return ORM_ENTITIES.get(cls).getAll();
    }

    public static <T> Map<Integer, T> getAllMap(Class cls) throws SQLException {
        return ORM_ENTITIES.get(cls).getAllMap();
    }

    public static <T> T get(int id, Class cls) throws SQLException {
        return (T) ORM_ENTITIES.get(cls).get(id);
    }

    public static Institute getInstitute(int id) throws SQLException {
        return _institute_db.get(id);
    }

    public static List<ClassComment> getScheuduledClassComments(OClass oClass) throws SQLException {
        List<ClassComment> oClassComments = _classComment_DB.getScheuduledClassComments(oClass);
        for (ClassComment oClassComment : oClassComments) {
            if (oClassComment.student != null) {
                oClassComment.student = getStudent(oClassComment.student.id);
            } else if (oClassComment.teacher != null) {
                oClassComment.teacher = getTeacher(oClassComment.teacher.id);
            }
        }
        return oClassComments;
    }

    public static List<AttachedFile> getClassAttachedFiles(OClass oClass) throws SQLException {
        List<AttachedFile> oClassAttachedFiles = _attachedFile_DB.getClassAttachedFiles(oClass);
        for (AttachedFile oClassAttachedFile : oClassAttachedFiles) {
            if (oClassAttachedFile.student != null) {
                oClassAttachedFile.student = getStudent(oClassAttachedFile.student.id);
            } else if (oClassAttachedFile.teacher != null) {
                oClassAttachedFile.teacher = getTeacher(oClassAttachedFile.teacher.id);
            }
        }
        return oClassAttachedFiles;
    }

    public static int updateClassStatus(OClass oClass, int status) throws SQLException {
        return _oclass_db.updateClassStatus(oClass, status);
    }

    public static int updateClassPricePerHour(OClass oClass, int newPricePerHour) throws SQLException {
        return _oclass_db.updateClassPricePerHour(oClass, newPricePerHour);
    }
    
    public static int updateAttachedFileUploadedBytes(AttachedFile attachedFile) throws SQLException {
        return _attachedFile_DB.updateAttachedFileUploadedBytes(attachedFile);
    }

    public static synchronized AttachedFile getClassAttachedFile(OClass oClass, String fileName) throws SQLException {
        return _attachedFile_DB.getClassAttachedFile(oClass, fileName);
    }

    public static City getCityByName(String name) throws SQLException {
        return _city_DB.getCityByName(name);
    }
}
