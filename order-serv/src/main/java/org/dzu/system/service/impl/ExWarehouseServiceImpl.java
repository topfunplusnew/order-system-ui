package org.dzu.system.service.impl;

import java.util.List;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.dzu.common.exception.ServiceException;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.StringUtils;
import org.dzu.system.domain.GoodsOrder;
import org.dzu.system.domain.Inventory;
import org.dzu.system.mapper.GoodsOrderMapper;
import org.dzu.system.mapper.InventoryMapper;
import org.dzu.system.service.IInventoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.ExWarehouseMapper;
import org.dzu.system.domain.ExWarehouse;
import org.dzu.system.service.IExWarehouseService;
 
import org.dzu.common.constant.DelConstants;
import org.springframework.transaction.annotation.Transactional;

/**
 * 出库Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class ExWarehouseServiceImpl implements IExWarehouseService
{
    @Autowired
    private ExWarehouseMapper exWarehouseMapper;

    @Autowired
    private InventoryMapper inventoryMapper;

    @Autowired
    private IInventoryService inventoryService;

    @Autowired
    private GoodsOrderMapper goodsOrderMapper;

    /**
     * 查询出库
     *
     * @param id 出库主键
     * @return 出库
     */
    @Override
    public ExWarehouse selectExWarehouseById(Long id)
    {
        return exWarehouseMapper.selectExWarehouseById(id);
    }

    /**
     * 查询出库列表
     *
     * @param exWarehouse 出库
     * @return 出库
     */
    @Override
    public List<ExWarehouse> selectExWarehouseList(ExWarehouse exWarehouse)
    {
        return exWarehouseMapper.selectExWarehouseList(exWarehouse);
    }

    /**
     * 新增出库
     *
     * @param exWarehouse 出库
     * @return 结果
     */
    @Override
    public int insertExWarehouse(ExWarehouse exWarehouse)
    {
        exWarehouse.setAddtime(String.valueOf(DateUtils.getNowDate()));
        exWarehouse.setUserId(SecurityUtils.getUserId());
        exWarehouse.setUserName(SecurityUtils.getUserTruename());
        exWarehouse.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return exWarehouseMapper.insertExWarehouse(exWarehouse);
    }

    /**
     * 修改出库
     * 
     * @param exWarehouse 出库
     * @return 结果
     */
    @Override
    public int updateExWarehouse(ExWarehouse exWarehouse)
    {
        exWarehouse.setUpdateTime(DateUtils.getNowDate());
        exWarehouse.setUserId(SecurityUtils.getUserId());
        exWarehouse.setUserName(SecurityUtils.getUserTruename());
        return exWarehouseMapper.updateExWarehouse(exWarehouse);
    }

    /**
     * 批量删除出库
     * 
     * @param ids 需要删除的出库主键
     * @return 结果
     */
    @Override
    public int deleteExWarehouseByIds(Long[] ids)
    {
        return exWarehouseMapper.deleteExWarehouseByIds(ids);
    }

    /**
     * 删除出库信息
     * 
     * @param id 出库主键
     * @return 结果
     */
    @Override
    public int deleteExWarehouseById(Long id)
    {
        return exWarehouseMapper.deleteExWarehouseById(id);
    }

    @Override
    @Transactional
    public void InventoryToEx(Long InventoryId, Long outAmount, String OrderNo, String outDate) {
        Inventory inventory = inventoryMapper.selectInventoryById(InventoryId);
        if (StringUtils.isNull(inventory)) {
            throw new ServiceException("库存不存在");
        }
        if (inventory.getStockNumber() < outAmount) {
            throw new ServiceException("库存不足");
        }
        inventory.setStockNumber(inventory.getStockNumber() - outAmount);
        // 写回
        inventoryMapper.updateInventory(inventory);

        // 进行校验
        QueryWrapper<GoodsOrder> eq = new QueryWrapper<GoodsOrder>().eq("orderNo", OrderNo).eq("cancelFlag", DelConstants.NODEL);
        GoodsOrder goodsOrder = goodsOrderMapper.selectOne(eq);
        if(StringUtils.isNull(goodsOrder)){
            throw new ServiceException("订单不存在");
        }

        // 出库
        ExWarehouse exWarehouse = new ExWarehouse();
        exWarehouse.setOrdersNo(OrderNo);
        exWarehouse.setOutAmount(outAmount);
        exWarehouse.setOutDate(outDate);

        insertExWarehouse(exWarehouse);
    }

}
