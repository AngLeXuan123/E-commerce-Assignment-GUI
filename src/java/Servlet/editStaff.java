package Servlet;

import java.time.*;
import java.util.Date;
import java.io.*;
import java.sql.*;
import java.time.format.DateTimeFormatter;
import java.util.Base64;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

public class editStaff extends HttpServlet {

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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        String username = request.getParameter("username");
        String pass = request.getParameter("password");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");        
        
        InputStream inputStream = null;

        
        Part filePart = request.getPart("photo");
        
        inputStream = filePart.getInputStream();
        try {
            if (pass.length() == 0 || email.length() == 0 || phoneNumber.length() == 0) {
                out.println("Please fill out all the fields!");
                errorCount++;
            }

            if (errorCount == 0) {
                editStaff(pass, email, phoneNumber, inputStream, username);
                response.sendRedirect("main/adminT/staff.jsp");
            }
        } catch (SQLException ex) {
            out.println("ERROR: " + ex.getMessage());
        }
    }

    private void initializeJdbc() {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(host, user, password);
            pstmt = conn.prepareStatement("update account set password = ?, email = ?, phoneNumber = ?, photo = ? where id = ?");
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    private void editStaff(String pass, String email, String phoneNumber, InputStream photo, String username) throws SQLException {
        pstmt.setString(1, pass);
        pstmt.setString(2, email);
        pstmt.setString(3, phoneNumber);
        pstmt.setBlob(4, photo);
        pstmt.setString(5, username);
        pstmt.executeUpdate();
    }

    public boolean equals(Object obj) {
        return (this == obj);
    }
}