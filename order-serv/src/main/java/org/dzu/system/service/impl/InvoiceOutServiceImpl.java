package org.dzu.system.service.impl;

import org.dzu.common.constant.DelConstants;
import org.dzu.common.constant.YesOrNoConstants;
import org.dzu.common.exception.ServiceException;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.StringUtils;
import org.dzu.system.domain.GoodsOrder;
import org.dzu.system.domain.InvoiceOut;
import org.dzu.system.mapper.InvoiceOutMapper;
import org.dzu.system.service.IGoodsOrderService;
import org.dzu.system.service.IInvoiceOutService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
/**
 * 发票卖出信息Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class InvoiceOutServiceImpl implements IInvoiceOutService
{
    @Autowired
    private InvoiceOutMapper invoiceOutMapper;

    @Autowired
    private IGoodsOrderService goodsOrderService;
    /**
     * 查询发票卖出信息
     *
     * @param id 发票卖出信息主键
     * @return 发票卖出信息
     */
    @Override
    public InvoiceOut selectInvoiceOutById(Long id)
    {
        return invoiceOutMapper.selectInvoiceOutById(id);
    }

    /**
     * 查询发票卖出信息列表
     *
     * @param invoiceOut 发票卖出信息
     * @return 发票卖出信息
     */
    @Override
    public List<InvoiceOut> selectInvoiceOutList(InvoiceOut invoiceOut)
    {
        return invoiceOutMapper.selectInvoiceOutList(invoiceOut);
    }

    /**
     * 新增发票卖出信息
     *
     * @param invoiceOut 发票卖出信息
     * @return 结果
     */
    @Override
    public int insertInvoiceOut(InvoiceOut invoiceOut)
    {
        // 设置基础信息
        invoiceOut.setAddtime(String.valueOf(DateUtils.getNowDate()));
        invoiceOut.setUserId(SecurityUtils.getUserId());
        invoiceOut.setUserName(SecurityUtils.getUserTruename());
        invoiceOut.setDelFlag(Long.valueOf(DelConstants.NODEL));

        // 如果是订单票点需要搜索订单数据检查金额是否合法
        if(invoiceOut.getIsOrderTax()!= YesOrNoConstants.NO_num){
            GoodsOrder goodsOrder = goodsOrderService.selectGoodsOrderById(invoiceOut.getIsOrderTax());
            if(StringUtils.isNull(goodsOrder)){
                throw new ServiceException("被标记为订单票点,但订单数据不存在,请刷新后重试");
            }
        }
        return invoiceOutMapper.insertInvoiceOut(invoiceOut);

    }

    /**
     * 修改发票卖出信息
     * 
     * @param invoiceOut 发票卖出信息
     * @return 结果
     */
    @Override
    public int updateInvoiceOut(InvoiceOut invoiceOut)
    {

        // 如果是订单票点需要搜索订单数据检查金额是否合法
        if(invoiceOut.getIsOrderTax()!= YesOrNoConstants.NO_num){
            GoodsOrder goodsOrder = goodsOrderService.selectGoodsOrderById(invoiceOut.getIsOrderTax());
            if(StringUtils.isNull(goodsOrder)){
                throw new ServiceException("被标记为订单票点,但订单数据不存在,请刷新后重试");
            }
        }

        invoiceOut.setUpdateTime(DateUtils.getNowDate());
        return invoiceOutMapper.updateInvoiceOut(invoiceOut);
    }

    /**
     * 批量删除发票卖出信息
     * 
     * @param ids 需要删除的发票卖出信息主键
     * @return 结果
     */
    @Override
    public int deleteInvoiceOutByIds(Long[] ids)
    {
        return invoiceOutMapper.deleteInvoiceOutByIds(ids);
    }

    /**
     * 删除发票卖出信息信息
     * 
     * @param id 发票卖出信息主键
     * @return 结果
     */
    @Override
    public int deleteInvoiceOutById(Long id)
    {
        return invoiceOutMapper.deleteInvoiceOutById(id);
    }
}
