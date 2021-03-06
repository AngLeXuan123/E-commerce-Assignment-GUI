package Servlet;

import java.io.*;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class deleteComment extends HttpServlet {

    private Connection conn;
    private PreparedStatement pstmt, pstmt2;
    private String host = "jdbc:derby://localhost:1527/assignmentdb";
    private String user = "nbuser";
    private String password = "nbuser";

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
            String prod = request.getParameter("prod");
            String id = request.getParameter("id");
            deleteReply(id);
            deleteComment(id);
            
            response.sendRedirect("main/adminT/viewProduct.jsp?id=" + prod);
        } catch (SQLException ex) {
            Logger.getLogger(deleteStaff.class.getName()).log(Level.SEVERE, null, ex);
        }
                  
    }

    private void initializeJdbc() {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(host, user, password);
            pstmt = conn.prepareStatement("delete from comment where comment_id = ?");
            pstmt2 = conn.prepareStatement("delete from reply where comment_id = ?");
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    private void deleteComment(String id) throws SQLException {
        pstmt.setString(1, id);
        pstmt.executeUpdate();
    }
    
    private void deleteReply(String id) throws SQLException {
        pstmt2.setString(1, id);
        pstmt2.executeUpdate();
    }

    public boolean equals(Object obj) {
        return (this == obj);
    }
}