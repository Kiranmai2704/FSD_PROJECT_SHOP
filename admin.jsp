<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
  <title>Login Result</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f2f2f2;
    }
    
    .container {
      max-width: 400px;
      margin: 0 auto;
      padding: 40px;
      background-color: #fff;
      border-radius: 5px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }
    
    .container h2 {
      text-align: center;
      margin-bottom: 30px;
    }
    
    .success-message {
      text-align: center;
      color: green;
      font-weight: bold;
      margin-bottom: 20px;
    }
    
    .error-message {
      text-align: center;
      color: red;
      font-weight: bold;
      margin-bottom: 20px;
    }
  </style>
</head>
<body>
  <div class="container">
    <h2>Login Result</h2>
    
    <%  
      // Retrieve user login credentials from the form
      String email = request.getParameter("email");
      String password = request.getParameter("password");

      // Establish a database connection
      Connection conn = null;
      PreparedStatement pstmt = null;
      ResultSet rs = null;
      String errorMessage = null;
      boolean loginSuccess = false;
      String username = null;
      
      try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "system", "2704");

        // Prepare the SQL query to check user credentials in the users table
        String query = "SELECT Name FROM Admin WHERE email = ? AND password = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setString(1, email);
        pstmt.setString(2, password);

        // Execute the query
        rs = pstmt.executeQuery();

        // Check if the query returned a matching record
        if (rs.next()) {
          loginSuccess = true;
          username = rs.getString("uname");
        } else {
          errorMessage = "Incorrect email or password. Please try again.";
        }
      } catch (ClassNotFoundException e) {
        errorMessage = "Database driver not found: " + e.getMessage();
      } catch (SQLException e) {
        errorMessage = "Database error: " + e.getMessage();
      } finally {
        // Close the database connection and release resources
        if (rs != null) {
          try {
            rs.close();
          } catch (SQLException e) {
            e.printStackTrace();
          }
        }
        if (pstmt != null) {
          try {
            pstmt.close();
          } catch (SQLException e) {
            e.printStackTrace();
          }
        }
        if (conn != null) {
          try {
            conn.close();
          } catch (SQLException e) {
            e.printStackTrace();
          }
        }
      }
      
      // Display appropriate messages based on login result
      if (loginSuccess) {
        // Store the username in a session variable
        session.setAttribute("username", username);
    %>
      <div class="success-message">
        <p>Login successful! Redirecting to Home page...</p>
        <script>
          setTimeout(function() {
            window.location.href = "index.html";
          }, 3000); // Redirect after 3 seconds
        </script>
      </div>
    <%
      } else {
    %>
     // <div class="error-message">
        <p><%= errorMessage %></p>
        <p>Please <a href="login.html">click here</a> to try again.</p>
     </div>
    <%
      }
    %>
  </div>
</body>
</html>
