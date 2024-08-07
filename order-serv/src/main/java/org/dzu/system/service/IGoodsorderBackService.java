package org.dzu.system.service;

import org.dzu.system.domain.GoodsorderBack;

import java.util.List;

/**
 * 订单备份Service接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface IGoodsorderBackService 
{
    /**
     * 查询订单备份
     * 
     * @param id 订单备份主键
     * @return 订单备份
     */
    public GoodsorderBack selectGoodsorderBackById(Long id);

    /**
     * 查询订单备份列表
     * 
     * @param goodsorderBack 订单备份
     * @return 订单备份集合
     */
    public List<GoodsorderBack> selectGoodsorderBackList(GoodsorderBack goodsorderBack);

    /**
     * 新增订单备份
     * 
     * @param goodsorderBack 订单备份
     * @return 结果
     */
    public int insertGoodsorderBack(GoodsorderBack goodsorderBack);

    /**
     * 修改订单备份
     * 
     * @param goodsorderBack 订单备份
     * @return 结果
     */
    public int updateGoodsorderBack(GoodsorderBack goodsorderBack);

    /**
     * 批量删除订单备份
     * 
     * @param ids 需要删除的订单备份主键集合
     * @return 结果
     */
    public int deleteGoodsorderBackByIds(Long[] ids);

    /**
     * 删除订单备份信息
     * 
     * @param id 订单备份主键
     * @return 结果
     */
    public int deleteGoodsorderBackById(Long id);
}
