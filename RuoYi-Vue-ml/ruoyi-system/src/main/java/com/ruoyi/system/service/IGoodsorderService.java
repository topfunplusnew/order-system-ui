package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.Goodsorder;

/**
 * 货物订单Service接口
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
public interface IGoodsorderService 
{
    /**
     * 查询货物订单
     * 
     * @param id 货物订单主键
     * @return 货物订单
     */
    public Goodsorder selectGoodsorderById(Long id);

    /**
     * 查询货物订单列表
     * 
     * @param goodsorder 货物订单
     * @return 货物订单集合
     */
    public List<Goodsorder> selectGoodsorderList(Goodsorder goodsorder);

    /**
     * 新增货物订单
     * 
     * @param goodsorder 货物订单
     * @return 结果
     */
    public int insertGoodsorder(Goodsorder goodsorder);

    /**
     * 修改货物订单
     * 
     * @param goodsorder 货物订单
     * @return 结果
     */
    public int updateGoodsorder(Goodsorder goodsorder);

    /**
     * 批量删除货物订单
     * 
     * @param ids 需要删除的货物订单主键集合
     * @return 结果
     */
    public int deleteGoodsorderByIds(Long[] ids);

    /**
     * 删除货物订单信息
     * 
     * @param id 货物订单主键
     * @return 结果
     */
    public int deleteGoodsorderById(Long id);
}
