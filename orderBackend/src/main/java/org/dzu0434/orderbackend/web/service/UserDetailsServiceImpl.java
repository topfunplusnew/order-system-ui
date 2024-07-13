package org.dzu0434.orderbackend.web.service;


import org.dzu0434.orderbackend.domain.entity.SysUser;
import org.dzu0434.orderbackend.domain.model.LoginUser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

/**
 * 用户验证处理
 *
 * @author ml
 */
@Service
public class UserDetailsServiceImpl implements UserDetailsService
{
    private static final Logger log = LoggerFactory.getLogger(UserDetailsServiceImpl.class);


    
    @Autowired
    private SysPasswordService passwordService;

    @Autowired
    private SysPermissionService permissionService;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException
    {
        SysUser user = new SysUser(1L);
        user.setPassword("$2a$10$.ftMd/JBjDveXuZUKhVty./SvSO8DIQdAwKGb1vg006OLwKQZplXC");
        user.setNickName("Adminw");
        user.setUserName("testAdmin");
        user.setDelFlag("F");
        user.setPhonenumber("1223314513445");
        // TODO 返回一个非空的用户。毛磊
        System.out.println("模拟用户生成");
        passwordService.validate(user);
        return createLoginUser(user);
    }

    public UserDetails createLoginUser(SysUser user)
    {
        return new LoginUser(user.getUserId(), user, permissionService.getMenuPermission(user));
    }
}
