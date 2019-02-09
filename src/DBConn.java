import java.sql.*;

/*
    Use your own connection string
 */

public class DBConn{
    private static final boolean DEBUG = true;
    private final String connectionUrl;
    private final String user = "admin";
    private final String password = "winter2019";
    public Connection conn;
    public Statement stmt;
    public ResultSet rs;
    public DBConn(){
        this.connectionUrl = "jdbc:postgresql://localhost:5432/cse132b";
    }

    public void openConnection(){
        try {
            Class.forName("org.postgresql.Driver");
            this.conn = DriverManager.getConnection(connectionUrl, user, password);
            this.stmt = this.conn.createStatement();
            if(DEBUG) System.out.println("Connected to DB successfully");
        }
        // Handle any errors that may have occurred.
        catch (Exception e) {
            System.out.println(e.getMessage());
            e.printStackTrace();
            if(DEBUG) System.out.println("Connection to DB failed.");
        }
    }

    public void closeConnections(){
        try {
            if( null != this.rs ) this.rs.close();
            if( null != this.stmt ) this.stmt.close();
            if( null != this.conn ) this.conn.close();
            if(DEBUG) System.out.println("Connection to DB closed.");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void executeQuery(String query){
        try {
            this.rs = this.stmt.executeQuery(query);
        } catch (SQLException e) {
            e.printStackTrace();
            if(DEBUG){ System.out.println("Query failed to execute:");
                System.out.println(query);
            }
        }
    }

    public PreparedStatement getPreparedStatment(String statement){
        try {
            this.conn.setAutoCommit(false);
            PreparedStatement pstmt = this.conn.prepareStatement(statement);
            return pstmt;

        } catch (SQLException e) {
            e.printStackTrace();
            if(DEBUG) System.out.println("Failed to create PreparedStatement.");
        }
        return null;
    }

    public boolean executePreparedStatement(PreparedStatement pstmt){
        boolean success = false;
        try{
            pstmt.executeUpdate();
            this.conn.commit();
            this.conn.setAutoCommit(true);
            success = true;
            return success;
        }
        catch (SQLException e) {
            System.out.println(e.getMessage());
            if(DEBUG){ System.out.println("Failed to execute prepared statement");
                System.out.println(pstmt.toString());
            }
        }
        return success;
    }

    public ResultSet getResultSet(){
        return this.rs;
    }

    public Statement getStatement(){
        try {
            return this.conn.createStatement();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /*
        Run this to test if you can connect to the database successfully
     */
    public static void main(String[] args){
        DBConn test = new DBConn();
        test.openConnection();
        String query = "SELECT * FROM student";
        test.executeQuery(query);
        ResultSet rs = test.getResultSet();
        try{
            while (rs.next()){
                System.out.println(rs.getString("ssn"));
            }
        } catch (Exception ex){
            System.out.println(ex.getMessage());
        }

        test.closeConnections();
    }

}
