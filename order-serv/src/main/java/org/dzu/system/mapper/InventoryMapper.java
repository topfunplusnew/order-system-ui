package org.dzu.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import java.util.List;
import org.dzu.system.domain.Inventory;

/**
 * 货物入库Mapper接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface InventoryMapper extends BaseMapper<Inventory>
{
    /**
     * 查询货物入库
     * 
     * @param id 货物入库主键
     * @return 货物入库
     */
    public Inventory selectInventoryById(Long id);

    /**
     * 查询货物入库列表
     * 
     * @param inventory 货物入库
     * @return 货物入库集合
     */
    public List<Inventory> selectInventoryList(Inventory inventory);

    /**
     * 新增货物入库
     * 
     * @param inventory 货物入库
     * @return 结果
     */
    public int insertInventory(Inventory inventory);

    /**
     * 修改货物入库
     * 
     * @param inventory 货物入库
     * @return 结果
     */
    public int updateInventory(Inventory inventory);

    /**
     * 删除货物入库
     * 
     * @param id 货物入库主键
     * @return 结果
     */
    public int deleteInventoryById(Long id);

    /**
     * 批量删除货物入库
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteInventoryByIds(Long[] ids);
}
