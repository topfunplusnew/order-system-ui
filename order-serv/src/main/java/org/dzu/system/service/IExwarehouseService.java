package org.dzu.system.service;

import java.util.List;
import org.dzu.system.domain.Exwarehouse;

/**
 * 出库Service接口
 * 
 * @author ml
 * @date 2024-07-19
 */
public interface IExwarehouseService 
{
    /**
     * 查询出库
     * 
     * @param id 出库主键
     * @return 出库
     */
    public Exwarehouse selectExwarehouseById(Long id);

    /**
     * 查询出库列表
     * 
     * @param exwarehouse 出库
     * @return 出库集合
     */
    public List<Exwarehouse> selectExwarehouseList(Exwarehouse exwarehouse);

    /**
     * 新增出库
     * 
     * @param exwarehouse 出库
     * @return 结果
     */
    public int insertExwarehouse(Exwarehouse exwarehouse);

    /**
     * 修改出库
     * 
     * @param exwarehouse 出库
     * @return 结果
     */
    public int updateExwarehouse(Exwarehouse exwarehouse);

    /**
     * 批量删除出库
     * 
     * @param ids 需要删除的出库主键集合
     * @return 结果
     */
    public int deleteExwarehouseByIds(Long[] ids);

    /**
     * 删除出库信息
     * 
     * @param id 出库主键
     * @return 结果
     */
    public int deleteExwarehouseById(Long id);
}
