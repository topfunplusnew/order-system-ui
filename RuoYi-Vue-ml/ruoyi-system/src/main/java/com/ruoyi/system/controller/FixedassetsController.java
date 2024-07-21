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
import com.ruoyi.system.domain.Fixedassets;
import com.ruoyi.system.service.IFixedassetsService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 固定资产信息Controller
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
@RestController
@RequestMapping("/system/fixedassets")
public class FixedassetsController extends BaseController
{
    @Autowired
    private IFixedassetsService fixedassetsService;

    /**
     * 查询固定资产信息列表
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
     * 导出固定资产信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:fixedassets:export')")
    @Log(title = "固定资产信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Fixedassets fixedassets)
    {
        List<Fixedassets> list = fixedassetsService.selectFixedassetsList(fixedassets);
        ExcelUtil<Fixedassets> util = new ExcelUtil<Fixedassets>(Fixedassets.class);
        util.exportExcel(response, list, "固定资产信息数据");
    }

    /**
     * 获取固定资产信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:fixedassets:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(fixedassetsService.selectFixedassetsById(id));
    }

    /**
     * 新增固定资产信息
     */
    @PreAuthorize("@ss.hasPermi('system:fixedassets:add')")
    @Log(title = "固定资产信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Fixedassets fixedassets)
    {
        return toAjax(fixedassetsService.insertFixedassets(fixedassets));
    }

    /**
     * 修改固定资产信息
     */
    @PreAuthorize("@ss.hasPermi('system:fixedassets:edit')")
    @Log(title = "固定资产信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Fixedassets fixedassets)
    {
        return toAjax(fixedassetsService.updateFixedassets(fixedassets));
    }

    /**
     * 删除固定资产信息
     */
    @PreAuthorize("@ss.hasPermi('system:fixedassets:remove')")
    @Log(title = "固定资产信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(fixedassetsService.deleteFixedassetsByIds(ids));
    }
}
