package org.dzu0434.orderbackend;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.cache.annotation.EnableCaching;

/**
 * 启动程序
 * 
 * @author ml
 */

// 排除数据源自动配置
@SpringBootApplication(exclude = DataSourceAutoConfiguration.class)
public class OrderBackendApplication
{
    public static void main(String[] args)
    {

        SpringApplication.run(OrderBackendApplication.class, args);

        System.out.println("订单管理系统启动成功!");
    }
}
