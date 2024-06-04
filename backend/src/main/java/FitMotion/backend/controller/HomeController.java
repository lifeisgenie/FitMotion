package FitMotion.backend.controller;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/user")
public class HomeController {

    @GetMapping("/index")
    public String home() {

        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        return "index"+username;
    }
}
