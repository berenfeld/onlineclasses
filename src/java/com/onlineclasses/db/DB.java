/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.db;

import com.j256.ormlite.jdbc.JdbcPooledConnectionSource;
import com.onlineclasses.db.orm.AvailableTime_DB;
import com.onlineclasses.db.orm.Base_DB;
import com.onlineclasses.db.orm.Email_DB;
import com.onlineclasses.db.orm.GoogleUser_DB;
import com.onlineclasses.db.orm.InstituteType_DB;
import com.onlineclasses.db.orm.Institute_DB;
import com.onlineclasses.db.orm.Payment_DB;
import com.onlineclasses.db.orm.AttachedFile_DB;
import com.onlineclasses.db.orm.ClassComment_DB;
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
import com.onlineclasses.entities.ClassComment;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
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
        _dataSource.close();
        try {
            _connectionSource.close();
        } catch (IOException ex) {
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
    private static Topic_DB _topic_DB;
    private static TeachingTopic_DB _teachingTopic_DB;

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
        _subject_DB = new Subject_DB(_connectionSource);
        _topic_DB = new Topic_DB(_connectionSource);
        _teachingTopic_DB = new TeachingTopic_DB(_connectionSource);

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
        ORM_ENTITIES.put(Topic.class, _topic_DB);
        ORM_ENTITIES.put(TeachingTopic.class, _teachingTopic_DB);
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

    public static List<Teacher> findTeachers(int minPrice, int maxPrice, String displayName) {
        return _teacher_db.findTeachers(minPrice, maxPrice, displayName);
    }

    public static List<AvailableTime> getTeacherAvailableTime(Teacher teacher) throws SQLException {
        return _availableTime_db.getTeacherAvailableTime(teacher);
    }

    public static List<TeachingTopic> getTeacherTeachingTopics(Teacher teacher) throws SQLException {
        return _teachingTopic_DB.getTeacherTeachingTopics(teacher);
    }

    public static List<InstituteType> getAllInstituteTypes() throws SQLException {
        return _instituteType_db.getAll();
    }

    public static List<Institute> getInstitutes(InstituteType instituteType) throws SQLException {
        return _institute_db.getInstitutes(instituteType);
    }

    public static List<OClass> getTeacherScheduledClasses(Teacher teacher) throws SQLException {
        return _oclass_db.getTeacherNotCanceledScheduledClasses(teacher);
    }

    public static OClass getOClass(int id) throws SQLException {
        OClass scheduledClass = _oclass_db.get(id);
        scheduledClass.teacher = getTeacher(scheduledClass.teacher.id);
        scheduledClass.student = getStudent(scheduledClass.student.id);
        return scheduledClass;
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

    public static <T> int add(T t) throws SQLException {
        return ORM_ENTITIES.get(t.getClass()).add(t);
    }

    public static <T> int delete(T t) throws SQLException {
        return ORM_ENTITIES.get(t.getClass()).delete(t);
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

    public static List<ClassComment> getScheuduledClassComments(OClass scheduledClass) throws SQLException {
        List<ClassComment> scheduledClassComments = _classComment_DB.getScheuduledClassComments(scheduledClass);
        for (ClassComment scheduledClassComment : scheduledClassComments) {
            if (scheduledClassComment.student != null) {
                scheduledClassComment.student = getStudent(scheduledClassComment.student.id);
            } else if (scheduledClassComment.teacher != null) {
                scheduledClassComment.teacher = getTeacher(scheduledClassComment.teacher.id);
            }
        }
        return scheduledClassComments;
    }

    public static List<AttachedFile> getClassAttachedFiles(OClass scheduledClass) throws SQLException {
        List<AttachedFile> scheduledClassAttachedFiles = _attachedFile_DB.getClassAttachedFiles(scheduledClass);
        for (AttachedFile scheduledClassAttachedFile : scheduledClassAttachedFiles) {
            if (scheduledClassAttachedFile.student != null) {
                scheduledClassAttachedFile.student = getStudent(scheduledClassAttachedFile.student.id);
            } else if (scheduledClassAttachedFile.teacher != null) {
                scheduledClassAttachedFile.teacher = getTeacher(scheduledClassAttachedFile.teacher.id);
            }
        }
        return scheduledClassAttachedFiles;
    }

    public static int updateClassStatus(OClass scheduledClass, int status) throws SQLException {
        return _oclass_db.updateClassStatus(scheduledClass, status);
    }

    public static int updateAttachedFileUploadedBytes(AttachedFile attachedFile) throws SQLException {
        return _attachedFile_DB.updateAttachedFileUploadedBytes(attachedFile);
    }

    public static synchronized AttachedFile getClassAttachedFile(OClass oClass, String fileName) throws SQLException {
        return _attachedFile_DB.getClassAttachedFile(oClass, fileName);
    }
}
