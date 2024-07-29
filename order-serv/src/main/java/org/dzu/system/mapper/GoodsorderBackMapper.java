package org.dzu.system.mapper;

import java.util.List;
import org.dzu.system.domain.GoodsorderBack;

/**
 * 订单备份信息Mapper接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface GoodsorderBackMapper 
{
    /**
     * 查询订单备份信息
     * 
     * @param id 订单备份信息主键
     * @return 订单备份信息
     */
    public GoodsorderBack selectGoodsorderBackById(Long id);

    /**
     * 查询订单备份信息列表
     * 
     * @param goodsorderBack 订单备份信息
     * @return 订单备份信息集合
     */
    public List<GoodsorderBack> selectGoodsorderBackList(GoodsorderBack goodsorderBack);

    /**
     * 新增订单备份信息
     * 
     * @param goodsorderBack 订单备份信息
     * @return 结果
     */
    public int insertGoodsorderBack(GoodsorderBack goodsorderBack);

    /**
     * 修改订单备份信息
     * 
     * @param goodsorderBack 订单备份信息
     * @return 结果
     */
    public int updateGoodsorderBack(GoodsorderBack goodsorderBack);

    /**
     * 删除订单备份信息
     * 
     * @param id 订单备份信息主键
     * @return 结果
     */
    public int deleteGoodsorderBackById(Long id);

    /**
     * 批量删除订单备份信息
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteGoodsorderBackByIds(Long[] ids);
}
