package org.dzu0434.orderbackend.exception.user;

/**
 * 黑名单IP异常类
 * 
 * @author ml
 */
public class BlackListException extends UserException
{
    private static final long serialVersionUID = 1L;

    public BlackListException()
    {
        super("login.blocked", null);
    }
}
