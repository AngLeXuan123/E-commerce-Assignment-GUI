package Servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.util.Base64;

public class signIn extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String username = request.getParameter("username");
        String pass = request.getParameter("pass");

        ResultSet rs = null;
        try {
            //loading drivers for mysql
            Class.forName("org.apache.derby.jdbc.ClientDriver");

            //creating connection with the database
            Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/assignmentdb", "nbuser", "nbuser");
            PreparedStatement ps = con.prepareStatement("select * from account where id=? and password=?");
            ps.setString(1, username);
            ps.setString(2, pass);
            rs = ps.executeQuery();

            String base64Image;
        
            if (rs.next()) {
                HttpSession httpSession = request.getSession();
                httpSession.setAttribute("username", username);

                char gender = rs.getString("gender").charAt(0);
                String birthDate = rs.getString("birthDate");
                String regDate = rs.getString("regDate");
                String email = rs.getString("email");
                String phoneNumber = rs.getString("phoneNumber");
                Blob photo = rs.getBlob("photo");
                
                InputStream inputStream = photo.getBinaryStream();
                
                ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                byte[] buffer = new byte[4096];
                int bytesRead = -1;
                 
                while ((bytesRead = inputStream.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, bytesRead);                  
                }
                 
                byte[] imageBytes = outputStream.toByteArray();
                base64Image = Base64.getEncoder().encodeToString(imageBytes);
                
                httpSession.setAttribute("regDate", regDate);
                httpSession.setAttribute("gender", gender);
                httpSession.setAttribute("birthDate", birthDate);
                httpSession.setAttribute("password", rs.getString("password"));
                httpSession.setAttribute("email", email);
                httpSession.setAttribute("phoneNumber", phoneNumber);
                httpSession.setAttribute("photo", base64Image);

                response.sendRedirect("admin/adminT/adminDashboard.jsp");
            } else {
                out.println("Username or Password incorrect");
                response.sendRedirect("admin/adminT/forms/login.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

    }

}
