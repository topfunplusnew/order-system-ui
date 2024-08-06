package org.dzu.system.service.impl;

import org.dzu.common.constant.DelConstants;
import org.dzu.common.exception.ServiceException;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.system.domain.GoodsOrder;
import org.dzu.system.domain.Offsetting;
import org.dzu.system.mapper.OffsettingMapper;
import org.dzu.system.service.IGoodsOrderService;
import org.dzu.system.service.IOffsettingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 对冲账信息Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class OffsettingServiceImpl implements IOffsettingService {
    @Autowired
    private OffsettingMapper offsettingMapper;

    @Autowired
    private IGoodsOrderService goodsOrderService;

    /**
     * 查询对冲账信息
     *
     * @param id 对冲账信息主键
     * @return 对冲账信息
     */
    @Override
    public Offsetting selectOffsettingById(Long id) {
        return offsettingMapper.selectOffsettingById(id);
    }

    /**
     * 查询对冲账信息列表
     *
     * @param offsetting 对冲账信息
     * @return 对冲账信息
     */
    @Override
    public List<Offsetting> selectOffsettingList(Offsetting offsetting) {
        return offsettingMapper.selectOffsettingList(offsetting);
    }

    /**
     * 新增对冲账信息
     *
     * @param offsetting 对冲账信息
     * @return 结果
     */
    @Override
    @Transactional
    public int insertOffsetting(Offsetting offsetting) {
        // 设置基础信息
        offsetting.setAddtime(String.valueOf(DateUtils.getNowDate()));
        offsetting.setUserId(SecurityUtils.getUserId());
        offsetting.setUserName(SecurityUtils.getUserTruename());
        offsetting.setDelFlag(Long.valueOf(DelConstants.NODEL));

        // 查询对应的订单信息
        GoodsOrder goodsOrder = goodsOrderService.selectGoodsOrderByOrderNO(offsetting.getOffsetNO());
        if (goodsOrder == null) {
            throw new ServiceException("对应订单不存在");
        }

        return offsettingMapper.insertOffsetting(offsetting);
    }

    /**
     * 修改对冲账信息
     *
     * @param offsetting 对冲账信息
     * @return 结果
     */
    @Override
    @Transactional
    public int updateOffsetting(Offsetting offsetting) {

        // 查询数据库中的原始数据
        Offsetting oldOffsetting = offsettingMapper.selectOffsettingById(offsetting.getId());

        // 如果修改了订单id则拒绝本次修改
        if (!oldOffsetting.getOffsetNO().equals(offsetting.getOffsetNO())) {
            throw new ServiceException("对冲账信息不允许修改对应订单");
        }
        // 放行
        return offsettingMapper.updateOffsetting(offsetting);
    }

    /**
     * 批量删除对冲账信息
     *
     * @param ids 需要删除的对冲账信息主键
     * @return 结果
     */
    @Override
    public int deleteOffsettingByIds(Long[] ids) {
        return offsettingMapper.deleteOffsettingByIds(ids);
    }

    /**
     * 删除对冲账信息信息
     *
     * @param id 对冲账信息主键
     * @return 结果
     */
    @Override
    public int deleteOffsettingById(Long id) {
        return offsettingMapper.deleteOffsettingById(id);
    }
}
