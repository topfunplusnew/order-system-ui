package org.dzu.system.controller;

import java.util.List;
import javax.servlet.http.HttpServletResponse;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.dzu.common.annotation.Log;
import org.dzu.common.core.controller.BaseController;
import org.dzu.common.core.domain.AjaxResult;
import org.dzu.common.enums.BusinessType;
import org.dzu.system.domain.InventoryBack;
import org.dzu.system.service.IInventoryBackService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 货物入库信息Controller
 * 
 * @author ml
 * @date 2024-07-19
 */
@RestController
@RequestMapping("/system/inventoryback")
public class InventoryBackController extends BaseController
{
    @Autowired
    private IInventoryBackService inventoryBackService;

    /**
     * 查询货物入库信息列表
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
     * 导出货物入库信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:back:export')")
    @Log(title = "货物入库信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, InventoryBack inventoryBack)
    {
        List<InventoryBack> list = inventoryBackService.selectInventoryBackList(inventoryBack);
        ExcelUtil<InventoryBack> util = new ExcelUtil<InventoryBack>(InventoryBack.class);
        util.exportExcel(response, list, "货物入库信息数据");
    }

    /**
     * 获取货物入库信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:back:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(inventoryBackService.selectInventoryBackById(id));
    }

    /**
     * 新增货物入库信息
     */
    @PreAuthorize("@ss.hasPermi('system:back:add')")
    @Log(title = "货物入库信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody InventoryBack inventoryBack)
    {
        return toAjax(inventoryBackService.insertInventoryBack(inventoryBack));
    }

    /**
     * 修改货物入库信息
     */
    @PreAuthorize("@ss.hasPermi('system:back:edit')")
    @Log(title = "货物入库信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody InventoryBack inventoryBack)
    {
        return toAjax(inventoryBackService.updateInventoryBack(inventoryBack));
    }

    /**
     * 删除货物入库信息
     */
    @PreAuthorize("@ss.hasPermi('system:back:remove')")
    @Log(title = "货物入库信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(inventoryBackService.deleteInventoryBackByIds(ids));
    }
}
