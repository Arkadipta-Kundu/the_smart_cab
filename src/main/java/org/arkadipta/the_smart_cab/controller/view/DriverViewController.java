package org.arkadipta.the_smart_cab.controller.view;

import org.arkadipta.the_smart_cab.entity.Driver;
import org.arkadipta.the_smart_cab.service.DriverService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/view/drivers")
public class DriverViewController {

    @Autowired
    private DriverService driverService;

    // Show add driver form
    @GetMapping("/new")
    public String showAddDriverForm(Model model) {
        model.addAttribute("driver", new Driver());
        return "driver/add-driver";
    }

    // Save driver
    @PostMapping("/save")
    public String saveDriver(@ModelAttribute Driver driver) {
        // Set default availability to true
        if (driver.getAvailable() == null) {
            driver.setAvailable(true);
        }
        driverService.registerDriver(driver);
        return "redirect:/view/drivers";
    }

    // List all drivers
    @GetMapping
    public String listDrivers(Model model) {
        model.addAttribute("drivers", driverService.getAllDrivers());
        return "driver/driver-list";
    }

    // Toggle driver availability
    @GetMapping("/{id}/toggle-availability")
    public String toggleAvailability(@PathVariable Long id) {
        Driver driver = driverService.updateAvailability(id, null);
        // Toggle current status
        Boolean newStatus = !driver.getAvailable();
        driverService.updateAvailability(id, newStatus);
        return "redirect:/view/drivers";
    }
}
