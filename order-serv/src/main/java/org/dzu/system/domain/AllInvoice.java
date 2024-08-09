package org.dzu.system.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class AllInvoice {

    /** 主键ID */
    private Integer id;

    /** 开票日期 */
    private String invoiceDate;

    /** 我方开票税务主体 */
    private String invoiceObject;

    /** 过账金额 */
    private Double invoiceAmount;

    /** 公司类别 */
    private String companyType;

    /** 供应商名称 */
    private String companyName;

    /** 供应商ID */
    private Integer companyID;

    /** 客户开票名称 */
    private String invoiceCompanyName;

    /** 票点 */
    private Double ticketPoint;

    /** 票点金额 */
    private Double ticketPointAmount;

    /** 是否订单对应票点 */
    private Integer isOrderTax;

    /** 供应商名称（在某些表中为NULL） */
    private String supplier;

    /** 供应商ID（在某些表中为NULL） */
    private Integer supplierID;

    /** 客户名称（在某些表中为NULL） */
    private String customer;

    /** 客户ID（在某些表中为NULL） */
    private Integer customerID;

    /** 备注 */
    private String comments;

    /** 添加时间 */
    private String addtime;

    /** 操作人员ID */
    private Integer userId;

    /** 操作人员姓名 */
    private String userName;

    /** 更新时间 */
    private Date updateTime;

    /** 删除标记 */
    private Integer delFlag;

    /** 采购发票金额 */
    private Double purchaseInvoiceAmount;

    /** 票点成本（点数） */
    private Double ticketPointCost;

    /** 票点成本（金额） */
    private Double ticketPointCostAmount;

    /** 票点收入（点数） */
    private Double ticketPointIncome;

    /** 票点收入（金额） */
    private Double ticketPointIncomeAmount;

    /** 票点差额 */
    private Double ticketPointDifference;

    /** 表名 */
    private String tableName;

    /** 开始时间（用于时间段搜索） */
    private String startDate;

    /** 结束时间（用于时间段搜索） */
    private String endDate;

    /** 客户/供应商搜索值 */
    private String searchCompamyName;

    /** 开票单位搜索值 */
    private String searchInvoiceCompanyName;
//    g.allPayments,
//    g.orderDate,

    /** 总货款 */
    private Double allPayments;

    /** 实际开票日期 */
    private String orderDate;
}
