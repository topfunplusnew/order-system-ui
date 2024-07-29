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
import org.dzu.system.domain.FixedAssets;
import org.dzu.system.service.IFixedAssetsService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

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
    @PreAuthorize("@ss.hasPermi('system:fixedAssets:list')")
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
    @PreAuthorize("@ss.hasPermi('system:fixedAssets:export')")
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
    @PreAuthorize("@ss.hasPermi('system:fixedAssets:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(fixedAssetsService.selectFixedAssetsById(id));
    }

    /**
     * 新增固定资产
     */
    @PreAuthorize("@ss.hasPermi('system:fixedAssets:add')")
    @Log(title = "固定资产", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody FixedAssets fixedAssets)
    {
        return toAjax(fixedAssetsService.insertFixedAssets(fixedAssets));
    }

    /**
     * 修改固定资产
     */
    @PreAuthorize("@ss.hasPermi('system:fixedAssets:edit')")
    @Log(title = "固定资产", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody FixedAssets fixedAssets)
    {
        return toAjax(fixedAssetsService.updateFixedAssets(fixedAssets));
    }

    /**
     * 删除固定资产
     */
    @PreAuthorize("@ss.hasPermi('system:fixedAssets:remove')")
    @Log(title = "固定资产", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(fixedAssetsService.deleteFixedAssetsByIds(ids));
    }
}
