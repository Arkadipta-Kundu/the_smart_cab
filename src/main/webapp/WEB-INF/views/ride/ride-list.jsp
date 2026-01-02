<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Ride List</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    max-width: 1200px;
                    margin: 50px auto;
                    padding: 20px;
                    background-color: #f5f5f5;
                }

                h2 {
                    color: #333;
                }

                table {
                    width: 100%;
                    background-color: white;
                    border-collapse: collapse;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                }

                th,
                td {
                    padding: 12px;
                    text-align: left;
                    border-bottom: 1px solid #ddd;
                }

                th {
                    background-color: #ffc107;
                    color: #333;
                }

                tr:hover {
                    background-color: #f5f5f5;
                }

                .status {
                    padding: 4px 8px;
                    border-radius: 4px;
                    font-size: 12px;
                    font-weight: bold;
                }

                .status-requested {
                    background-color: #fff3cd;
                    color: #856404;
                }

                .status-assigned {
                    background-color: #d1ecf1;
                    color: #0c5460;
                }

                .status-completed {
                    background-color: #d4edda;
                    color: #155724;
                }

                .status-cancelled {
                    background-color: #f8d7da;
                    color: #721c24;
                }

                .action-btn {
                    padding: 6px 12px;
                    border: none;
                    border-radius: 4px;
                    cursor: pointer;
                    color: white;
                    text-decoration: none;
                    display: inline-block;
                }

                .assign-btn {
                    background-color: #007bff;
                }

                .complete-btn {
                    background-color: #28a745;
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
            <h2>Ride List</h2>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>User</th>
                        <th>Pickup</th>
                        <th>Drop</th>
                        <th>Distance (km)</th>
                        <th>Driver</th>
                        <th>Fare (₹)</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${rides}" var="ride">
                        <tr>
                            <td>${ride.id}</td>
                            <td>
                                <c:forEach items="${users}" var="user">
                                    <c:if test="${user.id == ride.userId}">${user.name}</c:if>
                                </c:forEach>
                            </td>
                            <td>
                                ${ride.pickupLocation}
                                <c:if test="${ride.pickupLocationCode != null}">
                                    <br><small>(Code: ${ride.pickupLocationCode})</small>
                                </c:if>
                            </td>
                            <td>
                                ${ride.dropLocation}
                                <c:if test="${ride.dropLocationCode != null}">
                                    <br><small>(Code: ${ride.dropLocationCode})</small>
                                </c:if>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${ride.distance != null}">
                                        <strong>${ride.distance}</strong>
                                    </c:when>
                                    <c:otherwise>N/A</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${ride.driverId != null}">
                                        <c:forEach items="${drivers}" var="driver">
                                            <c:if test="${driver.id == ride.driverId}">${driver.name}</c:if>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>Not Assigned</c:otherwise>
                                </c:choose>
                            </td>
                            <td>${ride.fare}</td>
                            <td>
                                <span class="status status-${ride.status.toString().toLowerCase()}">
                                    ${ride.status}
                                </span>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${ride.status == 'REQUESTED'}">
                                        <a href="${pageContext.request.contextPath}/view/rides/${ride.id}/assign"
                                            class="action-btn assign-btn">
                                            Assign Driver
                                        </a>
                                    </c:when>
                                    <c:when test="${ride.status == 'ASSIGNED'}">
                                        <a href="${pageContext.request.contextPath}/view/rides/${ride.id}/complete"
                                            class="action-btn complete-btn">
                                            Complete
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        —
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <a href="${pageContext.request.contextPath}/" class="back-link">← Back to Home</a>
        </body>

        </html>