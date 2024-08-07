package org.dzu.system.service;

import java.util.List;
import org.dzu.system.domain.GoodsOrder;
import org.springframework.transaction.annotation.Transactional;

/**
 * 订单Service接口
 * 
 * @author ml
 * @date 2024-08-02
 */
public interface IGoodsOrderService 
{
    /**
     * 查询订单
     * 
     * @param id 订单主键
     * @return 订单
     */
    public GoodsOrder selectGoodsOrderById(Long id);

    /**
     * 查询订单列表
     * 
     * @param goodsOrder 订单
     * @return 订单集合
     */
    public List<GoodsOrder> selectGoodsOrderList(GoodsOrder goodsOrder);

    /**
     * 新增订单
     * 
     * @param goodsOrder 订单
     * @return 结果
     */
    public int insertGoodsOrder(GoodsOrder goodsOrder);

    /**
     * 修改订单
     * 
     * @param goodsOrder 订单
     * @return 结果
     */
    public int updateGoodsOrder(GoodsOrder goodsOrder);

    @Transactional
    int auditGoodsOrder(Long id, boolean isAudit);

    @Transactional
    int adjustGoodsOrder(GoodsOrder goodsOrder);

    /**
     * 批量删除订单
     * 
     * @param ids 需要删除的订单主键集合
     * @return 结果
     */
    public int deleteGoodsOrderByIds(Long[] ids);

    /**
     * 删除订单信息
     * 
     * @param id 订单主键
     * @return 结果
     */
    public int deleteGoodsOrderById(Long id);

    GoodsOrder selectGoodsOrderByOrderNO(String ordersNo);

}
