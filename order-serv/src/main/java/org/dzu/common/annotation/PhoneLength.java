package org.dzu.common.annotation;

import javax.validation.Constraint;
import javax.validation.Payload;
import javax.validation.constraints.Size;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Size(min = 0, max = 11, message = "电话长度不能超过11个字符")
@Target({ ElementType.FIELD, ElementType.METHOD, ElementType.PARAMETER, ElementType.ANNOTATION_TYPE })
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = {})
public @interface PhoneLength {
    String message() default "电话长度不能超过11个字符!";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
