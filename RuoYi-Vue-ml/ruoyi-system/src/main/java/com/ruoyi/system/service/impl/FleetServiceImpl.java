package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.FleetMapper;
import com.ruoyi.system.domain.Fleet;
import com.ruoyi.system.service.IFleetService;

/**
 * 车队信息Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
@Service
public class FleetServiceImpl implements IFleetService 
{
    @Autowired
    private FleetMapper fleetMapper;

    /**
     * 查询车队信息
     * 
     * @param id 车队信息主键
     * @return 车队信息
     */
    @Override
    public Fleet selectFleetById(Long id)
    {
        return fleetMapper.selectFleetById(id);
    }

    /**
     * 查询车队信息列表
     * 
     * @param fleet 车队信息
     * @return 车队信息
     */
    @Override
    public List<Fleet> selectFleetList(Fleet fleet)
    {
        return fleetMapper.selectFleetList(fleet);
    }

    /**
     * 新增车队信息
     * 
     * @param fleet 车队信息
     * @return 结果
     */
    @Override
    public int insertFleet(Fleet fleet)
    {
        return fleetMapper.insertFleet(fleet);
    }

    /**
     * 修改车队信息
     * 
     * @param fleet 车队信息
     * @return 结果
     */
    @Override
    public int updateFleet(Fleet fleet)
    {
        return fleetMapper.updateFleet(fleet);
    }

    /**
     * 批量删除车队信息
     * 
     * @param ids 需要删除的车队信息主键
     * @return 结果
     */
    @Override
    public int deleteFleetByIds(Long[] ids)
    {
        return fleetMapper.deleteFleetByIds(ids);
    }

    /**
     * 删除车队信息信息
     * 
     * @param id 车队信息主键
     * @return 结果
     */
    @Override
    public int deleteFleetById(Long id)
    {
        return fleetMapper.deleteFleetById(id);
    }
}
