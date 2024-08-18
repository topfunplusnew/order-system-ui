package org.dzu.system.service.impl;

import org.dzu.common.constant.DelConstants;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.system.domain.InventoryBack;
import org.dzu.system.mapper.InventoryBackMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
/**
 * 库存备份Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class InventoryBackServiceImpl {
    @Autowired
    private InventoryBackMapper inventoryBackMapper;

    /**
     * 查询库存备份
     *
     * @param id 库存备份主键
     * @return 库存备份
     */
    public InventoryBack selectInventoryBackById(Long id)
    {
        return inventoryBackMapper.selectInventoryBackById(id);
    }

    /**
     * 查询库存备份列表
     *
     * @param inventoryBack 库存备份
     * @return 库存备份
     */
    public List<InventoryBack> selectInventoryBackList(InventoryBack inventoryBack)
    {
        return inventoryBackMapper.selectInventoryBackList(inventoryBack);
    }

    /**
     * 新增库存备份
     *
     * @param inventoryBack 库存备份
     * @return 结果
     */
    public int insertInventoryBack(InventoryBack inventoryBack)
    {
        inventoryBack.setAddtime(String.valueOf(DateUtils.getNowDate()));
        inventoryBack.setUserId(SecurityUtils.getUserId());
        inventoryBack.setUserName(SecurityUtils.getUserTruename());
        inventoryBack.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return inventoryBackMapper.insertInventoryBack(inventoryBack);
    }

    /**
     * 修改库存备份
     * 
     * @param inventoryBack 库存备份
     * @return 结果
     */
    public int updateInventoryBack(InventoryBack inventoryBack)
    {
        inventoryBack.setUserId(SecurityUtils.getUserId());
        inventoryBack.setUserName(SecurityUtils.getUserTruename());
        inventoryBack.setUpdateTime(DateUtils.getNowDate());
        return inventoryBackMapper.updateInventoryBack(inventoryBack);
    }

    /**
     * 批量删除库存备份
     * 
     * @param ids 需要删除的库存备份主键
     * @return 结果
     */
    public int deleteInventoryBackByIds(Long[] ids)
    {
        return inventoryBackMapper.deleteInventoryBackByIds(ids);
    }

    /**
     * 删除库存备份信息
     * 
     * @param id 库存备份主键
     * @return 结果
     */
    public int deleteInventoryBackById(Long id)
    {
        return inventoryBackMapper.deleteInventoryBackById(id);
    }
}
