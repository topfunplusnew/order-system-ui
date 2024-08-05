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
import org.dzu.system.domain.InvoiceOut;
import org.dzu.system.service.IInvoiceOutService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 发票卖出信息Controller
 * 
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/invoiceOut")
public class InvoiceOutController extends BaseController
{
    @Autowired
    private IInvoiceOutService invoiceOutService;

    /**
     * 查询发票卖出信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:invoiceout:list')")
    @GetMapping("/list")
    public TableDataInfo list(InvoiceOut invoiceOut)
    {
        startPage();
        List<InvoiceOut> list = invoiceOutService.selectInvoiceOutList(invoiceOut);
        return getDataTable(list);
    }

    /**
     * 导出发票卖出信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:invoiceout:export')")
    @Log(title = "发票卖出信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, InvoiceOut invoiceOut)
    {
        List<InvoiceOut> list = invoiceOutService.selectInvoiceOutList(invoiceOut);
        ExcelUtil<InvoiceOut> util = new ExcelUtil<InvoiceOut>(InvoiceOut.class);
        util.exportExcel(response, list, "发票卖出信息数据");
    }

    /**
     * 获取发票卖出信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:invoiceout:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(invoiceOutService.selectInvoiceOutById(id));
    }

    /**
     * 新增发票卖出信息
     */
    @PreAuthorize("@ss.hasPermi('system:invoiceout:add')")
    @Log(title = "发票卖出信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody InvoiceOut invoiceOut)
    {
        return toAjax(invoiceOutService.insertInvoiceOut(invoiceOut));
    }

    /**
     * 修改发票卖出信息
     */
    @PreAuthorize("@ss.hasPermi('system:invoiceout:edit')")
    @Log(title = "发票卖出信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody InvoiceOut invoiceOut)
    {
        return toAjax(invoiceOutService.updateInvoiceOut(invoiceOut));
    }

    /**
     * 删除发票卖出信息
     */
    @PreAuthorize("@ss.hasPermi('system:invoiceout:remove')")
    @Log(title = "发票卖出信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(invoiceOutService.deleteInvoiceOutByIds(ids));
    }
}
