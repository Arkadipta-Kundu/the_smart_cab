<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Location List</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    max-width: 1000px;
                    margin: 50px auto;
                    padding: 20px;
                    background-color: #f5f5f5;
                }

                h2 {
                    color: #333;
                    text-align: center;
                }

                .actions {
                    text-align: center;
                    margin-bottom: 30px;
                }

                .actions a {
                    background-color: #ff9800;
                    color: white;
                    padding: 10px 25px;
                    text-decoration: none;
                    border-radius: 4px;
                    margin: 0 10px;
                }

                .actions a:hover {
                    background-color: #e68900;
                }

                table {
                    width: 100%;
                    background-color: white;
                    border-collapse: collapse;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                    border-radius: 8px;
                    overflow: hidden;
                }

                th {
                    background-color: #ff9800;
                    color: white;
                    padding: 15px;
                    text-align: left;
                }

                td {
                    padding: 12px 15px;
                    border-bottom: 1px solid #ddd;
                }

                tr:hover {
                    background-color: #f5f5f5;
                }

                .code-badge {
                    background-color: #2196F3;
                    color: white;
                    padding: 5px 15px;
                    border-radius: 20px;
                    font-weight: bold;
                    display: inline-block;
                }

                .empty-message {
                    text-align: center;
                    padding: 50px;
                    color: #999;
                    font-size: 18px;
                }

                .info-box {
                    background-color: #e7f3ff;
                    border-left: 4px solid #2196F3;
                    padding: 15px;
                    margin-bottom: 20px;
                    border-radius: 4px;
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
            <h2>📍 Location Management</h2>

            <div class="info-box">
                <strong>Distance Formula:</strong> distance = abs(pickupCode - dropCode) × 5 km
            </div>

            <div class="actions">
                <a href="${pageContext.request.contextPath}/view/locations/add">➕ Add New Location</a>
                <a href="${pageContext.request.contextPath}/location/distance-calculator">📏 Calculate Distance</a>
            </div>

            <c:choose>
                <c:when test="${not empty locations}">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Location Name</th>
                                <th>Location Code</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="location" items="${locations}">
                                <tr>
                                    <td>${location.id}</td>
                                    <td><strong>${location.name}</strong></td>
                                    <td><span class="code-badge">${location.locationCode}</span></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty-message">
                        📭 No locations found. Add your first location!
                    </div>
                </c:otherwise>
            </c:choose>

            <a href="${pageContext.request.contextPath}/auth/user-dashboard" class="back-link">← Back to Dashboard</a>
        </body>

        </html>