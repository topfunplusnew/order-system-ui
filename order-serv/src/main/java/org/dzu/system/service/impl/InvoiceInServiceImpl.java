package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.InvoiceInMapper;
import org.dzu.system.domain.InvoiceIn;
import org.dzu.system.service.IInvoiceInService;
 
import org.dzu.common.constant.DelConstants;
/**
 * 发票购入信息Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class InvoiceInServiceImpl implements IInvoiceInService
{
    @Autowired
    private InvoiceInMapper invoiceInMapper;

    /**
     * 查询发票购入信息
     *
     * @param id 发票购入信息主键
     * @return 发票购入信息
     */
    @Override
    public InvoiceIn selectInvoiceInById(Long id)
    {
        return invoiceInMapper.selectInvoiceInById(id);
    }

    /**
     * 查询发票购入信息列表
     *
     * @param invoiceIn 发票购入信息
     * @return 发票购入信息
     */
    @Override
    public List<InvoiceIn> selectInvoiceInList(InvoiceIn invoiceIn)
    {
        return invoiceInMapper.selectInvoiceInList(invoiceIn);
    }

    /**
     * 新增发票购入信息
     *
     * @param invoiceIn 发票购入信息
     * @return 结果
     */
    @Override
    public int insertInvoiceIn(InvoiceIn invoiceIn)
    {
        invoiceIn.setAddtime(String.valueOf(DateUtils.getNowDate()));
        invoiceIn.setUserId(SecurityUtils.getUserId());
        invoiceIn.setUserName(SecurityUtils.getUserTruename());
        invoiceIn.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return invoiceInMapper.insertInvoiceIn(invoiceIn);
    }

    /**
     * 修改发票购入信息
     * 
     * @param invoiceIn 发票购入信息
     * @return 结果
     */
    @Override
    public int updateInvoiceIn(InvoiceIn invoiceIn)
    {
        invoiceIn.setUserId(SecurityUtils.getUserId());
        invoiceIn.setUserName(SecurityUtils.getUserTruename());
        invoiceIn.setUpdateTime(DateUtils.getNowDate());
        return invoiceInMapper.updateInvoiceIn(invoiceIn);
    }

    /**
     * 批量删除发票购入信息
     * 
     * @param ids 需要删除的发票购入信息主键
     * @return 结果
     */
    @Override
    public int deleteInvoiceInByIds(Long[] ids)
    {
        return invoiceInMapper.deleteInvoiceInByIds(ids);
    }

    /**
     * 删除发票购入信息信息
     * 
     * @param id 发票购入信息主键
     * @return 结果
     */
    @Override
    public int deleteInvoiceInById(Long id)
    {
        return invoiceInMapper.deleteInvoiceInById(id);
    }
}
