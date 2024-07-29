package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.GoodsorderMapper;
import org.dzu.system.domain.Goodsorder;
import org.dzu.system.service.IGoodsorderService;
 
import org.dzu.common.constant.DelConstants;
/**
 * 订单Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class GoodsorderServiceImpl implements IGoodsorderService
{
    @Autowired
    private GoodsorderMapper goodsorderMapper;

    /**
     * 查询订单
     *
     * @param id 订单主键
     * @return 订单
     */
    @Override
    public Goodsorder selectGoodsorderById(Long id)
    {
        return goodsorderMapper.selectGoodsorderById(id);
    }

    /**
     * 查询订单列表
     *
     * @param goodsorder 订单
     * @return 订单
     */
    @Override
    public List<Goodsorder> selectGoodsorderList(Goodsorder goodsorder)
    {
        return goodsorderMapper.selectGoodsorderList(goodsorder);
    }

    /**
     * 新增订单
     *
     * @param goodsorder 订单
     * @return 结果
     */
    @Override
    public int insertGoodsorder(Goodsorder goodsorder)
    {
        goodsorder.setAddtime(String.valueOf(DateUtils.getNowDate()));
        goodsorder.setUserId(SecurityUtils.getUserId());
        goodsorder.setUserName(SecurityUtils.getUserTruename());
        goodsorder.setCancelFlag(Long.valueOf(DelConstants.NODEL));
        return goodsorderMapper.insertGoodsorder(goodsorder);
    }

    /**
     * 修改订单
     * 
     * @param goodsorder 订单
     * @return 结果
     */
    @Override
    public int updateGoodsorder(Goodsorder goodsorder)
    {
        goodsorder.setUserId(SecurityUtils.getUserId());
        goodsorder.setUserName(SecurityUtils.getUserTruename());
        goodsorder.setUpdateTime(DateUtils.getNowDate());
        return goodsorderMapper.updateGoodsorder(goodsorder);
    }

    /**
     * 批量删除订单
     * 
     * @param ids 需要删除的订单主键
     * @return 结果
     */
    @Override
    public int deleteGoodsorderByIds(Long[] ids)
    {
        return goodsorderMapper.deleteGoodsorderByIds(ids);
    }

    /**
     * 删除订单信息
     * 
     * @param id 订单主键
     * @return 结果
     */
    @Override
    public int deleteGoodsorderById(Long id)
    {
        return goodsorderMapper.deleteGoodsorderById(id);
    }
}
