<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Add Location</title>
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
                    text-align: center;
                }

                .info-box {
                    background-color: #e7f3ff;
                    border-left: 4px solid #2196F3;
                    padding: 15px;
                    margin-bottom: 20px;
                    border-radius: 4px;
                }

                .info-box h4 {
                    margin: 0 0 10px 0;
                    color: #2196F3;
                }

                .info-box p {
                    margin: 5px 0;
                    font-size: 14px;
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
                input[type="number"] {
                    width: 100%;
                    padding: 10px;
                    border: 1px solid #ddd;
                    border-radius: 4px;
                    box-sizing: border-box;
                }

                button {
                    background-color: #ff9800;
                    color: white;
                    padding: 12px 30px;
                    border: none;
                    border-radius: 4px;
                    cursor: pointer;
                    font-size: 16px;
                    width: 100%;
                }

                button:hover {
                    background-color: #e68900;
                }

                .back-link {
                    display: inline-block;
                    margin-top: 20px;
                    color: #007bff;
                    text-decoration: none;
                    text-align: center;
                    width: 100%;
                }

                .back-link:hover {
                    text-decoration: underline;
                }
            </style>
        </head>

        <body>
            <h2>📍 Add New Location</h2>

            <div class="info-box">
                <h4>ℹ️ Location System Info</h4>
                <p><strong>Location Code:</strong> Unique identifier (1, 2, 3, etc.)</p>
                <p><strong>Distance Formula:</strong> abs(pickupCode - dropCode) × 5 km</p>
                <p><strong>Example:</strong> Code 1 to Code 3 = |1-3| × 5 = 10 km</p>
            </div>

            <form action="${pageContext.request.contextPath}/view/locations/save" method="post">
                <div class="form-group">
                    <label for="name">Location Name:</label>
                    <input type="text" id="name" name="name" placeholder="e.g., Downtown, Airport, Mall" required>
                </div>

                <div class="form-group">
                    <label for="locationCode">Location Code:</label>
                    <input type="number" id="locationCode" name="locationCode" placeholder="e.g., 1, 2, 3" min="1"
                        required>
                </div>

                <button type="submit">Add Location</button>
            </form>

            <a href="${pageContext.request.contextPath}/view/locations/list" class="back-link">← View All Locations</a>
        </body>

        </html>