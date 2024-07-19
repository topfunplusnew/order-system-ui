package org.dzu.common.Validator;
import org.dzu.common.annotation.DecimalMaxDigits;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import java.math.BigDecimal;
// 自定义注解，小数点后最多六位
public class DecimalMaxValidator implements ConstraintValidator<DecimalMaxDigits, Float> {

    @Override
    public void initialize(DecimalMaxDigits constraintAnnotation) {
    }

    @Override
    public boolean isValid(Float value, ConstraintValidatorContext context) {
        if (value == null) {
            return true; // null 值不进行验证
        }
        BigDecimal bigDecimal = BigDecimal.valueOf(value);
        int scale = bigDecimal.scale();
        return scale <= 6;
    }
}