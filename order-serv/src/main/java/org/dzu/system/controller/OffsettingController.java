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
import org.dzu.system.domain.Offsetting;
import org.dzu.system.service.IOffsettingService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 资金调整单信息Controller
 * 
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/offsetting")
public class OffsettingController extends BaseController
{
    @Autowired
    private IOffsettingService offsettingService;

    /**
     * 查询资金调整单信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:offsetting:list')")
    @GetMapping("/list")
    public TableDataInfo list(Offsetting offsetting)
    {
        startPage();
        List<Offsetting> list = offsettingService.selectOffsettingList(offsetting);
        return getDataTable(list);
    }

    /**
     * 导出资金调整单信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:offsetting:export')")
    @Log(title = "资金调整单信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Offsetting offsetting)
    {
        List<Offsetting> list = offsettingService.selectOffsettingList(offsetting);
        ExcelUtil<Offsetting> util = new ExcelUtil<Offsetting>(Offsetting.class);
        util.exportExcel(response, list, "资金调整单信息数据");
    }

    /**
     * 获取资金调整单信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:offsetting:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(offsettingService.selectOffsettingById(id));
    }

    /**
     * 新增资金调整单信息
     */
    @PreAuthorize("@ss.hasPermi('system:offsetting:add')")
    @Log(title = "资金调整单信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody Offsetting offsetting)
    {
        return toAjax(offsettingService.insertOffsetting(offsetting));
    }

    /**
     * 修改资金调整单信息
     */
    @PreAuthorize("@ss.hasPermi('system:offsetting:edit')")
    @Log(title = "资金调整单信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody Offsetting offsetting)
    {
        return toAjax(offsettingService.updateOffsetting(offsetting));
    }

    /**
     * 删除资金调整单信息
     */
    @PreAuthorize("@ss.hasPermi('system:offsetting:remove')")
    @Log(title = "资金调整单信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(offsettingService.deleteOffsettingByIds(ids));
    }
}
