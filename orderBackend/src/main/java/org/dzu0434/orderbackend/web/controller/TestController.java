package org.dzu0434.orderbackend.web.controller;


import org.dzu0434.orderbackend.domain.model.LoginUser;
import org.springframework.cache.annotation.CachePut;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/test")
public class TestController {


    @GetMapping
    @Cacheable(cacheNames = "Test")
    public String hello(){
        return "Hello";
    }

    @Cacheable(cacheNames = "Test")
    @GetMapping("/test")
    public String hello2(@RequestBody String str){
        System.out.println("执行方法体，参数为:"+str);
        return "Hello2";
    }
}
