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

public class editProduct extends HttpServlet {

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
        
        String id = request.getParameter("id");
        
        String name = request.getParameter("name");
        String desc = request.getParameter("desc");
        String priceString = request.getParameter("price");
        double price = Double.parseDouble(priceString);
        String quantityString = request.getParameter("quantity");        
        int quantity = Integer.parseInt(quantityString);
        String brand = request.getParameter("brand");
        String category = request.getParameter("category");
         
        InputStream inputStream = null;
        Part filePart = request.getPart("photo");
        inputStream = filePart.getInputStream();
               
        try {
            if (name.length() == 0 || desc.length() == 0 || brand.length() == 0 || category.length() == 0) {
                out.println("Please fill out all the fields!");
                errorCount++;
            }

            if (errorCount == 0) {
                editProduct(name, desc, quantity, inputStream, brand, category, price, id);
                response.sendRedirect("main/adminT/product.jsp");
            }
        } catch (SQLException ex) {
            out.println("ERROR: " + ex.getMessage());
        }
    }

    private void initializeJdbc() {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(host, user, password);
            pstmt = conn.prepareStatement("update product set prod_name = ?, prod_desc = ?, prod_quantity = ?, prod_photo = ?, prod_brand = upper(?), prod_category = upper(?), prod_price = ? where prod_id = ?");
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    private void editProduct(String name, String desc, int quantity, InputStream photo, String brand, String category, double price, String id) throws SQLException {
        pstmt.setString(1, name);
        pstmt.setString(2, desc);    
        pstmt.setInt(3, quantity);
        pstmt.setBlob(4, photo);
        pstmt.setString(5, brand);
        pstmt.setString(6, category);
        pstmt.setDouble(7, price);
        pstmt.setString(8, id);
        pstmt.executeUpdate();
    }

    public boolean equals(Object obj) {
        return (this == obj);
    }
}