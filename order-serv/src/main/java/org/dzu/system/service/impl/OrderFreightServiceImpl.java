package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.OrderFreightMapper;
import org.dzu.system.domain.OrderFreight;
import org.dzu.system.service.IOrderFreightService;
 
import org.dzu.common.constant.DelConstants;
/**
 * 订单运费Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class OrderFreightServiceImpl implements IOrderFreightService
{
    @Autowired
    private OrderFreightMapper orderFreightMapper;

    /**
     * 查询订单运费
     *
     * @param id 订单运费主键
     * @return 订单运费
     */
    @Override
    public OrderFreight selectOrderFreightById(Long id)
    {
        return orderFreightMapper.selectOrderFreightById(id);
    }

    /**
     * 查询订单运费列表
     *
     * @param orderFreight 订单运费
     * @return 订单运费
     */
    @Override
    public List<OrderFreight> selectOrderFreightList(OrderFreight orderFreight)
    {
        return orderFreightMapper.selectOrderFreightList(orderFreight);
    }

    /**
     * 新增订单运费
     *
     * @param orderFreight 订单运费
     * @return 结果
     */
    @Override
    public int insertOrderFreight(OrderFreight orderFreight)
    {
        orderFreight.setAddtime(String.valueOf(DateUtils.getNowDate()));
        orderFreight.setUserId(SecurityUtils.getUserId());
        orderFreight.setUserName(SecurityUtils.getUserTruename());
        orderFreight.setCancelFlag(Long.valueOf(DelConstants.NODEL));
        return orderFreightMapper.insertOrderFreight(orderFreight);
    }

    /**
     * 修改订单运费
     * 
     * @param orderFreight 订单运费
     * @return 结果
     */
    @Override
    public int updateOrderFreight(OrderFreight orderFreight)
    {
        orderFreight.setUserId(SecurityUtils.getUserId());
        orderFreight.setUserName(SecurityUtils.getUserTruename());
        return orderFreightMapper.updateOrderFreight(orderFreight);
    }

    /**
     * 批量删除订单运费
     * 
     * @param ids 需要删除的订单运费主键
     * @return 结果
     */
    @Override
    public int deleteOrderFreightByIds(Long[] ids)
    {
        return orderFreightMapper.deleteOrderFreightByIds(ids);
    }

    /**
     * 删除订单运费信息
     * 
     * @param id 订单运费主键
     * @return 结果
     */
    @Override
    public int deleteOrderFreightById(Long id)
    {
        return orderFreightMapper.deleteOrderFreightById(id);
    }
}
