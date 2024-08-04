package org.dzu.common.annotation;

import javax.validation.Constraint;
import javax.validation.Payload;
import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Min(value = 0, message = "必须为0或1")
@Max(value = 1, message = "必须为0或1")
@Target({ ElementType.FIELD, ElementType.METHOD, ElementType.PARAMETER, ElementType.ANNOTATION_TYPE })
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = {})
public @interface FlagOnlyZeroOrOne {
    String message() default "违规操作!";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
