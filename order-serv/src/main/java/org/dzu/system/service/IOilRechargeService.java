package org.dzu.system.service;

import java.util.List;
import org.dzu.system.domain.OilRecharge;

/**
 * 加油卡充值信息Service接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface IOilRechargeService 
{
    /**
     * 查询加油卡充值信息
     * 
     * @param id 加油卡充值信息主键
     * @return 加油卡充值信息
     */
    public OilRecharge selectOilRechargeById(Long id);

    /**
     * 查询加油卡充值信息列表
     * 
     * @param oilRecharge 加油卡充值信息
     * @return 加油卡充值信息集合
     */
    public List<OilRecharge> selectOilRechargeList(OilRecharge oilRecharge);

    /**
     * 新增加油卡充值信息
     * 
     * @param oilRecharge 加油卡充值信息
     * @return 结果
     */
    public int insertOilRecharge(OilRecharge oilRecharge);

    void calculateCardBalances(OilRecharge oilRecharge);

    /**
     * 修改加油卡充值信息
     * 
     * @param oilRecharge 加油卡充值信息
     * @return 结果
     */
    public int updateOilRecharge(OilRecharge oilRecharge);

    /**
     * 批量删除加油卡充值信息
     * 
     * @param ids 需要删除的加油卡充值信息主键集合
     * @return 结果
     */
    public int deleteOilRechargeByIds(Long[] ids);

    /**
     * 删除加油卡充值信息信息
     * 
     * @param id 加油卡充值信息主键
     * @return 结果
     */
    public int deleteOilRechargeById(Long id);
}
