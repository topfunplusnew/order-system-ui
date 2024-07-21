package com.ruoyi.system.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.GoodsorderMapper;
import com.ruoyi.system.domain.Goodsorder;
import com.ruoyi.system.service.IGoodsorderService;

/**
 * 货物订单Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
@Service
public class GoodsorderServiceImpl implements IGoodsorderService 
{
    @Autowired
    private GoodsorderMapper goodsorderMapper;

    /**
     * 查询货物订单
     * 
     * @param id 货物订单主键
     * @return 货物订单
     */
    @Override
    public Goodsorder selectGoodsorderById(Long id)
    {
        return goodsorderMapper.selectGoodsorderById(id);
    }

    /**
     * 查询货物订单列表
     * 
     * @param goodsorder 货物订单
     * @return 货物订单
     */
    @Override
    public List<Goodsorder> selectGoodsorderList(Goodsorder goodsorder)
    {
        return goodsorderMapper.selectGoodsorderList(goodsorder);
    }

    /**
     * 新增货物订单
     * 
     * @param goodsorder 货物订单
     * @return 结果
     */
    @Override
    public int insertGoodsorder(Goodsorder goodsorder)
    {
        return goodsorderMapper.insertGoodsorder(goodsorder);
    }

    /**
     * 修改货物订单
     * 
     * @param goodsorder 货物订单
     * @return 结果
     */
    @Override
    public int updateGoodsorder(Goodsorder goodsorder)
    {
        goodsorder.setUpdateTime(DateUtils.getNowDate());
        return goodsorderMapper.updateGoodsorder(goodsorder);
    }

    /**
     * 批量删除货物订单
     * 
     * @param ids 需要删除的货物订单主键
     * @return 结果
     */
    @Override
    public int deleteGoodsorderByIds(Long[] ids)
    {
        return goodsorderMapper.deleteGoodsorderByIds(ids);
    }

    /**
     * 删除货物订单信息
     * 
     * @param id 货物订单主键
     * @return 结果
     */
    @Override
    public int deleteGoodsorderById(Long id)
    {
        return goodsorderMapper.deleteGoodsorderById(id);
    }
}
