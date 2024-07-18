package org.dzu.system.controller;

import org.dzu.common.annotation.Log;
import org.dzu.common.core.controller.BaseController;
import org.dzu.common.core.domain.AjaxResult;
import org.dzu.common.core.page.TableDataInfo;
import org.dzu.common.enums.BusinessType;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.system.domain.Rebate;
import org.dzu.system.service.IRebateService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 返利信息Controller
 * 
 * @author ml
 * @date 2024-07-18
 */
@RestController
@RequestMapping("/system/rebate")
public class RebateController extends BaseController
{
    @Autowired
    private IRebateService rebateService;

    /**
     * 查询返利信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:rebate:list')")
    @GetMapping("/list")
    public TableDataInfo list(Rebate rebate)
    {
        startPage();
        List<Rebate> list = rebateService.selectRebateList(rebate);
        return getDataTable(list);
    }

    /**
     * 导出返利信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:rebate:export')")
    @Log(title = "返利信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Rebate rebate)
    {
        List<Rebate> list = rebateService.selectRebateList(rebate);
        ExcelUtil<Rebate> util = new ExcelUtil<Rebate>(Rebate.class);
        util.exportExcel(response, list, "返利信息数据");
    }

    /**
     * 获取返利信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:rebate:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(rebateService.selectRebateById(id));
    }

    /**
     * 新增返利信息
     */
    @PreAuthorize("@ss.hasPermi('system:rebate:add')")
    @Log(title = "返利信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Rebate rebate)
    {
        return toAjax(rebateService.insertRebate(rebate));
    }

    /**
     * 修改返利信息
     */
    @PreAuthorize("@ss.hasPermi('system:rebate:edit')")
    @Log(title = "返利信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Rebate rebate)
    {
        return toAjax(rebateService.updateRebate(rebate));
    }

    /**
     * 删除返利信息
     */
    @PreAuthorize("@ss.hasPermi('system:rebate:remove')")
    @Log(title = "返利信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(rebateService.deleteRebateByIds(ids));
    }
}
