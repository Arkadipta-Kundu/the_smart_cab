<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Book Ride</title>
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

                select,
                input[type="text"] {
                    width: 100%;
                    padding: 10px;
                    border: 1px solid #ddd;
                    border-radius: 4px;
                    box-sizing: border-box;
                }

                button {
                    background-color: #ffc107;
                    color: #333;
                    padding: 12px 30px;
                    border: none;
                    border-radius: 4px;
                    cursor: pointer;
                    font-size: 16px;
                    font-weight: bold;
                }

                button:hover {
                    background-color: #e0a800;
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

                .info {
                    background-color: #e7f3ff;
                    padding: 10px;
                    border-radius: 4px;
                    margin-bottom: 20px;
                    color: #004085;
                }
            </style>
        </head>

        <body>
            <h2>Book a Ride</h2>

            <div class="info">
                💡 Fare is calculated automatically: Base ₹50 + (distance × ₹12)<br>
                📏 Distance = abs(pickupCode - dropCode) × 5 km
            </div>

            <form action="${pageContext.request.contextPath}/view/rides/book" method="post">
                <div class="form-group">
                    <label for="userId">Select User:</label>
                    <select id="userId" name="userId" required>
                        <option value="">-- Select User --</option>
                        <c:forEach items="${users}" var="user">
                            <option value="${user.id}">${user.name} (${user.phone})</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label for="pickupLocationCode">Pickup Location:</label>
                    <select id="pickupLocationCode" name="pickupLocationCode" required>
                        <option value="">-- Select Pickup Location --</option>
                        <c:forEach items="${locations}" var="location">
                            <option value="${location.locationCode}">${location.name} (Code: ${location.locationCode})
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label for="dropLocationCode">Drop Location:</label>
                    <select id="dropLocationCode" name="dropLocationCode" required>
                        <option value="">-- Select Drop Location --</option>
                        <c:forEach items="${locations}" var="location">
                            <option value="${location.locationCode}">${location.name} (Code: ${location.locationCode})
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <button type="submit">Book Ride</button>
            </form>

            <a href="${pageContext.request.contextPath}/" class="back-link">← Back to Home</a>
        </body>

        </html>