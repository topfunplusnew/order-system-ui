package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.Orderfreight;

/**
 * 订单运费信息Service接口
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
public interface IOrderfreightService 
{
    /**
     * 查询订单运费信息
     * 
     * @param id 订单运费信息主键
     * @return 订单运费信息
     */
    public Orderfreight selectOrderfreightById(Long id);

    /**
     * 查询订单运费信息列表
     * 
     * @param orderfreight 订单运费信息
     * @return 订单运费信息集合
     */
    public List<Orderfreight> selectOrderfreightList(Orderfreight orderfreight);

    /**
     * 新增订单运费信息
     * 
     * @param orderfreight 订单运费信息
     * @return 结果
     */
    public int insertOrderfreight(Orderfreight orderfreight);

    /**
     * 修改订单运费信息
     * 
     * @param orderfreight 订单运费信息
     * @return 结果
     */
    public int updateOrderfreight(Orderfreight orderfreight);

    /**
     * 批量删除订单运费信息
     * 
     * @param ids 需要删除的订单运费信息主键集合
     * @return 结果
     */
    public int deleteOrderfreightByIds(Long[] ids);

    /**
     * 删除订单运费信息信息
     * 
     * @param id 订单运费信息主键
     * @return 结果
     */
    public int deleteOrderfreightById(Long id);
}
