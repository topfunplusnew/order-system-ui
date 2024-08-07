package org.dzu.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.dzu.system.domain.InventoryBack;

import java.util.List;

/**
 * 库存备份Mapper接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface InventoryBackMapper extends BaseMapper<InventoryBack>
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
     * 删除库存备份
     * 
     * @param id 库存备份主键
     * @return 结果
     */
    public int deleteInventoryBackById(Long id);

    /**
     * 批量删除库存备份
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteInventoryBackByIds(Long[] ids);
}
