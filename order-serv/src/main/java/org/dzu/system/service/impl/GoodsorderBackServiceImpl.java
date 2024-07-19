package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.GoodsorderBackMapper;
import org.dzu.system.domain.GoodsorderBack;
import org.dzu.system.service.IGoodsorderBackService;

/**
 * 订单备份信息Service业务层处理
 * 
 * @author ml
 * @date 2024-07-19
 */
@Service
public class GoodsorderBackServiceImpl implements IGoodsorderBackService 
{
    @Autowired
    private GoodsorderBackMapper goodsorderBackMapper;

    /**
     * 查询订单备份信息
     * 
     * @param id 订单备份信息主键
     * @return 订单备份信息
     */
    @Override
    public GoodsorderBack selectGoodsorderBackById(Long id)
    {
        return goodsorderBackMapper.selectGoodsorderBackById(id);
    }

    /**
     * 查询订单备份信息列表
     * 
     * @param goodsorderBack 订单备份信息
     * @return 订单备份信息
     */
    @Override
    public List<GoodsorderBack> selectGoodsorderBackList(GoodsorderBack goodsorderBack)
    {
        return goodsorderBackMapper.selectGoodsorderBackList(goodsorderBack);
    }

    /**
     * 新增订单备份信息
     * 
     * @param goodsorderBack 订单备份信息
     * @return 结果
     */
    @Override
    public int insertGoodsorderBack(GoodsorderBack goodsorderBack)
    {
        return goodsorderBackMapper.insertGoodsorderBack(goodsorderBack);
    }

    /**
     * 修改订单备份信息
     * 
     * @param goodsorderBack 订单备份信息
     * @return 结果
     */
    @Override
    public int updateGoodsorderBack(GoodsorderBack goodsorderBack)
    {
        goodsorderBack.setUpdateTime(DateUtils.getNowDate());
        return goodsorderBackMapper.updateGoodsorderBack(goodsorderBack);
    }

    /**
     * 批量删除订单备份信息
     * 
     * @param ids 需要删除的订单备份信息主键
     * @return 结果
     */
    @Override
    public int deleteGoodsorderBackByIds(Long[] ids)
    {
        return goodsorderBackMapper.deleteGoodsorderBackByIds(ids);
    }

    /**
     * 删除订单备份信息信息
     * 
     * @param id 订单备份信息主键
     * @return 结果
     */
    @Override
    public int deleteGoodsorderBackById(Long id)
    {
        return goodsorderBackMapper.deleteGoodsorderBackById(id);
    }
}
