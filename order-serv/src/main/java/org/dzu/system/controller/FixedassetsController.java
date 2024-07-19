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
import org.dzu.system.domain.Fixedassets;
import org.dzu.system.service.IFixedassetsService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 固定资产Controller
 * 
 * @author ml
 * @date 2024-07-19
 */
@RestController
@RequestMapping("/system/fixedassets")
public class FixedassetsController extends BaseController
{
    @Autowired
    private IFixedassetsService fixedassetsService;

    /**
     * 查询固定资产列表
     */
    @PreAuthorize("@ss.hasPermi('system:fixedassets:list')")
    @GetMapping("/list")
    public TableDataInfo list(Fixedassets fixedassets)
    {
        startPage();
        List<Fixedassets> list = fixedassetsService.selectFixedassetsList(fixedassets);
        return getDataTable(list);
    }

    /**
     * 导出固定资产列表
     */
    @PreAuthorize("@ss.hasPermi('system:fixedassets:export')")
    @Log(title = "固定资产", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Fixedassets fixedassets)
    {
        List<Fixedassets> list = fixedassetsService.selectFixedassetsList(fixedassets);
        ExcelUtil<Fixedassets> util = new ExcelUtil<Fixedassets>(Fixedassets.class);
        util.exportExcel(response, list, "固定资产数据");
    }

    /**
     * 获取固定资产详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:fixedassets:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(fixedassetsService.selectFixedassetsById(id));
    }

    /**
     * 新增固定资产
     */
    @PreAuthorize("@ss.hasPermi('system:fixedassets:add')")
    @Log(title = "固定资产", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Fixedassets fixedassets)
    {
        return toAjax(fixedassetsService.insertFixedassets(fixedassets));
    }

    /**
     * 修改固定资产
     */
    @PreAuthorize("@ss.hasPermi('system:fixedassets:edit')")
    @Log(title = "固定资产", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Fixedassets fixedassets)
    {
        return toAjax(fixedassetsService.updateFixedassets(fixedassets));
    }

    /**
     * 删除固定资产
     */
    @PreAuthorize("@ss.hasPermi('system:fixedassets:remove')")
    @Log(title = "固定资产", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(fixedassetsService.deleteFixedassetsByIds(ids));
    }
}
