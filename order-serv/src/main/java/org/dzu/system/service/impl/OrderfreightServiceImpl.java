package org.dzu.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.OrderfreightMapper;
import org.dzu.system.domain.Orderfreight;
import org.dzu.system.service.IOrderfreightService;

/**
 * 订单运费Service业务层处理
 * 
 * @author ml
 * @date 2024-07-19
 */
@Service
public class OrderfreightServiceImpl implements IOrderfreightService 
{
    @Autowired
    private OrderfreightMapper orderfreightMapper;

    /**
     * 查询订单运费
     * 
     * @param id 订单运费主键
     * @return 订单运费
     */
    @Override
    public Orderfreight selectOrderfreightById(Long id)
    {
        return orderfreightMapper.selectOrderfreightById(id);
    }

    /**
     * 查询订单运费列表
     * 
     * @param orderfreight 订单运费
     * @return 订单运费
     */
    @Override
    public List<Orderfreight> selectOrderfreightList(Orderfreight orderfreight)
    {
        return orderfreightMapper.selectOrderfreightList(orderfreight);
    }

    /**
     * 新增订单运费
     * 
     * @param orderfreight 订单运费
     * @return 结果
     */
    @Override
    public int insertOrderfreight(Orderfreight orderfreight)
    {
        return orderfreightMapper.insertOrderfreight(orderfreight);
    }

    /**
     * 修改订单运费
     * 
     * @param orderfreight 订单运费
     * @return 结果
     */
    @Override
    public int updateOrderfreight(Orderfreight orderfreight)
    {
        return orderfreightMapper.updateOrderfreight(orderfreight);
    }

    /**
     * 批量删除订单运费
     * 
     * @param ids 需要删除的订单运费主键
     * @return 结果
     */
    @Override
    public int deleteOrderfreightByIds(Long[] ids)
    {
        return orderfreightMapper.deleteOrderfreightByIds(ids);
    }

    /**
     * 删除订单运费信息
     * 
     * @param id 订单运费主键
     * @return 结果
     */
    @Override
    public int deleteOrderfreightById(Long id)
    {
        return orderfreightMapper.deleteOrderfreightById(id);
    }
}
