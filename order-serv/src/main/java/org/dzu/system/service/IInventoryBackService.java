package org.dzu.system.service;

import java.util.List;
import org.dzu.system.domain.InventoryBack;

/**
 * 库存备份Service接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface IInventoryBackService 
{
    /**
     * 查询库存备份
     * 
     * @param id 库存备份主键
     * @return 库存备份
     */
    public InventoryBack selectInventoryBackById(Long id);

    /**
     * 查询库存备份列表
     * 
     * @param inventoryBack 库存备份
     * @return 库存备份集合
     */
    public List<InventoryBack> selectInventoryBackList(InventoryBack inventoryBack);

    /**
     * 新增库存备份
     * 
     * @param inventoryBack 库存备份
     * @return 结果
     */
    public int insertInventoryBack(InventoryBack inventoryBack);

    /**
     * 修改库存备份
     * 
     * @param inventoryBack 库存备份
     * @return 结果
     */
    public int updateInventoryBack(InventoryBack inventoryBack);

    /**
     * 批量删除库存备份
     * 
     * @param ids 需要删除的库存备份主键集合
     * @return 结果
     */
    public int deleteInventoryBackByIds(Long[] ids);

    /**
     * 删除库存备份信息
     * 
     * @param id 库存备份主键
     * @return 结果
     */
    public int deleteInventoryBackById(Long id);
}
