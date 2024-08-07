package org.dzu.system.service;

import org.dzu.system.domain.InvoiceIn;

import java.util.List;

/**
 * 发票购入信息Service接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface IInvoiceInService 
{
    /**
     * 查询发票购入信息
     * 
     * @param id 发票购入信息主键
     * @return 发票购入信息
     */
    public InvoiceIn selectInvoiceInById(Long id);

    /**
     * 查询发票购入信息列表
     * 
     * @param invoiceIn 发票购入信息
     * @return 发票购入信息集合
     */
    public List<InvoiceIn> selectInvoiceInList(InvoiceIn invoiceIn);

    /**
     * 新增发票购入信息
     * 
     * @param invoiceIn 发票购入信息
     * @return 结果
     */
    public int insertInvoiceIn(InvoiceIn invoiceIn);

    /**
     * 修改发票购入信息
     * 
     * @param invoiceIn 发票购入信息
     * @return 结果
     */
    public int updateInvoiceIn(InvoiceIn invoiceIn);

    /**
     * 批量删除发票购入信息
     * 
     * @param ids 需要删除的发票购入信息主键集合
     * @return 结果
     */
    public int deleteInvoiceInByIds(Long[] ids);

}
