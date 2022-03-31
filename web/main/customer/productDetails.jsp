<%-- 
    Document   : productDetails
    Created on : 20 Mar 2022, 7:22:33 pm
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
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" />
        <link rel="icon" type="image/x-icon" href="assets/favicon.ico" />
        <!-- Bootstrap icons-->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" rel="stylesheet" />
        <!-- Core theme CSS (includes Bootstrap)-->
        <link href="css/styles.css" rel="stylesheet" />
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Core theme JS-->
        <script src="js/scripts.js"></script>
        <title>JSP Page</title>
    </head>
    <body>
    <% String prodId = request.getParameter("prod");
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        int count = 0;
        ResultSet rs = null, rs2 = null, rs3 = null;
        HttpSession httpSession = request.getSession();
        String username = (String)(httpSession.getAttribute("username"));
        try {
            Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/assignmentdb", "nbuser", "nbuser");
            PreparedStatement ps = con.prepareStatement("select * from product where prod_id = ?");
            PreparedStatement ps2 = con.prepareStatement("select * from cart_item where id = ?");
            ps2.setString(1, username);
            ps.setString(1, prodId);
            rs = ps.executeQuery();
            rs2 = ps2.executeQuery();
            
            
            while(rs2.next()) {
                count++;
            }
 
            String base64Image = "";

            if (rs.next()) {
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
                <nav class="navbar navbar-expand-lg navbar-light bg-light">
            <div class="container px-4 px-lg-5">
                <a class="navbar-brand" href="#!">Start Bootstrap</a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation"><span class="navbar-toggler-icon"></span></button>
                <div class="collapse navbar-collapse" id="navbarSupportedContent">
                    <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-4">
                        <li class="nav-item"><a class="nav-link active" aria-current="page" href="index.jsp">Home</a></li>
                        <li class="nav-item"><a class="nav-link" href="order.jsp">Order</a></li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">Account</a>
                            <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                                <li><a class="dropdown-item" href="profile.jsp">Profile</a></li>
                                <li><hr class="dropdown-divider" /></li>
                                <li><a class="dropdown-item" href="http://localhost:8080/E-commerce-Assignment-GUI/Logout">Logout</a></li>
                          
                            </ul>
                        </li>
                    </ul>
                    <a href="cart.jsp">
                        
                        <button class="btn btn-outline-dark" type="submit">
                            <i class="bi-cart-fill me-1"></i>
                            Cart
                            <span class="badge bg-dark text-white ms-1 rounded-pill"><%= count %></span>
                        </button>
                    </a>
                </div>
            </div>
        </nav>
        <!-- Header-->
        <header class="bg-dark py-5">
            <div class="container px-4 px-lg-5 my-5">
                <div class="text-center text-white">
                    <h1 class="display-4 fw-bolder">Shop in style</h1>
                    <p class="lead fw-normal text-white-50 mb-0">With this shop hompeage template</p>
                </div>
            </div>
        </header>
                <table class="table table-bordered table-striped mb-4">
                <tr><td align="center" colspan="2"><img src="data:image/jpg;base64,<%= base64Image %>" width="240" height="300"/></td></tr>
                <tr><td>Product name </td><td> <%= rs.getString("prod_name")%></td></tr>
                <tr><td>Description </td><td> <%= rs.getString("prod_desc") %> </td></tr>
                <tr><td>Price </td><td>RM <%= String.format("%.2f", rs.getDouble("prod_price")) %></td></tr>
                <tr><td>Stock left </td><td>  <%= rs.getString("prod_quantity") %></td></tr>
                <tr><td>Brand </td><td>  <%= rs.getString("prod_brand") %></td></tr>
                <%  
                                rs3 = ps2.executeQuery();
                                int count2 = 0;
                                while(rs3.next()) {
                                    if(rs3.getString("PROD_ID").equals(rs.getString("PROD_ID")) == true) { 
                                        count2++;
                                    } 
                                }
                                if(count2 > 0) {
                                    %><tr><td align="center" colspan="2"><div class="text-left"><a class="btn btn-outline-dark mt-auto" disabled>Already in cart</a></div></td></tr><%
                                }
                                else if (rs.getInt("PROD_QUANTITY") <= 0) {
                                    %><tr><td align="center" colspan="2"><div class="text-left"><a class="btn btn-outline-dark mt-auto" disabled>Sold out</a></div></td></tr><%
                                } 
                                else {
                                    %><tr><td align="center" colspan="2"><div class="text-left"><a class="btn btn-outline-dark mt-auto" href="http://localhost:8080/E-commerce-Assignment-GUI/cart?id=<%= rs.getString("PROD_ID") %>">Add to cart</a></div></td></tr> <%
                                } 
                                %>
                
                <%
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    %> 
                </table>
        <!-- Bootstrap core JS-->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Core theme JS-->
        <script src="js/scripts.js"></script>
        
    </body>
</html>
