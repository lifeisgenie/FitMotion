package FitMotion.backend.controller;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/user")
// html에서 뭔가를 하면(클라이언트의 요청이 오면) 가장 먼저 받아주는 부분이 컨트롤러.
public class HomeController {

    // 기본 페이지 요청 메소
    @GetMapping("/index")
    public String home() {

        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        return "Welcome to FitMotion"+username;
    }
}
