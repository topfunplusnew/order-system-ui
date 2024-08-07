package org.dzu.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.dzu.system.domain.Inventory;

import java.util.List;

/**
 * 库存Mapper接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface InventoryMapper extends BaseMapper<Inventory>
{
    /**
     * 查询库存
     * 
     * @param id 库存主键
     * @return 库存
     */
    public Inventory selectInventoryById(Long id);

    /**
     * 查询库存列表
     * 
     * @param inventory 库存
     * @return 库存集合
     */
    public List<Inventory> selectInventoryList(Inventory inventory);

    /**
     * 新增库存
     * 
     * @param inventory 库存
     * @return 结果
     */
    public int insertInventory(Inventory inventory);

    /**
     * 修改库存
     * 
     * @param inventory 库存
     * @return 结果
     */
    public int updateInventory(Inventory inventory);

    /**
     * 删除库存
     * 
     * @param id 库存主键
     * @return 结果
     */
    public int deleteInventoryById(Long id);

    /**
     * 批量删除库存
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteInventoryByIds(Long[] ids);

    public List<Inventory> orderByInventory(Inventory inventory);
}
