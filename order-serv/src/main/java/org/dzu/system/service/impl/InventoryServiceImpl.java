package org.dzu.system.service.impl;

import java.util.List;

import com.fasterxml.jackson.databind.util.BeanUtil;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.bean.BeanUtils;
import org.dzu.common.utils.spring.SpringUtils;
import org.dzu.system.domain.InventoryBack;
import org.dzu.system.mapper.InventoryBackMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.InventoryMapper;
import org.dzu.system.domain.Inventory;
import org.dzu.system.service.IInventoryService;
 
import org.dzu.common.constant.DelConstants;
import org.springframework.transaction.annotation.Transactional;

/**
 * 库存Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class InventoryServiceImpl implements IInventoryService
{
    @Autowired
    private InventoryMapper inventoryMapper;

    @Autowired
    private InventoryBackServiceImpl inventoryBackService;
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
     * 寻找可以出库的inventory信息
     * @param inventory
     * @return
     */
    @Override
    public List<Inventory> orderByInventory(Inventory inventory){
        return inventoryMapper.orderByInventory(inventory);
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
        // 设置基础属性
        inventory.setPieces(inventory.getStockNumber());
        inventory.setAddtime(String.valueOf(DateUtils.getNowDate()));
        inventory.setUserId(SecurityUtils.getUserId());
        inventory.setUserName(SecurityUtils.getUserTruename());
        inventory.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return inventoryMapper.insertInventory(inventory);
    }

    /**
     * 修改库存
     * 
     * @param inventory 库存
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)// 多次sql，故开启事务
    public int updateInventory(Inventory inventory)
    {
        // 设置基础信息
        inventory.setUserId(SecurityUtils.getUserId());
        inventory.setUserName(SecurityUtils.getUserTruename());
        inventory.setUpdateTime(DateUtils.getNowDate());
        // 进行备份
        copyTobacb(inventory);
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


    private void copyTobacb(Inventory inventory){
        // 创建一个备份类
        InventoryBack inventoryBack = new InventoryBack();
        BeanUtils.copyProperties(inventory,inventoryBack);
        // 调整一下错误拷贝的id
        inventoryBack.setInventoryID(inventory.getId());
        inventoryBack.setId(null);
        // 插入信息，由对应业务层补充杂项信息
        inventoryBackService.insertInventoryBack(inventoryBack);
    }

}
