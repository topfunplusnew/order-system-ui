package org.dzu.system.service.impl;

import org.dzu.common.constant.DelConstants;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.system.domain.OrderdetailBack;
import org.dzu.system.mapper.OrderdetailBackMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
/**
 * 订单详情备份Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class OrderdetailBackServiceImpl {
    @Autowired
    private OrderdetailBackMapper orderdetailBackMapper;

    /**
     * 查询订单详情备份
     *
     * @param id 订单详情备份主键
     * @return 订单详情备份
     */
    public OrderdetailBack selectOrderdetailBackById(Long id)
    {
        return orderdetailBackMapper.selectOrderdetailBackById(id);
    }

    /**
     * 查询订单详情备份列表
     *
     * @param orderdetailBack 订单详情备份
     * @return 订单详情备份
     */
    public List<OrderdetailBack> selectOrderdetailBackList(OrderdetailBack orderdetailBack)
    {
        return orderdetailBackMapper.selectOrderdetailBackList(orderdetailBack);
    }

    /**
     * 新增订单详情备份
     *
     * @param orderdetailBack 订单详情备份
     * @return 结果
     */
    public int insertOrderdetailBack(OrderdetailBack orderdetailBack)
    {
        orderdetailBack.setAddtime(String.valueOf(DateUtils.getNowDate()));
        orderdetailBack.setUserId(SecurityUtils.getUserId());
        orderdetailBack.setUserName(SecurityUtils.getUserTruename());
        orderdetailBack.setCancelFlag(Long.valueOf(DelConstants.NODEL));
        return orderdetailBackMapper.insertOrderdetailBack(orderdetailBack);
    }

    /**
     * 修改订单详情备份
     * 
     * @param orderdetailBack 订单详情备份
     * @return 结果
     */
    public int updateOrderdetailBack(OrderdetailBack orderdetailBack)
    {
        orderdetailBack.setUserId(SecurityUtils.getUserId());
        orderdetailBack.setUserName(SecurityUtils.getUserTruename());
        orderdetailBack.setUpdateTime(DateUtils.getNowDate());
        return orderdetailBackMapper.updateOrderdetailBack(orderdetailBack);
    }

    /**
     * 批量删除订单详情备份
     * 
     * @param ids 需要删除的订单详情备份主键
     * @return 结果
     */
    public int deleteOrderdetailBackByIds(Long[] ids)
    {
        return orderdetailBackMapper.deleteOrderdetailBackByIds(ids);
    }

    /**
     * 删除订单详情备份信息
     * 
     * @param id 订单详情备份主键
     * @return 结果
     */
    public int deleteOrderdetailBackById(Long id)
    {
        return orderdetailBackMapper.deleteOrderdetailBackById(id);
    }
}
