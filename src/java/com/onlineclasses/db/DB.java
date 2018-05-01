/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.db;

import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.dao.DaoManager;
import com.j256.ormlite.support.ConnectionSource;
import com.onlineclasses.entities.InstituteType;
import com.onlineclasses.entities.Student;
import com.onlineclasses.entities.User;
import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Arrays;
import java.util.List;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.servlet.ServletContext;
import com.j256.ormlite.jdbc.JdbcConnectionSource;
import com.j256.ormlite.stmt.PreparedQuery;
import com.j256.ormlite.stmt.QueryBuilder;
import com.j256.ormlite.stmt.SelectArg;
import com.j256.ormlite.stmt.Where;
import com.j256.ormlite.table.TableUtils;
import com.onlineclasses.entities.AvailableTime;
import com.onlineclasses.entities.Teacher;
import com.onlineclasses.web.Config;
import com.onlineclasses.web.Utils;
import java.util.ArrayList;
import java.util.Map;
import org.apache.tomcat.jdbc.pool.DataSource;
import org.apache.tomcat.jdbc.pool.PoolProperties;

/**
 *
 * @author me
 */
public class DB {

    private static DataSource _dataSource;
    private static ConnectionSource _connectionSource;

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
            printAllTables();

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

    private static List<Base_DB> _entities_db;
    
    private static void initORM(String dbUrl, String dbUser, String dbPassword) throws SQLException {
        _connectionSource = new JdbcConnectionSource(dbUrl, dbUser, dbPassword);
        _student_db = new Student_DB(_connectionSource);
        _teacher_db = new Teacher_DB(_connectionSource);
        _availableTime_db = new AvailableTime_DB(_connectionSource);
        _instituteType_db = new InstituteType_DB(_connectionSource);
        _scheduledClass_db = new ScheduledClass_DB(_connectionSource);
        
        _entities_db = new ArrayList<>();
        _entities_db.add(_student_db);
        _entities_db.add(_teacher_db);
        _entities_db.add(_availableTime_db);
        _entities_db.add(_instituteType_db);
        _entities_db.add(_scheduledClass_db);
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

    private static void printAllTables() {
        try {
            Connection connection = _dataSource.getConnection();
            Statement st = connection.createStatement();
            ResultSet tables = st.executeQuery("Show Tables");
            Utils.info("Tables list : ");
            while (tables.next()) {
                Utils.info(tables.getString(1));
            }
            tables.close();
            st.close();
            connection.close();
        } catch (SQLException ex) {
            Utils.exception(ex);
        }

    }

    public static User getUserByEmail(String email) {
        return _student_db.getUserByEmail(email);
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
        return _instituteType_db.dao().queryForAll();
    }
    
    public static List<Teacher> getAllTeachers() throws SQLException {
        return _teacher_db.dao().queryForAll();
    }
}
