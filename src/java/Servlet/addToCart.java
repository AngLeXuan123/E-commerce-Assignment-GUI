/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author user
 */
public class addToCart extends HttpServlet {

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
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        HttpSession httpSession = request.getSession();
        String username = (String)httpSession.getAttribute("username");
        String id = request.getParameter("id");
        int quantity = 1;
        
        try {
            addToCart(username, id, quantity);
            response.sendRedirect("main/customer/index.jsp");
        } catch (SQLException ex) {
            Logger.getLogger(signUpServlets.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    private void initializeJdbc() {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(host, user, password);
            pstmt = conn.prepareStatement("INSERT INTO CART_ITEM VALUES(?, ?, ?)");
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    private void addToCart(String username, String prod_id, int quantity) throws SQLException {
        pstmt.setString(1, username);
        pstmt.setString(2, prod_id);
        pstmt.setInt(3, quantity);
        pstmt.executeUpdate();
    }

    public boolean equals(Object obj) {
        return (this == obj);
    }

}
