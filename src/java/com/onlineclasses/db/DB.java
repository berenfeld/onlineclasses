/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.db;

import com.j256.ormlite.jdbc.JdbcPooledConnectionSource;
import com.onlineclasses.entities.AvailableTime;
import com.onlineclasses.entities.Email;
import com.onlineclasses.entities.GoogleUser;
import com.onlineclasses.entities.InstituteType;
import com.onlineclasses.entities.ScheduledClass;
import com.onlineclasses.entities.Student;
import com.onlineclasses.entities.Teacher;
import com.onlineclasses.entities.User;
import com.onlineclasses.web.Config;
import com.onlineclasses.web.Utils;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
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
            Context context = (Context) initialContext.lookup("java:comp/env");
            String dbUser = Config.get("db.username");
            String dbPassword = Config.get("db.password");
            String dbName = Config.get("db.name");
            String dbUrl = "jdbc:mysql://localhost:3306/" + dbName
                    + "?useUnicode=true"
                    + "&characterEncoding=utf-8";
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
    }

    private static Student_DB _student_db;
    private static Teacher_DB _teacher_db;
    private static AvailableTime_DB _availableTime_db;
    private static InstituteType_DB _instituteType_db;
    private static ScheduledClass_DB _scheduledClass_db;
    private static Email_DB _email_db;
    private static GoogleUser_DB _googleUser_db;

    private static List<Base_DB> _entities_db;

    private static void initORM(String dbUrl, String dbUser, String dbPassword) throws SQLException {
        _connectionSource = new JdbcPooledConnectionSource(dbUrl, dbUser, dbPassword);
        _connectionSource.setTestBeforeGet(true);
        _student_db = new Student_DB(_connectionSource);
        _teacher_db = new Teacher_DB(_connectionSource);
        _availableTime_db = new AvailableTime_DB(_connectionSource);
        _instituteType_db = new InstituteType_DB(_connectionSource);
        _scheduledClass_db = new ScheduledClass_DB(_connectionSource);
        _email_db = new Email_DB(_connectionSource);
        _googleUser_db = new GoogleUser_DB(_connectionSource);

        _entities_db = new ArrayList<>();
        _entities_db.add(_student_db);
        _entities_db.add(_teacher_db);
        _entities_db.add(_availableTime_db);
        _entities_db.add(_instituteType_db);
        _entities_db.add(_scheduledClass_db);
        _entities_db.add(_email_db);
        _entities_db.add(_googleUser_db);
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
        for (Base_DB baseDB : _entities_db) {
            baseDB.createTable();
        }
    }

    public static User getUserByEmail(String email) throws SQLException  {
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

    public static int addStudent(Student student) throws SQLException {
        return _student_db.add(student);
    }

    static void addTeacher(Teacher teacher) throws SQLException {
        _teacher_db.add(teacher);
    }

    public static List<Teacher> findTeachers(int minPrice, int maxPrice, String displayName) {
        return _teacher_db.findTeachers(minPrice, maxPrice, displayName);
    }

    public static void addAvailableTime(AvailableTime availableTime) throws SQLException {
        _availableTime_db.add(availableTime);
    }

    public static void addInstituteType(InstituteType instituteType) throws SQLException {
        _instituteType_db.add(instituteType);
    }

    public static List<AvailableTime> getTeacherAvailableTime(Teacher teacher) {
        return _availableTime_db.getTeacherAvailableTime(teacher);
    }

    public static List<InstituteType> getAllInstituteTypes() throws SQLException {
        return _instituteType_db.getAll();
    }

    public static List<Teacher> getAllTeachers() throws SQLException {
        return _teacher_db.getAll();
    }

    public static int addScheduledClass(ScheduledClass scheduledClass) throws SQLException {
        return _scheduledClass_db.add(scheduledClass);
    }

    public static List<ScheduledClass> getTeacherScheduledClasses(Teacher teacher) throws SQLException {
        return _scheduledClass_db.getTeacherNotCanceledScheduledClasses(teacher);
    }

    public static ScheduledClass getScheduledClass(int id) throws SQLException {
        ScheduledClass scheduledClass = _scheduledClass_db.get(id);
        scheduledClass.teacher = getTeacher(scheduledClass.teacher.id);
        scheduledClass.student = getStudent(scheduledClass.student.id);
        return scheduledClass;
    }

    public static List<Email> getAllEmails() throws SQLException {
        return _email_db.getAll();
    }

    public static int deleteEmail(Email email) throws SQLException {
        return _email_db.delete(email);
    }

    public static int addEmail(Email email) throws SQLException {
        return _email_db.add(email);
    }

    public static int updateUserEmailEnabled(Student student) throws SQLException {
        return _student_db.updateEmailEnabled(student);
    }
    
    public static GoogleUser getGoogleUserByEmail(String email) throws SQLException  {
        return _googleUser_db.getGoogleUserByEmail(email);
    }
    
    public static int addGoogleUser(GoogleUser googleUser) throws SQLException {
        return _googleUser_db.add(googleUser);
    }
}
