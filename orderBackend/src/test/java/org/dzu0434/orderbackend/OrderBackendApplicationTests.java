package org.dzu0434.orderbackend;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class OrderBackendApplicationTests {


    private BCryptPasswordEncoder bCryptPasswordEncoder= new BCryptPasswordEncoder();

    @Test
    public void contextLoads() {
        System.out.println("hello");
    }

    @Test
    public void TestBadCredentials(){
        String[] passwords = {"password1", "password2", "password3"};

        for (String password : passwords) {
            String encodedPassword = bCryptPasswordEncoder.encode(password);
            System.out.println(encodedPassword);
            System.out.println(bCryptPasswordEncoder.matches(password, encodedPassword));
            System.out.println("=============");
        }

    }

}
