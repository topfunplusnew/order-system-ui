package org.dzu.system.domain;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.dzu.common.annotation.Excel;
import org.dzu.common.annotation.Excel.ColumnType;
import org.dzu.common.core.domain.BaseEntity;
import org.hibernate.validator.constraints.Length;

import java.util.Date;

/**
 * 操作日志记录表 oper_log
 * 
 * @author ml
 */
@TableName("sysOperLog")
public class SysOperLog extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 日志主键 */
    @TableField("operId")
    @Excel(name = "操作序号", cellType = ColumnType.NUMERIC)
    private Long operId;

    /** 操作模块 */
    @TableField("title")
    @Excel(name = "操作模块")
    private String title;

    /** 业务类型（0其它 1新增 2修改 3删除） */
    @TableField("businessType")
    @Excel(name = "业务类型", readConverterExp = "0=其它,1=新增,2=修改,3=删除,4=授权,5=导出,6=导入,7=强退,8=生成代码,9=清空数据")
    private Integer businessType;

    /** 业务类型数组 */
    @TableField("businessTypes")
    private Integer[] businessTypes;

    /** 请求方法 */
    @Excel(name = "请求方法")
    @TableField("method")
    @Length(max = 100, message = "请求方法长度不能超过 100 个字符")
    private String method;

    /** 请求方式 */
    @Excel(name = "请求方式")
    @Length(max = 100, message = "请求方式长度不能超过 100 个字符")
    private String requestMethod;

    /** 操作类别（0其它 1后台用户 2手机端用户） */
    @Excel(name = "操作类别", readConverterExp = "0=其它,1=后台用户,2=手机端用户")
    @TableField("operatorType")
    private Integer operatorType;

    /** 操作人员 */
    @Excel(name = "操作人员")
    @TableField("operName")
    private String operName;

    /** 部门名称 */
    @Excel(name = "部门名称")
    @TableField("deptName")
    private String deptName;

    /** 请求url */
    @Excel(name = "请求地址")
    @TableField("operUrl")
    private String operUrl;

    /** 操作地址 */
    @Excel(name = "操作地址")
    @Length(max = 255, message = "操作地址长度不能超过 255 个字符")
    @TableField("operIp")
    private String operIp;

    /** 操作地点 */
    @Excel(name = "操作地点")
    @TableField("operLocation")
    @Length(max = 255, message = "操作地点长度不能超过 255 个字符")
    private String operLocation;

    /** 请求参数 */
    @Excel(name = "请求参数")
    @TableField("operParam")
    private String operParam;

    /** 返回参数 */
    @Excel(name = "返回参数")
    @TableField("jsonResult")
    private String jsonResult;

    /** 操作状态（0正常 1异常） */
    @Excel(name = "状态", readConverterExp = "0=正常,1=异常")
    @TableField("status")
    private Integer status;

    /** 错误消息 */
    @Excel(name = "错误消息")
    @TableField("errorMsg")
    private String errorMsg;

    /** 操作时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @TableField("operTime")
    @Excel(name = "操作时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date operTime;

    /** 消耗时间 */
    @Excel(name = "消耗时间", suffix = "毫秒")
    @TableField("costTime")
    private Long costTime;

    public Long getOperId()
    {
        return operId;
    }

    public void setOperId(Long operId)
    {
        this.operId = operId;
    }

    public String getTitle()
    {
        return title;
    }

    public void setTitle(String title)
    {
        this.title = title;
    }

    public Integer getBusinessType()
    {
        return businessType;
    }

    public void setBusinessType(Integer businessType)
    {
        this.businessType = businessType;
    }

    public Integer[] getBusinessTypes()
    {
        return businessTypes;
    }

    public void setBusinessTypes(Integer[] businessTypes)
    {
        this.businessTypes = businessTypes;
    }

    public String getMethod()
    {
        return method;
    }

    public void setMethod(String method)
    {
        this.method = method;
    }

    public String getRequestMethod()
    {
        return requestMethod;
    }

    public void setRequestMethod(String requestMethod)
    {
        this.requestMethod = requestMethod;
    }

    public Integer getOperatorType()
    {
        return operatorType;
    }

    public void setOperatorType(Integer operatorType)
    {
        this.operatorType = operatorType;
    }

    public String getOperName()
    {
        return operName;
    }

    public void setOperName(String operName)
    {
        this.operName = operName;
    }

    public String getDeptName()
    {
        return deptName;
    }

    public void setDeptName(String deptName)
    {
        this.deptName = deptName;
    }

    public String getOperUrl()
    {
        return operUrl;
    }

    public void setOperUrl(String operUrl)
    {
        this.operUrl = operUrl;
    }

    public String getOperIp()
    {
        return operIp;
    }

    public void setOperIp(String operIp)
    {
        this.operIp = operIp;
    }

    public String getOperLocation()
    {
        return operLocation;
    }

    public void setOperLocation(String operLocation)
    {
        this.operLocation = operLocation;
    }

    public String getOperParam()
    {
        return operParam;
    }

    public void setOperParam(String operParam)
    {
        this.operParam = operParam;
    }

    public String getJsonResult()
    {
        return jsonResult;
    }

    public void setJsonResult(String jsonResult)
    {
        this.jsonResult = jsonResult;
    }

    public Integer getStatus()
    {
        return status;
    }

    public void setStatus(Integer status)
    {
        this.status = status;
    }

    public String getErrorMsg()
    {
        return errorMsg;
    }

    public void setErrorMsg(String errorMsg)
    {
        this.errorMsg = errorMsg;
    }

    public Date getOperTime()
    {
        return operTime;
    }

    public void setOperTime(Date operTime)
    {
        this.operTime = operTime;
    }

    public Long getCostTime()
    {
        return costTime;
    }

    public void setCostTime(Long costTime)
    {
        this.costTime = costTime;
    }
}
