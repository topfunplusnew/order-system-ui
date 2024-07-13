package org.dzu0434.orderbackend.web.controller;


import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/test")
public class TestController {


    @GetMapping
    public String hello(){
        return "Hello";
    }

    @GetMapping("/test")
    public String hello2(){
        return "Hello2";
    }
}
