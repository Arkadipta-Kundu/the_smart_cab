<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Driver Dashboard - Smart Cab</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    background-color: #f4f4f4;
                    margin: 0;
                    padding: 0;
                }

                .header {
                    background-color: #28a745;
                    color: white;
                    padding: 15px 30px;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                }

                .header h1 {
                    margin: 0;
                    font-size: 24px;
                }

                .logout-btn {
                    background-color: #dc3545;
                    color: white;
                    padding: 8px 20px;
                    border: none;
                    border-radius: 5px;
                    cursor: pointer;
                    text-decoration: none;
                    font-size: 14px;
                }

                .logout-btn:hover {
                    background-color: #c82333;
                }

                .container {
                    max-width: 1200px;
                    margin: 30px auto;
                    padding: 0 20px;
                }

                .welcome-card {
                    background-color: white;
                    padding: 30px;
                    border-radius: 10px;
                    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                    margin-bottom: 30px;
                }

                .welcome-card h2 {
                    color: #333;
                    margin: 0 0 10px 0;
                }

                .driver-info {
                    color: #666;
                    margin: 5px 0;
                }

                .status-badge {
                    display: inline-block;
                    padding: 5px 15px;
                    border-radius: 20px;
                    font-size: 14px;
                    font-weight: bold;
                    margin-left: 10px;
                }

                .status-available {
                    background-color: #d4edda;
                    color: #155724;
                }

                .status-busy {
                    background-color: #f8d7da;
                    color: #721c24;
                }

                .actions {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                    gap: 20px;
                    margin-top: 20px;
                }

                .action-card {
                    background-color: white;
                    padding: 30px;
                    border-radius: 10px;
                    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                    text-align: center;
                    transition: transform 0.3s;
                }

                .action-card:hover {
                    transform: translateY(-5px);
                }

                .action-card h3 {
                    color: #333;
                    margin: 15px 0;
                }

                .action-card p {
                    color: #666;
                    margin-bottom: 20px;
                }

                .action-btn {
                    background-color: #28a745;
                    color: white;
                    padding: 12px 30px;
                    border: none;
                    border-radius: 5px;
                    cursor: pointer;
                    text-decoration: none;
                    display: inline-block;
                    font-size: 16px;
                }

                .action-btn:hover {
                    background-color: #218838;
                }

                .icon {
                    font-size: 48px;
                }
            </style>
        </head>

        <body>
            <div class="header">
                <h1>🚗 Smart Cab - Driver Dashboard</h1>
                <a href="/auth/logout" class="logout-btn">Logout</a>
            </div>

            <div class="container">
                <div class="welcome-card">
                    <h2>Welcome, ${driver.name}! 👋</h2>
                    <div class="driver-info">📱 Phone: ${driver.phone}</div>
                    <div class="driver-info">🚗 Vehicle: ${driver.vehicleNumber}</div>
                    <div class="driver-info">📍 Location: ${driver.currentLocation != null ? driver.currentLocation :
                        'Not set'}</div>
                    <div class="driver-info">
                        🎭 Role: ${driver.role}
                        <c:choose>
                            <c:when test="${driver.available}">
                                <span class="status-badge status-available">✓ Available</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge status-busy">✗ Busy</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="actions">
                    <div class="action-card">
                        <div class="icon">📋</div>
                        <h3>My Rides</h3>
                        <p>View your assigned rides</p>
                        <a href="/rides/list" class="action-btn">View Rides</a>
                    </div>

                    <div class="action-card">
                        <div class="icon">🔄</div>
                        <h3>Toggle Availability</h3>
                        <p>Update your availability status</p>
                        <a href="/drivers/list" class="action-btn">Manage Status</a>
                    </div>

                    <div class="action-card">
                        <div class="icon">⚙️</div>
                        <h3>Profile Settings</h3>
                        <p>Update your profile information</p>
                        <a href="/drivers/add" class="action-btn">Edit Profile</a>
                    </div>
                </div>
            </div>
        </body>

        </html>