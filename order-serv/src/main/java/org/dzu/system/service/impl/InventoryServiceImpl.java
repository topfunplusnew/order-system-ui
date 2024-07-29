package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.InventoryMapper;
import org.dzu.system.domain.Inventory;
import org.dzu.system.service.IInventoryService;
 
import org.dzu.common.constant.DelConstants;
/**
 * 货物入库Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class InventoryServiceImpl implements IInventoryService
{
    @Autowired
    private InventoryMapper inventoryMapper;

    /**
     * 查询货物入库
     *
     * @param id 货物入库主键
     * @return 货物入库
     */
    @Override
    public Inventory selectInventoryById(Long id)
    {
        return inventoryMapper.selectInventoryById(id);
    }

    /**
     * 查询货物入库列表
     *
     * @param inventory 货物入库
     * @return 货物入库
     */
    @Override
    public List<Inventory> selectInventoryList(Inventory inventory)
    {
        return inventoryMapper.selectInventoryList(inventory);
    }

    /**
     * 新增货物入库
     *
     * @param inventory 货物入库
     * @return 结果
     */
    @Override
    public int insertInventory(Inventory inventory)
    {
        inventory.setAddtime(String.valueOf(DateUtils.getNowDate()));
        inventory.setUserId(SecurityUtils.getUserId());
        inventory.setUserName(SecurityUtils.getUserTruename());
        inventory.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return inventoryMapper.insertInventory(inventory);
    }

    /**
     * 修改货物入库
     * 
     * @param inventory 货物入库
     * @return 结果
     */
    @Override
    public int updateInventory(Inventory inventory)
    {
        inventory.setUserId(SecurityUtils.getUserId());
        inventory.setUserName(SecurityUtils.getUserTruename());
        inventory.setUpdateTime(DateUtils.getNowDate());
        return inventoryMapper.updateInventory(inventory);
    }

    /**
     * 批量删除货物入库
     * 
     * @param ids 需要删除的货物入库主键
     * @return 结果
     */
    @Override
    public int deleteInventoryByIds(Long[] ids)
    {
        return inventoryMapper.deleteInventoryByIds(ids);
    }

    /**
     * 删除货物入库信息
     * 
     * @param id 货物入库主键
     * @return 结果
     */
    @Override
    public int deleteInventoryById(Long id)
    {
        return inventoryMapper.deleteInventoryById(id);
    }
}
