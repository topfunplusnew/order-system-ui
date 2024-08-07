package org.dzu.system.controller;

import org.dzu.common.annotation.Log;
import org.dzu.common.core.controller.BaseController;
import org.dzu.common.core.domain.AjaxResult;
import org.dzu.common.core.page.TableDataInfo;
import org.dzu.common.enums.BusinessType;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.system.domain.FixedAssets;
import org.dzu.system.service.IFixedAssetsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 固定资产Controller
 * 
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/fixedAssets")
public class FixedAssetsController extends BaseController
{
    @Autowired
    private IFixedAssetsService fixedAssetsService;

    /**
     * 查询固定资产列表
     */
    @PreAuthorize("@ss.hasPermi('system:fixedassets:list')")
    @GetMapping("/list")
    public TableDataInfo list(FixedAssets fixedAssets)
    {
        startPage();
        List<FixedAssets> list = fixedAssetsService.selectFixedAssetsList(fixedAssets);
        return getDataTable(list);
    }

    /**
     * 导出固定资产列表
     */
    @PreAuthorize("@ss.hasPermi('system:fixedassets:export')")
    @Log(title = "固定资产", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, FixedAssets fixedAssets)
    {
        List<FixedAssets> list = fixedAssetsService.selectFixedAssetsList(fixedAssets);
        ExcelUtil<FixedAssets> util = new ExcelUtil<FixedAssets>(FixedAssets.class);
        util.exportExcel(response, list, "固定资产数据");
    }

    /**
     * 获取固定资产详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:fixedassets:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(fixedAssetsService.selectFixedAssetsById(id));
    }

    /**
     * 新增固定资产
     */
    @PreAuthorize("@ss.hasPermi('system:fixedassets:add')")
    @Log(title = "固定资产", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody FixedAssets fixedAssets)
    {
        return toAjax(fixedAssetsService.insertFixedAssets(fixedAssets));
    }

    /**
     * 修改固定资产
     */
    @PreAuthorize("@ss.hasPermi('system:fixedassets:edit')")
    @Log(title = "固定资产", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody FixedAssets fixedAssets)
    {
        return toAjax(fixedAssetsService.updateFixedAssets(fixedAssets));
    }

    /**
     * 删除固定资产
     */
    @PreAuthorize("@ss.hasPermi('system:fixedassets:remove')")
    @Log(title = "固定资产", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(fixedAssetsService.deleteFixedAssetsByIds(ids));
    }
}
