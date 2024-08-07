package org.dzu.system.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.dzu.common.annotation.DecimalMaxDigits;
import org.dzu.common.annotation.Excel;
import org.dzu.common.annotation.FlagOnlyZeroOrOne;
import org.dzu.common.core.domain.BaseEntity;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotNull;

/**
 * 借出款收回信息对象 recoverMoney
 *
 * @author ml
 * @date 2024-07-29
 */
@TableName("recoverMoney")
public class RecoverMoney extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /** id */
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /** 借出款编号（UUID） */
    @Excel(name = "借出款编号")
    @NotNull(message = "缺少借出款编号")
    @Length(max = 50, message = "借出款编号的字符长度不允许超过50")
    @TableField("futuresNO")
    private String futuresNO;

    /** 还款编号（UUID） */
    @Excel(name = "还款编号")
    @Length(max = 50, message = "还款编号的字符长度不允许超过50")
    @TableField("recoverNO")
    private String recoverNO;

    /** 收回金额 */
    @DecimalMaxDigits
    @TableField("moneyAmount")
    private Double moneyAmount;

    /** 收回日期 */
    @Excel(name = "收回日期")
    @NotNull(message = "收回日期不能为空")
    @Length(max = 50, message = "收回日期的字符长度不允许超过50")
    @TableField("recoverDate")
    private String recoverDate;

    /** 收回账户 */
    @Excel(name = "收回账户")
    @Length(max = 80, message = "收回账户的字符长度不允许超过80")
    @TableField("acountsName")
    private String acountsName;

    /** 收回账号 */
    @Excel(name = "收回账号")
    @Length(max = 80, message = "收回账号的字符长度不允许超过80")
    @TableField("bankNo")
    private String bankNo;

    /** 备注 */
    @Excel(name = "备注")
    @Length(max = 200, message = "备注的字符长度不允许超过200")
    @TableField("comments")
    private String comments;

    /** 添加时间 */
    @Excel(name = "添加时间")
    @TableField("addtime")
    private String addtime;

    /** 操作人员ID */
    @Excel(name = "操作人员ID")
    @TableField("userId")
    private Long userId;

    /** 操作人员姓名 */
    @Excel(name = "操作人员姓名")
    @TableField("UserName")
    private String UserName;

    /** 更新时间 */
    @TableField("update_time")
    private String  updateTime;

    /** 删除标记 */
    @FlagOnlyZeroOrOne
    @TableField("delFlag")
    private Long delFlag;

    public void setId(Long id)
    {
        this.id = id;
    }

    public Long getId()
    {
        return id;
    }
    public void setFuturesNO(String futuresNO)
    {
        this.futuresNO = futuresNO;
    }

    public String getFuturesNO()
    {
        return futuresNO;
    }
    public void setRecoverNO(String recoverNO)
    {
        this.recoverNO = recoverNO;
    }

    public String getRecoverNO()
    {
        return recoverNO;
    }
    public void setMoneyAmount(Double moneyAmount)
    {
        this.moneyAmount = moneyAmount;
    }

    public Double getMoneyAmount()
    {
        return moneyAmount;
    }
    public void setRecoverDate(String recoverDate)
    {
        this.recoverDate = recoverDate;
    }

    public String getRecoverDate()
    {
        return recoverDate;
    }
    public void setAcountsName(String acountsName)
    {
        this.acountsName = acountsName;
    }

    public String getAcountsName()
    {
        return acountsName;
    }
    public void setBankNo(String bankNo)
    {
        this.bankNo = bankNo;
    }

    public String getBankNo()
    {
        return bankNo;
    }
    public void setComments(String comments)
    {
        this.comments = comments;
    }

    public String getComments()
    {
        return comments;
    }
    public void setAddtime(String addtime)
    {
        this.addtime = addtime;
    }

    public String getAddtime()
    {
        return addtime;
    }
    public void setUserId(Long userId)
    {
        this.userId = userId;
    }

    public Long getUserId()
    {
        return userId;
    }
    public void setUserName(String UserName)
    {
        this.UserName = UserName;
    }

    public String getUserName()
    {
        return UserName;
    }
    public void setDelFlag(Long delFlag)
    {
        this.delFlag = delFlag;
    }

    public Long getDelFlag()
    {
        return delFlag;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("futuresNO", getFuturesNO())
            .append("recoverNO", getRecoverNO())
            .append("moneyAmount", getMoneyAmount())
            .append("recoverDate", getRecoverDate())
            .append("acountsName", getAcountsName())
            .append("bankNo", getBankNo())
            .append("comments", getComments())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("updateTime", getUpdateTime())
            .append("delFlag", getDelFlag())
            .toString();
    }
}
