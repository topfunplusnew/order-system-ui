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
import org.dzu.system.domain.InvoiceIn;
import org.dzu.system.service.IInvoiceInService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 发票购入信息Controller
 * 
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/invoiceIn")
public class InvoiceInController extends BaseController
{
    @Autowired
    private IInvoiceInService invoiceInService;

    /**
     * 查询发票购入信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:invoiceIn:list')")
    @GetMapping("/list")
    public TableDataInfo list(InvoiceIn invoiceIn)
    {
        startPage();
        List<InvoiceIn> list = invoiceInService.selectInvoiceInList(invoiceIn);
        return getDataTable(list);
    }

    /**
     * 导出发票购入信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:invoiceIn:export')")
    @Log(title = "发票购入信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, InvoiceIn invoiceIn)
    {
        List<InvoiceIn> list = invoiceInService.selectInvoiceInList(invoiceIn);
        ExcelUtil<InvoiceIn> util = new ExcelUtil<InvoiceIn>(InvoiceIn.class);
        util.exportExcel(response, list, "发票购入信息数据");
    }

    /**
     * 获取发票购入信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:invoiceIn:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(invoiceInService.selectInvoiceInById(id));
    }

    /**
     * 新增发票购入信息
     */
    @PreAuthorize("@ss.hasPermi('system:invoiceIn:add')")
    @Log(title = "发票购入信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody InvoiceIn invoiceIn)
    {
        return toAjax(invoiceInService.insertInvoiceIn(invoiceIn));
    }

    /**
     * 修改发票购入信息
     */
    @PreAuthorize("@ss.hasPermi('system:invoiceIn:edit')")
    @Log(title = "发票购入信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody InvoiceIn invoiceIn)
    {
        return toAjax(invoiceInService.updateInvoiceIn(invoiceIn));
    }

    /**
     * 删除发票购入信息
     */
    @PreAuthorize("@ss.hasPermi('system:invoiceIn:remove')")
    @Log(title = "发票购入信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(invoiceInService.deleteInvoiceInByIds(ids));
    }
}
