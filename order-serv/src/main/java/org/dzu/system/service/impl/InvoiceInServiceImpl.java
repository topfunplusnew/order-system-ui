package org.dzu.system.service.impl;

import java.util.List;

import org.dzu.common.exception.ServiceException;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.StringUtils;
import org.dzu.system.domain.Company;
import org.dzu.system.service.ICompanyService;
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

    @Autowired
    private ICompanyService companyService;
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
        // 设置基础信息
        invoiceIn.setAddtime(String.valueOf(DateUtils.getNowDate()));
        invoiceIn.setUserId(SecurityUtils.getUserId());
        invoiceIn.setUserName(SecurityUtils.getUserTruename());
        invoiceIn.setDelFlag(Long.valueOf(DelConstants.NODEL));

        // 检查客户信息是否存在
        Company company = companyService.selectCompanyById(invoiceIn.getCompanyID());
        if(StringUtils.isNull(company)){
            // 搜索不到客户信息
            throw new ServiceException("搜索不到客户信息,请刷新后重试");
        }



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
