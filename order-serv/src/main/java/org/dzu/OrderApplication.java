package org.dzu;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;

/**
 * 启动程序
 * 
 * @author ml
 */
@SpringBootApplication(exclude = { DataSourceAutoConfiguration.class })
public class OrderApplication
{
    public static void main(String[] args)
    {
        // System.setProperty("spring.devtools.restart.enabled", "false");
        SpringApplication.run(OrderApplication.class, args);
        System.out.println("+------------------+");
        System.out.println("|-订单管理系统启动成功-|");
        System.out.println("+------------------+");
    }
}
