<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Register Driver</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    max-width: 600px;
                    margin: 50px auto;
                    padding: 20px;
                    background-color: #f5f5f5;
                }

                h2 {
                    color: #333;
                }

                form {
                    background-color: white;
                    padding: 30px;
                    border-radius: 8px;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                }

                .form-group {
                    margin-bottom: 20px;
                }

                label {
                    display: block;
                    margin-bottom: 5px;
                    color: #555;
                    font-weight: bold;
                }

                input[type="text"],
                input[type="password"] {
                    width: 100%;
                    padding: 10px;
                    border: 1px solid #ddd;
                    border-radius: 4px;
                    box-sizing: border-box;
                }

                button {
                    background-color: #28a745;
                    color: white;
                    padding: 12px 30px;
                    border: none;
                    border-radius: 4px;
                    cursor: pointer;
                    font-size: 16px;
                }

                button:hover {
                    background-color: #218838;
                }

                .back-link {
                    display: inline-block;
                    margin-top: 20px;
                    color: #007bff;
                    text-decoration: none;
                }

                .back-link:hover {
                    text-decoration: underline;
                }
            </style>
        </head>

        <body>
            <h2>Register New Driver</h2>

            <form action="${pageContext.request.contextPath}/view/drivers/save" method="post">
                <div class="form-group">
                    <label for="name">Name:</label>
                    <input type="text" id="name" name="name" required>
                </div>

                <div class="form-group">
                    <label for="phone">Phone:</label>
                    <input type="text" id="phone" name="phone" required>
                </div>

                <div class="form-group">
                    <label for="vehicleNumber">Vehicle Number:</label>
                    <input type="text" id="vehicleNumber" name="vehicleNumber" required>
                </div>

                <div class="form-group">
                    <label for="password">Password:</label>
                    <input type="password" id="password" name="password" required>
                </div>

                <div class="form-group">
                    <label for="currentLocation">Current Location (Name):</label>
                    <input type="text" id="currentLocation" name="currentLocation" placeholder="e.g., Downtown"
                        required>
                </div>

                <div class="form-group">
                    <label for="currentLocationCode">Current Location Code:</label>
                    <select id="currentLocationCode" name="currentLocationCode" required>
                        <option value="">-- Select Location --</option>
                        <c:forEach items="${locations}" var="location">
                            <option value="${location.locationCode}">${location.name} (Code: ${location.locationCode})
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <button type="submit">Register Driver</button>
            </form>

            <a href="${pageContext.request.contextPath}/auth/login" class="back-link">← Back to Login</a>
        </body>

        </html>