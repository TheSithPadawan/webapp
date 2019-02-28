package main;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.*;
import java.io.PrintWriter;

import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.text.DateFormat;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.text.SimpleDateFormat;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.*;

@WebServlet("/review_schedule")
public class ReviewScheduleServlet extends HttpServlet {
    private static final DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("LLL dd EEE");
    private static final DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("hh:mma");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String sectionID = request.getParameter("sectionID");
        String dateStartStr = request.getParameter("start");
        String dateEndStr = request.getParameter("end");

        LocalDate dateStart, dateEnd;
        try {
            dateStart = LocalDate.parse(dateStartStr);
            dateEnd = LocalDate.parse(dateEndStr);
        } catch (DateTimeParseException ex) {
            ex.printStackTrace();
            return;
        }

        // map day of week to a newline delimited string of time slots
        Map<DayOfWeek, ArrayList<String>> map = new HashMap<DayOfWeek, ArrayList<String>>();
        ArrayList<String> output = new ArrayList<String>();

        for (LocalDate currentDate = dateStart; currentDate.isBefore(dateEnd) || currentDate.isEqual(dateEnd); currentDate = currentDate.plusDays(1)) {
            DayOfWeek day = currentDate.getDayOfWeek();

            // skip weekends
            if (day == DayOfWeek.SATURDAY || day == DayOfWeek.SUNDAY) {
                continue;
            }

            // only need to be run once per day of week
            ArrayList<String> times = map.get(day);
            if (times == null) {
                ArrayList<String> newList = new ArrayList<String>();

                LocalTime timeStart = LocalTime.parse("08:00AM", timeFormatter);
                LocalTime timeEnd = LocalTime.parse("07:00PM", timeFormatter);
                LocalTime timeStartEnd = LocalTime.parse("09:00AM", timeFormatter);
                for (LocalTime currentTime = timeStart; currentTime.isBefore(timeEnd) || currentTime.equals(timeEnd); currentTime = currentTime.plusHours(1), timeStartEnd = timeStartEnd.plusHours(1)) {
                    String result = checkAvailable(sectionID, day, currentTime, timeStartEnd);
                    if (result != null) {
                        newList.add(result);
                    }
                }

                map.put(day, newList);
                times = newList;
            }

            String formattedDate = currentDate.format(dateFormatter);
            for (String formattedTime : times) {
                output.add(formattedDate + " " + formattedTime);
            }
        }

        Gson gson = new Gson();
        response.setStatus(200);
        response.setHeader("Content-Type", "application/json");
        PrintWriter writer = response.getWriter();
        writer.write(gson.toJson(output));
        writer.flush();
    }

    private String checkAvailable(String sectionID, DayOfWeek day, LocalTime start, LocalTime end) {
        String sqlDay = null;
        switch (day) {
            case MONDAY:
                sqlDay = "M";
                break;
            case TUESDAY:
                sqlDay = "Tu";
                break;
            case WEDNESDAY:
                sqlDay = "W";
                break;
            case THURSDAY:
                sqlDay = "Th";
                break;
            case FRIDAY:
                sqlDay = "F";
                break;
            default:
                return null;
        }

        String startStr = start.format(timeFormatter);
        String endStr = end.format(timeFormatter);

        String query =
            "SELECT COUNT(students_section.studentID) AS count " +
            "    FROM ( " +
            "        SELECT studentID " +
            "        FROM students_enrolled " +
            "        WHERE sectionID = '%s' " +
            "    ) AS students_section " +
            "JOIN students_enrolled " +
            "    ON students_enrolled.studentID = students_section.studentID " +
            "JOIN has_weekly_meetings " +
            "    ON has_weekly_meetings.sectionID = students_enrolled.sectionID " +
            "WHERE has_weekly_meetings.day = '%s'::day_enum " +
            "    AND has_weekly_meetings.time_start < '%s' AND has_weekly_meetings.time_end > '%s' " +
            "    AND students_enrolled.quarter = 'WI'::quarter_enum AND students_enrolled.year = 2019";
        String formattedQuery = String.format(query, sectionID, sqlDay, endStr, startStr);

        try {
            DBConn dbConn = new DBConn();
            dbConn.openConnection();
            dbConn.executeQuery(formattedQuery);
            ResultSet rs = dbConn.getResultSet();
            rs.next();
            Integer count = rs.getInt("count");
            if (count != 0) {
                return null;
            }

            dbConn.closeConnections();
        } catch (Exception ex) {
            return null;
        }

        String result = startStr + " - " + endStr;
        return result;
    }
}
