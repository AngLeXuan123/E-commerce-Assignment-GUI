<%-- 
    Document   : editProfile
    Created on : 3 Mar 2022, 8:29:55 pm
    Author     : user
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

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

    <title>Checkout</title>

    <!-- Custom fonts for this template-->
    
    <link rel="icon" type="image/x-icon" href="../assets/favicon.ico" />
        <!-- Bootstrap icons-->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" rel="stylesheet" />
        <!-- Core theme CSS (includes Bootstrap)-->
        <link href="../css/styles.css" rel="stylesheet" />
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

        <!-- Core theme JS-->
        <script src="js/scripts.js"></script>
</head>
<%try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        double totalPrice = 0;
        int count = 0;
        ResultSet rs = null, rs2 = null, rs3 = null;
        HttpSession httpSession = request.getSession();
        String username = (String)(httpSession.getAttribute("username"));
        try {
            Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/assignmentdb", "nbuser", "nbuser");
            PreparedStatement ps = con.prepareStatement("select * from cart_item where id = ?");
            PreparedStatement ps2 = con.prepareStatement("select * from product where prod_id = ?");
            ps.setString(1, username);
   
            rs = ps.executeQuery();
            
            while(rs.next()) {
                count++;
                
                String cartQuantityString = rs.getString("quantity");        
                int cartQuantity = Integer.parseInt(cartQuantityString); 
                
                ps2.setString(1, rs.getString("prod_id"));
                rs2 = ps2.executeQuery();
                
                if(rs2.next()) {
                    String priceString = rs2.getString("prod_price");  
                    double price = Double.parseDouble(priceString);

                    double price2 = price * cartQuantity;

                    totalPrice = totalPrice + price2;
                }
                
            }
 
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>
<body class="bg-gradient-primary">
<!-- Navigation-->
        <nav class="navbar navbar-expand-lg navbar-light bg-light">
            <div class="container px-4 px-lg-5">
                <a class="navbar-brand" href="#!">Start Bootstrap</a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation"><span class="navbar-toggler-icon"></span></button>
                <div class="collapse navbar-collapse" id="navbarSupportedContent">
                    <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-4">
                        <li class="nav-item"><a class="nav-link active" aria-current="page" href="../index.jsp">Home</a></li>
                        <li class="nav-item"><a class="nav-link" href=../order.jsp>Order</a></li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">Account</a>
                            <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                                <li><a class="dropdown-item" href="profile.jsp">Profile</a></li>
                                <li><hr class="dropdown-divider" /></li>
                                <li><a class="dropdown-item" href="http://localhost:8080/E-commerce-Assignment-GUI/Logout">Logout</a></li>
                          
                            </ul>
                        </li>
                    </ul>
                    <form method="get" action="../search.jsp" style="margin-right: 30px;">
                    <input type="text" name="id" placeholder="Search">
                    <button type="submit"><i class="fa fa-search"></i></button>
                    </form>
                    <a href="../cart.jsp">
                        
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
        <!-- Section-->
    <div class="container">
        
        <% 
           
           String email = (String)(httpSession.getAttribute("email"));
           String phoneNumber = (String)(httpSession.getAttribute("phoneNumber"));
           String birthDate = (String)(httpSession.getAttribute("birthDate"));
           String password = (String)(httpSession.getAttribute("password"));
        %>
        
        <div class="card o-hidden border-0 shadow-lg my-5">
            <div class="card-body p-0">
                <!-- Nested Row within Card Body -->
                <div class="p-5">
                    <div class="text-center">
                        <h1 class="h4 text-gray-900 mb-4">Checkout</h1>
                    </div>
                    <form method="post" action="http://localhost:8080/E-commerce-Assignment-GUI/checkout">
                        <div class="form-group">
                            <input type="text" class="form-control" name="address" id="address" placeholder="Address" required>
                        </div><br>
                        <div class="form-group">
                            <input type="tel" class="form-control" name="phoneNumber" id="phoneNumber" placeholder="Your contact number" required> 
                        </div><br>                        
                        <div class="form-group">
                            <input type="text" class="form-control" name="name" id="name" placeholder="Recepient name" required>
                        </div><br>
                        <div class="form-group">
                            <input id="cardNum" class="form-control" name="cardNum" type="tel" inputmode="numeric" pattern="[0-9\s]{13,19}" autocomplete="cc-number" maxlength="19" placeholder="xxxx xxxx xxxx xxxx">
                        </div><br>
                        <div class="form-group">
                            <label for="expiryMonth">Expiry Month </label>
                            <select class="form-control" name="expiryMonth" id="expiryMonth"required>
                                <option value="1">January</option>
                                <option value="2">February</option>
                                <option value="3">March</option>
                                <option value="4">April</option>
                                <option value="5">May</option>
                                <option value="6">June</option>
                                <option value="7">July</option>
                                <option value="8">August</option> 
                                <option value="9">September</option>
                                <option value="10">October</option>
                                <option value="11">November</option>
                                <option value="12">December</option>
                              </select>
                        </div><br>

                        <div class="form-group">
                            <input type="number" min="2022" max="2100" class="form-control" name="expiryYear" id="expiryYear" placeholder="Expiry year" required>
                        </div><br>
                        
                        <div class="form-group">
                            <input type="number" min="100" max="999" class="form-control" name="cardCCV" id="cardCCV" placeholder="Card CCV" required>
                        </div><br>
                        <input type="hidden" name="amount" value="<%= totalPrice %>">
                        <div class="form-group">
                            <table width="100%"><tr>
                                <td align="left"><h3>Total amount : </h3></td><td align="right"><h3>RM <%= String.format("%.2f", totalPrice) %></h3></td>
                                </tr></table>
                        </div><br>
                        
                        <input type="submit" value="Confirm" class="btn btn-primary btn-user btn-block">
                    </form>
                    <hr>
 
                </div>
            </div>
        </div>

    </div>

    <!-- Bootstrap core JavaScript-->
    <script src="../vendor/jquery/jquery.min.js"></script>
    <script src="../vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

    <!-- Core plugin JavaScript-->
    <script src="../vendor/jquery-easing/jquery.easing.min.js"></script>

    <!-- Custom scripts for all pages-->
    <script src="../js/sb-admin-2.min.js"></script>

</body>

</html>
