package org.dzu.framework.aspectj;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.ProceedingJoinPoint;
import org.dzu.common.core.domain.model.LoginUser;
import org.dzu.common.exception.ServiceException;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Aspect
@Component
public class ParamFilterAspect {

    @Value("#{'${order.IllegalParameters}'.split(',')}")
    public List<String> IllegalParameters;
    private final ObjectMapper objectMapper;
    private final HttpServletRequest request;

    public ParamFilterAspect(ObjectMapper objectMapper, HttpServletRequest request) {
        this.objectMapper = objectMapper;
        this.request = request;
    }

    @Pointcut("execution(* org.dzu.system.controller..*(..)) ")
    public void controllerMethods() {}

    @Around("controllerMethods()")
    public Object filterParams(ProceedingJoinPoint joinPoint) throws Throwable {
        Map<String, String[]> paramMap = request.getParameterMap();
        Map<String, String[]> filteredParams = paramMap.entrySet().stream()
                .filter(
                        entry -> IllegalParameters.contains(entry.getKey())
                )
                .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue));

        //  TODO： 没想好怎么处理，打算直接抛出异常
        if(filteredParams.size()>0){
            throw new ServiceException("非法操作!已经记录你的ip和对应操作");
        }
        return joinPoint.proceed();

//        IllegalParameters.stream().forEach(s -> {
//            if(ReflectUtils.invokeGetter(proceed.get(AjaxResult.DATA_TAG),s)!=null){
//                ReflectUtils.invokeSetter(proceed,s,null);
//            }
//        }
//        );
//
//        return proceed;
    }

//    @AfterReturning(pointcut = "controllerMethods()", returning = "result")
    public void modifyResponse(Object result) throws Throwable {

        String json = objectMapper.writeValueAsString(result);
        Map<String, Object> resultMap = objectMapper.readValue(json, Map.class);

        resultMap.forEach((s, o) -> {
            if(IllegalParameters.contains(s)){
                o=null;
            }
        });

        result = objectMapper.convertValue(resultMap, result.getClass());
    }
    /**
     * 是否过滤
     */
    private boolean desensitization()
    {
        try
        {
            LoginUser securityUser = SecurityUtils.getLoginUser();
            // 管理员不过滤
            return !securityUser.getUser().isAdmin();
        }
        catch (Exception e)
        {
            return true;
        }
    }
}
