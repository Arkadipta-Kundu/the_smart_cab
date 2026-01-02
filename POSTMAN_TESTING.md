# 📮 Postman Testing Guide - Smart Cab Service

This guide provides step-by-step instructions for testing the Smart Cab Service REST APIs using Postman.

## Quick Start

1. **Import Collection**: Import the `Smart_Cab_Service.postman_collection.json` file into Postman
2. **Start Application**: Run `mvn spring-boot:run`
3. **Base URL**: `http://localhost:8080`

## Import Postman Collection

### Method 1: Import File

1. Open Postman
2. Click **Import** button (top left)
3. Select **File** tab
4. Choose `Smart_Cab_Service.postman_collection.json`
5. Click **Import**

### Method 2: Drag & Drop

- Drag the collection file into Postman window

## Testing Flow (Recommended Order)

Follow this sequence for a complete test flow:

### Step 1: Register Users (Customers)

**API**: `POST /users`

**Request Body**:

```json
{
  "name": "John Doe",
  "phone": "1234567890",
  "email": "john@example.com"
}
```

**Expected Response** (201 Created):

```json
{
  "id": 1,
  "name": "John Doe",
  "phone": "1234567890",
  "email": "john@example.com"
}
```

✅ **Register 2-3 users for testing**

---

### Step 2: Register Drivers

**API**: `POST /drivers`

**Request Body**:

```json
{
  "name": "Mike Wilson",
  "phone": "1112223333",
  "vehicleNumber": "DL-01-AB-1234",
  "available": true
}
```

**Expected Response** (201 Created):

```json
{
  "id": 1,
  "name": "Mike Wilson",
  "phone": "1112223333",
  "vehicleNumber": "DL-01-AB-1234",
  "available": true
}
```

✅ **Register 2-3 drivers for testing**

---

### Step 3: View All Users

**API**: `GET /users`

**Expected Response** (200 OK):

```json
[
  {
    "id": 1,
    "name": "John Doe",
    "phone": "1234567890",
    "email": "john@example.com"
  },
  {
    "id": 2,
    "name": "Jane Smith",
    "phone": "9876543210",
    "email": "jane@example.com"
  }
]
```

---

### Step 4: View Available Drivers

**API**: `GET /drivers?available=true`

**Expected Response** (200 OK):

```json
[
  {
    "id": 1,
    "name": "Mike Wilson",
    "phone": "1112223333",
    "vehicleNumber": "DL-01-AB-1234",
    "available": true
  }
]
```

---

### Step 5: Book a Ride

**API**: `POST /rides`

**Request Body**:

```json
{
  "userId": 1,
  "pickupLocation": "Downtown",
  "dropLocation": "Airport"
}
```

**Note**: Fare is calculated automatically!

**Expected Response** (201 Created):

```json
{
  "id": 1,
  "pickupLocation": "Downtown",
  "dropLocation": "Airport",
  "status": "REQUESTED",
  "userId": 1,
  "driverId": null,
  "fare": 125.0
}
```

**Fare Calculation**:

- Base Fare: ₹50
- "Downtown" (8 chars) + "Airport" (7 chars) = 15
- Total: 50 + (15 × 5) = **₹125**

---

### Step 6: Assign Driver to Ride

**API**: `PUT /rides/{rideId}/assign`

**Example**: `PUT /rides/1/assign`

**Expected Response** (200 OK):

```json
{
  "id": 1,
  "pickupLocation": "Downtown",
  "dropLocation": "Airport",
  "status": "ASSIGNED",
  "userId": 1,
  "driverId": 1,
  "fare": 125.0
}
```

**What Happens**:

1. First available driver is found
2. Driver assigned to ride
3. Ride status → ASSIGNED
4. Driver availability → false (busy)

---

### Step 7: Complete Ride

**API**: `PUT /rides/{rideId}/complete`

**Example**: `PUT /rides/1/complete`

**Expected Response** (200 OK):

```json
{
  "id": 1,
  "pickupLocation": "Downtown",
  "dropLocation": "Airport",
  "status": "COMPLETED",
  "userId": 1,
  "driverId": 1,
  "fare": 125.0
}
```

**What Happens**:

1. Ride status → COMPLETED
2. Driver availability → true (available again)

---

### Step 8: View All Rides

**API**: `GET /rides`

**Expected Response** (200 OK):

```json
[
  {
    "id": 1,
    "pickupLocation": "Downtown",
    "dropLocation": "Airport",
    "status": "COMPLETED",
    "userId": 1,
    "driverId": 1,
    "fare": 125.0
  }
]
```

---

## Error Testing Scenarios

### Test 1: Assign Driver When No Drivers Available

**Steps**:

1. Mark all drivers as unavailable
2. Try to assign driver to a ride

**API**: `PUT /rides/{rideId}/assign`

**Expected Response** (400 Bad Request):

```json
{
  "timestamp": "2026-01-02T10:30:00",
  "status": 400,
  "error": "Bad Request",
  "message": "No available drivers found"
}
```

---

### Test 2: Get Non-Existent User

**API**: `GET /users/999`

**Expected Response** (404 Not Found):

```json
{
  "timestamp": "2026-01-02T10:30:00",
  "status": 404,
  "error": "Not Found",
  "message": "User not found with id: 999"
}
```

---

### Test 3: Complete Already Completed Ride

**API**: `PUT /rides/1/complete` (on already completed ride)

**Expected Response** (400 Bad Request):

```json
{
  "timestamp": "2026-01-02T10:30:00",
  "status": 400,
  "error": "Bad Request",
  "message": "Ride 1 is in COMPLETED status. Expected: ASSIGNED"
}
```

---

### Test 4: Assign Driver to Already Assigned Ride

**API**: `PUT /rides/1/assign` (on already assigned ride)

**Expected Response** (400 Bad Request):

```json
{
  "timestamp": "2026-01-02T10:30:00",
  "status": 400,
  "error": "Bad Request",
  "message": "Ride 1 is in ASSIGNED status. Expected: REQUESTED"
}
```

---

## Complete API Reference

### User APIs

| Method | Endpoint      | Description       |
| ------ | ------------- | ----------------- |
| POST   | `/users`      | Register new user |
| GET    | `/users`      | Get all users     |
| GET    | `/users/{id}` | Get user by ID    |

### Driver APIs

| Method | Endpoint                                    | Description                |
| ------ | ------------------------------------------- | -------------------------- |
| POST   | `/drivers`                                  | Register new driver        |
| GET    | `/drivers`                                  | Get all drivers            |
| GET    | `/drivers?available=true`                   | Get only available drivers |
| PUT    | `/drivers/{id}/availability?available=true` | Update driver availability |

### Ride APIs

| Method | Endpoint                   | Description           |
| ------ | -------------------------- | --------------------- |
| POST   | `/rides`                   | Book new ride         |
| GET    | `/rides`                   | Get all rides         |
| GET    | `/rides/{id}`              | Get ride by ID        |
| PUT    | `/rides/{rideId}/assign`   | Assign driver to ride |
| PUT    | `/rides/{rideId}/complete` | Complete ride         |

---

## Sample Test Data

### Sample Users

```json
[
  {
    "name": "John Doe",
    "phone": "1234567890",
    "email": "john@example.com"
  },
  {
    "name": "Jane Smith",
    "phone": "9876543210",
    "email": "jane@example.com"
  },
  {
    "name": "Bob Johnson",
    "phone": "5555555555",
    "email": "bob@example.com"
  }
]
```

### Sample Drivers

```json
[
  {
    "name": "Mike Wilson",
    "phone": "1112223333",
    "vehicleNumber": "DL-01-AB-1234",
    "available": true
  },
  {
    "name": "Sarah Brown",
    "phone": "4445556666",
    "vehicleNumber": "DL-02-CD-5678",
    "available": true
  },
  {
    "name": "Tom Davis",
    "phone": "7778889999",
    "vehicleNumber": "DL-03-EF-9012",
    "available": true
  }
]
```

### Sample Rides

```json
[
  {
    "userId": 1,
    "pickupLocation": "Downtown",
    "dropLocation": "Airport"
  },
  {
    "userId": 2,
    "pickupLocation": "Mall",
    "dropLocation": "Hotel"
  },
  {
    "userId": 3,
    "pickupLocation": "Station",
    "dropLocation": "Home"
  }
]
```

---

## Tips & Best Practices

### 1. **Use Variables**

Create Postman environment variables:

- `base_url`: `http://localhost:8080`
- `user_id`: Store after creating user
- `driver_id`: Store after creating driver
- `ride_id`: Store after booking ride

### 2. **Save Responses**

Use Postman's **Tests** tab to auto-save IDs:

```javascript
var jsonData = pm.response.json();
pm.environment.set("user_id", jsonData.id);
```

### 3. **Check Status Codes**

Always verify:

- ✅ 200 OK - Success
- ✅ 201 Created - Resource created
- ✅ 400 Bad Request - Validation error
- ✅ 404 Not Found - Resource not found

### 4. **Test Edge Cases**

- Empty request bodies
- Invalid IDs
- Duplicate operations
- Out-of-order operations

---

## Troubleshooting

### Issue: Connection Refused

**Solution**: Ensure application is running (`mvn spring-boot:run`)

### Issue: 404 Not Found on all endpoints

**Solution**: Check if using correct base URL (`http://localhost:8080`)

### Issue: 500 Internal Server Error

**Solution**:

1. Check application logs
2. Verify database is running
3. Check if tables are created

### Issue: Driver not getting assigned

**Solution**:

1. Verify drivers exist (`GET /drivers`)
2. Check driver availability (`GET /drivers?available=true`)
3. Ensure ride status is REQUESTED

---

## Demo Presentation Flow

Follow this sequence during demo:

1. **Show Postman Collection** - "I've organized all APIs in a collection"
2. **Register User** - POST /users
3. **Register Driver** - POST /drivers
4. **View Resources** - GET /users, GET /drivers
5. **Book Ride** - POST /rides (show auto-calculated fare)
6. **Assign Driver** - PUT /rides/1/assign (explain business logic)
7. **Check Driver Status** - GET /drivers (show driver is now busy)
8. **Complete Ride** - PUT /rides/1/complete
9. **Check Driver Again** - GET /drivers (show driver is available)
10. **Show Error Handling** - Try invalid operations

---

## Additional Resources

- **API Documentation**: See README.md
- **Source Code**: Check controller classes
- **Business Logic**: Review service classes
- **Exception Handling**: See GlobalExceptionHandler.java

---

**Ready to Test!** 🚀

Import the collection and start testing your APIs!
