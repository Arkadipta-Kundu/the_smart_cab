<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Smart Cab Service</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                max-width: 800px;
                margin: 50px auto;
                padding: 20px;
                background-color: #f5f5f5;
            }

            h1 {
                color: #333;
                text-align: center;
            }

            .menu {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 20px;
                margin-top: 40px;
            }

            .menu-item {
                background-color: white;
                padding: 30px;
                border-radius: 8px;
                text-align: center;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                transition: transform 0.2s;
            }

            .menu-item:hover {
                transform: translateY(-5px);
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            }

            .menu-item a {
                text-decoration: none;
                color: #007bff;
                font-size: 18px;
                font-weight: bold;
            }

            .menu-item p {
                color: #666;
                margin-top: 10px;
            }
        </style>
    </head>

    <body>
        <h1>🚕 Smart Cab Service</h1>
        <p style="text-align: center; color: #666;">Spring Boot MVC Application</p>

        <div class="menu">
            <div class="menu-item">
                <a href="${pageContext.request.contextPath}/view/users/new">Register User</a>
                <p>Add new customer</p>
            </div>

            <div class="menu-item">
                <a href="${pageContext.request.contextPath}/view/users">View Users</a>
                <p>See all customers</p>
            </div>

            <div class="menu-item">
                <a href="${pageContext.request.contextPath}/view/drivers/new">Register Driver</a>
                <p>Add new driver</p>
            </div>

            <div class="menu-item">
                <a href="${pageContext.request.contextPath}/view/drivers">View Drivers</a>
                <p>See all drivers</p>
            </div>

            <div class="menu-item">
                <a href="${pageContext.request.contextPath}/view/rides/new">Book Ride</a>
                <p>Create new ride</p>
            </div>

            <div class="menu-item">
                <a href="${pageContext.request.contextPath}/view/rides">View Rides</a>
                <p>See all rides</p>
            </div>
        </div>
    </body>

    </html>