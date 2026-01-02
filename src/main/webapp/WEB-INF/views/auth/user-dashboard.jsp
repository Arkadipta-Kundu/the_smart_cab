<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>User Dashboard - Smart Cab</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    background-color: #f4f4f4;
                    margin: 0;
                    padding: 0;
                }

                .header {
                    background-color: #007bff;
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

                .user-info {
                    color: #666;
                    margin: 5px 0;
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
                    background-color: #007bff;
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
                    background-color: #0056b3;
                }

                .icon {
                    font-size: 48px;
                }
            </style>
        </head>

        <body>
            <div class="header">
                <h1>🚕 Smart Cab - User Dashboard</h1>
                <a href="/auth/logout" class="logout-btn">Logout</a>
            </div>

            <div class="container">
                <div class="welcome-card">
                    <h2>Welcome, ${user.name}! 👋</h2>
                    <div class="user-info">📧 Email: ${user.email}</div>
                    <div class="user-info">📱 Phone: ${user.phone}</div>
                    <div class="user-info">🎭 Role: ${user.role}</div>
                </div>

                <div class="actions">
                    <div class="action-card">
                        <div class="icon">🚖</div>
                        <h3>Book a Ride</h3>
                        <p>Request a new cab for your journey</p>
                        <a href="/rides/book" class="action-btn">Book Now</a>
                    </div>

                    <div class="action-card">
                        <div class="icon">📋</div>
                        <h3>My Rides</h3>
                        <p>View all your ride history and status</p>
                        <a href="/view/rides/user-status?userId=${user.id}" class="action-btn">View Rides</a>
                    </div>

                    <div class="action-card">
                        <div class="icon">⚙️</div>
                        <h3>Account Settings</h3>
                        <p>Update your profile information</p>
                        <a href="/users/add" class="action-btn">Edit Profile</a>
                    </div>
                </div>
            </div>
        </body>

        </html>