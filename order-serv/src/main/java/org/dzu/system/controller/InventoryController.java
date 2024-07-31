package org.dzu.system.controller;

import org.dzu.common.annotation.Log;
import org.dzu.common.core.controller.BaseController;
import org.dzu.common.core.domain.AjaxResult;
import org.dzu.common.core.page.TableDataInfo;
import org.dzu.common.enums.BusinessType;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.system.domain.Inventory;
import org.dzu.system.service.IInventoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 库存Controller
 *
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/inventory")
public class InventoryController extends BaseController {
    @Autowired
    private IInventoryService inventoryService;

    /**
     * 查询库存列表
     */
    @PreAuthorize("@ss.hasPermi('system:inventory:list')")
    @GetMapping("/list")
    public TableDataInfo list(Inventory inventory) {
        startPage();
        List<Inventory> list = inventoryService.selectInventoryList(inventory);
        return getDataTable(list);
    }

    /**
     * 查询库存列表
     */
    @PreAuthorize("@ss.hasPermi('system:inventory:list')")
    @GetMapping("/canOrderByInventory")
    public TableDataInfo canOrderByInventory(Inventory inventory) {
        startPage();
        List<Inventory> list = inventoryService.orderByInventory(inventory);
        return getDataTable(list);
    }

    /**
     * 导出库存列表
     */
    @PreAuthorize("@ss.hasPermi('system:inventory:export')")
    @Log(title = "库存", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Inventory inventory) {
        List<Inventory> list = inventoryService.selectInventoryList(inventory);
        ExcelUtil<Inventory> util = new ExcelUtil<Inventory>(Inventory.class);
        util.exportExcel(response, list, "库存数据");
    }

    /**
     * 获取库存详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:inventory:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id) {
        return success(inventoryService.selectInventoryById(id));
    }

    /**
     * 新增库存
     */
    @PreAuthorize("@ss.hasPermi('system:inventory:add')")
    @Log(title = "库存", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody Inventory inventory) {
        return toAjax(inventoryService.insertInventory(inventory));
    }

    /**
     * 修改库存
     */
    @PreAuthorize("@ss.hasPermi('system:inventory:edit')")
    @Log(title = "库存", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody Inventory inventory) {
        return toAjax(inventoryService.updateInventory(inventory));
    }

    /**
     * 删除库存
     */
    @PreAuthorize("@ss.hasPermi('system:inventory:remove')")
    @Log(title = "库存", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids) {
        return toAjax(inventoryService.deleteInventoryByIds(ids));
    }
}
