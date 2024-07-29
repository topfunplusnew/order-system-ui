package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.InventoryBackMapper;
import org.dzu.system.domain.InventoryBack;
import org.dzu.system.service.IInventoryBackService;
 
import org.dzu.common.constant.DelConstants;
/**
 * 货物入库信息Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class InventoryBackServiceImpl implements IInventoryBackService
{
    @Autowired
    private InventoryBackMapper inventoryBackMapper;

    /**
     * 查询货物入库信息
     *
     * @param id 货物入库信息主键
     * @return 货物入库信息
     */
    @Override
    public InventoryBack selectInventoryBackById(Long id)
    {
        return inventoryBackMapper.selectInventoryBackById(id);
    }

    /**
     * 查询货物入库信息列表
     *
     * @param inventoryBack 货物入库信息
     * @return 货物入库信息
     */
    @Override
    public List<InventoryBack> selectInventoryBackList(InventoryBack inventoryBack)
    {
        return inventoryBackMapper.selectInventoryBackList(inventoryBack);
    }

    /**
     * 新增货物入库信息
     *
     * @param inventoryBack 货物入库信息
     * @return 结果
     */
    @Override
    public int insertInventoryBack(InventoryBack inventoryBack)
    {
        inventoryBack.setAddtime(String.valueOf(DateUtils.getNowDate()));
        inventoryBack.setUserId(SecurityUtils.getUserId());
        inventoryBack.setUserName(SecurityUtils.getUserTruename());
        inventoryBack.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return inventoryBackMapper.insertInventoryBack(inventoryBack);
    }

    /**
     * 修改货物入库信息
     * 
     * @param inventoryBack 货物入库信息
     * @return 结果
     */
    @Override
    public int updateInventoryBack(InventoryBack inventoryBack)
    {
        inventoryBack.setUserId(SecurityUtils.getUserId());
        inventoryBack.setUserName(SecurityUtils.getUserTruename());
        inventoryBack.setUpdateTime(DateUtils.getNowDate());
        return inventoryBackMapper.updateInventoryBack(inventoryBack);
    }

    /**
     * 批量删除货物入库信息
     * 
     * @param ids 需要删除的货物入库信息主键
     * @return 结果
     */
    @Override
    public int deleteInventoryBackByIds(Long[] ids)
    {
        return inventoryBackMapper.deleteInventoryBackByIds(ids);
    }

    /**
     * 删除货物入库信息信息
     * 
     * @param id 货物入库信息主键
     * @return 结果
     */
    @Override
    public int deleteInventoryBackById(Long id)
    {
        return inventoryBackMapper.deleteInventoryBackById(id);
    }
}
