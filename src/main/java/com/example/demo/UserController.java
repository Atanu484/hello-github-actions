package com.example.demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class UserController {
    @GetMapping
    public String demo() {
        return "Hello World! This is a demo yrdbjhvgdgjgdgddgghjbdrjgjfsfssfggfdvdsggdssvfbfhgddgdsdgsgdsdgsdsdvvdsgeegegsdg";
    }
}
