<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Smart Cab - Login</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f4f4f4;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
            }

            .login-container {
                background-color: white;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
                width: 400px;
            }

            h2 {
                text-align: center;
                color: #333;
                margin-bottom: 30px;
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

            input[type="text"],
            input[type="password"] {
                width: 100%;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 5px;
                box-sizing: border-box;
                font-size: 14px;
            }

            .role-selector {
                display: flex;
                gap: 20px;
                margin-bottom: 20px;
            }

            .role-option {
                flex: 1;
                padding: 15px;
                border: 2px solid #ddd;
                border-radius: 8px;
                cursor: pointer;
                text-align: center;
                transition: all 0.3s;
            }

            .role-option:hover {
                background-color: #f0f0f0;
            }

            .role-option.active {
                border-color: #007bff;
                background-color: #e7f3ff;
            }

            .role-option input[type="radio"] {
                margin-right: 5px;
            }

            button {
                width: 100%;
                padding: 12px;
                background-color: #007bff;
                color: white;
                border: none;
                border-radius: 5px;
                font-size: 16px;
                cursor: pointer;
                transition: background-color 0.3s;
            }

            button:hover {
                background-color: #0056b3;
            }

            .error {
                color: red;
                text-align: center;
                margin-bottom: 15px;
                font-size: 14px;
            }

            .register-link {
                text-align: center;
                margin-top: 20px;
            }

            .register-link a {
                color: #007bff;
                text-decoration: none;
            }

            .register-link a:hover {
                text-decoration: underline;
            }

            #userFields,
            #driverFields {
                display: none;
            }
        </style>
        <script>
            function showFields(role) {
                document.getElementById('userFields').style.display = 'none';
                document.getElementById('driverFields').style.display = 'none';

                if (role === 'user') {
                    document.getElementById('userFields').style.display = 'block';
                    document.getElementById('loginForm').action = '/auth/user-login';
                } else if (role === 'driver') {
                    document.getElementById('driverFields').style.display = 'block';
                    document.getElementById('loginForm').action = '/auth/driver-login';
                }

                // Update active class
                document.querySelectorAll('.role-option').forEach(opt => opt.classList.remove('active'));
                event.target.closest('.role-option').classList.add('active');
            }
        </script>
    </head>

    <body>
        <div class="login-container">
            <h2>🚕 Smart Cab Login</h2>

            <% if (request.getParameter("error") !=null) { %>
                <div class="error">${error}</div>
                <% } %>

                    <div class="role-selector">
                        <div class="role-option">
                            <input type="radio" name="role" id="userRole" value="user" onclick="showFields('user')">
                            <label for="userRole" style="display: inline; font-weight: normal; cursor: pointer;">👤
                                User</label>
                        </div>
                        <div class="role-option">
                            <input type="radio" name="role" id="driverRole" value="driver"
                                onclick="showFields('driver')">
                            <label for="driverRole" style="display: inline; font-weight: normal; cursor: pointer;">🚗
                                Driver</label>
                        </div>
                    </div>

                    <form id="loginForm" method="post">
                        <div id="userFields">
                            <div class="form-group">
                                <label for="email">Email</label>
                                <input type="text" id="email" name="email" required>
                            </div>
                            <div class="form-group">
                                <label for="userPassword">Password</label>
                                <input type="password" id="userPassword" name="password" required>
                            </div>
                        </div>

                        <div id="driverFields">
                            <div class="form-group">
                                <label for="phone">Phone Number</label>
                                <input type="text" id="phone" name="phone" required>
                            </div>
                            <div class="form-group">
                                <label for="driverPassword">Password</label>
                                <input type="password" id="driverPassword" name="password" required>
                            </div>
                        </div>

                        <button type="submit">Login</button>
                    </form>

                    <div class="register-link">
                        Don't have an account?
                        <a href="/users/add">Register as User</a> |
                        <a href="/drivers/add">Register as Driver</a>
                    </div>
        </div>
    </body>

    </html>