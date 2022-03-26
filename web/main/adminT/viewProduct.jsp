<%-- 
    Document   : profile.jsp
    Created on : 3 Mar 2022, 9:04:08 pm
    Author     : user
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%@ page import="java.io.*" %>
        <%@ page import="javax.servlet.*" %>
        <%@ page import="javax.servlet.http.*" %>
        <%@ page import="java.sql.*" %>
        <%@ page import="java.util.*" %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>

        <%  String id = request.getParameter("id");    
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            } catch (ClassNotFoundException e) {
            e.printStackTrace();
            }
            
            
        
            ResultSet rs = null;
            try {
            Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/assignmentdb", "nbuser", "nbuser");
            PreparedStatement ps = con.prepareStatement("select * from product where prod_id = ?");
            ps.setString(1, id);
            rs = ps.executeQuery();
            
            
            String base64Image = "";
            
            
            while (rs.next()) {
                
            Blob pic;
            pic = rs.getBlob("prod_photo");
           
            if (pic != null) {

                                InputStream inputStream = pic.getBinaryStream();

                                ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                                byte[] buffer = new byte[4096];
                                int bytesRead = -1;

                                while ((bytesRead = inputStream.read(buffer)) != -1) {
                                outputStream.write(buffer, 0, bytesRead);
                                }

                                byte[] imageBytes = outputStream.toByteArray();
                                base64Image = Base64.getEncoder().encodeToString(imageBytes);
                                }
        %>
        <div class='solid'>
            <img src="data:image/jpg;base64,<%= base64Image %>" width="240" height="300"/>
            <p>Name : <%= rs.getString("prod_name") %> </p>
            <p>Description : <%= rs.getString("prod_desc") %> </p>
            <p>Price : <%= rs.getString("prod_price") %> </p>
            <p>Quantity : <%= rs.getString("prod_quantity") %> </p>
            <p>Release Date : <%= rs.getString("prod_release") %> </p>
            <p>Brand : <%= rs.getString("prod_brand") %> </p>
            <p>Category : 
            <%
            if(rs.getString("prod_category").charAt(0) == 'L') {
            %>
            Laptop
            <%
            }
            %>
            <br><a href="forms/editProduct.jsp?id=<%= id %>"><button type=\"button\">Edit Product</button></a>
            <br><a href="http://localhost:8080/E-commerce-Assignment-GUI/deleteProduct?id=<%= id %>"><button type=\"button\">Delete Product</button></a>
        </div>

        <%
                    } } catch (Exception e) {
                                    e.printStackTrace();
                                    }
        %>
    </body>
</html>
