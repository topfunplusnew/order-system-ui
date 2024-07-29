package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.OrderDetailMapper;
import org.dzu.system.domain.OrderDetail;
import org.dzu.system.service.IOrderDetailService;
 
import org.dzu.common.constant.DelConstants;
/**
 * 订单详情Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class OrderDetailServiceImpl implements IOrderDetailService
{
    @Autowired
    private OrderDetailMapper orderDetailMapper;

    /**
     * 查询订单详情
     *
     * @param id 订单详情主键
     * @return 订单详情
     */
    @Override
    public OrderDetail selectOrderDetailById(Long id)
    {
        return orderDetailMapper.selectOrderDetailById(id);
    }

    /**
     * 查询订单详情列表
     *
     * @param orderDetail 订单详情
     * @return 订单详情
     */
    @Override
    public List<OrderDetail> selectOrderDetailList(OrderDetail orderDetail)
    {
        return orderDetailMapper.selectOrderDetailList(orderDetail);
    }

    /**
     * 新增订单详情
     *
     * @param orderDetail 订单详情
     * @return 结果
     */
    @Override
    public int insertOrderDetail(OrderDetail orderDetail)
    {
        orderDetail.setAddtime(String.valueOf(DateUtils.getNowDate()));
        orderDetail.setUserId(SecurityUtils.getUserId());
        orderDetail.setUserName(SecurityUtils.getUserTruename());
        orderDetail.setCancelFlag(Long.valueOf(DelConstants.NODEL));
        return orderDetailMapper.insertOrderDetail(orderDetail);
    }

    /**
     * 修改订单详情
     * 
     * @param orderDetail 订单详情
     * @return 结果
     */
    @Override
    public int updateOrderDetail(OrderDetail orderDetail)
    {
        orderDetail.setUserId(SecurityUtils.getUserId());
        orderDetail.setUserName(SecurityUtils.getUserTruename());
        orderDetail.setUpdateTime(DateUtils.getNowDate());
        return orderDetailMapper.updateOrderDetail(orderDetail);
    }

    /**
     * 批量删除订单详情
     * 
     * @param ids 需要删除的订单详情主键
     * @return 结果
     */
    @Override
    public int deleteOrderDetailByIds(Long[] ids)
    {
        return orderDetailMapper.deleteOrderDetailByIds(ids);
    }

    /**
     * 删除订单详情信息
     * 
     * @param id 订单详情主键
     * @return 结果
     */
    @Override
    public int deleteOrderDetailById(Long id)
    {
        return orderDetailMapper.deleteOrderDetailById(id);
    }
}
