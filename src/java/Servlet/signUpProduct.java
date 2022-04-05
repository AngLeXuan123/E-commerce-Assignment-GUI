package Servlet;

import java.time.*;
import java.util.Date;
import java.io.*;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part; 

public class signUpProduct extends HttpServlet {

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
        
        String name = request.getParameter("name");
        String desc = request.getParameter("desc");
        String priceString = request.getParameter("price");
        double price = Double.parseDouble(priceString);
        String quantityString = request.getParameter("quantity");        
        int quantity = Integer.parseInt(quantityString);
        String brand = request.getParameter("brand");
        String category = request.getParameter("category");
        
        LocalDate RegDate = java.time.LocalDate.now();
        Date reg = Date.from(RegDate.atStartOfDay(ZoneId.systemDefault()).toInstant());
        java.sql.Date regDate = new java.sql.Date(reg.getTime());
        
        InputStream inputStream = null;
        Part filePart = request.getPart("photo");
        inputStream = filePart.getInputStream();

            if (name.length() == 0 || desc.length() == 0 || brand.length() == 0 || category.length() == 0) {
                out.println("Please fill out all the fields!");
                errorCount++;
            }

            if (errorCount == 0) {
                try {
                    signUpAccount(name, desc, quantity, regDate, inputStream, brand, category, price);
                    response.sendRedirect("main/adminT/product.jsp");
                } catch (SQLException ex) {
                    Logger.getLogger(signUpServlets.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
}

private void initializeJdbc() {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(host, user, password);
            pstmt = conn.prepareStatement("INSERT INTO PRODUCT (PROD_NAME, PROD_DESC, PROD_QUANTITY, PROD_RELEASE, PROD_PHOTO, PROD_BRAND, PROD_CATEGORY, PROD_PRICE) VALUES(?, ?, ?, ?, ?, upper(?), ?, ?)");
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    private void signUpAccount(String name, String desc, int quantity, java.sql.Date regDate, InputStream photo, String brand, String category, double price) throws SQLException {
        pstmt.setString(1, name);
        pstmt.setString(2, desc);;
        pstmt.setInt(3, quantity);
        pstmt.setDate(4, regDate);
        pstmt.setBlob(5, photo);
        pstmt.setString(6, brand);
        pstmt.setString(7, category);
        pstmt.setDouble(8, price);
        pstmt.executeUpdate();
    }

    public boolean equals(Object obj) {
        return (this == obj);
    }
}
