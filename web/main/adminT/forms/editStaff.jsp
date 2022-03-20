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
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>SB Admin 2 - Register</title>

    <!-- Custom fonts for this template-->
    <link href="../vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link
        href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
        rel="stylesheet">

    <!-- Custom styles for this template-->
    <link href="../css/sb-admin-2.min.css" rel="stylesheet">
    <%  String id = request.getParameter("id");    
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            } catch (ClassNotFoundException e) {
            e.printStackTrace();
            }
            
            ResultSet rs = null;
            HttpSession httpSession = request.getSession();
            String username = (String)(httpSession.getAttribute("username"));
            String photo = (String)(httpSession.getAttribute("photo"));
            try {
            Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/assignmentdb", "nbuser", "nbuser");
            PreparedStatement ps = con.prepareStatement("select * from account where id = ?");
            ps.setString(1, id);
            rs = ps.executeQuery();
            String base64Image = "";
            
            while (rs.next()) {
    %>
</head>

<body class="bg-gradient-primary">

    <div class="container">
        
        <% 
            
        %>

        <div class="card o-hidden border-0 shadow-lg my-5">
            <div class="card-body p-0">
                <!-- Nested Row within Card Body -->
                <div class="p-5">
                    <div class="text-center">
                        <h1 class="h4 text-gray-900 mb-4">Edit staff > <%= id %>?</h1>
                    </div>
                    <form method="post" action="http://localhost:8080/E-commerce-Assignment-GUI/editStaff" enctype="multipart/form-data" >
                        <div class="form-group">
                            <input type="email" class="form-control" name="email" id="email" value="<%= rs.getString("email") %>" required
                                >
                        </div>
                        <div class="form-group">
                            <input type="text" class="form-control" name="phoneNumber" id="phoneNumber" value="<%= rs.getString("phoneNumber") %>" required
                                >
                        </div>
                        <div class="form-group">
                            <label for="birthDate">Birthday:</label>
                            <input type="date" id="birthDate" name="birthDate" value="<%= rs.getString("birthDate") %>" class="form-control" required>
                        </div>
                        
                        <div class="form-group">
                            <input type="text" class="form-control" name="password" id="password" value="<%= rs.getString("password") %>" required>
                        </div>
                        
                        <div class="form-group">
                            <input type="file" class="form-control" name="photo" id="photo" accept="image/*" required>
                        </div>
                        <input type="hidden" value="<%= id %>" name="username" id="username" />
                        <input type="submit" value="Confirm" class="btn btn-primary btn-user btn-block">
                    </form>
                    <hr>
 
                </div>
            </div>
        </div>
            <%
                } } catch (Exception e) {
                                e.printStackTrace();
                                }
            %>
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
