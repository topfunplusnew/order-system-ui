package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import org.dzu.common.utils.StringUtils;
import org.springframework.transaction.annotation.Transactional;
import org.dzu.system.domain.OrderDetail;
import org.dzu.system.mapper.GoodsOrderMapper;
import org.dzu.system.domain.GoodsOrder;
import org.dzu.system.service.IGoodsOrderService;
 
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
        goodsOrder.setAddtime(String.valueOf(DateUtils.getNowDate()));
        goodsOrder.setUserId(SecurityUtils.getUserId());
        goodsOrder.setUserName(SecurityUtils.getUserTruename());
        goodsOrder.setCancelFlag(Long.valueOf(DelConstants.NODEL));
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
        goodsOrderMapper.deleteOrderDetailByOrdersNos(ids);
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
        goodsOrderMapper.deleteOrderDetailByOrdersNo(id);
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
                list.add(orderDetail);
            }
            if (list.size() > 0)
            {
                goodsOrderMapper.batchOrderDetail(list);
            }
        }
    }
}
