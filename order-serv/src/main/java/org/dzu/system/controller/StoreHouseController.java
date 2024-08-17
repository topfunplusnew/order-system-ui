package org.dzu.system.controller;

import org.dzu.common.annotation.Log;
import org.dzu.common.core.controller.BaseController;
import org.dzu.common.core.domain.AjaxResult;
import org.dzu.common.core.page.TableDataInfo;
import org.dzu.common.enums.BusinessType;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.system.domain.StoreHouse;
import org.dzu.system.service.impl.StoreHouseServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 库房Controller
 * 
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/StoreHouse")
public class StoreHouseController extends BaseController
{
    @Autowired
    private StoreHouseServiceImpl storeHouseService;

    /**
     * 查询库房列表
     */
    @PreAuthorize("@ss.hasPermi('system:storehouse:list')")
    @GetMapping("/list")
    public TableDataInfo list(StoreHouse storeHouse)
    {
        startPage();
        List<StoreHouse> list = storeHouseService.selectStoreHouseList(storeHouse);
        return getDataTable(list);
    }

    /**
     * 导出库房列表
     */
    @PreAuthorize("@ss.hasPermi('system:storehouse:export')")
    @Log(title = "库房", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, StoreHouse storeHouse)
    {
        List<StoreHouse> list = storeHouseService.selectStoreHouseList(storeHouse);
        ExcelUtil<StoreHouse> util = new ExcelUtil<StoreHouse>(StoreHouse.class);
        util.exportExcel(response, list, "库房数据");
    }

    /**
     * 获取库房详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:storehouse:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(storeHouseService.selectStoreHouseById(id));
    }

    /**
     * 新增库房
     */
    @PreAuthorize("@ss.hasPermi('system:storehouse:add')")
    @Log(title = "库房", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody StoreHouse storeHouse)
    {
        return toAjax(storeHouseService.insertStoreHouse(storeHouse));
    }

    /**
     * 修改库房
     */
    @PreAuthorize("@ss.hasPermi('system:storehouse:edit')")
    @Log(title = "库房", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody StoreHouse storeHouse)
    {
        return toAjax(storeHouseService.updateStoreHouse(storeHouse));
    }

    /**
     * 删除库房
     */
    @PreAuthorize("@ss.hasPermi('system:storehouse:remove')")
    @Log(title = "库房", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(storeHouseService.deleteStoreHouseByIds(ids));
    }
}
