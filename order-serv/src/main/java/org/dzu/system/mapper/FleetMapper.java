package org.dzu.system.mapper;

import org.dzu.system.domain.Fleet;

import java.util.List;

/**
 * 车队信息Mapper接口
 * 
 * @author ml
 * @date 2024-07-18
 */
public interface FleetMapper 
{
    /**
     * 查询车队信息
     * 
     * @param id 车队信息主键
     * @return 车队信息
     */
    public Fleet selectFleetById(Long id);

    /**
     * 查询车队信息列表
     * 
     * @param fleet 车队信息
     * @return 车队信息集合
     */
    public List<Fleet> selectFleetList(Fleet fleet);

    /**
     * 新增车队信息
     * 
     * @param fleet 车队信息
     * @return 结果
     */
    public int insertFleet(Fleet fleet);

    /**
     * 修改车队信息
     * 
     * @param fleet 车队信息
     * @return 结果
     */
    public int updateFleet(Fleet fleet);

    /**
     * 删除车队信息
     * 
     * @param id 车队信息主键
     * @return 结果
     */
    public int deleteFleetById(Long id);

    /**
     * 批量删除车队信息
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteFleetByIds(Long[] ids);
}
