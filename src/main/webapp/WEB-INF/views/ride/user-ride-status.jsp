<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>My Ride Status</title>
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

                .ride-card {
                    background-color: white;
                    padding: 20px;
                    border-radius: 8px;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                    margin-bottom: 20px;
                }

                .ride-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    border-bottom: 2px solid #f0f0f0;
                    padding-bottom: 10px;
                    margin-bottom: 15px;
                }

                .ride-id {
                    font-weight: bold;
                    font-size: 18px;
                    color: #007bff;
                }

                .status {
                    padding: 8px 16px;
                    border-radius: 20px;
                    font-size: 14px;
                    font-weight: bold;
                }

                .status-requested {
                    background-color: #fff3cd;
                    color: #856404;
                }

                .status-driver_assigned {
                    background-color: #cce5ff;
                    color: #004085;
                }

                .status-driver_accepted {
                    background-color: #d1ecf1;
                    color: #0c5460;
                }

                .status-started {
                    background-color: #d4edda;
                    color: #155724;
                }

                .status-completed {
                    background-color: #28a745;
                    color: white;
                }

                .status-cancelled {
                    background-color: #f8d7da;
                    color: #721c24;
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

                .action-btn {
                    padding: 10px 20px;
                    border: none;
                    border-radius: 5px;
                    cursor: pointer;
                    font-size: 14px;
                    font-weight: bold;
                    text-decoration: none;
                    display: inline-block;
                    margin-right: 10px;
                }

                .cancel-btn {
                    background-color: #dc3545;
                    color: white;
                }

                .cancel-btn:hover {
                    background-color: #c82333;
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

                .empty-message {
                    text-align: center;
                    padding: 50px;
                    color: #999;
                    font-size: 18px;
                }

                .timeline {
                    margin-top: 20px;
                    padding: 15px;
                    background-color: #e7f3ff;
                    border-radius: 5px;
                }

                .timeline h4 {
                    margin: 0 0 10px 0;
                    color: #007bff;
                }
            </style>
        </head>

        <body>
            <h2>🚖 My Ride Status</h2>

            <c:choose>
                <c:when test="${not empty rides}">
                    <c:forEach var="ride" items="${rides}">
                        <div class="ride-card">
                            <div class="ride-header">
                                <span class="ride-id">Ride #${ride.id}</span>
                                <span class="status status-${ride.status.toString().toLowerCase()}">
                                    ${ride.status}
                                </span>
                            </div>

                            <div class="ride-details">
                                <div class="detail-item">
                                    <div class="detail-label">📍 Pickup Location</div>
                                    <div class="detail-value">${ride.pickupLocation}</div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">📍 Drop Location</div>
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
                                <div class="detail-item">
                                    <div class="detail-label">💰 Fare</div>
                                    <div class="detail-value">₹${ride.fare}</div>
                                </div>
                                <c:if test="${ride.driverId != null}">
                                    <div class="detail-item">
                                        <div class="detail-label">🚗 Driver</div>
                                        <div class="detail-value">
                                            <c:forEach items="${drivers}" var="driver">
                                                <c:if test="${driver.id == ride.driverId}">
                                                    ${driver.name} (${driver.phone})
                                                </c:if>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </c:if>
                            </div>

                            <div class="timeline">
                                <h4>📋 Ride Lifecycle</h4>
                                <c:choose>
                                    <c:when test="${ride.status == 'REQUESTED'}">
                                        ⏳ Searching for nearest driver...
                                    </c:when>
                                    <c:when test="${ride.status == 'DRIVER_ASSIGNED'}">
                                        ✅ Driver assigned! Waiting for driver acceptance...
                                    </c:when>
                                    <c:when test="${ride.status == 'DRIVER_ACCEPTED'}">
                                        ✅ Driver accepted! Driver is on the way...
                                    </c:when>
                                    <c:when test="${ride.status == 'STARTED'}">
                                        🚀 Ride started! En route to destination...
                                    </c:when>
                                    <c:when test="${ride.status == 'COMPLETED'}">
                                        🎉 Ride completed! Thank you for using Smart Cab!
                                    </c:when>
                                    <c:when test="${ride.status == 'CANCELLED'}">
                                        ❌ Ride cancelled
                                    </c:when>
                                </c:choose>
                            </div>

                            <c:if test="${ride.status != 'COMPLETED' && ride.status != 'CANCELLED'}">
                                <div style="margin-top: 15px;">
                                    <a href="${pageContext.request.contextPath}/view/rides/${ride.id}/cancel?userId=${sessionScope.loggedUser.id}"
                                        class="action-btn cancel-btn"
                                        onclick="return confirm('Are you sure you want to cancel this ride?')">
                                        Cancel Ride
                                    </a>
                                </div>
                            </c:if>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-message">
                        📭 No rides found. Book your first ride!
                    </div>
                </c:otherwise>
            </c:choose>

            <a href="${pageContext.request.contextPath}/auth/user-dashboard" class="back-link">← Back to Dashboard</a>
        </body>

        </html>