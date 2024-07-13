package org.dzu0434.orderbackend.web.controller;


import org.dzu0434.orderbackend.constant.Constants;
import org.dzu0434.orderbackend.domain.AjaxResult;
import org.dzu0434.orderbackend.domain.model.LoginBody;
import org.dzu0434.orderbackend.utils.uuid.UUID;
import org.dzu0434.orderbackend.web.service.SysLoginService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.Set;

/**
 * 登录验证
 * 
 * @author ml
 */
@RestController
public class SysLoginController
{
    @Autowired
    private SysLoginService sysLoginService;

    /**
     * 登录方法
     * 
     * @param loginBody 登录信息
     * @return 结果
     */
    @PostMapping("/login")
    public AjaxResult login(@RequestBody LoginBody loginBody)
    {
        AjaxResult ajax = AjaxResult.success();

        // 生成令牌 TODO : 如果用JWT的话，这里下发令牌
        String token = sysLoginService.login(loginBody.getUsername(), loginBody.getPassword(), loginBody.getCode(), loginBody.getUuid());
        ajax.put(Constants.TOKEN, token);
        return ajax;
    }



}
