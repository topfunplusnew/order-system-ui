package org.dzu.system.controller;

import java.util.List;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
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
import org.dzu.system.domain.Virtualbankaccountchange;
import org.dzu.system.service.IVirtualbankaccountchangeService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 虚拟银行账户变动信息Controller
 * 
 * @author ml
 * @date 2024-07-19
 */
@RestController
@RequestMapping("/system/virtualbankaccountchange")
public class VirtualbankaccountchangeController extends BaseController
{
    @Autowired
    private IVirtualbankaccountchangeService virtualbankaccountchangeService;

    /**
     * 查询虚拟银行账户变动信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:virtualbankaccountchange:list')")
    @GetMapping("/list")
    public TableDataInfo list(Virtualbankaccountchange virtualbankaccountchange)
    {
        startPage();
        List<Virtualbankaccountchange> list = virtualbankaccountchangeService.selectVirtualbankaccountchangeList(virtualbankaccountchange);
        return getDataTable(list);
    }

    /**
     * 导出虚拟银行账户变动信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:virtualbankaccountchange:export')")
    @Log(title = "虚拟银行账户变动信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Virtualbankaccountchange virtualbankaccountchange)
    {
        List<Virtualbankaccountchange> list = virtualbankaccountchangeService.selectVirtualbankaccountchangeList(virtualbankaccountchange);
        ExcelUtil<Virtualbankaccountchange> util = new ExcelUtil<Virtualbankaccountchange>(Virtualbankaccountchange.class);
        util.exportExcel(response, list, "虚拟银行账户变动信息数据");
    }

    /**
     * 获取虚拟银行账户变动信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:virtualbankaccountchange:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(virtualbankaccountchangeService.selectVirtualbankaccountchangeById(id));
    }

    /**
     * 新增虚拟银行账户变动信息
     */
    @PreAuthorize("@ss.hasPermi('system:virtualbankaccountchange:add')")
    @Log(title = "虚拟银行账户变动信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated  @RequestBody Virtualbankaccountchange virtualbankaccountchange)
    {
        return toAjax(virtualbankaccountchangeService.insertVirtualbankaccountchange(virtualbankaccountchange));
    }

    /**
     * 修改虚拟银行账户变动信息
     */
    @PreAuthorize("@ss.hasPermi('system:virtualbankaccountchange:edit')")
    @Log(title = "虚拟银行账户变动信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody Virtualbankaccountchange virtualbankaccountchange)
    {
        return toAjax(virtualbankaccountchangeService.updateVirtualbankaccountchange(virtualbankaccountchange));
    }

    /**
     * 删除虚拟银行账户变动信息
     */
    @PreAuthorize("@ss.hasPermi('system:virtualbankaccountchange:remove')")
    @Log(title = "虚拟银行账户变动信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(virtualbankaccountchangeService.deleteVirtualbankaccountchangeByIds(ids));
    }
}
