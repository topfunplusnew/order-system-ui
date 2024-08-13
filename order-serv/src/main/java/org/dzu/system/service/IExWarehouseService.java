package org.dzu.system.service;

import org.dzu.system.domain.ExWarehouse;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 出库Service接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface IExWarehouseService 
{
    /**
     * 查询出库
     * 
     * @param id 出库主键
     * @return 出库
     */
    public ExWarehouse selectExWarehouseById(Long id);

    /**
     * 查询出库列表
     * 
     * @param exWarehouse 出库
     * @return 出库集合
     */
    public List<ExWarehouse> selectExWarehouseList(ExWarehouse exWarehouse);

    /**
     * 新增出库
     * 
     * @param exWarehouse 出库
     * @return 结果
     */
    public int insertExWarehouse(ExWarehouse exWarehouse);

    int insertExWarehouseByFront(ExWarehouse exWarehouse);

    /**
     * 修改出库
     * 
     * @param exWarehouse 出库
     * @return 结果
     */
    public int updateExWarehouse(ExWarehouse exWarehouse);

    /**
     * 批量删除出库
     * 
     * @param ids 需要删除的出库主键集合
     * @return 结果
     */
    public int deleteExWarehouseByIds(Long[] ids);


    void InventoryToEx(Long InventoryId, Long outAmount, String OrderNo, String outDate);

    int deleteExWarehouseByOrderNo(String detail);
}
