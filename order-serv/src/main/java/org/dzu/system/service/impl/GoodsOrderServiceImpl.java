package org.dzu.system.service.impl;

import java.util.List;

import org.dzu.common.constant.YesOrNoConstants;
import org.dzu.common.exception.ServiceException;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.uuid.UUID;
import org.dzu.system.domain.BankAccount;
import org.dzu.system.domain.Company;
import org.dzu.system.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import org.dzu.common.utils.StringUtils;
import org.springframework.transaction.annotation.Transactional;
import org.dzu.system.domain.OrderDetail;
import org.dzu.system.mapper.GoodsOrderMapper;
import org.dzu.system.domain.GoodsOrder;

import org.dzu.common.constant.DelConstants;
/**
 * 订单Service业务层处理
 *
 * @author ml
 * @date 2024-08-02
 */
@Service
public class GoodsOrderServiceImpl implements IGoodsOrderService
{
    @Autowired
    private GoodsOrderMapper goodsOrderMapper;

    @Autowired
    private ICarsService carsService;

    @Autowired
    private IBankAccountService bankAccountService;

    @Autowired
    private ICompanyService companyService;

    @Autowired
    private IOrderDetailService orderDetailService;
    /**
     * 查询订单
     *
     * @param id 订单主键
     * @return 订单
     */
    @Override
    public GoodsOrder selectGoodsOrderById(Long id)
    {
        return goodsOrderMapper.selectGoodsOrderById(id);
    }

    /**
     * 查询订单列表
     *
     * @param goodsOrder 订单
     * @return 订单
     */
    @Override
    public List<GoodsOrder> selectGoodsOrderList(GoodsOrder goodsOrder)
    {
        return goodsOrderMapper.selectGoodsOrderList(goodsOrder);
    }

    /**
     * 新增订单
     *
     * @param goodsOrder 订单
     * @return 结果
     */
    @Transactional
    @Override
    public int insertGoodsOrder(GoodsOrder goodsOrder)
    {
        // 设置基础信息
        goodsOrder.setAddtime(String.valueOf(DateUtils.getNowDate()));
        goodsOrder.setUserId(SecurityUtils.getUserId());
        goodsOrder.setUserName(SecurityUtils.getUserTruename());
        goodsOrder.setCancelFlag(Long.valueOf(DelConstants.NODEL));

        // 检测海运和陆运司机，如果搜索不到则抛出异常
        if(goodsOrder.getLandCarID()!=null&&carsService.selectCarsById(goodsOrder.getLandCarID())==null){
            throw new ServiceException("获取陆运司机信息异常，请刷新页面后重试");
        }else {
            // 判断银行卡号是否存在
            BankAccount bankAccount = bankAccountService.selectBankAccountByBankNo(goodsOrder.getLandBankNo());
            if(bankAccount==null){
                throw new ServiceException("获取银行卡信息异常，请刷新页面后重试");
            }
        }
        if(goodsOrder.getSeaCarID()!=null&&carsService.selectCarsById(goodsOrder.getSeaCarID())==null){
            throw new ServiceException("获取海运司机信息异常，请刷新页面后重试");
        }else {
            // 判断银行卡号是否存在
            BankAccount bankAccount = bankAccountService.selectBankAccountByBankNo(goodsOrder.getSeaBankNo());
            if(bankAccount==null){
                throw new ServiceException("获取银行卡信息异常，请刷新页面后重试");
            }
        }

        // 判断客户是否存在
        Company company = companyService.selectCompanyById(goodsOrder.getCustomerID());
        if(company==null){
            throw new ServiceException("获取客户信息异常，请刷新页面后重试");
        }


        // 设置订单号
        goodsOrder.setOrdersNo(UUID.fastUUID().toString());


        // 新增一定不是调整单
        goodsOrder.setIsAdjust(YesOrNoConstants.NO_zh);
        goodsOrder.setIsAdjusted(YesOrNoConstants.NO_zh);
        goodsOrder.setAdjustOrderid(null);
        goodsOrder.setAdjustDate(null);
        // 新增一定不可能被审核
//        goodsOrder.setA
        goodsOrder.setCheckState(String.valueOf(YesOrNoConstants.NO_num));
        goodsOrder.setCheckUserId(null);
        //是否可编辑为是
        goodsOrder.setIsedit(Long.valueOf(YesOrNoConstants.YES_num));

        // 先插入主表后插入子表
        int rows = goodsOrderMapper.insertGoodsOrder(goodsOrder);
        insertOrderDetail(goodsOrder);
        return rows;
    }

    /**
     * 修改订单
     * 
     * @param goodsOrder 订单
     * @return 结果
     */
    @Transactional
    @Override
    public int updateGoodsOrder(GoodsOrder goodsOrder)
    {
        goodsOrder.setUserId(SecurityUtils.getUserId());
        goodsOrder.setUserName(SecurityUtils.getUserTruename());
        goodsOrder.setUpdateTime(DateUtils.getNowDate());
        goodsOrderMapper.deleteOrderDetailByOrdersNo(goodsOrder.getId());
        insertOrderDetail(goodsOrder);
        return goodsOrderMapper.updateGoodsOrder(goodsOrder);
    }

    /**
     * 批量删除订单
     * 
     * @param ids 需要删除的订单主键
     * @return 结果
     */
    @Transactional
    @Override
    public int deleteGoodsOrderByIds(Long[] ids)
    {
        goodsOrderMapper.deleteOrderDetailByIds(ids);
        return goodsOrderMapper.deleteGoodsOrderByIds(ids);
    }

    /**
     * 删除订单信息
     * 
     * @param id 订单主键
     * @return 结果
     */
    @Transactional
    @Override
    public int deleteGoodsOrderById(Long id)
    {
        goodsOrderMapper.deleteOrderDetailByOrderId(id);
        return goodsOrderMapper.deleteGoodsOrderById(id);
    }

    /**
     * 新增订单详情信息
     * 
     * @param goodsOrder 订单对象
     */
    public void insertOrderDetail(GoodsOrder goodsOrder)
    {
        List<OrderDetail> orderDetailList = goodsOrder.getOrderDetailList();
        if (StringUtils.isNotNull(orderDetailList))
        {
            List<OrderDetail> list = new ArrayList<OrderDetail>();
            for (OrderDetail orderDetail : orderDetailList)
            {
                orderDetail.setOrdersNo(goodsOrder.getOrdersNo());
                // 具体的补充细节
                orderDetailService.preInsert(orderDetail);
                list.add(orderDetail);
            }
            if (list.size() > 0)
            {
                goodsOrderMapper.batchOrderDetail(list);
            }
        }
    }
}
