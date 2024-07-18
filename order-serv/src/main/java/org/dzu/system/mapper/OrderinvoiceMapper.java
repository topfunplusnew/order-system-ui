package org.dzu.system.mapper;

import java.util.List;
import org.dzu.system.domain.Orderinvoice;

/**
 * 订单发票信息Mapper接口
 * 
 * @author ml
 * @date 2024-07-18
 */
public interface OrderinvoiceMapper 
{
    /**
     * 查询订单发票信息
     * 
     * @param id 订单发票信息主键
     * @return 订单发票信息
     */
    public Orderinvoice selectOrderinvoiceById(Long id);

    /**
     * 查询订单发票信息列表
     * 
     * @param orderinvoice 订单发票信息
     * @return 订单发票信息集合
     */
    public List<Orderinvoice> selectOrderinvoiceList(Orderinvoice orderinvoice);

    /**
     * 新增订单发票信息
     * 
     * @param orderinvoice 订单发票信息
     * @return 结果
     */
    public int insertOrderinvoice(Orderinvoice orderinvoice);

    /**
     * 修改订单发票信息
     * 
     * @param orderinvoice 订单发票信息
     * @return 结果
     */
    public int updateOrderinvoice(Orderinvoice orderinvoice);

    /**
     * 删除订单发票信息
     * 
     * @param id 订单发票信息主键
     * @return 结果
     */
    public int deleteOrderinvoiceById(Long id);

    /**
     * 批量删除订单发票信息
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteOrderinvoiceByIds(Long[] ids);
}
