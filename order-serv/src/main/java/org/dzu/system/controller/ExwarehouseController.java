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
import org.dzu.system.domain.Exwarehouse;
import org.dzu.system.service.IExwarehouseService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 出库信息Controller
 * 
 * @author ml
 * @date 2024-07-18
 */
@RestController
@RequestMapping("/system/exwarehouse")
public class ExwarehouseController extends BaseController
{
    @Autowired
    private IExwarehouseService exwarehouseService;

    /**
     * 查询出库信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:exwarehouse:list')")
    @GetMapping("/list")
    public TableDataInfo list(Exwarehouse exwarehouse)
    {
        startPage();
        List<Exwarehouse> list = exwarehouseService.selectExwarehouseList(exwarehouse);
        return getDataTable(list);
    }

    /**
     * 导出出库信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:exwarehouse:export')")
    @Log(title = "出库信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Exwarehouse exwarehouse)
    {
        List<Exwarehouse> list = exwarehouseService.selectExwarehouseList(exwarehouse);
        ExcelUtil<Exwarehouse> util = new ExcelUtil<Exwarehouse>(Exwarehouse.class);
        util.exportExcel(response, list, "出库信息数据");
    }

    /**
     * 获取出库信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:exwarehouse:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(exwarehouseService.selectExwarehouseById(id));
    }

    /**
     * 新增出库信息
     */
    @PreAuthorize("@ss.hasPermi('system:exwarehouse:add')")
    @Log(title = "出库信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Exwarehouse exwarehouse)
    {
        return toAjax(exwarehouseService.insertExwarehouse(exwarehouse));
    }

    /**
     * 修改出库信息
     */
    @PreAuthorize("@ss.hasPermi('system:exwarehouse:edit')")
    @Log(title = "出库信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Exwarehouse exwarehouse)
    {
        return toAjax(exwarehouseService.updateExwarehouse(exwarehouse));
    }

    /**
     * 删除出库信息
     */
    @PreAuthorize("@ss.hasPermi('system:exwarehouse:remove')")
    @Log(title = "出库信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(exwarehouseService.deleteExwarehouseByIds(ids));
    }
}
