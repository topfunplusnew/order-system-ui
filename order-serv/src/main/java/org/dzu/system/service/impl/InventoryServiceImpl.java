package org.dzu.system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.dzu.common.constant.DelConstants;
import org.dzu.common.exception.ServiceException;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.StringUtils;
import org.dzu.common.utils.bean.BeanUtils;
import org.dzu.system.domain.ExWarehouse;
import org.dzu.system.domain.Inventory;
import org.dzu.system.domain.InventoryBack;
import org.dzu.system.mapper.ExWarehouseMapper;
import org.dzu.system.mapper.InventoryMapper;
import org.dzu.system.service.IInventoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 库存Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class InventoryServiceImpl implements IInventoryService {
    @Autowired
    private InventoryMapper inventoryMapper;

    @Autowired
    private InventoryBackServiceImpl inventoryBackService;

    @Autowired
    private ExWarehouseMapper exWarehouseMapper;

    /**
     * 查询库存
     *
     * @param id 库存主键
     * @return 库存
     */
    @Override
    public Inventory selectInventoryById(Long id) {
        return inventoryMapper.selectInventoryById(id);
    }

    /**
     * 寻找可以出库的inventory信息
     *
     * @param inventory
     * @return
     */
    @Override
    public List<Inventory> orderByInventory(Inventory inventory) {
        return inventoryMapper.orderByInventory(inventory);
    }

    /**
     * 查询库存列表
     *
     * @param inventory 库存
     * @return 库存
     */
    @Override
    public List<Inventory> selectInventoryList(Inventory inventory) {
        return inventoryMapper.selectInventoryList(inventory);
    }

    /**
     * 新增库存
     *
     * @param inventory 库存
     * @return 结果
     */
    @Override
    public int insertInventory(Inventory inventory) {
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
    public int updateInventory(Inventory inventory) {
        // 设置基础信息
        inventory.setUserId(SecurityUtils.getUserId());
        inventory.setUserName(SecurityUtils.getUserTruename());
        inventory.setUpdateTime(DateUtils.getNowDate());
        // 进行备份
        copyTobacb(inventory);
        // 修改需要确定不会影响到现有的出库信息

        // 1 先手机原有的库存信息i
        Inventory old = selectInventoryById(inventory.getId());
        if (StringUtils.isNull(old)) {
            throw new ServiceException("搜索数据失败，可能已经被删除，请刷新页面后重试");
        }
        // 2 收集对应的所有出库信息
        List<ExWarehouse> exWarehouses = exWarehouseMapper.selectList(new QueryWrapper<ExWarehouse>().eq("storeID", inventory.getId()));

        if (exWarehouses.size() == 0) {
            // 没有出库，直接放行修改
            return inventoryMapper.updateInventory(inventory);
        } else {
            // 判断新旧信息除了库存数量外是否有其他不同，如果有，则拒绝修改，因为已经根据这些信息创建了订单了
            if(hasOtherChanges(inventory, old)){
                throw new ServiceException("本次修改中除了库存数量和司机信息，其他信息发生了变化，由于已经产生订单，无法修改！");
            }

            // 3 判断本次修改是增多了还是减少了库存
            if (inventory.getStockNumber() > old.getStockNumber()) {
                // 增加了库存
                // 3.2 增加无所谓，直接放行
            } else {
                // 减少了库存
                // 3.1.1 判断是否有出库信息
                if (exWarehouses.size() > 0) {
                    // 3.1.2 有出库信息，判断是否有足够的库存
                    Long sum = exWarehouses.stream().mapToLong(ExWarehouse::getOutAmount).sum();
                    if (sum > inventory.getStockNumber()) {
                        throw new ServiceException("本次修改增加后，库存不足以支持已有的出库信息，请先处理订单部分！");
                    }
                }
            }
        }

        return inventoryMapper.updateInventory(inventory);
    }

    /**
     * 批量删除库存
     *
     * @param ids 需要删除的库存主键
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class, isolation = Isolation.SERIALIZABLE)// 多次sql，故开启事务
    public int deleteInventoryByIds(Long[] ids) {
        // 需要确定没有出库信息！
        new QueryWrapper<ExWarehouse>().in("storeID", ids);
        if (exWarehouseMapper.selectCount(new QueryWrapper<ExWarehouse>().in("storeID", ids)) > 0) {
            throw new RuntimeException("本次删除中含有出已库信息，无法删除！");
        }
        return inventoryMapper.deleteInventoryByIds(ids);
    }

    /**
     * 删除库存信息
     *
     * @param id 库存主键
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class, isolation = Isolation.SERIALIZABLE)// 多次sql，故开启事务
    public int deleteInventoryById(Long id) {
        // 根据id判断是不是有出库信息
        new QueryWrapper<ExWarehouse>().eq("storeID", id);
        if (exWarehouseMapper.selectCount(new QueryWrapper<ExWarehouse>().eq("storeID", id)) > 0) {
            throw new RuntimeException("本次删除中含有出库信息，无法删除！");
        }
        return inventoryMapper.deleteInventoryById(id);
    }


    private void copyTobacb(Inventory inventory) {
        // 创建一个备份类
        InventoryBack inventoryBack = new InventoryBack();
        BeanUtils.copyProperties(inventory, inventoryBack);
        // 调整一下错误拷贝的id
        inventoryBack.setInventoryID(inventory.getId());
        inventoryBack.setId(null);
        // 插入信息，由对应业务层补充杂项信息
        inventoryBackService.insertInventoryBack(inventoryBack);
    }

    /**
     * 判断除了库存数量外，是否有其他信息发生了变化
     * @param newInfo
     * @param oldInfo
     * @return
     */

private boolean hasOtherChanges(Inventory newInfo, Inventory oldInfo) {
    // 仓库ID
    if (!newInfo.getStoreHouseid().equals(oldInfo.getStoreHouseid())) return true;
    // 仓库名称
    if (!newInfo.getStoreHouseName().equals(oldInfo.getStoreHouseName())) return true;
    // 入库日期
    if (!newInfo.getStoreDate().equals(oldInfo.getStoreDate())) return true;
    // 供应商
    if (!newInfo.getSupplier().equals(oldInfo.getSupplier())) return true;
    // 供应商ID
    if (!newInfo.getSupplierId().equals(oldInfo.getSupplierId())) return true;
    // 级别编码
    if (!newInfo.getLevelID().equals(oldInfo.getLevelID())) return true;
    // 级别名称
    if (!newInfo.getLevelName().equals(oldInfo.getLevelName())) return true;
    // 计量单位
    if (!newInfo.getCountingUnit().equals(oldInfo.getCountingUnit())) return true;
    // 厚度
    if (!newInfo.getHeight().equals(oldInfo.getHeight())) return true;
    // 长度
    if (!newInfo.getLength().equals(oldInfo.getLength())) return true;
    // 宽度
    if (!newInfo.getWidth().equals(oldInfo.getWidth())) return true;
    // 出厂片数
    if (!newInfo.getPieces().equals(oldInfo.getPieces())) return true;
    // 每包片数
    if (!newInfo.getPiecesPerPack().equals(oldInfo.getPiecesPerPack())) return true;
    // 包数
    if (!newInfo.getPacks().equals(oldInfo.getPacks())) return true;
    // 出厂单价
    if (!newInfo.getPrice().equals(oldInfo.getPrice())) return true;
    // 出厂是否含税
    if (!newInfo.getIsIncludeTaxFactory().equals(oldInfo.getIsIncludeTaxFactory())) return true;
    // 杂费
    if (!newInfo.getSundryCost().equals(oldInfo.getSundryCost())) return true;
    // 出厂货款
    if (!newInfo.getPaymentFactory().equals(oldInfo.getPaymentFactory())) return true;
    // 卸货价
    if (!newInfo.getPaymentUnload().equals(oldInfo.getPaymentUnload())) return true;
    // 销售是否含税
    if (!newInfo.getIsIncludeTaxSale().equals(oldInfo.getIsIncludeTaxSale())) return true;
    // 总货款
    if (!newInfo.getSeaDriverName().equals(oldInfo.getSeaDriverName())) return true;
    // 误差
    if (!newInfo.getErro().equals(oldInfo.getErro())) return true;
    // 吨位
    if (!newInfo.getTonnage().equals(oldInfo.getTonnage())) return true;
    // 陆运费单价
    if (!newInfo.getLandFreightPrice().equals(oldInfo.getLandFreightPrice())) return true;
    // 陆运费
    if (!newInfo.getLandFreight().equals(oldInfo.getLandFreight())) return true;
    // 海运费
    if (!newInfo.getSeaFreight().equals(oldInfo.getSeaFreight())) return true;
    // 运费
    if (!newInfo.getFreight().equals(oldInfo.getFreight())) return true;
    // 其他费用
    if (!newInfo.getOtherCost().equals(oldInfo.getOtherCost())) return true;
    // 利润
    if (!newInfo.getProfit().equals(oldInfo.getProfit())) return true;
    // 不含税利润
    if (!newInfo.getProfitNoTax().equals(oldInfo.getProfitNoTax())) return true;
    // 实际片数
    if (!newInfo.getActualPieces().equals(oldInfo.getActualPieces())) return true;
    // 总货款杂费
    if (!newInfo.getPaymentsWithSundry().equals(oldInfo.getPaymentsWithSundry())) return true;
    // 加费
    if (!newInfo.getAdditionalFees().equals(oldInfo.getAdditionalFees())) return true;
    // 返利金额
    if (!newInfo.getRebate().equals(oldInfo.getRebate())) return true;
    // 客户佣金
    if (!newInfo.getCustomerCommission().equals(oldInfo.getCustomerCommission())) return true;
    // 备注


    return false;
}
}
