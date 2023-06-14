<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
  <title>User Insert Result</title>
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
    <h2>User Insert Result</h2>
    
    <%  
      // Retrieve user details from the form
      String name = request.getParameter("name");
      String email = request.getParameter("email");
      String password = request.getParameter("password");
      

      // Establish a database connection
      Connection conn = null;
      PreparedStatement pstmt = null;
      String errorMessage = null;
      boolean insertSuccess = false;
      
      try {
        Class.forName("oracle.jdbc.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "system", "2704");

        // Prepare the SQL query to insert user details into the users table
        String query = "INSERT INTO P(Name,Email,Password ) VALUES (?, ?, ?)";
        pstmt = conn.prepareStatement(query);
        pstmt.setString(1, name);
        pstmt.setString(2, email);
        pstmt.setString(3, password);
        // Execute the query
        int rowsInserted = pstmt.executeUpdate();

        // Check if the insertion was successful
        if (rowsInserted > 0) {
          insertSuccess = true;
        } else {
          errorMessage = "Failed to insert user details. Please try again.";
        }
      } catch (ClassNotFoundException e) {
        errorMessage = "Database driver not found: " + e.getMessage();
      } catch (SQLException e) {
        errorMessage = "Database error: " + e.getMessage();
      } finally {
        // Close the database connection and release resources
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
      
      // Display appropriate messages based on insertion result
      if (insertSuccess) {
    %>
      <div class="success-message">
        <p>User registration successful!</p>
        <script>
          setTimeout(function() {
            window.location.href = "index.html";
          }, 3000); // Redirect after 3 seconds
        </script>
      </div>
    <%
      } else {
    %>
      <div class="error-message">
        <p><%= errorMessage %></p>
      </div>
    <%
      }
    %>
  </div>
</body>
</html>
