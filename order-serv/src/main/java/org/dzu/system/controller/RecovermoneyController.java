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
import org.dzu.system.domain.Recovermoney;
import org.dzu.system.service.IRecovermoneyService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 资金回收Controller
 * 
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/recovermoney")
public class RecovermoneyController extends BaseController
{
    @Autowired
    private IRecovermoneyService recovermoneyService;

    /**
     * 查询资金回收列表
     */
    @PreAuthorize("@ss.hasPermi('system:recovermoney:list')")
    @GetMapping("/list")
    public TableDataInfo list(Recovermoney recovermoney)
    {
        startPage();
        List<Recovermoney> list = recovermoneyService.selectRecovermoneyList(recovermoney);
        return getDataTable(list);
    }

    /**
     * 导出资金回收列表
     */
    @PreAuthorize("@ss.hasPermi('system:recovermoney:export')")
    @Log(title = "资金回收", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Recovermoney recovermoney)
    {
        List<Recovermoney> list = recovermoneyService.selectRecovermoneyList(recovermoney);
        ExcelUtil<Recovermoney> util = new ExcelUtil<Recovermoney>(Recovermoney.class);
        util.exportExcel(response, list, "资金回收数据");
    }

    /**
     * 获取资金回收详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:recovermoney:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(recovermoneyService.selectRecovermoneyById(id));
    }

    /**
     * 新增资金回收
     */
    @PreAuthorize("@ss.hasPermi('system:recovermoney:add')")
    @Log(title = "资金回收", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody Recovermoney recovermoney)
    {
        return toAjax(recovermoneyService.insertRecovermoney(recovermoney));
    }

    /**
     * 修改资金回收
     */
    @PreAuthorize("@ss.hasPermi('system:recovermoney:edit')")
    @Log(title = "资金回收", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody Recovermoney recovermoney)
    {
        return toAjax(recovermoneyService.updateRecovermoney(recovermoney));
    }

    /**
     * 删除资金回收
     */
    @PreAuthorize("@ss.hasPermi('system:recovermoney:remove')")
    @Log(title = "资金回收", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(recovermoneyService.deleteRecovermoneyByIds(ids));
    }
}
