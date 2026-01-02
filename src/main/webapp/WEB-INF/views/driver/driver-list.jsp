<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Driver List</title>
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
                    background-color: #28a745;
                    color: white;
                }

                tr:hover {
                    background-color: #f5f5f5;
                }

                .available {
                    color: green;
                    font-weight: bold;
                }

                .unavailable {
                    color: red;
                    font-weight: bold;
                }

                .toggle-btn {
                    padding: 6px 12px;
                    border: none;
                    border-radius: 4px;
                    cursor: pointer;
                    color: white;
                }

                .toggle-btn.available {
                    background-color: #dc3545;
                }

                .toggle-btn.unavailable {
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
            <h2>Driver List</h2>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Phone</th>
                        <th>Vehicle Number</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${drivers}" var="driver">
                        <tr>
                            <td>${driver.id}</td>
                            <td>${driver.name}</td>
                            <td>${driver.phone}</td>
                            <td>${driver.vehicleNumber}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${driver.available}">
                                        <span class="available">Available</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="unavailable">Busy</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <a
                                    href="${pageContext.request.contextPath}/view/drivers/${driver.id}/toggle-availability">
                                    <button class="toggle-btn ${driver.available ? 'available' : 'unavailable'}">
                                        ${driver.available ? 'Mark Busy' : 'Mark Available'}
                                    </button>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <a href="${pageContext.request.contextPath}/" class="back-link">← Back to Home</a>
        </body>

        </html>