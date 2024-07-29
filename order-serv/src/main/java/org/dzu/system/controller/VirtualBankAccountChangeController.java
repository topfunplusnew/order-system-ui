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
import org.dzu.system.domain.VirtualBankAccountChange;
import org.dzu.system.service.IVirtualBankAccountChangeService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

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
    private IVirtualBankAccountChangeService virtualBankAccountChangeService;

    /**
     * 查询虚拟银行账号列表
     */
    @PreAuthorize("@ss.hasPermi('system:virtualBankAccountChange:list')")
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
    @PreAuthorize("@ss.hasPermi('system:virtualBankAccountChange:export')")
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
    @PreAuthorize("@ss.hasPermi('system:virtualBankAccountChange:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(virtualBankAccountChangeService.selectVirtualBankAccountChangeById(id));
    }

    /**
     * 新增虚拟银行账号
     */
    @PreAuthorize("@ss.hasPermi('system:virtualBankAccountChange:add')")
    @Log(title = "虚拟银行账号", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody VirtualBankAccountChange virtualBankAccountChange)
    {
        return toAjax(virtualBankAccountChangeService.insertVirtualBankAccountChange(virtualBankAccountChange));
    }

    /**
     * 修改虚拟银行账号
     */
    @PreAuthorize("@ss.hasPermi('system:virtualBankAccountChange:edit')")
    @Log(title = "虚拟银行账号", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody VirtualBankAccountChange virtualBankAccountChange)
    {
        return toAjax(virtualBankAccountChangeService.updateVirtualBankAccountChange(virtualBankAccountChange));
    }

    /**
     * 删除虚拟银行账号
     */
    @PreAuthorize("@ss.hasPermi('system:virtualBankAccountChange:remove')")
    @Log(title = "虚拟银行账号", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(virtualBankAccountChangeService.deleteVirtualBankAccountChangeByIds(ids));
    }
}
