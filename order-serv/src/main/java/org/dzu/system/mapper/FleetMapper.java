package org.dzu.system.mapper;

import java.util.List;
import org.dzu.system.domain.Fleet;

/**
 * 车队管理Mapper接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface FleetMapper 
{
    /**
     * 查询车队管理
     * 
     * @param id 车队管理主键
     * @return 车队管理
     */
    public Fleet selectFleetById(Long id);

    /**
     * 查询车队管理列表
     * 
     * @param fleet 车队管理
     * @return 车队管理集合
     */
    public List<Fleet> selectFleetList(Fleet fleet);

    /**
     * 新增车队管理
     * 
     * @param fleet 车队管理
     * @return 结果
     */
    public int insertFleet(Fleet fleet);

    /**
     * 修改车队管理
     * 
     * @param fleet 车队管理
     * @return 结果
     */
    public int updateFleet(Fleet fleet);

    /**
     * 删除车队管理
     * 
     * @param id 车队管理主键
     * @return 结果
     */
    public int deleteFleetById(Long id);

    /**
     * 批量删除车队管理
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteFleetByIds(Long[] ids);
}
