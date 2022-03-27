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
public class minusQuantity extends HttpServlet {

    private Connection conn;
    private PreparedStatement pstmt, pstmt2;
    private String host = "jdbc:derby://localhost:1527/assignmentdb";
    private String user = "nbuser";
    private String password = "nbuser";
    private int errorCount = 0;

    // Initialize variables
    @Override
    public void init() throws ServletException {
        initializeJdbc();
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        HttpSession httpSession = request.getSession();
        String username = (String)httpSession.getAttribute("username");
        String id = request.getParameter("prod_id");
        String quantityString = request.getParameter("quantity");
        int quantity = Integer.parseInt(quantityString);
        
        try {
            if(quantity - 1 <= 0) {
                deleteCart(username, id);
            }
            else {
                minusQuantity(quantity, username, id);
            }
            response.sendRedirect("main/customer/cart.jsp");
        } catch (SQLException ex) {
            Logger.getLogger(signUpServlets.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    private void initializeJdbc() {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(host, user, password);
            pstmt = conn.prepareStatement("UPDATE CART_ITEM SET QUANTITY = ? WHERE ID = ? AND PROD_ID = ?");
            pstmt2 = conn.prepareStatement("DELETE FROM CART_ITEM WHERE ID = ? AND PROD_ID = ?");
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    private void minusQuantity(int quantity, String username, String prod_id) throws SQLException {
        pstmt.setInt(1, quantity - 1);
        pstmt.setString(2, username);
        pstmt.setString(3, prod_id);
        
        pstmt.executeUpdate();
    }
    
    private void deleteCart(String username, String prod_id) throws SQLException {
        pstmt2.setString(1, username);
        pstmt2.setString(2, prod_id);
        
        pstmt2.executeUpdate();
    }

    public boolean equals(Object obj) {
        return (this == obj);
    }

}
