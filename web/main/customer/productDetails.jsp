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
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

        <!-- Core theme CSS (includes Bootstrap)-->
        <link href="css/styles.css" rel="stylesheet" />
        <!-- Core theme JS-->
        <title>JSP Page</title>
    </head>
    <body>
        
    <%  
        String prodId = request.getParameter("prod");
        int prod = Integer.parseInt(prodId);
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        int count = 0, count3 = 0, count4 = 0, ratingCount = 0;
        ResultSet rs = null, rs2 = null, rs3 = null, rs4 = null, rs5 = null, rs6 = null, rs7 = null, rs8 = null;
        HttpSession httpSession = request.getSession();
        String username = (String)(httpSession.getAttribute("username"));
        try {
            Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/assignmentdb", "nbuser", "nbuser");
            PreparedStatement ps = con.prepareStatement("select * from product where prod_id = ?");
            PreparedStatement ps2 = con.prepareStatement("select * from cart_item where id = ?");
            PreparedStatement ps3 = con.prepareStatement("select * from comment where prod_id = ?");
            PreparedStatement ps4 = con.prepareStatement("select * from orders where id = ?");
            PreparedStatement ps5 = con.prepareStatement("select * from order_item where order_id = ?");
            PreparedStatement ps6 = con.prepareStatement("select * from comment where prod_id = ? and id = ?");
            PreparedStatement ps7 = con.prepareStatement("select * from reply where comment_id = ?");

            ps.setString(1, prodId);
            ps2.setString(1, username);
            ps3.setString(1, prodId);
            ps4.setString(1, username);
            ps6.setString(1, prodId);
            ps6.setString(2, username);
            
            rs = ps.executeQuery();
            rs2 = ps2.executeQuery();
            rs4 = ps3.executeQuery();
            rs5 = ps4.executeQuery();
            rs7 = ps6.executeQuery();
            
            while(rs7.next()) {
                count4++;
            }
            
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
                    <form method="get" action="search.jsp" style="margin-right: 30px;">
                    <input type="text" name="id" placeholder="Search">
                    <button type="submit"><i class="fa fa-search"></i></button>
                    </form>
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
    %> 
                </table>
                <h2>Comment(s)</h2>
                <table class="table table-bordered table-striped mb-4">
                    <% while(rs5.next()) { 
                       ps5.setInt(1, rs5.getInt("order_id"));
                       rs6 = ps5.executeQuery();
                            while(rs6.next()) {
                                if(rs6.getInt("prod_id") == prod && count3 == 0 && count4 == 0) { count3++; %>
                                    
                                    <tr><form class="form-group" method="get" action="http://localhost:8080/E-commerce-Assignment-GUI/submitComment">
                                        <td><input type="text" name="comment" placeholder="Leave your comment..." required></td><td>Rating (1-5) : <input type="number" min="1" max="5" name="rating" placeholder="Rating(1-5)" required></td><td><input type="submit" value="Submit"></td>
                                        <input type="hidden" value="<%= prod %>" name="prod">
                                    </tr></form>
                                    
                                <% }
                            }
                    }%>
                        <% while(rs4.next()) { 
                        ps7.setInt(1, rs4.getInt("comment_id"));
                        rs8 = ps7.executeQuery();%>
                        <table class="table table-bordered table-striped mb-4">
                    <tr><td><%= rs4.getString("id") %></td><td><%= rs4.getString("comment_time") %></td></tr>
                    <tr><td><%= rs4.getString("comment_text") %></td><td><% while(ratingCount < rs4.getInt("rating")) { ratingCount++;%><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-star" viewBox="0 0 16 16">
  <path d="M2.866 14.85c-.078.444.36.791.746.593l4.39-2.256 4.389 2.256c.386.198.824-.149.746-.592l-.83-4.73 3.522-3.356c.33-.314.16-.888-.282-.95l-4.898-.696L8.465.792a.513.513 0 0 0-.927 0L5.354 5.12l-4.898.696c-.441.062-.612.636-.283.95l3.523 3.356-.83 4.73zm4.905-2.767-3.686 1.894.694-3.957a.565.565 0 0 0-.163-.505L1.71 6.745l4.052-.576a.525.525 0 0 0 .393-.288L8 2.223l1.847 3.658a.525.525 0 0 0 .393.288l4.052.575-2.906 2.77a.565.565 0 0 0-.163.506l.694 3.957-3.686-1.894a.503.503 0 0 0-.461 0z"/>
</svg> <%}%></td></tr>      
                    <% if(rs8.next()) { %>
                    <tr><td><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-reply" viewBox="0 0 16 16">
  <path d="M6.598 5.013a.144.144 0 0 1 .202.134V6.3a.5.5 0 0 0 .5.5c.667 0 2.013.005 3.3.822.984.624 1.99 1.76 2.595 3.876-1.02-.983-2.185-1.516-3.205-1.799a8.74 8.74 0 0 0-1.921-.306 7.404 7.404 0 0 0-.798.008h-.013l-.005.001h-.001L7.3 9.9l-.05-.498a.5.5 0 0 0-.45.498v1.153c0 .108-.11.176-.202.134L2.614 8.254a.503.503 0 0 0-.042-.028.147.147 0 0 1 0-.252.499.499 0 0 0 .042-.028l3.984-2.933zM7.8 10.386c.068 0 .143.003.223.006.434.02 1.034.086 1.7.271 1.326.368 2.896 1.202 3.94 3.08a.5.5 0 0 0 .933-.305c-.464-3.71-1.886-5.662-3.46-6.66-1.245-.79-2.527-.942-3.336-.971v-.66a1.144 1.144 0 0 0-1.767-.96l-3.994 2.94a1.147 1.147 0 0 0 0 1.946l3.994 2.94a1.144 1.144 0 0 0 1.767-.96v-.667z"/>
                    </svg>Admin</td><td><%= rs8.getString("reply_time") %></td></tr>
                    <tr><td colspan="2"><%= rs8.getString("reply_text") %></td></tr>

                    <% } %>
                        </table>
                    <%  } %>
                </table>
    </table>
                </body>
                <% } catch (Exception e) {
                e.printStackTrace();
                } %>
        <footer class="py-5 bg-dark">
            <div class="container"><p class="m-0 text-center text-white">Copyright &copy; Your Website 2021</p></div>
        </footer>
        <!-- Bootstrap core JS-->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Core theme JS-->
        <script src="js/scripts.js"></script>
        
    
</html>
