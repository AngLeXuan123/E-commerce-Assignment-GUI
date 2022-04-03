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
    <%  String id = request.getParameter("id");    
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            } catch (ClassNotFoundException e) {
            e.printStackTrace();
            }
        
            int ratingCount = 0;
            ResultSet rs = null, rs2 = null, rs3 = null;
            HttpSession httpSession = request.getSession();
            String username = (String)(httpSession.getAttribute("username"));
            String photo = (String)(httpSession.getAttribute("photo"));
            String levelString = (String)(httpSession.getAttribute("level"));
            char level = levelString.charAt(0);
            try {
            Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/assignmentdb", "nbuser", "nbuser");
            PreparedStatement ps = con.prepareStatement("select * from product where prod_id = ?");
            PreparedStatement ps2 = con.prepareStatement("select * from comment where prod_id = ?");
            PreparedStatement ps3 = con.prepareStatement("select * from reply where comment_id = ?");
            
            ps.setString(1, id);
            ps2.setString(1, id);
            
            rs = ps.executeQuery();
            rs2 = ps2.executeQuery();
                     
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
                <li class="nav-item active">
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
                <li class="nav-item">
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
                        <h1 class="h3 mb-4 text-gray-800">Product</h1>
                        <div class="content">
                            <table class="table">
                                <tr><img src="data:image/jpg;base64,<%= base64Image %>" width="240" height="300"/></tr>
                                <tr><td>Name : </td><td><%= rs.getString("prod_name") %> </td></tr>
                                <tr><td>Description : </td><td><%= rs.getString("prod_desc") %> </td></tr>
                                <tr><td>Price : </td><td>RM <%= String.format("%.2f", rs.getDouble("prod_price")) %> </td></tr>
                                <tr><td>Quantity : </td><td><%= rs.getInt("prod_quantity") %> </td></tr>
                                <tr><td>Release Date : </td><td><%= rs.getString("prod_release") %> </td></tr>
                                <tr><td>Brand : </td><td><%= rs.getString("prod_brand") %> </td></tr>
                                <tr><td>Category : 
                                        <%
                                        if(rs.getString("prod_category").charAt(0) == 'L') {
                                        %>
                                        </td><td>Laptop</td></tr>
                                        <%
                                        } else if(rs.getString("prod_category").charAt(0) == 'H') {
                                        %>
                                        </td><td>Headphone</td></tr>
                                        <%
                                        } else if(rs.getString("prod_category").charAt(0) == 'M') {
                                        %>
                                        </td><td>Mouse</td></tr>
                                        <%
                                        } else if(rs.getString("prod_category").charAt(0) == 'K') {
                                        %>
                                        </td><td>Keyboard</td></tr>
                                        <% } %>
                                        <tr><td><a href="forms/editProduct.jsp?id=<%= id %>"><button type=\"button\">Edit Product</button></a>
                                        <a href="http://localhost:8080/E-commerce-Assignment-GUI/deleteProduct?id=<%= id %>"><button type=\"button\">Delete Product</button></a></td></tr>
                                        <%
                                        } 
                                        %>
                            </table>
                        </div>
                            
                        <h1 class="h3 mb-4 text-gray-800">Comment(s)</h1>
                        <div class="content">
                            
                                <% while(rs2.next()) { 
                                ps3.setInt(1, rs2.getInt("comment_id"));
                                rs3 = ps3.executeQuery();
                                %>
                                <table class="table table-bordered table-striped mb-4">
                                <tr><td><a href="viewCustomer.jsp?id=<%= rs2.getString("id") %>"><%= rs2.getString("id") %></td><td colspan="2"><%= rs2.getString("comment_time") %></td></tr>
                                <tr><td colspan="2"><%= rs2.getString("comment_text") %> <% while(ratingCount < rs2.getInt("rating")) { ratingCount++;%><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-star" viewBox="0 0 16 16">
  <path d="M2.866 14.85c-.078.444.36.791.746.593l4.39-2.256 4.389 2.256c.386.198.824-.149.746-.592l-.83-4.73 3.522-3.356c.33-.314.16-.888-.282-.95l-4.898-.696L8.465.792a.513.513 0 0 0-.927 0L5.354 5.12l-4.898.696c-.441.062-.612.636-.283.95l3.523 3.356-.83 4.73zm4.905-2.767-3.686 1.894.694-3.957a.565.565 0 0 0-.163-.505L1.71 6.745l4.052-.576a.525.525 0 0 0 .393-.288L8 2.223l1.847 3.658a.525.525 0 0 0 .393.288l4.052.575-2.906 2.77a.565.565 0 0 0-.163.506l.694 3.957-3.686-1.894a.503.503 0 0 0-.461 0z"/>
</svg> <%}%></td><td><a class="btn btn-outline-dark mt-auto" href="http://localhost:8080/E-commerce-Assignment-GUI/deleteComment?id=<%= rs2.getString("comment_id") %>&prod=<%= id %>">Delete comment</a></td>
                                    <% if(rs3.next()) { %>
                                <tr><td><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-reply" viewBox="0 0 16 16">
  <path d="M6.598 5.013a.144.144 0 0 1 .202.134V6.3a.5.5 0 0 0 .5.5c.667 0 2.013.005 3.3.822.984.624 1.99 1.76 2.595 3.876-1.02-.983-2.185-1.516-3.205-1.799a8.74 8.74 0 0 0-1.921-.306 7.404 7.404 0 0 0-.798.008h-.013l-.005.001h-.001L7.3 9.9l-.05-.498a.5.5 0 0 0-.45.498v1.153c0 .108-.11.176-.202.134L2.614 8.254a.503.503 0 0 0-.042-.028.147.147 0 0 1 0-.252.499.499 0 0 0 .042-.028l3.984-2.933zM7.8 10.386c.068 0 .143.003.223.006.434.02 1.034.086 1.7.271 1.326.368 2.896 1.202 3.94 3.08a.5.5 0 0 0 .933-.305c-.464-3.71-1.886-5.662-3.46-6.66-1.245-.79-2.527-.942-3.336-.971v-.66a1.144 1.144 0 0 0-1.767-.96l-3.994 2.94a1.147 1.147 0 0 0 0 1.946l3.994 2.94a1.144 1.144 0 0 0 1.767-.96v-.667z"/>
</svg><a href="staffProfile.jsp?id=<%= rs3.getString("id") %>"><%= rs3.getString("id") %></td><td colspan="2"><%= rs3.getString("reply_time") %></td></tr>
                                    <tr><td colspan="2"><%= rs3.getString("reply_text") %></td><td><a class="btn btn-outline-dark mt-auto" href="http://localhost:8080/E-commerce-Assignment-GUI/deleteReply?id=<%= rs3.getString("reply_id") %>&prod=<%= id %>">Delete reply</a></td></tr>
                                    
                                    <% } else {%>          
                                    <td><form method="get" action="http://localhost:8080/E-commerce-Assignment-GUI/submitReply"><input type="hidden" value="<%= rs2.getString("comment_id") %>" name="id"><input type="hidden" value="<%= id %>" name="prod"><input type="text" name="reply" required><input class="btn btn-outline-dark mt-auto" type="submit" value="Submit Reply"></form></td></tr>    
                                <%} %> </table> <%} } catch (Exception e) {
                                            e.printStackTrace();
                                        } %>
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
