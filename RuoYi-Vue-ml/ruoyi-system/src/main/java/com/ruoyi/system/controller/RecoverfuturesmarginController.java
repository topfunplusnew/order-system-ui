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
import com.ruoyi.system.domain.Recoverfuturesmargin;
import com.ruoyi.system.service.IRecoverfuturesmarginService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 恢复期货保证金？Controller
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
@RestController
@RequestMapping("/system/recoverfuturesmargin")
public class RecoverfuturesmarginController extends BaseController
{
    @Autowired
    private IRecoverfuturesmarginService recoverfuturesmarginService;

    /**
     * 查询恢复期货保证金？列表
     */
    @PreAuthorize("@ss.hasPermi('system:recoverfuturesmargin:list')")
    @GetMapping("/list")
    public TableDataInfo list(Recoverfuturesmargin recoverfuturesmargin)
    {
        startPage();
        List<Recoverfuturesmargin> list = recoverfuturesmarginService.selectRecoverfuturesmarginList(recoverfuturesmargin);
        return getDataTable(list);
    }

    /**
     * 导出恢复期货保证金？列表
     */
    @PreAuthorize("@ss.hasPermi('system:recoverfuturesmargin:export')")
    @Log(title = "恢复期货保证金？", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Recoverfuturesmargin recoverfuturesmargin)
    {
        List<Recoverfuturesmargin> list = recoverfuturesmarginService.selectRecoverfuturesmarginList(recoverfuturesmargin);
        ExcelUtil<Recoverfuturesmargin> util = new ExcelUtil<Recoverfuturesmargin>(Recoverfuturesmargin.class);
        util.exportExcel(response, list, "恢复期货保证金？数据");
    }

    /**
     * 获取恢复期货保证金？详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:recoverfuturesmargin:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(recoverfuturesmarginService.selectRecoverfuturesmarginById(id));
    }

    /**
     * 新增恢复期货保证金？
     */
    @PreAuthorize("@ss.hasPermi('system:recoverfuturesmargin:add')")
    @Log(title = "恢复期货保证金？", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Recoverfuturesmargin recoverfuturesmargin)
    {
        return toAjax(recoverfuturesmarginService.insertRecoverfuturesmargin(recoverfuturesmargin));
    }

    /**
     * 修改恢复期货保证金？
     */
    @PreAuthorize("@ss.hasPermi('system:recoverfuturesmargin:edit')")
    @Log(title = "恢复期货保证金？", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Recoverfuturesmargin recoverfuturesmargin)
    {
        return toAjax(recoverfuturesmarginService.updateRecoverfuturesmargin(recoverfuturesmargin));
    }

    /**
     * 删除恢复期货保证金？
     */
    @PreAuthorize("@ss.hasPermi('system:recoverfuturesmargin:remove')")
    @Log(title = "恢复期货保证金？", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(recoverfuturesmarginService.deleteRecoverfuturesmarginByIds(ids));
    }
}
