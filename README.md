# 🚕 Smart Cab Service

A Spring Boot MVC application for managing cab bookings with automatic driver assignment.

## Project Overview

The Smart Cab Service is a complete cab booking system built with Spring Boot, JPA, PostgreSQL, and JSP. It demonstrates core Spring Boot concepts including dependency injection, MVC architecture, JPA/Hibernate ORM, exception handling, and server-side rendering with JSP.

## Technology Stack

- **Backend Framework**: Spring Boot 4.0.1
- **Language**: Java 21
- **Database**: PostgreSQL
- **ORM**: Hibernate/JPA
- **View Layer**: JSP with JSTL
- **Build Tool**: Maven

## Project Structure

```
src/main/java/org/arkadipta/the_smart_cab/
├── controller/
│   ├── UserController.java         # REST API for users
│   ├── DriverController.java       # REST API for drivers
│   ├── RideController.java         # REST API for rides
│   └── view/
│       ├── HomeController.java     # JSP homepage
│       ├── UserViewController.java # User UI
│       ├── DriverViewController.java # Driver UI
│       └── RideViewController.java # Ride UI
├── service/
│   ├── UserService.java
│   ├── DriverService.java
│   └── RideService.java
├── repository/
│   ├── UserRepository.java
│   ├── DriverRepository.java
│   └── RideRepository.java
├── entity/
│   ├── User.java
│   ├── Driver.java
│   ├── Ride.java
│   └── RideStatus.java
├── exception/
│   ├── UserNotFoundException.java
│   ├── DriverNotFoundException.java
│   ├── RideNotFoundException.java
│   ├── DriverNotAvailableException.java
│   ├── InvalidRideStatusException.java
│   └── GlobalExceptionHandler.java
└── config/
    └── DataInitializer.java
```

## Core Modules

### 1. User Module

**Purpose**: Manage customer registrations

**Entities**:

- id (Long)
- name (String)
- phone (String)
- email (String)

**Features**:

- Register new user
- View all users
- Get user by ID

### 2. Driver Module

**Purpose**: Manage driver registrations and availability

**Entities**:

- id (Long)
- name (String)
- phone (String)
- vehicleNumber (String)
- available (Boolean)

**Features**:

- Register new driver
- View all drivers
- Filter available drivers
- Update driver availability

### 3. Ride Module

**Purpose**: Core ride booking and management

**Entities**:

- id (Long)
- pickupLocation (String)
- dropLocation (String)
- status (RideStatus: REQUESTED, ASSIGNED, COMPLETED, CANCELLED)
- userId (Long)
- driverId (Long)
- fare (Double)

**Features**:

- Book ride (status = REQUESTED)
- Assign first available driver
- Complete ride
- Automatic fare calculation

## Business Logic Flow

### Ride Lifecycle

```
1. USER BOOKS RIDE
   ↓
   Status: REQUESTED
   Driver: null

2. SYSTEM ASSIGNS DRIVER
   ↓
   Find first available driver
   Status: ASSIGNED
   Driver: marked unavailable

3. RIDE COMPLETED
   ↓
   Status: COMPLETED
   Driver: marked available again
```

### Fare Calculation (Simple Logic)

```java
Base Fare = ₹50
Total Fare = Base + (pickup.length + drop.length) × ₹5
```

**Example**:

- Pickup: "Downtown" (8 chars)
- Drop: "Airport" (7 chars)
- **Fare**: 50 + (8 + 7) × 5 = **₹125**

## REST API Endpoints

### User APIs

```
POST   /users              - Register user
GET    /users              - Get all users
GET    /users/{id}         - Get user by ID
```

### Driver APIs

```
POST   /drivers                        - Register driver
GET    /drivers                        - Get all drivers
GET    /drivers?available=true         - Get available drivers
PUT    /drivers/{id}/availability      - Update availability
```

### Ride APIs

```
POST   /rides                 - Book ride
GET    /rides                 - Get all rides
GET    /rides/{id}            - Get ride by ID
PUT    /rides/{id}/assign     - Assign driver
PUT    /rides/{id}/complete   - Complete ride
```

## Web UI (JSP Pages)

### Homepage

**URL**: `http://localhost:8080/`

Navigation hub with links to all features.

### User Pages

- `/view/users/new` - Register new user
- `/view/users` - View all users

### Driver Pages

- `/view/drivers/new` - Register new driver
- `/view/drivers` - View all drivers (with availability toggle)

### Ride Pages

- `/view/rides/new` - Book a ride
- `/view/rides` - View all rides (with assign/complete actions)

## Database Configuration

**File**: `src/main/resources/application.properties`

```properties
# PostgreSQL Configuration
spring.datasource.url=jdbc:postgresql://localhost:5432/smartcabdb
spring.datasource.username=postgres
spring.datasource.password=0000

# JPA Configuration
spring.jpa.hibernate.ddl-auto=create-drop
spring.jpa.show-sql=true

# JSP Configuration
spring.mvc.view.prefix=/WEB-INF/views/
spring.mvc.view.suffix=.jsp
```

## Exception Handling

**Global Exception Handler** (`@RestControllerAdvice`)

Returns structured JSON responses:

```json
{
  "timestamp": "2026-01-02T10:30:00",
  "status": 404,
  "error": "Not Found",
  "message": "User not found with id: 1"
}
```

**Custom Exceptions**:

- `UserNotFoundException` - 404
- `DriverNotFoundException` - 404
- `RideNotFoundException` - 404
- `DriverNotAvailableException` - 400
- `InvalidRideStatusException` - 400

## Setup Instructions

### Prerequisites

1. Java 21
2. Maven
3. PostgreSQL
4. IDE (IntelliJ IDEA / Eclipse / VS Code)

### Database Setup

```sql
CREATE DATABASE smartcabdb;
```

### Run Application

```bash
mvn clean install
mvn spring-boot:run
```

### Access Application

- **Web UI**: http://localhost:8080/
- **REST APIs**: http://localhost:8080/users, /drivers, /rides

## Sample Data

The application automatically loads sample data on startup:

**Users**: 3 customers
**Drivers**: 3 drivers (2 available, 1 busy)
**Rides**: 3 sample rides (COMPLETED, ASSIGNED, REQUESTED)

## Key Interview Questions & Answers

### 1. Why Spring Boot?

- Auto-configuration reduces boilerplate
- Embedded server (Tomcat)
- Easy dependency management
- Production-ready features

### 2. How does Dependency Injection work here?

- `@Autowired` injects dependencies
- Controller → Service → Repository
- Spring manages object lifecycle
- Promotes loose coupling

### 3. Explain Controller → Service → Repository pattern

- **Controller**: Handles HTTP requests
- **Service**: Business logic
- **Repository**: Database operations
- Clean separation of concerns

### 4. How does ride assignment work?

1. User books ride → Status: REQUESTED
2. System finds first available driver
3. Assigns driver → Status: ASSIGNED
4. Driver marked unavailable
5. Ride completes → Driver available again

### 5. How are DB tables created?

- JPA annotations (`@Entity`, `@Table`, `@Column`)
- Hibernate auto-creates tables
- `ddl-auto=create-drop` regenerates schema on restart

### 6. How does exception handling work?

- `@RestControllerAdvice` for global handling
- Custom exceptions for specific errors
- Returns structured error responses
- HTTP status codes: 404, 400, 500

## Future Enhancements (Optional)

- ✅ Switch H2 → PostgreSQL (Done)
- ⏳ Add basic login (without Spring Security)
- ⏳ Add ride history API by user
- ⏳ Add ride cancellation feature
- ⏳ Add driver ratings

## Author

**Arkadipta Kundu**  
Spring Boot MVC Application

## License

This project is for educational purposes.

---

**Demo Ready**: This project is fully functional and demo-ready for project submission or interview purposes.
