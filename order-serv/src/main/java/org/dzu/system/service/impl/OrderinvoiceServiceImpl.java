package org.dzu.system.service.impl;

import org.dzu.common.utils.DateUtils;
import org.dzu.system.domain.Orderinvoice;
import org.dzu.system.mapper.OrderinvoiceMapper;
import org.dzu.system.service.IOrderinvoiceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 订单发票信息Service业务层处理
 * 
 * @author ml
 * @date 2024-07-18
 */
@Service
public class OrderinvoiceServiceImpl implements IOrderinvoiceService 
{
    @Autowired
    private OrderinvoiceMapper orderinvoiceMapper;

    /**
     * 查询订单发票信息
     * 
     * @param id 订单发票信息主键
     * @return 订单发票信息
     */
    @Override
    public Orderinvoice selectOrderinvoiceById(Long id)
    {
        return orderinvoiceMapper.selectOrderinvoiceById(id);
    }

    /**
     * 查询订单发票信息列表
     * 
     * @param orderinvoice 订单发票信息
     * @return 订单发票信息
     */
    @Override
    public List<Orderinvoice> selectOrderinvoiceList(Orderinvoice orderinvoice)
    {
        return orderinvoiceMapper.selectOrderinvoiceList(orderinvoice);
    }

    /**
     * 新增订单发票信息
     * 
     * @param orderinvoice 订单发票信息
     * @return 结果
     */
    @Override
    public int insertOrderinvoice(Orderinvoice orderinvoice)
    {
        return orderinvoiceMapper.insertOrderinvoice(orderinvoice);
    }

    /**
     * 修改订单发票信息
     * 
     * @param orderinvoice 订单发票信息
     * @return 结果
     */
    @Override
    public int updateOrderinvoice(Orderinvoice orderinvoice)
    {
        orderinvoice.setUpdateTime(DateUtils.getNowDate());
        return orderinvoiceMapper.updateOrderinvoice(orderinvoice);
    }

    /**
     * 批量删除订单发票信息
     * 
     * @param ids 需要删除的订单发票信息主键
     * @return 结果
     */
    @Override
    public int deleteOrderinvoiceByIds(Long[] ids)
    {
        return orderinvoiceMapper.deleteOrderinvoiceByIds(ids);
    }

    /**
     * 删除订单发票信息信息
     * 
     * @param id 订单发票信息主键
     * @return 结果
     */
    @Override
    public int deleteOrderinvoiceById(Long id)
    {
        return orderinvoiceMapper.deleteOrderinvoiceById(id);
    }
}
