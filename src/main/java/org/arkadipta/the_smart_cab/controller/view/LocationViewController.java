package org.arkadipta.the_smart_cab.controller.view;

import org.arkadipta.the_smart_cab.entity.Location;
import org.arkadipta.the_smart_cab.service.LocationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/view/locations")
public class LocationViewController {

    @Autowired
    private LocationService locationService;

    // Show add location form
    @GetMapping("/add")
    public String showAddLocationForm() {
        return "location/add-location";
    }

    // Save new location
    @PostMapping("/save")
    public String saveLocation(@RequestParam String name,
            @RequestParam Integer locationCode) {
        Location location = new Location();
        location.setName(name);
        location.setLocationCode(locationCode);
        locationService.saveLocation(location);
        return "redirect:/view/locations/list";
    }

    // Show all locations
    @GetMapping("/list")
    public String listLocations(Model model) {
        List<Location> locations = locationService.getAllLocations();
        model.addAttribute("locations", locations);
        return "location/location-list";
    }

    // Calculate distance
    @GetMapping("/distance")
    public String calculateDistance(@RequestParam Integer pickupCode,
            @RequestParam Integer dropCode,
            Model model) {
        double distance = locationService.calculateDistance(pickupCode, dropCode);

        Location pickup = locationService.getLocationByCode(pickupCode);
        Location drop = locationService.getLocationByCode(dropCode);

        model.addAttribute("pickupLocation", pickup.getName());
        model.addAttribute("dropLocation", drop.getName());
        model.addAttribute("distance", distance);
        model.addAttribute("locations", locationService.getAllLocations());

        return "location/distance-calculator";
    }
}
