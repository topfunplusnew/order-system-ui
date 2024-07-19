package org.dzu.system.mapper;

import java.util.List;
import org.dzu.system.domain.Carapply;

/**
 * 车辆派出管理Mapper接口
 * 
 * @author ml
 * @date 2024-07-19
 */
public interface CarapplyMapper 
{
    /**
     * 查询车辆派出管理
     * 
     * @param id 车辆派出管理主键
     * @return 车辆派出管理
     */
    public Carapply selectCarapplyById(Long id);

    /**
     * 查询车辆派出管理列表
     * 
     * @param carapply 车辆派出管理
     * @return 车辆派出管理集合
     */
    public List<Carapply> selectCarapplyList(Carapply carapply);

    /**
     * 新增车辆派出管理
     * 
     * @param carapply 车辆派出管理
     * @return 结果
     */
    public int insertCarapply(Carapply carapply);

    /**
     * 修改车辆派出管理
     * 
     * @param carapply 车辆派出管理
     * @return 结果
     */
    public int updateCarapply(Carapply carapply);

    /**
     * 删除车辆派出管理
     * 
     * @param id 车辆派出管理主键
     * @return 结果
     */
    public int deleteCarapplyById(Long id);

    /**
     * 批量删除车辆派出管理
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteCarapplyByIds(Long[] ids);
}
