package org.dzu.system.service;

import java.util.List;
import org.dzu.system.domain.Orderdetail;

/**
 * 订单详情Service接口
 * 
 * @author ml
 * @date 2024-07-19
 */
public interface IOrderdetailService 
{
    /**
     * 查询订单详情
     * 
     * @param id 订单详情主键
     * @return 订单详情
     */
    public Orderdetail selectOrderdetailById(Long id);

    /**
     * 查询订单详情列表
     * 
     * @param orderdetail 订单详情
     * @return 订单详情集合
     */
    public List<Orderdetail> selectOrderdetailList(Orderdetail orderdetail);

    /**
     * 新增订单详情
     * 
     * @param orderdetail 订单详情
     * @return 结果
     */
    public int insertOrderdetail(Orderdetail orderdetail);

    /**
     * 修改订单详情
     * 
     * @param orderdetail 订单详情
     * @return 结果
     */
    public int updateOrderdetail(Orderdetail orderdetail);

    /**
     * 批量删除订单详情
     * 
     * @param ids 需要删除的订单详情主键集合
     * @return 结果
     */
    public int deleteOrderdetailByIds(Long[] ids);

    /**
     * 删除订单详情信息
     * 
     * @param id 订单详情主键
     * @return 结果
     */
    public int deleteOrderdetailById(Long id);
}
