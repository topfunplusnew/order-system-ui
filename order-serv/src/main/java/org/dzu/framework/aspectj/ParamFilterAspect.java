package org.dzu.framework.aspectj;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.dzu.common.core.domain.model.LoginUser;
import org.dzu.common.exception.ServiceException;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.reflect.ReflectUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicBoolean;

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
    public void controllerMethods() {
    }

    @Around("controllerMethods()")
    public Object filterParams(ProceedingJoinPoint joinPoint) throws Throwable {
        Object[] args = joinPoint.getArgs();
        AtomicBoolean flag = new AtomicBoolean(false);
        IllegalParameters.parallelStream().forEach(
                s -> {
                    Arrays.stream(args).forEach(
                            arg -> {
                                if (ReflectUtils.invokeGetter(arg, s) != null) {
                                    flag.set(true);
                                }
                            }
                    );
                }
        );
        if (flag.get()) {
            throw new ServiceException("非法操作！已经记录你的ip和对应操作");
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
            if (IllegalParameters.contains(s)) {
                o = null;
            }
        });

        result = objectMapper.convertValue(resultMap, result.getClass());
    }

    /**
     * 是否过滤
     */
    private boolean desensitization() {
        try {
            LoginUser securityUser = SecurityUtils.getLoginUser();
            // 管理员不过滤
            return !securityUser.getUser().isAdmin();
        } catch (Exception e) {
            return true;
        }
    }
}
