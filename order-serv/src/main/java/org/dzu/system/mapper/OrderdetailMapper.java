package org.dzu.system.mapper;

import java.util.List;
import org.dzu.system.domain.Orderdetail;

/**
 * 订单详情Mapper接口
 * 
 * @author ml
 * @date 2024-07-19
 */
public interface OrderdetailMapper 
{
    public void copyOrderDetailsToBack(List<Long> ids);
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
     * 删除订单详情
     * 
     * @param id 订单详情主键
     * @return 结果
     */
    public int deleteOrderdetailById(Long id);

    /**
     * 批量删除订单详情
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteOrderdetailByIds(Long[] ids);
}
