/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.*;

/**
 *
 * @author user
 */
public class checkout extends HttpServlet {

    private ResultSet rs, rs2, rs3;
    private Connection conn;
    private PreparedStatement pstmt, pstmt2, pstmt3, pstmt4, pstmt5, pstmt6, pstmt7;
    private String host = "jdbc:derby://localhost:1527/assignmentdb";
    private String user = "nbuser";
    private String password = "nbuser";

    @Override
    public void init() throws ServletException {
        initializeJdbc();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        HttpSession httpSession = request.getSession();
        String username = (String) httpSession.getAttribute("username");

        String address = request.getParameter("address");
        String phoneNum = request.getParameter("phoneNumber");
        String repName = request.getParameter("name");
        String cardNum = request.getParameter("cardNum");
        String expiryMonthString = request.getParameter("expiryMonth");
        int expiryMonth = Integer.parseInt(expiryMonthString);
        String expiryYearString = request.getParameter("expiryYear");
        int expiryYear = Integer.parseInt(expiryYearString);
        String ccvString = request.getParameter("cardCCV");
        int cardCCV = Integer.parseInt(ccvString);
        String amountString = request.getParameter("amount");
        double amount = Double.parseDouble(amountString);

        String orderStatus = "Order Received";

        try {
            int orderId = 0;
            
            pstmt = conn.prepareStatement("INSERT INTO ORDERS (ORDER_ADDRESS, PHONENUM, RECIPIENTNAME, ORDER_STATUS, ID, CARD_NUMBER, EXPIRY_MONTH, EXPIRY_YEAR, CARD_CCV, TOTAL_AMOUNT, ORDER_TIME) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)", Statement.RETURN_GENERATED_KEYS);  
            pstmt.setString(1, address);
            pstmt.setString(2, phoneNum);
            pstmt.setString(3, repName);
            pstmt.setString(4, orderStatus);
            pstmt.setString(5, username);
            pstmt.setString(6, cardNum);
            pstmt.setInt(7, expiryMonth);
            pstmt.setInt(8, expiryYear);
            pstmt.setInt(9, cardCCV);
            pstmt.setDouble(10, amount);
            pstmt.executeUpdate();
            rs3 = pstmt.getGeneratedKeys();
            rs3.next();
            orderId = rs3.getInt(1);       

            pstmt2 = conn.prepareStatement("SELECT * FROM CART_ITEM WHERE ID = ?");
            pstmt2.setString(1, username);
            rs = pstmt2.executeQuery();

            while(rs.next()) {
                pstmt3 = conn.prepareStatement("UPDATE PRODUCT SET PROD_QUANTITY = PROD_QUANTITY - ? WHERE PROD_ID = ?");
                pstmt3.setInt(1, Integer.parseInt(rs.getString("quantity")));
                pstmt3.setInt(2, Integer.parseInt(rs.getString("prod_id")));
                pstmt3.executeUpdate();

                pstmt4 = conn.prepareStatement("INSERT INTO ORDER_ITEM (ORDER_ID, PROD_ID, ORDER_QUANTITY) VALUES (?, ?, ?)");
                pstmt4.setInt(1, orderId);
                pstmt4.setInt(2, Integer.parseInt(rs.getString("prod_id")));
                pstmt4.setInt(3, Integer.parseInt(rs.getString("quantity")));
                pstmt4.executeUpdate();

                pstmt5 = conn.prepareStatement("DELETE FROM CART_ITEM WHERE ID = ? AND PROD_ID = ?");
                pstmt5.setString(1, rs.getString("id"));
                pstmt5.setInt(2, Integer.parseInt(rs.getString("prod_id")));
                pstmt5.executeUpdate();
            }

            response.sendRedirect("main/customer/order.jsp");
        } catch (SQLException ex) {
            Logger.getLogger(checkout.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    private void initializeJdbc() {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(host, user, password);  
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    public boolean equals(Object obj) {
        return (this == obj);
    }

}
