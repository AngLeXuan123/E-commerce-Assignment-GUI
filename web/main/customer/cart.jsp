<%-- 
    Document   : newjspca
    Created on : 27 Mar 2022, 12:41:25 pm
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
        <title>Shop Homepage - Start Bootstrap Template</title>
        <!-- Favicon-->
        <link rel="icon" type="image/x-icon" href="assets/favicon.ico" />
        <!-- Bootstrap icons-->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" rel="stylesheet" />
        <!-- Core theme CSS (includes Bootstrap)-->
        <link href="css/styles.css" rel="stylesheet" />
       
        <%  try {
                Class.forName("org.apache.derby.jdbc.ClientDriver");
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            }
            int count = 0;
            double totalPrice = 0;
            ResultSet rs = null, rs2 = null, rs3 = null;
            HttpSession httpSession = request.getSession();
            String username = (String) (httpSession.getAttribute("username"));
            try {
                Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/assignmentdb", "nbuser", "nbuser");
                PreparedStatement ps = con.prepareStatement("select * from cart_item where id = ?");
                PreparedStatement ps2 = con.prepareStatement("select * from cart_item where id = ?");
                PreparedStatement ps3 = con.prepareStatement("select * from product where prod_id = ?");
                ps.setString(1, username);
                ps2.setString(1, username);
                
                rs = ps.executeQuery();
                rs2 = ps2.executeQuery();
                while (rs.next()) {
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
                        <li class="nav-item"><a class="nav-link" href="#!">About</a></li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">Account</a>
                            <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                                <li><a class="dropdown-item" href="profile.jsp">Profile</a></li>
                                <li><hr class="dropdown-divider" /></li>
                                <li><a class="dropdown-item" href="http://localhost:8080/E-commerce-GUI-Assignment/Logout">Logout</a></li>

                            </ul>
                        </li>
                    </ul>
                    <form class="d-flex" method="post" action="cart.jsp">

                        <button class="btn btn-outline-dark" type="submit">
                            <i class="bi-cart-fill me-1"></i>
                            Cart
                            <span class="badge bg-dark text-white ms-1 rounded-pill"><%= count%></span>
                        </button>
                    </form>
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
        <!-- Section-->
        <table>
        <% while (rs2.next()) { 
        String prod_id = rs2.getString("PROD_ID");
        ps3.setString(1, prod_id); 
 
        rs3 = ps3.executeQuery();
        if(rs3.next()) {
        Blob pic;
        String base64Image = "";
        pic = rs3.getBlob("prod_photo");
                
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
        
        <tr>
        <td>
        <img src="data:image/jpg;base64,<%= base64Image %>" width="100" height="100"/> <%= rs3.getString("prod_name")%>
        </td>
        <td>
        <form style="display: inline-block;" action ="http://localhost:8080/E-commerce-Assignment-GUI/minusQuantity" method="POST">
        <input class="btn btn-primary" type="submit" value= "-">
        <input type="hidden" name="prod_id" value="<%= rs2.getString("prod_id") %>" >
        <input type="hidden" name="quantity" value="<%= rs2.getString("quantity") %>" >
        </form>
        </td>
        <td style="font-size: 25px;"> &nbsp;
        <%= rs2.getString("quantity") %>
        &nbsp; </td>
        <td>
        <form style="display: inline-block;" action ="http://localhost:8080/E-commerce-Assignment-GUI/addQuantity" method="POST">
        <%
            String prodQuantityString = rs3.getString("prod_quantity");
            int prodQuantity = Integer.parseInt(prodQuantityString);
            String cartQuantityString = rs2.getString("quantity");        
            int cartQuantity = Integer.parseInt(cartQuantityString);                 
            if(prodQuantity < (cartQuantity + 1)) { %>
            <input class="btn btn-primary" type="submit" value= "+" disabled>
            <% } else { %>
            <input class="btn btn-primary" type="submit" value= "+">
            <% } %>
        <input type="hidden" name="prod_id" value="<%= rs2.getString("prod_id") %>" >
        <input type="hidden" name="quantity" value="<%= rs2.getString("quantity") %>" >
        </form>
        </td>
        <td>
            <% String priceString = rs3.getString("prod_price");  
               double price = Double.parseDouble(priceString);
               
               double price2 = price * cartQuantity;
               
               totalPrice = totalPrice + price2;
            %>    
            RM <%= String.format("%.2f", price2) %> 
        </td>
        </tr>
        
        <% }} 
        } catch (Exception e) {
                e.printStackTrace();
            }
        %>   
        <tr>
            <td><h2>Total price :  RM <%= String.format("%.2f", totalPrice) %></h2></td>
            <td align="center" colspan="4"><a href="checkout.jsp"><button class="btn btn-primary">Proceed to checkout</button></a></td>
        </tr>
        </table>
</div>
<br><br>

       
        
    </body>
</html>
