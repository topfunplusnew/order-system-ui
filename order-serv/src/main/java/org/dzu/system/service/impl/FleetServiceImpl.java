package org.dzu.system.service.impl;

import java.util.List;

import org.dzu.common.constant.DelConstants;
import org.dzu.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.FleetMapper;
import org.dzu.system.domain.Fleet;
import org.dzu.system.service.IFleetService;

/**
 * 车队管理Service业务层处理
 * 
 * @author ml
 * @date 2024-07-19
 */
@Service
public class FleetServiceImpl implements IFleetService 
{
    @Autowired
    private FleetMapper fleetMapper;

    /**
     * 查询车队管理
     * 
     * @param id 车队管理主键
     * @return 车队管理
     */
    @Override
    public Fleet selectFleetById(Long id)
    {
        return fleetMapper.selectFleetById(id);
    }

    /**
     * 查询车队管理列表
     * 
     * @param fleet 车队管理
     * @return 车队管理
     */
    @Override
    public List<Fleet> selectFleetList(Fleet fleet)
    {
        return fleetMapper.selectFleetList(fleet);
    }

    /**
     * 新增车队管理
     * 
     * @param fleet 车队管理
     * @return 结果
     */
    @Override
    public int insertFleet(Fleet fleet)
    {
        fleet.setAddtime(DateUtils.getTime());
        fleet.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return fleetMapper.insertFleet(fleet);
    }

    /**
     * 修改车队管理
     * 
     * @param fleet 车队管理
     * @return 结果
     */
    @Override
    public int updateFleet(Fleet fleet)
    {
        fleet.setDelFlag(Long.valueOf(DelConstants.NODEL));
        fleet.setEditTime(DateUtils.getTime());
        return fleetMapper.updateFleet(fleet);
    }

    /**
     * 批量删除车队管理
     * 
     * @param ids 需要删除的车队管理主键
     * @return 结果
     */
    @Override
    public int deleteFleetByIds(Long[] ids)
    {
        return fleetMapper.deleteFleetByIds(ids);
    }

    /**
     * 删除车队管理信息
     * 
     * @param id 车队管理主键
     * @return 结果
     */
    @Override
    public int deleteFleetById(Long id)
    {
        return fleetMapper.deleteFleetById(id);
    }
}
