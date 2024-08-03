package org.dzu.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import java.util.List;
import org.dzu.system.domain.GoodsOrder;
import org.dzu.system.domain.GoodsorderBack;
import org.dzu.system.domain.OrderDetail;

/**
 * 订单Mapper接口
 * 
 * @author ml
 * @date 2024-08-02
 */
public interface GoodsOrderMapper extends BaseMapper<GoodsOrder>
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

    /**
     * 删除订单
     * 
     * @param id 订单主键
     * @return 结果
     */
    public int deleteGoodsOrderById(Long id);

    /**
     * 批量删除订单
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteGoodsOrderByIds(Long[] ids);

    /**
     * 批量删除订单详情
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteOrderDetailByOrdersNos(Long[] ids);
    
    /**
     * 批量新增订单详情
     * 
     * @param orderDetailList 订单详情列表
     * @return 结果
     */
    public int batchOrderDetail(List<OrderDetail> orderDetailList);
    

    /**
     * 通过订单主键删除订单详情信息
     * 
     * @param orderNo 订单ID
     * @return 结果
     */
    public int deleteOrderDetailByOrdersNo(String orderNo);

    int deleteOrderDetailByOrderId(Long id);

    int deleteOrderDetailByIds(Long[] ids);

    void backupGoodsOrder(GoodsorderBack goodsOrder);
}
