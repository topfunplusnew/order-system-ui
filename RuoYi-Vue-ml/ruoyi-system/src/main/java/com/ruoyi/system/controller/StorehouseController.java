package com.ruoyi.system.controller;

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
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.Storehouse;
import com.ruoyi.system.service.IStorehouseService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 仓库信息Controller
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
@RestController
@RequestMapping("/system/storehouse")
public class StorehouseController extends BaseController
{
    @Autowired
    private IStorehouseService storehouseService;

    /**
     * 查询仓库信息列表
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
     * 导出仓库信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:storehouse:export')")
    @Log(title = "仓库信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Storehouse storehouse)
    {
        List<Storehouse> list = storehouseService.selectStorehouseList(storehouse);
        ExcelUtil<Storehouse> util = new ExcelUtil<Storehouse>(Storehouse.class);
        util.exportExcel(response, list, "仓库信息数据");
    }

    /**
     * 获取仓库信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:storehouse:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(storehouseService.selectStorehouseById(id));
    }

    /**
     * 新增仓库信息
     */
    @PreAuthorize("@ss.hasPermi('system:storehouse:add')")
    @Log(title = "仓库信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Storehouse storehouse)
    {
        return toAjax(storehouseService.insertStorehouse(storehouse));
    }

    /**
     * 修改仓库信息
     */
    @PreAuthorize("@ss.hasPermi('system:storehouse:edit')")
    @Log(title = "仓库信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Storehouse storehouse)
    {
        return toAjax(storehouseService.updateStorehouse(storehouse));
    }

    /**
     * 删除仓库信息
     */
    @PreAuthorize("@ss.hasPermi('system:storehouse:remove')")
    @Log(title = "仓库信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(storehouseService.deleteStorehouseByIds(ids));
    }
}
