<%-- 
    Document   : newjs
    Created on : 28 Mar 2022, 8:12:31 pm
    Author     : user
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <%@ page import="java.io.*" %>
        <%@ page import="javax.servlet.*" %>
        <%@ page import="javax.servlet.http.*" %>
        <%@ page import="java.sql.*" %>
        <%@ page import="java.util.*" %>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" />
        <title>Shop Homepage - Start Bootstrap Template</title>
        <!-- Favicon-->
        <link rel="icon" type="image/x-icon" href="assets/favicon.ico" />
        <!-- Bootstrap icons-->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" rel="stylesheet" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <!-- Core theme CSS (includes Bootstrap)-->
        <link href="css/styles.css" rel="stylesheet" />
        <%  try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            } catch (ClassNotFoundException e) {
            e.printStackTrace();
            }
            int count = 0, count2 = 0;
            ResultSet rs = null, rs2 = null, rs3 = null, rs4 = null, rs5 = null;
            String id = request.getParameter("id");
            HttpSession httpSession = request.getSession();
            String username = (String)(httpSession.getAttribute("username"));
            String photo = (String)(httpSession.getAttribute("photo"));
            try {
            Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/assignmentdb", "nbuser", "nbuser");
            PreparedStatement ps = con.prepareStatement("select * from product");
            PreparedStatement ps2 = con.prepareStatement("select * from cart_item where id = ?");
            PreparedStatement ps3 = con.prepareStatement("select * from order_item where order_id = ?");
            PreparedStatement ps4 = con.prepareStatement("select * from product where prod_id = ?");
            PreparedStatement ps5 = con.prepareStatement("select * from orders where order_id = ?");
            ps2.setString(1, username);
            ps3.setString(1, id);
            ps5.setString(1, id);        
            
            rs = ps.executeQuery();
            rs2 = ps2.executeQuery();
            rs3 = ps3.executeQuery();
            rs5 = ps5.executeQuery(); 
            String base64Image = "";
            
            while(rs2.next()) {
                count++;
            }
            
            
        %>
    </head>
    <body>
        <!-- Navigation-->
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
        <h2>Order item(s) :</h2>
        <table caption="Order item(s) :" class="table table-bordered table-striped mb-4">
        <% 
        while (rs3.next()) { 
        ps4.setInt(1, Integer.parseInt(rs3.getString("prod_id")));
        rs4 = ps4.executeQuery();
        if(rs4.next()) {
        Blob pic = rs4.getBlob("prod_photo");
                
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
        
        count2++;
        %>   
        <tr><td><%= count2 %></td><td><img src="data:image/jpg;base64,<%= base64Image %>" width="100" height="100"/><a href="productDetails.jsp?prod=<%= rs4.getString("prod_id")%>"><%= rs4.getString("prod_name")%></td><td><%= rs3.getInt("ORDER_QUANTITY") %></td><td>RM <%= String.format("%.2f", rs4.getDouble("PROD_PRICE"))%></td></tr>
      
        <% 
        } } } catch (Exception e) {
        e.printStackTrace();
        } 
        %>
        </table><br>
        <h2>Order Details</h2>
        <table class="table table-bordered table-striped mb-4">
        <% while (rs5.next()) { %>
        <tr><td>Order Address : </td><td><%= rs5.getString("ORDER_ADDRESS") %></td></tr>    
        <tr><td>Phone Number : </td><td><%= rs5.getString("PHONENUM") %></td></tr>
        <tr><td>Recipient Name : </td><td><%= rs5.getString("RECIPIENTNAME") %></td></tr>
        <tr><td>Order Status: </td><td><%= rs5.getString("ORDER_STATUS") %></td></tr>
        <tr><td>Card Number : </td><td><%= rs5.getString("CARD_NUMBER") %></td></tr>
        <tr><td>Expiry Date : </td><td><%= rs5.getString("EXPIRY_YEAR") %>/<%= rs5.getString("EXPIRY_MONTH") %></td></tr>
        <tr><td>Total Amount : </td><td>RM <%= String.format("%.2f", rs5.getDouble("TOTAL_AMOUNT")) %></td></tr>
        <% } %>
        </table>
    </body>
        <footer class="py-5 bg-dark">
            <div class="container"><p class="m-0 text-center text-white">Copyright &copy; Your Website 2021</p></div>
        </footer>
        <!-- Bootstrap core JS-->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Core theme JS-->
        <script src="js/scripts.js"></script>
</html>
