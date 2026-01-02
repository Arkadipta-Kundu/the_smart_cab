<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Active Ride</title>
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

                .ride-card {
                    background-color: white;
                    padding: 30px;
                    border-radius: 8px;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                    border-left: 5px solid #28a745;
                }

                .status-banner {
                    text-align: center;
                    padding: 15px;
                    background-color: #d4edda;
                    border-radius: 5px;
                    margin-bottom: 20px;
                }

                .status-banner h3 {
                    margin: 0;
                    color: #155724;
                }

                .ride-details {
                    display: grid;
                    grid-template-columns: 1fr;
                    gap: 15px;
                    margin-bottom: 20px;
                }

                .detail-item {
                    padding: 15px;
                    background-color: #f8f9fa;
                    border-radius: 5px;
                }

                .detail-label {
                    font-size: 14px;
                    color: #666;
                    margin-bottom: 5px;
                }

                .detail-value {
                    font-size: 18px;
                    font-weight: bold;
                    color: #333;
                }

                .action-btn {
                    width: 100%;
                    padding: 15px;
                    border: none;
                    border-radius: 5px;
                    cursor: pointer;
                    font-size: 18px;
                    font-weight: bold;
                    text-decoration: none;
                    text-align: center;
                    display: block;
                    margin-top: 10px;
                }

                .start-btn {
                    background-color: #007bff;
                    color: white;
                }

                .start-btn:hover {
                    background-color: #0056b3;
                }

                .complete-btn {
                    background-color: #28a745;
                    color: white;
                }

                .complete-btn:hover {
                    background-color: #218838;
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

                .progress {
                    margin: 20px 0;
                    padding: 15px;
                    background-color: #e7f3ff;
                    border-radius: 5px;
                }

                .progress-step {
                    display: flex;
                    justify-content: space-between;
                    margin-bottom: 10px;
                }

                .progress-step .step {
                    padding: 5px 10px;
                    border-radius: 5px;
                    font-size: 14px;
                }

                .step-active {
                    background-color: #007bff;
                    color: white;
                    font-weight: bold;
                }

                .step-completed {
                    background-color: #28a745;
                    color: white;
                }

                .step-pending {
                    background-color: #e9ecef;
                    color: #666;
                }
            </style>
        </head>

        <body>
            <h2>🚗 Active Ride</h2>

            <c:choose>
                <c:when test="${not empty activeRide}">
                    <div class="ride-card">
                        <div class="status-banner">
                            <h3>
                                <c:choose>
                                    <c:when test="${activeRide.status == 'DRIVER_ACCEPTED'}">
                                        ✅ Ride Accepted - En Route to Pickup
                                    </c:when>
                                    <c:when test="${activeRide.status == 'STARTED'}">
                                        🚀 Ride In Progress
                                    </c:when>
                                </c:choose>
                            </h3>
                        </div>

                        <div class="progress">
                            <div class="progress-step">
                                <span class="step step-completed">✓ Assigned</span>
                                <span class="step step-completed">✓ Accepted</span>
                                <span class="step ${activeRide.status == 'STARTED' ? 'step-completed' : 'step-active'}">
                                    ${activeRide.status == 'STARTED' ? '✓ Started' : '⏳ Start'}
                                </span>
                                <span class="step step-pending">⏳ Complete</span>
                            </div>
                        </div>

                        <div class="ride-details">
                            <div class="detail-item">
                                <div class="detail-label">👤 Customer</div>
                                <div class="detail-value">
                                    <c:forEach items="${users}" var="user">
                                        <c:if test="${user.id == activeRide.userId}">
                                            ${user.name}<br>
                                            <small style="font-size: 14px; color: #666;">📞 ${user.phone}</small>
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </div>

                            <div class="detail-item">
                                <div class="detail-label">📍 Pickup Location</div>
                                <div class="detail-value">${activeRide.pickupLocation}</div>
                            </div>

                            <div class="detail-item">
                                <div class="detail-label">📍 Drop Location</div>
                                <div class="detail-value">${activeRide.dropLocation}</div>
                            </div>

                            <div class="detail-item">
                                <div class="detail-label">📏 Distance</div>
                                <div class="detail-value">
                                    <c:choose>
                                        <c:when test="${activeRide.distance != null}">
                                            ${activeRide.distance} km
                                        </c:when>
                                        <c:otherwise>N/A</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="detail-item">
                                <div class="detail-label">💰 Fare</div>
                                <div class="detail-value">₹${activeRide.fare}</div>
                            </div>
                        </div>

                        <c:choose>
                            <c:when test="${activeRide.status == 'DRIVER_ACCEPTED'}">
                                <a href="${pageContext.request.contextPath}/view/rides/${activeRide.id}/start?driverId=${sessionScope.loggedDriver.id}"
                                    class="action-btn start-btn">
                                    🚀 Start Ride
                                </a>
                            </c:when>
                            <c:when test="${activeRide.status == 'STARTED'}">
                                <a href="${pageContext.request.contextPath}/view/rides/${activeRide.id}/complete?driverId=${sessionScope.loggedDriver.id}"
                                    class="action-btn complete-btn"
                                    onclick="return confirm('Are you sure you want to complete this ride?')">
                                    ✓ Complete Ride
                                </a>
                            </c:when>
                        </c:choose>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-message">
                        📭 No active ride. Check pending requests to accept a new ride.
                    </div>
                </c:otherwise>
            </c:choose>

            <a href="${pageContext.request.contextPath}/auth/driver-dashboard" class="back-link">← Back to Dashboard</a>
        </body>

        </html>