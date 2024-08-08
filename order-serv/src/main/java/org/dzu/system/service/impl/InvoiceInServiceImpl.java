package org.dzu.system.service.impl;

import org.dzu.common.constant.DelConstants;
import org.dzu.common.constant.YesOrNoConstants;
import org.dzu.common.enums.TableName;
import org.dzu.common.exception.ServiceException;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.StringUtils;
import org.dzu.system.domain.Company;
import org.dzu.system.domain.GoodsOrder;
import org.dzu.system.domain.InvoiceIn;
import org.dzu.system.mapper.InvoiceInMapper;
import org.dzu.system.service.ICompanyService;
import org.dzu.system.service.IGoodsOrderService;
import org.dzu.system.service.IInvoiceInService;
import org.dzu.system.service.IPaymentApplyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 发票购入信息Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class InvoiceInServiceImpl implements IInvoiceInService {
    @Autowired
    private InvoiceInMapper invoiceInMapper;

    @Autowired
    private ICompanyService companyService;

    @Autowired
    private IPaymentApplyService paymentApplyService;

    @Autowired
    private IGoodsOrderService goodsOrderService;

    /**
     * 查询发票购入信息
     *
     * @param id 发票购入信息主键
     * @return 发票购入信息
     */
    @Override
    public InvoiceIn selectInvoiceInById(Long id) {
        return invoiceInMapper.selectInvoiceInById(id);
    }

    /**
     * 查询发票购入信息列表
     *
     * @param invoiceIn 发票购入信息
     * @return 发票购入信息
     */
    @Override
    public List<InvoiceIn> selectInvoiceInList(InvoiceIn invoiceIn) {
        return invoiceInMapper.selectInvoiceInList(invoiceIn);
    }

    /**
     * 新增发票购入信息
     *
     * @param invoiceIn 发票购入信息
     * @return 结果
     */
    @Override
    public int insertInvoiceIn(InvoiceIn invoiceIn) {
        // 设置基础信息
        invoiceIn.setAddtime(String.valueOf(DateUtils.getNowDate()));
        invoiceIn.setUserId(SecurityUtils.getUserId());
        invoiceIn.setUserName(SecurityUtils.getUserTruename());
        invoiceIn.setDelFlag(Long.valueOf(DelConstants.NODEL));

        // 检查客户信息是否存在
        Company company = companyService.selectCompanyById(invoiceIn.getCompanyID());
        if (StringUtils.isNull(company)) {
            // 搜索不到客户信息
            throw new ServiceException("搜索不到客户信息,请刷新后重试");
        }

        // 判读是否为订单票点
        if (invoiceIn.getIsOrderTax() != YesOrNoConstants.NO_num) {
            // 是订单票点，就去搜索对应数据，保证订单存在
            GoodsOrder goodsOrder = goodsOrderService.selectGoodsOrderById(invoiceIn.getIsOrderTax());
            if(StringUtils.isNull(goodsOrder)){
                // 搜索不到订单信息
                throw new ServiceException("被标记为订单票点，但搜索不到订单信息,请刷新后重试");
            }
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
    public int updateInvoiceIn(InvoiceIn invoiceIn) {
        // 先获取对应的申请记录
        boolean isAudit = paymentApplyService.checkExist(TableName.INVOICE_IN.get(), invoiceIn.getId());

        if (isAudit) {
            // 已经存在正在审核流程或者审核通过，本信息不允许修改或删除
            throw new ServiceException("本信息已递交付款申请,已进入审核流程，不允许删除");
        }

        // 判读是否为订单票点
        if (invoiceIn.getIsOrderTax() != YesOrNoConstants.NO_num) {
            // 是订单票点，就去搜索对应数据，保证订单存在
            GoodsOrder goodsOrder = goodsOrderService.selectGoodsOrderById(invoiceIn.getIsOrderTax());
            if(StringUtils.isNull(goodsOrder)){
                // 搜索不到订单信息
                throw new ServiceException("被标记为订单票点，但搜索不到订单信息,请刷新后重试");
            }
        }

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
    public int deleteInvoiceInByIds(Long[] ids) {
        // 检查对应的申请记录
        for (Long id : ids) {
            if (paymentApplyService.checkExist(TableName.INVOICE_IN.get(), id)) {
                // 已经存在正在审核流程或者审核通过，本信息不允许修改或删除
                throw new ServiceException("本信息已递交付款申请,已进入审核流程，不允许删除");
            }
        }
        return invoiceInMapper.deleteInvoiceInByIds(ids);
    }


}
