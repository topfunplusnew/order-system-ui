package org.dzu.system.controller;

import org.dzu.common.annotation.Log;
import org.dzu.common.core.controller.BaseController;
import org.dzu.common.core.domain.AjaxResult;
import org.dzu.common.core.page.TableDataInfo;
import org.dzu.common.enums.BusinessType;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.system.domain.Futuresmargin;
import org.dzu.system.service.IFuturesmarginService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 期货保证金信息Controller
 * 
 * @author ml
 * @date 2024-07-18
 */
@RestController
@RequestMapping("/system/futuresmargin")
public class FuturesmarginController extends BaseController
{
    @Autowired
    private IFuturesmarginService futuresmarginService;

    /**
     * 查询期货保证金信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:futuresmargin:list')")
    @GetMapping("/list")
    public TableDataInfo list(Futuresmargin futuresmargin)
    {
        startPage();
        List<Futuresmargin> list = futuresmarginService.selectFuturesmarginList(futuresmargin);
        return getDataTable(list);
    }

    /**
     * 导出期货保证金信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:futuresmargin:export')")
    @Log(title = "期货保证金信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Futuresmargin futuresmargin)
    {
        List<Futuresmargin> list = futuresmarginService.selectFuturesmarginList(futuresmargin);
        ExcelUtil<Futuresmargin> util = new ExcelUtil<Futuresmargin>(Futuresmargin.class);
        util.exportExcel(response, list, "期货保证金信息数据");
    }

    /**
     * 获取期货保证金信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:futuresmargin:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(futuresmarginService.selectFuturesmarginById(id));
    }

    /**
     * 新增期货保证金信息
     */
    @PreAuthorize("@ss.hasPermi('system:futuresmargin:add')")
    @Log(title = "期货保证金信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Futuresmargin futuresmargin)
    {
        return toAjax(futuresmarginService.insertFuturesmargin(futuresmargin));
    }

    /**
     * 修改期货保证金信息
     */
    @PreAuthorize("@ss.hasPermi('system:futuresmargin:edit')")
    @Log(title = "期货保证金信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Futuresmargin futuresmargin)
    {
        return toAjax(futuresmarginService.updateFuturesmargin(futuresmargin));
    }

    /**
     * 删除期货保证金信息
     */
    @PreAuthorize("@ss.hasPermi('system:futuresmargin:remove')")
    @Log(title = "期货保证金信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(futuresmarginService.deleteFuturesmarginByIds(ids));
    }
}
