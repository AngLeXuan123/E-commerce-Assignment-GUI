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
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"><link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
        <link
            href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
            rel="stylesheet">

        <!-- Custom styles for this template-->
        <link href="css/sb-admin-2.min.css" rel="stylesheet">

        <title>JSP Page</title>
    </head>
    <%  String idString = request.getParameter("id");    
        int id = Integer.parseInt(idString);
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            } catch (ClassNotFoundException e) {
            e.printStackTrace();
            }
        
            ResultSet rs = null, rs2 = null, rs3 = null;
            HttpSession httpSession = request.getSession();
            String username = (String)(httpSession.getAttribute("username"));
            String photo = (String)(httpSession.getAttribute("photo"));
            String levelString = (String)(httpSession.getAttribute("level"));
            char level = levelString.charAt(0);
            try {
            Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/assignmentdb", "nbuser", "nbuser");
            PreparedStatement ps = con.prepareStatement("select * from order_item where order_id = ?");
            PreparedStatement ps2 = con.prepareStatement("select * from product where prod_id = ?");
            PreparedStatement ps3 = con.prepareStatement("select * from orders where order_id = ?");
            ps.setInt(1, id);
            ps3.setInt(1, id);        
            
            rs = ps.executeQuery();
            rs3 = ps3.executeQuery();
            String base64Image = "";   
    %>
    <body id="page-top">

        <!-- Page Wrapper -->
        <div id="wrapper">

            <!-- Sidebar -->
            <ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar">

                <!-- Sidebar - Brand -->
                <a class="sidebar-brand d-flex align-items-center justify-content-center" href="adminDashboard.jsp">
                    <div class="sidebar-brand-icon rotate-n-15">
                        <i class="fas fa-laugh-wink"></i>
                    </div>
                    <div class="sidebar-brand-text mx-3">SB Admin <sup>2</sup></div>
                </a>

                <!-- Divider -->
                <hr class="sidebar-divider my-0">

                <!-- Nav Item - Dashboard -->
                <li class="nav-item">
                    <a class="nav-link" href="adminDashboard.jsp">
                        <i class="fas fa-fw fa-tachometer-alt"></i>
                        <span>Dashboard</span></a>
                </li>

                <!-- Divider -->
                <hr class="sidebar-divider">

                <!-- Heading -->
                <div class="sidebar-heading">
                    Interface
                </div>

                <!-- Nav Item - Pages Collapse Menu -->
                <li class="nav-item">
                    <a class="nav-link" href="#" data-toggle="collapse" data-target="#collapseTwo" aria-expanded="true"
                       aria-controls="collapseTwo">
                        <i class="fas fa-fw fa-cog"></i>
                        <span>Manage</span>
                    </a>
                    <div id="collapseTwo" class="collapse" aria-labelledby="headingTwo"
                         data-parent="#accordionSidebar">
                        <div class="bg-white py-2 collapse-inner rounded">
                            <% if (Character.compare(level, 'A') == 0) { %>
                            <a class="collapse-item" href="staff.jsp">Staff</a>
                            <% } %>
                            <a class="collapse-item" href="product.jsp">Product</a>
                        </div>
                    </div>
                </li>
                <!-- Nav Item - Utilities Collapse Menu -->
                <li class="nav-item active">
                    <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseUtilities"
                       aria-expanded="true" aria-controls="collapseUtilities">
                        <i class="fas fa-fw fa-wrench"></i>
                        <span>View</span>
                    </a>
                    <div id="collapseUtilities" class="collapse" aria-labelledby="headingUtilities"
                         data-parent="#accordionSidebar">
                        <div class="bg-white py-2 collapse-inner rounded">
                            <a class="collapse-item" href="customer.jsp">Customers</a>
                            <a class="collapse-item" href="sales.jsp">Sales</a>
                        </div>
                    </div>
                </li>
                <!-- Divider -->
                <hr class="sidebar-divider d-none d-md-block">          
            </ul>
            <!-- End of Sidebar -->

            <!-- Content Wrapper -->
            <div id="content-wrapper" class="d-flex flex-column">

                <!-- Main Content -->
                <div id="content">

                    <!-- Topbar -->
                    <nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow">

                        <!-- Sidebar Toggle (Topbar) -->
                        <button id="sidebarToggleTop" class="btn btn-link d-md-none rounded-circle mr-3">
                            <i class="fa fa-bars"></i>
                        </button>

                        <!-- Topbar Search -->
                        <form method="get" action="search.jsp"
                            class="d-none d-sm-inline-block form-inline mr-auto ml-md-3 my-2 my-md-0 mw-100 navbar-search">
                            <div class="input-group">
                                <input type="text" class="form-control bg-light border-0 small" name="id" placeholder="Search for..."
                                       aria-label="Search" aria-describedby="basic-addon2">
                                <div class="input-group-append">
                                    <button class="btn btn-primary" type="button">
                                        <i class="fas fa-search fa-sm"></i>
                                    </button>
                                </div>
                            </div>
                        </form>

                        <!-- Topbar Navbar -->
                        <ul class="navbar-nav ml-auto">

                            <!-- Nav Item - Search Dropdown (Visible Only XS) -->
                            <li class="nav-item dropdown no-arrow d-sm-none">
                                <a class="nav-link dropdown-toggle" href="#" id="searchDropdown" role="button"
                                   data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                    <i class="fas fa-search fa-fw"></i>
                                </a>
                                <!-- Dropdown - Messages -->
                                <div class="dropdown-menu dropdown-menu-right p-3 shadow animated--grow-in"
                                     aria-labelledby="searchDropdown">
                                    <form class="form-inline mr-auto w-100 navbar-search">
                                        <div class="input-group">
                                            <input type="text" class="form-control bg-light border-0 small"
                                                   placeholder="Search for..." aria-label="Search"
                                                   aria-describedby="basic-addon2">
                                            <div class="input-group-append">
                                                <button class="btn btn-primary" type="button">
                                                    <i class="fas fa-search fa-sm"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </li>                         
                            <div class="topbar-divider d-none d-sm-block"></div>

                            <!-- Nav Item - User Information -->
                            <li class="nav-item dropdown no-arrow">
                                <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button"
                                   data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                    <span class="mr-2 d-none d-lg-inline text-gray-600 small"><%= username %></span>
                                    <img class="img-profile rounded-circle"
                                         src="data:image/jpg;base64,<%= photo %>">
                                </a>
                                <!-- Dropdown - User Information -->
                                <div class="dropdown-menu dropdown-menu-right shadow animated--grow-in"
                                     aria-labelledby="userDropdown">
                                    <a class="dropdown-item" href="profile.jsp">
                                        <i class="fas fa-user fa-sm fa-fw mr-2 text-gray-400"></i>
                                        Profile
                                    </a>

                                    <div class="dropdown-divider"></div>
                                    <a class="dropdown-item" href="http://localhost:8080/E-commerce-Assignment-GUI/Logout" data-toggle="modal" data-target="#logoutModal">
                                        <i class="fas fa-sign-out-alt fa-sm fa-fw mr-2 text-gray-400"></i>
                                        Logout
                                    </a>
                                </div>
                            </li>

                        </ul>

                    </nav>
                    <!-- End of Topbar -->

                    <!-- Begin Page Content -->
                    <div class="container-fluid">

                        <!-- Page Heading -->
                        <h1 class="h3 mb-4 text-gray-800"><% if(rs3.next()) { %> <%= rs3.getString("id") %> <% }%>'s Profile</h1>
                        <div class="content">
                            <table class="table">
                                <tr><td>Product</td><td>Quantity</td><td>Price (each)</td></tr>
                                <%
                                    while (rs.next()) {
                                    ps2.setInt(1, rs.getInt("prod_id"));
                                    rs2 = ps2.executeQuery();
                                
                                    if(rs2.next()) {
                                    Blob pic;
                                    pic = rs2.getBlob("prod_photo");

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
                                    }
                                %>                          
                                <tr><td><img src="data:image/jpg;base64,<%= base64Image %>" width="100" height="100"/><a href="viewProduct.jsp?id=<%= rs2.getString("prod_id")%>"><%= rs2.getString("prod_name")%></td><td><%= rs.getInt("ORDER_QUANTITY") %></td><td>RM <%= String.format("%.2f", rs2.getDouble("PROD_PRICE"))%></td></tr>
                                        <%
                                               } } catch (Exception e) {
                                                    e.printStackTrace();
                                                }
                                        %>
                                <tr><td>Order ID </td><td><%= rs3.getInt("order_id") %> </td></tr>
                                <tr><td>Address </td><td><%= rs3.getString("order_address") %> </td></tr>
                                <tr><td>Phone Number </td><td><%= rs3.getString("phoneNum") %> </td></tr>
                                <tr><td>Recipient Name </td><td><%= rs3.getString("recipientname") %> </td></tr>
                                <tr><td>Username </td><td><a href="viewCustomer.jsp?id=<%= rs3.getString("id") %>"><%= rs3.getString("id") %></td></tr>
                                <tr><td>Card Number </td><td><%= rs3.getString("card_number") %> </td></tr> 
                                <tr><td>Expiry Date </td><td><%= rs3.getInt("expiry_year")/rs3.getInt("expiry_month") %> </td></tr> 
                                <tr><td>Total Amount </td><td>RM <%= rs3.getDouble("total_amount") %> </td></tr> 
                                <tr><td><form action="http://localhost:8080/E-commerce-Assignment-GUI/updateStatus" method="post">
                                    <div class="form-group">
                                        <label for="category">Order Status</label></td><td>
                                        <select class="form-control" name="status" id="status" required>    
                                            <option value="Order Received" <% if(rs3.getString("order_status").equals("Order Received"))  { %> selected <% } %>>Order Received</option>
                                            <option value="Packaging Order" <% if(rs3.getString("order_status").equals("Packaging Order"))  { %> selected <% } %>>Packaging Order</option>
                                            <option value="Shipping Order" <% if(rs3.getString("order_status").equals("Shipping Order"))  { %> selected <% } %>>Shipping Order</option>
                                            <option value="Order Delivered" <% if(rs3.getString("order_status").equals("Order Delivered"))  { %> selected <% } %>>Order Delivered</option>  
                                            
                                        </select>
                                    </div> 
                                        <input type="hidden" name="id" value="<%= id %>">
                                        </td>  
                                        <td><input type="submit" value="Update"></td></tr> </form>
                            </table>
                        </div>





                    </div>
                    <!-- /.container-fluid -->

                </div>
                <!-- End of Main Content -->

                <!-- Footer -->
                <footer class="sticky-footer bg-white">
                    <div class="container my-auto">
                        <div class="copyright text-center my-auto">
                            <span>Copyright &copy; Your Website 2020</span>
                        </div>
                    </div>
                </footer>
                <!-- End of Footer -->

            </div>
            <!-- End of Content Wrapper -->

        </div>
        <!-- End of Page Wrapper -->

        <!-- Scroll to Top Button-->
        <a class="scroll-to-top rounded" href="#page-top">
            <i class="fas fa-angle-up"></i>
        </a>

        <!-- Logout Modal-->
        <div class="modal fade" id="logoutModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
             aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">Ready to Leave?</h5>
                        <button class="close" type="button" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">×</span>
                        </button>
                    </div>
                    <div class="modal-body">Select "Logout" below if you are ready to end your current session.</div>
                    <div class="modal-footer">
                        <button class="btn btn-secondary" type="button" data-dismiss="modal">Cancel</button>
                        <a class="btn btn-primary" href="http://localhost:8080/E-commerce-Assignment-GUI/Logout">Logout</a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap core JavaScript-->
        <script src="vendor/jquery/jquery.min.js"></script>
        <script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

        <!-- Core plugin JavaScript-->
        <script src="vendor/jquery-easing/jquery.easing.min.js"></script>

        <!-- Custom scripts for all pages-->
        <script src="js/sb-admin-2.min.js"></script>

    </body>

</html>
