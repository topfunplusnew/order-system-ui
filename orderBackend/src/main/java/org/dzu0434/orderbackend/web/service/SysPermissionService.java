package org.dzu0434.orderbackend.web.service;


import org.dzu0434.orderbackend.domain.entity.SysRole;
import org.dzu0434.orderbackend.domain.entity.SysUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * 用户权限处理
 * 
 * @author ml
 */
@Component
public class SysPermissionService
{

    /**
     * 获取角色数据权限
     * 
     * @param user 用户信息
     * @return 角色权限信息
     */
    public Set<String> getRolePermission(SysUser user)
    {
        Set<String> roles = new HashSet<String>();
        // 管理员拥有所有权限
        if (user.isAdmin())
        {
            roles.add("admin");
        }
        else
        {
//            roles.addAll(roleService.selectRolePermissionByUserId(user.getUserId()));
            roles.addAll(null);
        }
        return roles;
    }

    /**
     * 获取菜单数据权限
     * 
     * @param user 用户信息
     * @return 菜单权限信息
     */
    public Set<String> getMenuPermission(SysUser user)
    {
        Set<String> perms = new HashSet<String>();
        // 管理员拥有所有权限
        if (user.isAdmin())
        {
            perms.add("*:*:*");
        }
        else
        {
            List<SysRole> roles = user.getRoles();
            if (!CollectionUtils.isEmpty(roles))
            {
                // 多角色设置permissions属性，以便数据权限匹配权限
                for (SysRole role : roles)
                {
//                    Set<String> rolePerms = menuService.selectMenuPermsByRoleId(role.getRoleId());
                    Set<String> rolePerms = null;
                    role.setPermissions(rolePerms);
                    perms.addAll(rolePerms);
                }
            }
            else
            {
                // 通过角色id查询权限
                perms.addAll(null);
            }
        }
        return perms;
    }
}
