package org.dzu.system.controller;

import org.dzu.common.annotation.Log;
import org.dzu.common.core.controller.BaseController;
import org.dzu.common.core.domain.AjaxResult;
import org.dzu.common.core.page.TableDataInfo;
import org.dzu.common.enums.BusinessType;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.system.domain.InventoryBack;
import org.dzu.system.service.IInventoryBackService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 库存备份Controller
 * 
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/inentoryBack")
public class InventoryBackController extends BaseController
{
    @Autowired
    private IInventoryBackService inventoryBackService;

    /**
     * 查询库存备份列表
     */
    @PreAuthorize("@ss.hasPermi('system:back:list')")
    @GetMapping("/list")
    public TableDataInfo list(InventoryBack inventoryBack)
    {
        startPage();
        List<InventoryBack> list = inventoryBackService.selectInventoryBackList(inventoryBack);
        return getDataTable(list);
    }

    /**
     * 导出库存备份列表
     */
    @PreAuthorize("@ss.hasPermi('system:back:export')")
    @Log(title = "库存备份", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, InventoryBack inventoryBack)
    {
        List<InventoryBack> list = inventoryBackService.selectInventoryBackList(inventoryBack);
        ExcelUtil<InventoryBack> util = new ExcelUtil<InventoryBack>(InventoryBack.class);
        util.exportExcel(response, list, "库存备份数据");
    }

    /**
     * 获取库存备份详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:back:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(inventoryBackService.selectInventoryBackById(id));
    }

    /**
     * 新增库存备份
     */
    @PreAuthorize("@ss.hasPermi('system:back:add')")
    @Log(title = "库存备份", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody InventoryBack inventoryBack)
    {
        return toAjax(inventoryBackService.insertInventoryBack(inventoryBack));
    }

    /**
     * 修改库存备份
     */
    @PreAuthorize("@ss.hasPermi('system:back:edit')")
    @Log(title = "库存备份", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody InventoryBack inventoryBack)
    {
        return toAjax(inventoryBackService.updateInventoryBack(inventoryBack));
    }

    /**
     * 删除库存备份
     */
    @PreAuthorize("@ss.hasPermi('system:back:remove')")
    @Log(title = "库存备份", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(inventoryBackService.deleteInventoryBackByIds(ids));
    }
}
