package org.dzu.system.controller;

import org.dzu.common.annotation.Log;
import org.dzu.common.core.controller.BaseController;
import org.dzu.common.core.domain.AjaxResult;
import org.dzu.common.core.page.TableDataInfo;
import org.dzu.common.enums.BusinessType;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.system.domain.ExWarehouse;
import org.dzu.system.service.IExWarehouseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 出库Controller
 *
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/exWarehouse")
public class ExWarehouseController extends BaseController {
    @Autowired
    private IExWarehouseService exWarehouseService;

    /**
     * 查询出库列表
     */
    @PreAuthorize("@ss.hasPermi('system:exwarehouse:list')")
    @GetMapping("/list")
    public TableDataInfo list(ExWarehouse exWarehouse) {
        startPage();
        List<ExWarehouse> list = exWarehouseService.selectExWarehouseList(exWarehouse);
        return getDataTable(list);
    }

    /**
     * 导出出库列表
     */
    @PreAuthorize("@ss.hasPermi('system:exwarehouse:export')")
    @Log(title = "出库", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, ExWarehouse exWarehouse) {
        List<ExWarehouse> list = exWarehouseService.selectExWarehouseList(exWarehouse);
        ExcelUtil<ExWarehouse> util = new ExcelUtil<ExWarehouse>(ExWarehouse.class);
        util.exportExcel(response, list, "出库数据");
    }

    /**
     * 获取出库详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:exwarehouse:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id) {
        return success(exWarehouseService.selectExWarehouseById(id));
    }

    /**
     * 新增出库
     */
    @PreAuthorize("@ss.hasPermi('system:exWarehouse:add')")
    @Log(title = "出库", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody ExWarehouse exWarehouse) {
        return toAjax(exWarehouseService.insertExWarehouseByFront(exWarehouse));
    }
    /**
     * 修改出库
     */
    @PreAuthorize("@ss.hasPermi('system:exwarehouse:edit')")
    @Log(title = "出库", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody ExWarehouse exwarehouse)
    {
        return toAjax(exWarehouseService.updateExWarehouse(exwarehouse));
    }

    /**
     * 删除出库
     */
    @PreAuthorize("@ss.hasPermi('system:exwarehouse:remove')")
    @Log(title = "出库", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(exWarehouseService.deleteExWarehouseByIds(ids));
    }
}
