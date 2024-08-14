package org.dzu.system.domain.vo;

import lombok.Data;
import org.dzu.common.annotation.DecimalMaxDigits;
import org.hibernate.validator.constraints.Length;

@Data
public class TranseferMoney {
    @Length(max = 50, message = "转出银行账号长度不能超过50个字符")
    private String fromBankNo;
    @Length(max = 50, message = "转入银行账号长度不能超过50个字符")
    private String toBankNo;
    @DecimalMaxDigits
    private Double money;
}
