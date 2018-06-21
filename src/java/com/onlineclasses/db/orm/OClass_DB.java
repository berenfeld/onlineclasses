/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.onlineclasses.db.orm;

import com.j256.ormlite.stmt.PreparedQuery;
import com.j256.ormlite.stmt.QueryBuilder;
import com.j256.ormlite.stmt.SelectArg;
import com.j256.ormlite.stmt.UpdateBuilder;
import com.j256.ormlite.stmt.Where;
import com.j256.ormlite.support.ConnectionSource;
import com.onlineclasses.entities.OClass;
import com.onlineclasses.entities.Student;
import com.onlineclasses.entities.Teacher;
import com.onlineclasses.utils.CConfig;
import com.onlineclasses.utils.Utils;
import java.sql.SQLException;
import java.util.List;

public class OClass_DB extends Base_DB<OClass> {

    public OClass_DB(ConnectionSource connectionSource) throws SQLException {
        super(connectionSource, OClass.class);

        QueryBuilder<OClass, Integer> queryBuilder = _dao.queryBuilder();
        Where<OClass, Integer> where = queryBuilder.where();
        where.eq(OClass.TEACHER_COLUMN, _getTeacherClassesTeacherArg);
        where.and();
        where.ne(OClass.STATUS_COLUMN, OClass.STATUS_CANCELCED);
        _getTeacherNotCanceledClasses = queryBuilder.prepare();

        where.reset();
        where.eq(OClass.STUDENT_COLUMN, _getStudentUpcomingClassesStudentArg);
        where.and();
        where.eq(OClass.STATUS_COLUMN, OClass.STATUS_SCHEDULED);
        where.and();
        where.le(OClass.START_DATE_COLUMN, _getStudentUpcomingClassesStartDateArg);
        queryBuilder.orderBy(OClass.START_DATE_COLUMN, true);
        _getStudentUpcomingClasses = queryBuilder.prepare();

        where.reset();
        where.eq(OClass.TEACHER_COLUMN, _getTeacherUpcomingClassesTeacherArg);
        where.and();
        where.eq(OClass.STATUS_COLUMN, OClass.STATUS_SCHEDULED);
        where.and();
        where.le(OClass.START_DATE_COLUMN, _getTeacherUpcomingClassesStartDateArg);
        queryBuilder.orderBy(OClass.START_DATE_COLUMN, true);
        _getTeacherUpcomingClasses = queryBuilder.prepare();

    }

    private final PreparedQuery<OClass> _getTeacherNotCanceledClasses;
    private final SelectArg _getTeacherClassesTeacherArg = new SelectArg();
    private final PreparedQuery<OClass> _getStudentUpcomingClasses;
    private final SelectArg _getStudentUpcomingClassesStudentArg = new SelectArg();
    private final SelectArg _getStudentUpcomingClassesStartDateArg = new SelectArg();
    private final PreparedQuery<OClass> _getTeacherUpcomingClasses;
    private final SelectArg _getTeacherUpcomingClassesTeacherArg = new SelectArg();
    private final SelectArg _getTeacherUpcomingClassesStartDateArg = new SelectArg();

    public synchronized List<OClass> getTeacherNotCanceledScheduledClasses(Teacher teacher) throws SQLException {
        _getTeacherClassesTeacherArg.setValue(teacher);
        return _dao.query(_getTeacherNotCanceledClasses);
    }

    public synchronized List<OClass> getStudentUpcomingClasses(Student student) throws SQLException {
        _getStudentUpcomingClassesStudentArg.setValue(student);
        _getStudentUpcomingClassesStartDateArg.setValue(Utils.xHoursFromNow(CConfig.getInt("website.time.upcoming_student_classes_hours")));
        return _dao.query(_getStudentUpcomingClasses);
    }

    public synchronized List<OClass> getTeacherUpcomingClasses(Teacher teacher) throws SQLException {
        _getTeacherUpcomingClassesTeacherArg.setValue(teacher);
        _getTeacherUpcomingClassesStartDateArg.setValue(Utils.xHoursFromNow(CConfig.getInt("website.time.upcoming_teacher_classes_hours")));
        return _dao.query(_getTeacherUpcomingClasses);
    }

    public int updateClassStatus(OClass oClass, int status) throws SQLException {
        UpdateBuilder<OClass, Integer> updateBuilder = _dao.updateBuilder();
        updateBuilder.where().idEq(oClass.id);
        updateBuilder.updateColumnValue(OClass.STATUS_COLUMN, status);
        return updateBuilder.update();
    }

    public int updateClassPricePerHour(OClass oClass, int newPricePerHour) throws SQLException {
        UpdateBuilder<OClass, Integer> updateBuilder = _dao.updateBuilder();
        updateBuilder.where().idEq(oClass.id);
        updateBuilder.updateColumnValue(OClass.PRICE_PER_HOUR_COLUMN, newPricePerHour);
        return updateBuilder.update();
    }

}
