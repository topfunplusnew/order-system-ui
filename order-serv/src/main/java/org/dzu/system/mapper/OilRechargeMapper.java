package org.dzu.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import java.util.List;
import org.dzu.system.domain.OilRecharge;

/**
 * 加油卡充值信息Mapper接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface OilRechargeMapper extends BaseMapper<OilRecharge>
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

    /**
     * 修改加油卡充值信息
     * 
     * @param oilRecharge 加油卡充值信息
     * @return 结果
     */
    public int updateOilRecharge(OilRecharge oilRecharge);

    /**
     * 删除加油卡充值信息
     * 
     * @param id 加油卡充值信息主键
     * @return 结果
     */
    public int deleteOilRechargeById(Long id);

    /**
     * 批量删除加油卡充值信息
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteOilRechargeByIds(Long[] ids);


}
