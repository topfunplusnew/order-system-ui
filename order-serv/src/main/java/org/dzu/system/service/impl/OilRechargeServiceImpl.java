package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.OilRechargeMapper;
import org.dzu.system.domain.OilRecharge;
import org.dzu.system.service.IOilRechargeService;
 
import org.dzu.common.constant.DelConstants;
/**
 * 加油卡充值信息Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class OilRechargeServiceImpl implements IOilRechargeService
{
    @Autowired
    private OilRechargeMapper oilRechargeMapper;

    /**
     * 查询加油卡充值信息
     *
     * @param id 加油卡充值信息主键
     * @return 加油卡充值信息
     */
    @Override
    public OilRecharge selectOilRechargeById(Long id)
    {
        return oilRechargeMapper.selectOilRechargeById(id);
    }

    /**
     * 查询加油卡充值信息列表
     *
     * @param oilRecharge 加油卡充值信息
     * @return 加油卡充值信息
     */
    @Override
    public List<OilRecharge> selectOilRechargeList(OilRecharge oilRecharge)
    {
        return oilRechargeMapper.selectOilRechargeList(oilRecharge);
    }

    /**
     * 新增加油卡充值信息
     *
     * @param oilRecharge 加油卡充值信息
     * @return 结果
     */
    @Override
    public int insertOilRecharge(OilRecharge oilRecharge)
    {
        oilRecharge.setAddtime(String.valueOf(DateUtils.getNowDate()));
        oilRecharge.setUserId(SecurityUtils.getUserId());
        oilRecharge.setUserName(SecurityUtils.getUserTruename());
        oilRecharge.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return oilRechargeMapper.insertOilRecharge(oilRecharge);
    }

    /**
     * 修改加油卡充值信息
     * 
     * @param oilRecharge 加油卡充值信息
     * @return 结果
     */
    @Override
    public int updateOilRecharge(OilRecharge oilRecharge)
    {
        oilRecharge.setUserId(SecurityUtils.getUserId());
        oilRecharge.setUserName(SecurityUtils.getUserTruename());
        oilRecharge.setUpdateTime(DateUtils.getNowDate());
        return oilRechargeMapper.updateOilRecharge(oilRecharge);
    }

    /**
     * 批量删除加油卡充值信息
     * 
     * @param ids 需要删除的加油卡充值信息主键
     * @return 结果
     */
    @Override
    public int deleteOilRechargeByIds(Long[] ids)
    {
        return oilRechargeMapper.deleteOilRechargeByIds(ids);
    }

    /**
     * 删除加油卡充值信息信息
     * 
     * @param id 加油卡充值信息主键
     * @return 结果
     */
    @Override
    public int deleteOilRechargeById(Long id)
    {
        return oilRechargeMapper.deleteOilRechargeById(id);
    }
}
