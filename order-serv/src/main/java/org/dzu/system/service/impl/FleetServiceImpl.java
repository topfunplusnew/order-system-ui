package org.dzu.system.service.impl;

import org.dzu.common.constant.DelConstants;
import org.dzu.common.utils.DateUtils;
import org.dzu.system.domain.Fleet;
import org.dzu.system.mapper.FleetMapper;
import org.dzu.system.service.IFleetService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
/**
 * 车队Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class FleetServiceImpl implements IFleetService
{
    @Autowired
    private FleetMapper fleetMapper;

    /**
     * 查询车队
     *
     * @param id 车队主键
     * @return 车队
     */
    @Override
    public Fleet selectFleetById(Long id)
    {
        return fleetMapper.selectFleetById(id);
    }

    /**
     * 查询车队列表
     *
     * @param fleet 车队
     * @return 车队
     */
    @Override
    public List<Fleet> selectFleetList(Fleet fleet)
    {
        return fleetMapper.selectFleetList(fleet);
    }

    /**
     * 新增车队
     *
     * @param fleet 车队
     * @return 结果
     */
    @Override
    public int insertFleet(Fleet fleet)
    {
        fleet.setAddtime(String.valueOf(DateUtils.getNowDate()));
        fleet.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return fleetMapper.insertFleet(fleet);
    }

    /**
     * 修改车队
     * 
     * @param fleet 车队
     * @return 结果
     */
    @Override
    public int updateFleet(Fleet fleet)
    {
        return fleetMapper.updateFleet(fleet);
    }

    /**
     * 批量删除车队
     * 
     * @param ids 需要删除的车队主键
     * @return 结果
     */
    @Override
    public int deleteFleetByIds(Long[] ids)
    {
        return fleetMapper.deleteFleetByIds(ids);
    }

    /**
     * 删除车队信息
     * 
     * @param id 车队主键
     * @return 结果
     */
    @Override
    public int deleteFleetById(Long id)
    {
        return fleetMapper.deleteFleetById(id);
    }
}
