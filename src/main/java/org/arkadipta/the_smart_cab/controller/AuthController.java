package org.arkadipta.the_smart_cab.controller;

import jakarta.servlet.http.HttpSession;
import org.arkadipta.the_smart_cab.entity.Driver;
import org.arkadipta.the_smart_cab.entity.User;
import org.arkadipta.the_smart_cab.service.DriverService;
import org.arkadipta.the_smart_cab.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@Controller
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private UserService userService;

    @Autowired
    private DriverService driverService;

    @GetMapping("/login")
    public String showLoginPage() {
        return "auth/login";
    }

    @PostMapping("/user-login")
    public String userLogin(@RequestParam String email,
            @RequestParam String password,
            HttpSession session,
            Model model) {

        Optional<User> user = userService.findByEmailAndPassword(email, password);

        if (user.isPresent()) {
            session.setAttribute("loggedUser", user.get());
            session.setAttribute("role", "USER");
            return "redirect:/auth/user-dashboard";
        } else {
            model.addAttribute("error", "Invalid email or password");
            return "auth/login";
        }
    }

    @PostMapping("/driver-login")
    public String driverLogin(@RequestParam String phone,
            @RequestParam String password,
            HttpSession session,
            Model model) {

        Optional<Driver> driver = driverService.findByPhoneAndPassword(phone, password);

        if (driver.isPresent()) {
            session.setAttribute("loggedDriver", driver.get());
            session.setAttribute("role", "DRIVER");
            return "redirect:/auth/driver-dashboard";
        } else {
            model.addAttribute("error", "Invalid phone or password");
            return "auth/login";
        }
    }

    @GetMapping("/user-dashboard")
    public String userDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("loggedUser");

        if (user == null) {
            return "redirect:/auth/login";
        }

        model.addAttribute("user", user);
        return "auth/user-dashboard";
    }

    @GetMapping("/driver-dashboard")
    public String driverDashboard(HttpSession session, Model model) {
        Driver driver = (Driver) session.getAttribute("loggedDriver");

        if (driver == null) {
            return "redirect:/auth/login";
        }

        model.addAttribute("driver", driver);
        return "auth/driver-dashboard";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/auth/login";
    }
}
