package org.arkadipta.the_smart_cab.controller.view;

import org.arkadipta.the_smart_cab.entity.User;
import org.arkadipta.the_smart_cab.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/view/users")
public class UserViewController {

    @Autowired
    private UserService userService;

    // Show add user form
    @GetMapping("/new")
    public String showAddUserForm(Model model) {
        model.addAttribute("user", new User());
        return "user/add-user";
    }

    // Save user
    @PostMapping("/save")
    public String saveUser(@ModelAttribute User user) {
        userService.registerUser(user);
        return "redirect:/view/users";
    }

    // List all users
    @GetMapping
    public String listUsers(Model model) {
        model.addAttribute("users", userService.getAllUsers());
        return "user/user-list";
    }
}
