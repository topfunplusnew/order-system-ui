package org.dzu.system.service.impl;

import org.dzu.common.constant.DelConstants;
import org.dzu.common.exception.ServiceException;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.StringUtils;
import org.dzu.system.domain.Company;
import org.dzu.system.domain.GoodsOrder;
import org.dzu.system.domain.InvoiceOther;
import org.dzu.system.mapper.InvoiceOtherMapper;
import org.dzu.system.service.IGoodsOrderService;
import org.dzu.system.service.IInvoiceOtherService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
/**
 * 商家直接给客户开发票Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class InvoiceOtherServiceImpl implements IInvoiceOtherService
{
    @Autowired
    private InvoiceOtherMapper invoiceOtherMapper;

    @Autowired
    private CompanyServiceImpl companyService;

    @Autowired
    private IGoodsOrderService goodsOrderService;
    /**
     * 查询商家直接给客户开发票
     *
     * @param id 商家直接给客户开发票主键
     * @return 商家直接给客户开发票
     */
    @Override
    public InvoiceOther selectInvoiceOtherById(Long id)
    {
        return invoiceOtherMapper.selectInvoiceOtherById(id);
    }

    /**
     * 查询商家直接给客户开发票列表
     *
     * @param invoiceOther 商家直接给客户开发票
     * @return 商家直接给客户开发票
     */
    @Override
    public List<InvoiceOther> selectInvoiceOtherList(InvoiceOther invoiceOther)
    {
        return invoiceOtherMapper.selectInvoiceOtherList(invoiceOther);
    }

    /**
     * 新增商家直接给客户开发票
     *
     * @param invoiceOther 商家直接给客户开发票
     * @return 结果
     */
    @Override
    public int insertInvoiceOther(InvoiceOther invoiceOther)
    {
        // 设置基础信息
        invoiceOther.setAddtime(String.valueOf(DateUtils.getNowDate()));
        invoiceOther.setUserId(SecurityUtils.getUserId());
        invoiceOther.setUserName(SecurityUtils.getUserTruename());
        invoiceOther.setDelFlag(Long.valueOf(DelConstants.NODEL));

        // 确定对应的客户和供应商信息存在
        Company customer = companyService.selectCompanyById(invoiceOther.getCustomerID());
        Company supplier = companyService.selectCompanyById(invoiceOther.getSupplierID());

        if(StringUtils.isNull(customer) || StringUtils.isNull(supplier)){
            throw new ServiceException("对应的客户或着供应商信息不存在,请刷新页面后重试");
        }

        // 搜索对应的订单是否存在
        if(StringUtils.isNotNull(invoiceOther.getOrdersNo())){
            GoodsOrder goodsOrder = goodsOrderService.selectGoodsOrderByOrderNO(invoiceOther.getOrdersNo());
            if(StringUtils.isNull(goodsOrder)){
                throw new ServiceException("对应的订单信息不存在,请刷新页面后重试");
            }
        }
        return invoiceOtherMapper.insertInvoiceOther(invoiceOther);
    }

    /**
     * 修改商家直接给客户开发票
     * 
     * @param invoiceOther 商家直接给客户开发票
     * @return 结果
     */
    @Override
    public int updateInvoiceOther(InvoiceOther invoiceOther)
    {
        // 确定对应的客户和供应商信息存在
        Company customer = companyService.selectCompanyById(invoiceOther.getCustomerID());
        Company supplier = companyService.selectCompanyById(invoiceOther.getSupplierID());

        if(StringUtils.isNull(customer) || StringUtils.isNull(supplier)){
            throw new ServiceException("对应的客户或着供应商信息不存在,请刷新页面后重试");
        }

        // 搜索对应的订单是否存在
        if(StringUtils.isNotNull(invoiceOther.getOrdersNo())){
            GoodsOrder goodsOrder = goodsOrderService.selectGoodsOrderByOrderNO(invoiceOther.getOrdersNo());
            if(StringUtils.isNull(goodsOrder)){
                throw new ServiceException("对应的订单信息不存在,请刷新页面后重试");
            }
        }

        // 设置更新时间
        invoiceOther.setUpdateTime(DateUtils.getNowDate());


        return invoiceOtherMapper.updateInvoiceOther(invoiceOther);
    }

    /**
     * 批量删除商家直接给客户开发票
     * 
     * @param ids 需要删除的商家直接给客户开发票主键
     * @return 结果
     */
    @Override
    public int deleteInvoiceOtherByIds(Long[] ids)
    {
        return invoiceOtherMapper.deleteInvoiceOtherByIds(ids);
    }

    /**
     * 删除商家直接给客户开发票信息
     * 
     * @param id 商家直接给客户开发票主键
     * @return 结果
     */
    @Override
    public int deleteInvoiceOtherById(Long id)
    {
        return invoiceOtherMapper.deleteInvoiceOtherById(id);
    }
}
