package org.dzu.system.mapper;

import java.util.List;
import org.dzu.system.domain.Carapply;

/**
 * 汽车申请Mapper接口
 * 
 * @author ml
 * @date 2024-07-18
 */
public interface CarapplyMapper 
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
     * 删除汽车申请
     * 
     * @param id 汽车申请主键
     * @return 结果
     */
    public int deleteCarapplyById(Long id);

    /**
     * 批量删除汽车申请
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteCarapplyByIds(Long[] ids);
}
