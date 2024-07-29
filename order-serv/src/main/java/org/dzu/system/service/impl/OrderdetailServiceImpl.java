package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.OrderdetailMapper;
import org.dzu.system.domain.Orderdetail;
import org.dzu.system.service.IOrderdetailService;
 
import org.dzu.common.constant.DelConstants;
/**
 * 订单详情Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class OrderdetailServiceImpl implements IOrderdetailService
{
    @Autowired
    private OrderdetailMapper orderdetailMapper;

    /**
     * 查询订单详情
     *
     * @param id 订单详情主键
     * @return 订单详情
     */
    @Override
    public Orderdetail selectOrderdetailById(Long id)
    {
        return orderdetailMapper.selectOrderdetailById(id);
    }

    /**
     * 查询订单详情列表
     *
     * @param orderdetail 订单详情
     * @return 订单详情
     */
    @Override
    public List<Orderdetail> selectOrderdetailList(Orderdetail orderdetail)
    {
        return orderdetailMapper.selectOrderdetailList(orderdetail);
    }

    /**
     * 新增订单详情
     *
     * @param orderdetail 订单详情
     * @return 结果
     */
    @Override
    public int insertOrderdetail(Orderdetail orderdetail)
    {
        orderdetail.setAddtime(String.valueOf(DateUtils.getNowDate()));
        orderdetail.setUserId(SecurityUtils.getUserId());
        orderdetail.setUserName(SecurityUtils.getUserTruename());
        orderdetail.setCancelFlag(Long.valueOf(DelConstants.NODEL));
        return orderdetailMapper.insertOrderdetail(orderdetail);
    }

    /**
     * 修改订单详情
     * 
     * @param orderdetail 订单详情
     * @return 结果
     */
    @Override
    public int updateOrderdetail(Orderdetail orderdetail)
    {
        orderdetail.setUserId(SecurityUtils.getUserId());
        orderdetail.setUserName(SecurityUtils.getUserTruename());
        orderdetail.setUpdateTime(DateUtils.getNowDate());
        return orderdetailMapper.updateOrderdetail(orderdetail);
    }

    /**
     * 批量删除订单详情
     * 
     * @param ids 需要删除的订单详情主键
     * @return 结果
     */
    @Override
    public int deleteOrderdetailByIds(Long[] ids)
    {
        return orderdetailMapper.deleteOrderdetailByIds(ids);
    }

    /**
     * 删除订单详情信息
     * 
     * @param id 订单详情主键
     * @return 结果
     */
    @Override
    public int deleteOrderdetailById(Long id)
    {
        return orderdetailMapper.deleteOrderdetailById(id);
    }
}
