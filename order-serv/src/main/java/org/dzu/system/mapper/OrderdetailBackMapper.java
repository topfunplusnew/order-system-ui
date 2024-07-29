package org.dzu.system.mapper;

import java.util.List;
import org.dzu.system.domain.OrderdetailBack;

/**
 * 订单详情备份Mapper接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface OrderdetailBackMapper 
{
    /**
     * 查询订单详情备份
     * 
     * @param id 订单详情备份主键
     * @return 订单详情备份
     */
    public OrderdetailBack selectOrderdetailBackById(Long id);

    /**
     * 查询订单详情备份列表
     * 
     * @param orderdetailBack 订单详情备份
     * @return 订单详情备份集合
     */
    public List<OrderdetailBack> selectOrderdetailBackList(OrderdetailBack orderdetailBack);

    /**
     * 新增订单详情备份
     * 
     * @param orderdetailBack 订单详情备份
     * @return 结果
     */
    public int insertOrderdetailBack(OrderdetailBack orderdetailBack);

    /**
     * 修改订单详情备份
     * 
     * @param orderdetailBack 订单详情备份
     * @return 结果
     */
    public int updateOrderdetailBack(OrderdetailBack orderdetailBack);

    /**
     * 删除订单详情备份
     * 
     * @param id 订单详情备份主键
     * @return 结果
     */
    public int deleteOrderdetailBackById(Long id);

    /**
     * 批量删除订单详情备份
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteOrderdetailBackByIds(Long[] ids);
}
