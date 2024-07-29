package org.dzu.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import java.util.List;
import org.dzu.system.domain.InventoryBack;

/**
 * 货物入库信息Mapper接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface InventoryBackMapper extends BaseMapper<InventoryBack>
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
     * 删除货物入库信息
     * 
     * @param id 货物入库信息主键
     * @return 结果
     */
    public int deleteInventoryBackById(Long id);

    /**
     * 批量删除货物入库信息
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteInventoryBackByIds(Long[] ids);
}
