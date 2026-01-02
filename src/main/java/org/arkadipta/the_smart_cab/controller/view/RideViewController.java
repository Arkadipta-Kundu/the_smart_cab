package org.arkadipta.the_smart_cab.controller.view;

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
    public String showBookRideForm(Model model) {
        model.addAttribute("users", userService.getAllUsers());
        model.addAttribute("locations", locationService.getAllLocations());
        return "ride/book-ride";
    }

    // Book a ride using location codes
    @PostMapping("/book")
    public String bookRide(@RequestParam Long userId,
            @RequestParam Integer pickupLocationCode,
            @RequestParam Integer dropLocationCode) {
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

    // Complete ride
    @GetMapping("/{id}/complete")
    public String completeRide(@PathVariable Long id) {
        rideService.completeRide(id);
        return "redirect:/view/rides";
    }
}
