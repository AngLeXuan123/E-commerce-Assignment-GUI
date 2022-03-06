<%-- 
    Document   : profile.jsp
    Created on : 3 Mar 2022, 9:04:08 pm
    Author     : user
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        
        <% HttpSession httpSession = request.getSession();
           String username = (String)(httpSession.getAttribute("username"));
           char gender = (char)(httpSession.getAttribute("gender"));
           String regDate = (String)(httpSession.getAttribute("regDate"));
           String birthDate = (String)(httpSession.getAttribute("birthDate"));
           String email = (String)(httpSession.getAttribute("email"));
           String phoneNumber = (String)(httpSession.getAttribute("phoneNumber"));
           String photo = (String)(httpSession.getAttribute("photo"));
        %>
        <div class='solid'>
                <img src="data:image/jpg;base64,<%= photo %>" width="240" height="300"/>
                <p>Username : <%= username %> </p>
                <p>Gender : <%= gender %> </p>
                <p>Registration Date : <%= regDate %> </p>
                <p>Birth Date : <%= birthDate %> </p>
                <p>Email : <%= email %> </p>
                <p>Phone Number : <%= phoneNumber %> </p>
                <br><a href="editProfile.jsp"><button type=\"button\">Edit Profile</button></a>
        </div>
    </body>
</html>
