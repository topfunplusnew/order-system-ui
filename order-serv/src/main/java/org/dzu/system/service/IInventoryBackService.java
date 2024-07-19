package org.dzu.system.service;

import java.util.List;
import org.dzu.system.domain.InventoryBack;

/**
 * 货物入库信息Service接口
 * 
 * @author ml
 * @date 2024-07-19
 */
public interface IInventoryBackService 
{
    /**
     * 查询货物入库信息
     * 
     * @param id 货物入库信息主键
     * @return 货物入库信息
     */
    public InventoryBack selectInventoryBackById(Long id);

    /**
     * 查询货物入库信息列表
     * 
     * @param inventoryBack 货物入库信息
     * @return 货物入库信息集合
     */
    public List<InventoryBack> selectInventoryBackList(InventoryBack inventoryBack);

    /**
     * 新增货物入库信息
     * 
     * @param inventoryBack 货物入库信息
     * @return 结果
     */
    public int insertInventoryBack(InventoryBack inventoryBack);

    /**
     * 修改货物入库信息
     * 
     * @param inventoryBack 货物入库信息
     * @return 结果
     */
    public int updateInventoryBack(InventoryBack inventoryBack);

    /**
     * 批量删除货物入库信息
     * 
     * @param ids 需要删除的货物入库信息主键集合
     * @return 结果
     */
    public int deleteInventoryBackByIds(Long[] ids);

    /**
     * 删除货物入库信息信息
     * 
     * @param id 货物入库信息主键
     * @return 结果
     */
    public int deleteInventoryBackById(Long id);
}
