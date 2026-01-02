package org.arkadipta.the_smart_cab.controller.view;

import jakarta.servlet.http.HttpSession;
import org.arkadipta.the_smart_cab.entity.Ride;
import org.arkadipta.the_smart_cab.service.DriverService;
import org.arkadipta.the_smart_cab.service.LocationService;
import org.arkadipta.the_smart_cab.service.RideService;
import org.arkadipta.the_smart_cab.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/view/rides")
public class RideViewController {

    @Autowired
    private RideService rideService;

    @Autowired
    private UserService userService;

    @Autowired
    private DriverService driverService;

    @Autowired
    private LocationService locationService;

    // Show book ride form
    @GetMapping("/new")
    public String showBookRideForm(HttpSession session, Model model) {
        // Session guard - only USER role
        String role = (String) session.getAttribute("role");
        if (role == null || !role.equals("USER")) {
            return "redirect:/auth/login";
        }

        model.addAttribute("users", userService.getAllUsers());
        model.addAttribute("locations", locationService.getAllLocations());
        return "ride/book-ride";
    }

    // Book a ride using location codes
    @PostMapping("/book")
    public String bookRide(@RequestParam Long userId,
            @RequestParam Integer pickupLocationCode,
            @RequestParam Integer dropLocationCode,
            HttpSession session) {
        // Session guard - only USER role
        String role = (String) session.getAttribute("role");
        if (role == null || !role.equals("USER")) {
            return "redirect:/auth/login";
        }

        rideService.bookRideWithLocationCodes(pickupLocationCode, dropLocationCode, userId);
        return "redirect:/view/rides";
    }

    // List all rides
    @GetMapping
    public String listRides(Model model) {
        model.addAttribute("rides", rideService.getAllRides());
        model.addAttribute("users", userService.getAllUsers());
        model.addAttribute("drivers", driverService.getAllDrivers());
        return "ride/ride-list";
    }

    // Assign driver to ride
    @GetMapping("/{id}/assign")
    public String assignDriver(@PathVariable Long id) {
        rideService.assignDriver(id);
        return "redirect:/view/rides";
    }

    // User: View ride status
    @GetMapping("/user-status")
    public String userRideStatus(@RequestParam Long userId, HttpSession session, Model model) {
        // Session guard - only USER role
        String role = (String) session.getAttribute("role");
        if (role == null || !role.equals("USER")) {
            return "redirect:/auth/login";
        }

        model.addAttribute("rides", rideService.getRidesByUserId(userId));
        model.addAttribute("drivers", driverService.getAllDrivers());
        return "ride/user-ride-status";
    }

    // Driver: View pending ride requests
    @GetMapping("/driver-requests")
    public String driverRequests(@RequestParam Long driverId, HttpSession session, Model model) {
        // Session guard - only DRIVER role
        String role = (String) session.getAttribute("role");
        if (role == null || !role.equals("DRIVER")) {
            return "redirect:/auth/login";
        }

        model.addAttribute("pendingRides", rideService.getPendingRidesForDriver(driverId));
        model.addAttribute("users", userService.getAllUsers());
        return "ride/driver-requests";
    }

    // Driver: View active ride
    @GetMapping("/active-ride")
    public String activeRide(@RequestParam Long driverId, HttpSession session, Model model) {
        // Session guard - only DRIVER role
        String role = (String) session.getAttribute("role");
        if (role == null || !role.equals("DRIVER")) {
            return "redirect:/auth/login";
        }

        model.addAttribute("activeRide", rideService.getActiveRideForDriver(driverId).orElse(null));
        model.addAttribute("users", userService.getAllUsers());
        return "ride/active-ride";
    }

    // Driver: Accept ride
    @GetMapping("/{id}/accept")
    public String acceptRide(@PathVariable Long id, @RequestParam Long driverId, HttpSession session) {
        // Session guard - only DRIVER role
        String role = (String) session.getAttribute("role");
        if (role == null || !role.equals("DRIVER")) {
            return "redirect:/auth/login";
        }

        rideService.acceptRide(id, driverId);
        return "redirect:/view/rides/active-ride?driverId=" + driverId;
    }

    // Driver: Reject ride
    @GetMapping("/{id}/reject")
    public String rejectRide(@PathVariable Long id, @RequestParam Long driverId, HttpSession session) {
        // Session guard - only DRIVER role
        String role = (String) session.getAttribute("role");
        if (role == null || !role.equals("DRIVER")) {
            return "redirect:/auth/login";
        }

        rideService.rejectRide(id, driverId);
        return "redirect:/view/rides/driver-requests?driverId=" + driverId;
    }

    // Driver: Start ride
    @GetMapping("/{id}/start")
    public String startRide(@PathVariable Long id, @RequestParam Long driverId, HttpSession session) {
        // Session guard - only DRIVER role
        String role = (String) session.getAttribute("role");
        if (role == null || !role.equals("DRIVER")) {
            return "redirect:/auth/login";
        }

        rideService.startRide(id, driverId);
        return "redirect:/view/rides/active-ride?driverId=" + driverId;
    }

    // Driver/Admin: Complete ride
    @GetMapping("/{id}/complete")
    public String completeRide(@PathVariable Long id, @RequestParam Long driverId, HttpSession session) {
        // Session guard - only DRIVER role
        String role = (String) session.getAttribute("role");
        if (role == null || !role.equals("DRIVER")) {
            return "redirect:/auth/login";
        }

        rideService.completeRide(id, driverId);
        return "redirect:/view/rides";
    }

    // User: Cancel ride
    @GetMapping("/{id}/cancel")
    public String cancelRide(@PathVariable Long id, @RequestParam Long userId, HttpSession session) {
        // Session guard - only USER role
        String role = (String) session.getAttribute("role");
        if (role == null || !role.equals("USER")) {
            return "redirect:/auth/login";
        }

        rideService.cancelRide(id, userId);
        return "redirect:/view/rides/user-status?userId=" + userId;
    }
}
