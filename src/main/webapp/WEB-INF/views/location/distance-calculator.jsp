<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Distance Calculator</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    max-width: 800px;
                    margin: 50px auto;
                    padding: 20px;
                    background-color: #f5f5f5;
                }

                h2 {
                    color: #333;
                    text-align: center;
                }

                .calculator {
                    background-color: white;
                    padding: 30px;
                    border-radius: 8px;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                    margin-bottom: 20px;
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

                select {
                    width: 100%;
                    padding: 10px;
                    border: 1px solid #ddd;
                    border-radius: 4px;
                    box-sizing: border-box;
                }

                button {
                    background-color: #2196F3;
                    color: white;
                    padding: 12px 30px;
                    border: none;
                    border-radius: 4px;
                    cursor: pointer;
                    font-size: 16px;
                    width: 100%;
                }

                button:hover {
                    background-color: #0b7dda;
                }

                .result {
                    background-color: #e8f5e9;
                    border-left: 4px solid #4caf50;
                    padding: 20px;
                    margin-top: 20px;
                    border-radius: 4px;
                }

                .result h3 {
                    margin: 0 0 15px 0;
                    color: #4caf50;
                }

                .result-item {
                    margin: 10px 0;
                    font-size: 16px;
                }

                .result-item strong {
                    color: #333;
                }

                .formula {
                    background-color: #fff3cd;
                    border-left: 4px solid #ffc107;
                    padding: 15px;
                    margin-top: 15px;
                    border-radius: 4px;
                    font-family: 'Courier New', monospace;
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
            <h2>📏 Distance Calculator</h2>

            <div class="calculator">
                <form action="${pageContext.request.contextPath}/view/locations/distance" method="get">
                    <div class="form-group">
                        <label for="pickupCode">Pickup Location:</label>
                        <select id="pickupCode" name="pickupCode" required>
                            <option value="">-- Select Pickup Location --</option>
                            <c:forEach var="location" items="${locations}">
                                <option value="${location.locationCode}">${location.name} (Code:
                                    ${location.locationCode})</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="dropCode">Drop Location:</label>
                        <select id="dropCode" name="dropCode" required>
                            <option value="">-- Select Drop Location --</option>
                            <c:forEach var="location" items="${locations}">
                                <option value="${location.locationCode}">${location.name} (Code:
                                    ${location.locationCode})</option>
                            </c:forEach>
                        </select>
                    </div>

                    <button type="submit">Calculate Distance</button>
                </form>

                <c:if test="${not empty distance}">
                    <div class="result">
                        <h3>✅ Distance Calculation Result</h3>
                        <div class="result-item">
                            <strong>Pickup:</strong> ${pickupLocation}
                        </div>
                        <div class="result-item">
                            <strong>Drop:</strong> ${dropLocation}
                        </div>
                        <div class="result-item">
                            <strong>Distance:</strong> ${distance} km
                        </div>
                        <div class="formula">
                            <strong>Formula:</strong> distance = abs(pickupCode - dropCode) × 5
                        </div>
                    </div>
                </c:if>
            </div>

            <a href="${pageContext.request.contextPath}/view/locations/list" class="back-link">← Back to Locations</a>
        </body>

        </html>