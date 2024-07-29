package org.dzu.system.mapper;

import java.util.List;
import org.dzu.system.domain.Orderfreight;

/**
 * 订单运费Mapper接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface OrderfreightMapper 
{
    /**
     * 查询订单运费
     * 
     * @param id 订单运费主键
     * @return 订单运费
     */
    public Orderfreight selectOrderfreightById(Long id);

    /**
     * 查询订单运费列表
     * 
     * @param orderfreight 订单运费
     * @return 订单运费集合
     */
    public List<Orderfreight> selectOrderfreightList(Orderfreight orderfreight);

    /**
     * 新增订单运费
     * 
     * @param orderfreight 订单运费
     * @return 结果
     */
    public int insertOrderfreight(Orderfreight orderfreight);

    /**
     * 修改订单运费
     * 
     * @param orderfreight 订单运费
     * @return 结果
     */
    public int updateOrderfreight(Orderfreight orderfreight);

    /**
     * 删除订单运费
     * 
     * @param id 订单运费主键
     * @return 结果
     */
    public int deleteOrderfreightById(Long id);

    /**
     * 批量删除订单运费
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteOrderfreightByIds(Long[] ids);
}
