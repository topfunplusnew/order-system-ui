package org.dzu.system.service;

import java.util.List;
import org.dzu.system.domain.Carapply;

/**
 * 车辆派出管理Service接口
 * 
 * @author ml
 * @date 2024-07-19
 */
public interface ICarapplyService 
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
     * 批量删除车辆派出管理
     * 
     * @param ids 需要删除的车辆派出管理主键集合
     * @return 结果
     */
    public int deleteCarapplyByIds(Long[] ids);

    /**
     * 删除车辆派出管理信息
     * 
     * @param id 车辆派出管理主键
     * @return 结果
     */
    public int deleteCarapplyById(Long id);
}
