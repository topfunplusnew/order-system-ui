package org.dzu.system.service;

import org.dzu.system.domain.OrderFreight;

import java.util.List;

/**
 * 订单运费Service接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface IOrderFreightService 
{
    /**
     * 查询订单运费
     * 
     * @param id 订单运费主键
     * @return 订单运费
     */
    public OrderFreight selectOrderFreightById(Long id);

    /**
     * 查询订单运费列表
     * 
     * @param orderFreight 订单运费
     * @return 订单运费集合
     */
    public List<OrderFreight> selectOrderFreightList(OrderFreight orderFreight);

    /**
     * 新增订单运费
     * 
     * @param orderFreight 订单运费
     * @return 结果
     */
    public int insertOrderFreight(OrderFreight orderFreight);

    /**
     * 修改订单运费
     * 
     * @param orderFreight 订单运费
     * @return 结果
     */
    public int updateOrderFreight(OrderFreight orderFreight);

    /**
     * 批量删除订单运费
     * 
     * @param ids 需要删除的订单运费主键集合
     * @return 结果
     */
    public int deleteOrderFreightByIds(Long[] ids);

}
