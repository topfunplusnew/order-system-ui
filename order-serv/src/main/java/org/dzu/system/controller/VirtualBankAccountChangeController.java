package org.dzu.system.controller;

import org.dzu.common.annotation.Log;
import org.dzu.common.core.controller.BaseController;
import org.dzu.common.core.domain.AjaxResult;
import org.dzu.common.core.page.TableDataInfo;
import org.dzu.common.enums.BusinessType;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.system.domain.VirtualBankAccountChange;
import org.dzu.system.service.impl.VirtualBankAccountChangeServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 虚拟银行账号Controller
 * 
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/virtualBankAccountChange")
public class VirtualBankAccountChangeController extends BaseController
{
    @Autowired
    private VirtualBankAccountChangeServiceImpl virtualBankAccountChangeService;

    /**
     * 查询虚拟银行账号列表
     */
    @PreAuthorize("@ss.hasPermi('system:virtualbankaccountchange:list')")
    @GetMapping("/list")
    public TableDataInfo list(VirtualBankAccountChange virtualBankAccountChange)
    {
        startPage();
        List<VirtualBankAccountChange> list = virtualBankAccountChangeService.selectVirtualBankAccountChangeList(virtualBankAccountChange);
        return getDataTable(list);
    }

    /**
     * 导出虚拟银行账号列表
     */
    @PreAuthorize("@ss.hasPermi('system:virtualbankaccountchange:export')")
    @Log(title = "虚拟银行账号", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, VirtualBankAccountChange virtualBankAccountChange)
    {
        List<VirtualBankAccountChange> list = virtualBankAccountChangeService.selectVirtualBankAccountChangeList(virtualBankAccountChange);
        ExcelUtil<VirtualBankAccountChange> util = new ExcelUtil<VirtualBankAccountChange>(VirtualBankAccountChange.class);
        util.exportExcel(response, list, "虚拟银行账号数据");
    }

    /**
     * 获取虚拟银行账号详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:virtualbankaccountchange:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(virtualBankAccountChangeService.selectVirtualBankAccountChangeById(id));
    }

    /**
     * 新增虚拟银行账号
     */
    @PreAuthorize("@ss.hasPermi('system:virtualbankaccountchange:add')")
    @Log(title = "虚拟银行账号", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody VirtualBankAccountChange virtualBankAccountChange)
    {
        return toAjax(virtualBankAccountChangeService.insertVirtualBankAccountChange(virtualBankAccountChange));
    }

    /**
     * 修改虚拟银行账号
     */
    @PreAuthorize("@ss.hasPermi('system:virtualbankaccountchange:edit')")
    @Log(title = "虚拟银行账号", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody VirtualBankAccountChange virtualBankAccountChange)
    {
        return toAjax(virtualBankAccountChangeService.updateVirtualBankAccountChange(virtualBankAccountChange));
    }

    /**
     * 删除虚拟银行账号
     */
    @PreAuthorize("@ss.hasPermi('system:virtualbankaccountchange:remove')")
    @Log(title = "虚拟银行账号", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(virtualBankAccountChangeService.deleteVirtualBankAccountChangeByIds(ids));
    }
}
