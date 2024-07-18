package org.dzu.system.service;

import org.dzu.system.domain.Carapply;

import java.util.List;

/**
 * 汽车申请Service接口
 * 
 * @author ml
 * @date 2024-07-18
 */
public interface ICarapplyService 
{
    /**
     * 查询汽车申请
     * 
     * @param id 汽车申请主键
     * @return 汽车申请
     */
    public Carapply selectCarapplyById(Long id);

    /**
     * 查询汽车申请列表
     * 
     * @param carapply 汽车申请
     * @return 汽车申请集合
     */
    public List<Carapply> selectCarapplyList(Carapply carapply);

    /**
     * 新增汽车申请
     * 
     * @param carapply 汽车申请
     * @return 结果
     */
    public int insertCarapply(Carapply carapply);

    /**
     * 修改汽车申请
     * 
     * @param carapply 汽车申请
     * @return 结果
     */
    public int updateCarapply(Carapply carapply);

    /**
     * 批量删除汽车申请
     * 
     * @param ids 需要删除的汽车申请主键集合
     * @return 结果
     */
    public int deleteCarapplyByIds(Long[] ids);

    /**
     * 删除汽车申请信息
     * 
     * @param id 汽车申请主键
     * @return 结果
     */
    public int deleteCarapplyById(Long id);
}
