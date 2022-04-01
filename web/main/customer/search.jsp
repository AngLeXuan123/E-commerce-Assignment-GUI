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
        <title>Shop Homepage - Start Bootstrap Template</title>
        <!-- Favicon-->
        <link rel="icon" type="image/x-icon" href="assets/favicon.ico" />
        <!-- Bootstrap icons-->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" rel="stylesheet" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <!-- Core theme CSS (includes Bootstrap)-->
        <link href="css/styles.css" rel="stylesheet" />
        <%  String id = request.getParameter("id");
            try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            } catch (ClassNotFoundException e) {
            e.printStackTrace();
            }
            int count = 0, count3 = 0;
            ResultSet rs = null, rs2 = null, rs3 = null;
            HttpSession httpSession = request.getSession();
            String username = (String)(httpSession.getAttribute("username"));
            String photo = (String)(httpSession.getAttribute("photo"));
            try {
            Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/assignmentdb", "nbuser", "nbuser");
            PreparedStatement ps = con.prepareStatement("select * from product where upper(prod_name) like upper(?) or upper(prod_brand) like upper(?)");
            PreparedStatement ps2 = con.prepareStatement("select * from cart_item where id = ?");
            ps.setString(1, "%" + id + "%");
            ps.setString(2, "%" + id + "%");
            ps2.setString(1, username);
            
            rs = ps.executeQuery();
            rs2 = ps2.executeQuery();
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
        <!-- Section-->
        
        <section class="py-5">
            <div class="container px-4 px-lg-5 mt-5">
                <div class="row gx-4 gx-lg-5 row-cols-2 row-cols-md-3 row-cols-xl-4 justify-content-center">
                    <%
                                
                                while (rs.next()) {
                                count3++;
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
                                <div class="col mb-5">
                        <div class="card h-100">
                            <!-- Product image-->
                            <img class="card-img-top" width="205.99px" height="205.99px" src="data:image/jpg;base64,<%= base64Image %>" alt="..." />
                            <!-- Product details-->
                            <div class="card-body p-4">
                                <div class="text-center">
                                    <!-- Product name-->
                                    <h5 class="fw-bolder"><%= rs.getString("PROD_NAME") %></h5>
                                    <!-- Product price-->
                                    RM <%= String.format("%.2f", rs.getDouble("PROD_PRICE")) %>
                                </div>
                            </div>
                            <!-- Product actions-->
                            <div class="card-footer p-4 pt-0 border-top-0 bg-transparent">
                                <div class="text-center"><a class="btn btn-outline-dark mt-auto" href="productDetails.jsp?prod=<%= rs.getString("PROD_ID") %>">View details</a></div><br>
                                <%  
                                rs3 = ps2.executeQuery();
                                int count2 = 0;
                                while(rs3.next()) {
                                    if(rs3.getString("PROD_ID").equals(rs.getString("PROD_ID")) == true) { 
                                        count2++;
                                    } 
                                }
                                if(count2 > 0) {
                                    %><div class="text-center"><a class="btn btn-outline-dark mt-auto" disabled>Already in cart</a></div><%
                                }
                                else if (rs.getInt("PROD_QUANTITY") <= 0) {
                                    %><div class="text-center"><a class="btn btn-outline-dark mt-auto" disabled>Sold Out</a></div><%
                                } 
                                else {
                                    %> <div class="text-center"><a class="btn btn-outline-dark mt-auto" href="http://localhost:8080/E-commerce-Assignment-GUI/cart?id=<%= rs.getString("PROD_ID") %>">Add to cart</a></div> <%
                                } 
                                %>
                                
                                
                            </div>   
                        </div>
                    </div>
                           <%
                                } } catch (Exception e) {
                                e.printStackTrace();
                                } 
                                %>                                  
                             <% if(count3 == 0) { %>
                                <h1 width="100%">No matches found...</h1>
                                <% } %>
                </div>
            </div>
        </section>
        </body>
        <footer class="py-5 bg-dark">
            <div class="container"><p class="m-0 text-center text-white">Copyright &copy; Your Website 2021</p></div>
        </footer>
        <!-- Bootstrap core JS-->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Core theme JS-->
        <script src="js/scripts.js"></script>
    
</html>
