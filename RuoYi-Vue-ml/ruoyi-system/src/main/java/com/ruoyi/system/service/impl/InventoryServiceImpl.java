package com.ruoyi.system.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.InventoryMapper;
import com.ruoyi.system.domain.Inventory;
import com.ruoyi.system.service.IInventoryService;

/**
 * 库存Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
@Service
public class InventoryServiceImpl implements IInventoryService 
{
    @Autowired
    private InventoryMapper inventoryMapper;

    /**
     * 查询库存
     * 
     * @param id 库存主键
     * @return 库存
     */
    @Override
    public Inventory selectInventoryById(Long id)
    {
        return inventoryMapper.selectInventoryById(id);
    }

    /**
     * 查询库存列表
     * 
     * @param inventory 库存
     * @return 库存
     */
    @Override
    public List<Inventory> selectInventoryList(Inventory inventory)
    {
        return inventoryMapper.selectInventoryList(inventory);
    }

    /**
     * 新增库存
     * 
     * @param inventory 库存
     * @return 结果
     */
    @Override
    public int insertInventory(Inventory inventory)
    {
        return inventoryMapper.insertInventory(inventory);
    }

    /**
     * 修改库存
     * 
     * @param inventory 库存
     * @return 结果
     */
    @Override
    public int updateInventory(Inventory inventory)
    {
        inventory.setUpdateTime(DateUtils.getNowDate());
        return inventoryMapper.updateInventory(inventory);
    }

    /**
     * 批量删除库存
     * 
     * @param ids 需要删除的库存主键
     * @return 结果
     */
    @Override
    public int deleteInventoryByIds(Long[] ids)
    {
        return inventoryMapper.deleteInventoryByIds(ids);
    }

    /**
     * 删除库存信息
     * 
     * @param id 库存主键
     * @return 结果
     */
    @Override
    public int deleteInventoryById(Long id)
    {
        return inventoryMapper.deleteInventoryById(id);
    }
}
