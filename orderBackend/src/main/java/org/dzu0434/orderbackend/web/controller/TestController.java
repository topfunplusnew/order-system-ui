package org.dzu0434.orderbackend.web.controller;


import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.cache.annotation.Caching;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/test")
public class TestController {


    @GetMapping
    @Cacheable(cacheNames = "Test", key = "#str")
    public String hello(@RequestBody String str) {
        return "Hello";
    }

    @Cacheable(cacheNames = "hello2")
    @GetMapping("/test2")
    public String hello2(@RequestBody String str) {
        System.out.println("缓存未生效，执行方法体，参数为:" + str);
        return "Hello2";
    }

    @Caching(
            cacheable = @Cacheable(cacheNames = "hello3"),
            evict = {
                    @CacheEvict(cacheNames = "hello2", allEntries = true),
                    @CacheEvict(cacheNames = "Test", key = "#str")
            }
    )
    @GetMapping("/test3")
    public String hello3(@RequestBody String str) {
        System.out.println("缓存未生效，执行方法体，参数为:" + str);
        return "Hello2";
    }

    @GetMapping("/test4")
    @Cacheable(cacheNames = "Test", key = "#str")
    public String hello4(@RequestBody String str) {
        System.out.println("缓存未生效，执行方法体，参数为:" + str);
        return "Hello2";
    }

}
