<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Driver - Ride Requests</title>
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

                .request-card {
                    background-color: white;
                    padding: 20px;
                    border-radius: 8px;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                    margin-bottom: 20px;
                    border-left: 5px solid #ffc107;
                }

                .request-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 15px;
                }

                .ride-id {
                    font-weight: bold;
                    font-size: 18px;
                    color: #007bff;
                }

                .badge {
                    padding: 5px 15px;
                    border-radius: 20px;
                    font-size: 12px;
                    font-weight: bold;
                    background-color: #ffc107;
                    color: #333;
                }

                .ride-details {
                    display: grid;
                    grid-template-columns: 1fr 1fr;
                    gap: 15px;
                    margin-bottom: 15px;
                }

                .detail-item {
                    padding: 10px;
                    background-color: #f8f9fa;
                    border-radius: 5px;
                }

                .detail-label {
                    font-size: 12px;
                    color: #666;
                    margin-bottom: 5px;
                }

                .detail-value {
                    font-size: 16px;
                    font-weight: bold;
                    color: #333;
                }

                .actions {
                    display: flex;
                    gap: 10px;
                }

                .action-btn {
                    flex: 1;
                    padding: 12px;
                    border: none;
                    border-radius: 5px;
                    cursor: pointer;
                    font-size: 16px;
                    font-weight: bold;
                    text-decoration: none;
                    text-align: center;
                    display: block;
                }

                .accept-btn {
                    background-color: #28a745;
                    color: white;
                }

                .accept-btn:hover {
                    background-color: #218838;
                }

                .reject-btn {
                    background-color: #dc3545;
                    color: white;
                }

                .reject-btn:hover {
                    background-color: #c82333;
                }

                .empty-message {
                    text-align: center;
                    padding: 50px;
                    color: #999;
                    font-size: 18px;
                    background-color: white;
                    border-radius: 8px;
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
            <h2>🚗 Pending Ride Requests</h2>

            <c:choose>
                <c:when test="${not empty pendingRides}">
                    <c:forEach var="ride" items="${pendingRides}">
                        <div class="request-card">
                            <div class="request-header">
                                <span class="ride-id">Ride #${ride.id}</span>
                                <span class="badge">WAITING FOR RESPONSE</span>
                            </div>

                            <div class="ride-details">
                                <div class="detail-item">
                                    <div class="detail-label">👤 Customer</div>
                                    <div class="detail-value">
                                        <c:forEach items="${users}" var="user">
                                            <c:if test="${user.id == ride.userId}">
                                                ${user.name} (${user.phone})
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">💰 Fare</div>
                                    <div class="detail-value">₹${ride.fare}</div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">📍 Pickup</div>
                                    <div class="detail-value">${ride.pickupLocation}</div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">📍 Drop</div>
                                    <div class="detail-value">${ride.dropLocation}</div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">📏 Distance</div>
                                    <div class="detail-value">
                                        <c:choose>
                                            <c:when test="${ride.distance != null}">
                                                ${ride.distance} km
                                            </c:when>
                                            <c:otherwise>N/A</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>

                            <div class="actions">
                                <a href="${pageContext.request.contextPath}/view/rides/${ride.id}/accept?driverId=${sessionScope.loggedDriver.id}"
                                    class="action-btn accept-btn">
                                    ✅ Accept Ride
                                </a>
                                <a href="${pageContext.request.contextPath}/view/rides/${ride.id}/reject?driverId=${sessionScope.loggedDriver.id}"
                                    class="action-btn reject-btn"
                                    onclick="return confirm('Are you sure you want to reject this ride?')">
                                    ❌ Reject Ride
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-message">
                        ✅ No pending ride requests. You're all caught up!
                    </div>
                </c:otherwise>
            </c:choose>

            <a href="${pageContext.request.contextPath}/auth/driver-dashboard" class="back-link">← Back to Dashboard</a>
        </body>

        </html>