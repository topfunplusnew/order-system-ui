package org.dzu.common.Validator;
import org.dzu.common.annotation.DecimalMaxDigits;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import java.math.BigDecimal;
// 自定义注解，小数点后最多六位
public class DecimalMaxValidator implements ConstraintValidator<DecimalMaxDigits, Double> {

    @Override
    public void initialize(DecimalMaxDigits constraintAnnotation) {
    }

    @Override
    public boolean isValid(Double value, ConstraintValidatorContext context) {
        if (value == null) {
            return true; // null 值不进行验证
        }

        BigDecimal bigDecimal = BigDecimal.valueOf(value);
        int scale = bigDecimal.scale();
        int precision = bigDecimal.precision();

        int integerPartLength = precision - scale;

        // 检查小数位数和整数位数
        return scale <= 2 && integerPartLength <= 13;
    }
}