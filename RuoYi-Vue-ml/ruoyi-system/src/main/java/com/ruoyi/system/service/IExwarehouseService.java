package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.Exwarehouse;

/**
 * 出库信息Service接口
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
public interface IExwarehouseService 
{
    /**
     * 查询出库信息
     * 
     * @param id 出库信息主键
     * @return 出库信息
     */
    public Exwarehouse selectExwarehouseById(Long id);

    /**
     * 查询出库信息列表
     * 
     * @param exwarehouse 出库信息
     * @return 出库信息集合
     */
    public List<Exwarehouse> selectExwarehouseList(Exwarehouse exwarehouse);

    /**
     * 新增出库信息
     * 
     * @param exwarehouse 出库信息
     * @return 结果
     */
    public int insertExwarehouse(Exwarehouse exwarehouse);

    /**
     * 修改出库信息
     * 
     * @param exwarehouse 出库信息
     * @return 结果
     */
    public int updateExwarehouse(Exwarehouse exwarehouse);

    /**
     * 批量删除出库信息
     * 
     * @param ids 需要删除的出库信息主键集合
     * @return 结果
     */
    public int deleteExwarehouseByIds(Long[] ids);

    /**
     * 删除出库信息信息
     * 
     * @param id 出库信息主键
     * @return 结果
     */
    public int deleteExwarehouseById(Long id);
}
