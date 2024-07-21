package com.ruoyi.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 出差记录对象 businesstrip
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
public class Businesstrip extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** $column.columnComment */
    private Long id;

    /** 出差人员 */
    @Excel(name = "出差人员")
    private String personnel;

    /** 出差时间 */
    @Excel(name = "出差时间")
    private String starttime;

    /** 出发里程拍照 */
    @Excel(name = "出发里程拍照")
    private String startMilesPhoto;

    /** 加油拍照 */
    @Excel(name = "加油拍照")
    private String refuelPhoto;

    /** 出差结束时间 */
    @Excel(name = "出差结束时间")
    private String endtime;

    /** 结束里程拍照 */
    @Excel(name = "结束里程拍照")
    private String endMilesPhoto;

    /** 出差费用拍照 */
    @Excel(name = "出差费用拍照")
    private String feesPhoto;

    /** 是否已报销（0未报销，1已报销） */
    @Excel(name = "是否已报销", readConverterExp = "0=未报销，1已报销")
    private Long isReimburse;

    /** 备注 */
    @Excel(name = "备注")
    private String comments;

    /** 添加时间 */
    @Excel(name = "添加时间")
    private String addtime;

    /** 操作人员ID */
    @Excel(name = "操作人员ID")
    private Long userId;

    /** 操作人员姓名 */
    @Excel(name = "操作人员姓名")
    private String UserName;

    /** 删除标记 */
    @Excel(name = "删除标记")
    private Long delFlag;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }
    public void setPersonnel(String personnel) 
    {
        this.personnel = personnel;
    }

    public String getPersonnel() 
    {
        return personnel;
    }
    public void setStarttime(String starttime) 
    {
        this.starttime = starttime;
    }

    public String getStarttime() 
    {
        return starttime;
    }
    public void setStartMilesPhoto(String startMilesPhoto) 
    {
        this.startMilesPhoto = startMilesPhoto;
    }

    public String getStartMilesPhoto() 
    {
        return startMilesPhoto;
    }
    public void setRefuelPhoto(String refuelPhoto) 
    {
        this.refuelPhoto = refuelPhoto;
    }

    public String getRefuelPhoto() 
    {
        return refuelPhoto;
    }
    public void setEndtime(String endtime) 
    {
        this.endtime = endtime;
    }

    public String getEndtime() 
    {
        return endtime;
    }
    public void setEndMilesPhoto(String endMilesPhoto) 
    {
        this.endMilesPhoto = endMilesPhoto;
    }

    public String getEndMilesPhoto() 
    {
        return endMilesPhoto;
    }
    public void setFeesPhoto(String feesPhoto) 
    {
        this.feesPhoto = feesPhoto;
    }

    public String getFeesPhoto() 
    {
        return feesPhoto;
    }
    public void setIsReimburse(Long isReimburse) 
    {
        this.isReimburse = isReimburse;
    }

    public Long getIsReimburse() 
    {
        return isReimburse;
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
            .append("personnel", getPersonnel())
            .append("starttime", getStarttime())
            .append("startMilesPhoto", getStartMilesPhoto())
            .append("refuelPhoto", getRefuelPhoto())
            .append("endtime", getEndtime())
            .append("endMilesPhoto", getEndMilesPhoto())
            .append("feesPhoto", getFeesPhoto())
            .append("isReimburse", getIsReimburse())
            .append("comments", getComments())
            .append("addtime", getAddtime())
            .append("userId", getUserId())
            .append("UserName", getUserName())
            .append("updateTime", getUpdateTime())
            .append("delFlag", getDelFlag())
            .toString();
    }
}
