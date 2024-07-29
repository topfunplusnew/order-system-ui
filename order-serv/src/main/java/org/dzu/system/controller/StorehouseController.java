package org.dzu.system.controller;

import java.util.List;
import javax.servlet.http.HttpServletResponse;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
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
import org.dzu.system.domain.Storehouse;
import org.dzu.system.service.IStorehouseService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 仓库管理Controller
 * 
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/storehouse")
public class StorehouseController extends BaseController
{
    @Autowired
    private IStorehouseService storehouseService;

    /**
     * 查询仓库管理列表
     */
    @PreAuthorize("@ss.hasPermi('system:storehouse:list')")
    @GetMapping("/list")
    public TableDataInfo list(Storehouse storehouse)
    {
        startPage();
        List<Storehouse> list = storehouseService.selectStorehouseList(storehouse);
        return getDataTable(list);
    }

    /**
     * 导出仓库管理列表
     */
    @PreAuthorize("@ss.hasPermi('system:storehouse:export')")
    @Log(title = "仓库管理", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Storehouse storehouse)
    {
        List<Storehouse> list = storehouseService.selectStorehouseList(storehouse);
        ExcelUtil<Storehouse> util = new ExcelUtil<Storehouse>(Storehouse.class);
        util.exportExcel(response, list, "仓库管理数据");
    }

    /**
     * 获取仓库管理详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:storehouse:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(storehouseService.selectStorehouseById(id));
    }

    /**
     * 新增仓库管理
     */
    @PreAuthorize("@ss.hasPermi('system:storehouse:add')")
    @Log(title = "仓库管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody Storehouse storehouse)
    {
        return toAjax(storehouseService.insertStorehouse(storehouse));
    }

    /**
     * 修改仓库管理
     */
    @PreAuthorize("@ss.hasPermi('system:storehouse:edit')")
    @Log(title = "仓库管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody Storehouse storehouse)
    {
        return toAjax(storehouseService.updateStorehouse(storehouse));
    }

    /**
     * 删除仓库管理
     */
    @PreAuthorize("@ss.hasPermi('system:storehouse:remove')")
    @Log(title = "仓库管理", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(storehouseService.deleteStorehouseByIds(ids));
    }
}
