package org.dzu0434.orderbackend.exception.user;


import org.dzu0434.orderbackend.exception.base.BaseException;

/**
 * 用户信息异常类
 * 
 * @author ml
 */
public class UserException extends BaseException
{
    private static final long serialVersionUID = 1L;

    public UserException(String code, Object[] args)
    {
        super("user", code, args, null);
    }
}
