package org.dzu.system.service.impl;

import org.dzu.common.constant.DelConstants;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.system.domain.GoodsorderBack;
import org.dzu.system.mapper.GoodsorderBackMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
/**
 * 订单备份Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class GoodsorderBackServiceImpl {
    @Autowired
    private GoodsorderBackMapper goodsorderBackMapper;

    /**
     * 查询订单备份
     *
     * @param id 订单备份主键
     * @return 订单备份
     */
    public GoodsorderBack selectGoodsorderBackById(Long id)
    {
        return goodsorderBackMapper.selectGoodsorderBackById(id);
    }

    /**
     * 查询订单备份列表
     *
     * @param goodsorderBack 订单备份
     * @return 订单备份
     */
    public List<GoodsorderBack> selectGoodsorderBackList(GoodsorderBack goodsorderBack)
    {
        return goodsorderBackMapper.selectGoodsorderBackList(goodsorderBack);
    }

    /**
     * 新增订单备份
     *
     * @param goodsorderBack 订单备份
     * @return 结果
     */
    public int insertGoodsorderBack(GoodsorderBack goodsorderBack)
    {
        goodsorderBack.setAddtime(String.valueOf(DateUtils.getNowDate()));
        goodsorderBack.setUserId(SecurityUtils.getUserId());
        goodsorderBack.setUserName(SecurityUtils.getUserTruename());
        goodsorderBack.setCancelFlag(Long.valueOf(DelConstants.NODEL));
        return goodsorderBackMapper.insertGoodsorderBack(goodsorderBack);
    }

    /**
     * 修改订单备份
     * 
     * @param goodsorderBack 订单备份
     * @return 结果
     */
    public int updateGoodsorderBack(GoodsorderBack goodsorderBack)
    {
        goodsorderBack.setUserId(SecurityUtils.getUserId());
        goodsorderBack.setUserName(SecurityUtils.getUserTruename());
        goodsorderBack.setUpdateTime(DateUtils.getNowDate());
        return goodsorderBackMapper.updateGoodsorderBack(goodsorderBack);
    }

    /**
     * 批量删除订单备份
     * 
     * @param ids 需要删除的订单备份主键
     * @return 结果
     */
    public int deleteGoodsorderBackByIds(Long[] ids)
    {
        return goodsorderBackMapper.deleteGoodsorderBackByIds(ids);
    }

    /**
     * 删除订单备份信息
     * 
     * @param id 订单备份主键
     * @return 结果
     */
    public int deleteGoodsorderBackById(Long id)
    {
        return goodsorderBackMapper.deleteGoodsorderBackById(id);
    }
}
