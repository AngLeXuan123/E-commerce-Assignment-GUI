package Servlet;

import java.io.*;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class deleteStaff extends HttpServlet {

    private Connection conn;
    private PreparedStatement pstmt;
    private String host = "jdbc:derby://localhost:1527/assignmentdb";
    private String user = "nbuser";
    private String password = "nbuser";
    private int errorCount = 0;

    // Initialize variables
    @Override
    public void init() throws ServletException {
        initializeJdbc();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
       
        try {
            String username = request.getParameter("id");
            deleteStaff(username);
            response.sendRedirect("main/adminT/staff.jsp");
        } catch (SQLException ex) {
            Logger.getLogger(deleteStaff.class.getName()).log(Level.SEVERE, null, ex);
        }         
    }

    private void initializeJdbc() {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(host, user, password);
            pstmt = conn.prepareStatement("delete from account where id = ?");
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    private void deleteStaff(String username) throws SQLException {
        pstmt.setString(1, username);
        pstmt.executeUpdate();
    }

    public boolean equals(Object obj) {
        return (this == obj);
    }
}