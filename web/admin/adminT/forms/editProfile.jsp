<%-- 
    Document   : editProfile
    Created on : 3 Mar 2022, 8:29:55 pm
    Author     : user
--%>
halo halo halo halo halo
halo halo halo halo halo
halo halo halo halo halo
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>

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

</head>

<body class="bg-gradient-primary">

    <div class="container">
        
        <% HttpSession httpSession = request.getSession();
           String username = (String)(httpSession.getAttribute("username"));
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
                        <h1 class="h4 text-gray-900 mb-4">Edit your account, <%= username %> ?</h1>
                    </div>
                    <form method="post" action="http://localhost:8080/E-commerce%20Assignment/editProfile" enctype="multipart/form-data" >
                        <div class="form-group">
                            <input type="email" class="form-control" name="email" id="email" value="<%= email %>"
                                >
                        </div>
                        <div class="form-group">
                            <input type="text" class="form-control" name="phoneNumber" id="phoneNumber" value="<%= phoneNumber %>"
                                >
                        </div>
                        <div class="form-group">
                            <label for="birthDate">Birthday:</label>
                            <input type="date" id="birthDate" name="birthDate" value="<%= birthDate %>" class="form-control">
                        </div>
                        
                        <div class="form-group">
                            <input type="text" class="form-control" name="password" id="password" value="<%= password %>">
                        </div>
                        
                        <div class="form-group">
                            <input type="file" class="form-control" name="photo" id="photo" accept="image/*">
                        </div>

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
