package org.dzu.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import java.util.List;
import org.dzu.system.domain.Fleet;

/**
 * 车队Mapper接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface FleetMapper extends BaseMapper<Fleet>
{
    /**
     * 查询车队
     * 
     * @param id 车队主键
     * @return 车队
     */
    public Fleet selectFleetById(Long id);

    /**
     * 查询车队列表
     * 
     * @param fleet 车队
     * @return 车队集合
     */
    public List<Fleet> selectFleetList(Fleet fleet);

    /**
     * 新增车队
     * 
     * @param fleet 车队
     * @return 结果
     */
    public int insertFleet(Fleet fleet);

    /**
     * 修改车队
     * 
     * @param fleet 车队
     * @return 结果
     */
    public int updateFleet(Fleet fleet);

    /**
     * 删除车队
     * 
     * @param id 车队主键
     * @return 结果
     */
    public int deleteFleetById(Long id);

    /**
     * 批量删除车队
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteFleetByIds(Long[] ids);
}
