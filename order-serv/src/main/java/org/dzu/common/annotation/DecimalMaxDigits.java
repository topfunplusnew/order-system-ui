package org.dzu.common.annotation;

import org.dzu.common.Validator.DecimalMaxValidator;

import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Constraint(validatedBy = DecimalMaxValidator.class)
@Target({ ElementType.FIELD, ElementType.METHOD, ElementType.PARAMETER, ElementType.ANNOTATION_TYPE })
@Retention(RetentionPolicy.RUNTIME)
public @interface DecimalMaxDigits {
    String message() default "小数位数不能超过6位";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
