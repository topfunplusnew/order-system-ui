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
import org.dzu.system.domain.InvoiceOther;
import org.dzu.system.service.IInvoiceOtherService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 商家直接给客户开发票Controller
 * 
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/invoiceOther")
public class InvoiceOtherController extends BaseController
{
    @Autowired
    private IInvoiceOtherService invoiceOtherService;

    /**
     * 查询商家直接给客户开发票列表
     */
    @PreAuthorize("@ss.hasPermi('system:invoiceOther:list')")
    @GetMapping("/list")
    public TableDataInfo list(InvoiceOther invoiceOther)
    {
        startPage();
        List<InvoiceOther> list = invoiceOtherService.selectInvoiceOtherList(invoiceOther);
        return getDataTable(list);
    }

    /**
     * 导出商家直接给客户开发票列表
     */
    @PreAuthorize("@ss.hasPermi('system:invoiceOther:export')")
    @Log(title = "商家直接给客户开发票", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, InvoiceOther invoiceOther)
    {
        List<InvoiceOther> list = invoiceOtherService.selectInvoiceOtherList(invoiceOther);
        ExcelUtil<InvoiceOther> util = new ExcelUtil<InvoiceOther>(InvoiceOther.class);
        util.exportExcel(response, list, "商家直接给客户开发票数据");
    }

    /**
     * 获取商家直接给客户开发票详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:invoiceOther:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(invoiceOtherService.selectInvoiceOtherById(id));
    }

    /**
     * 新增商家直接给客户开发票
     */
    @PreAuthorize("@ss.hasPermi('system:invoiceOther:add')")
    @Log(title = "商家直接给客户开发票", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody InvoiceOther invoiceOther)
    {
        return toAjax(invoiceOtherService.insertInvoiceOther(invoiceOther));
    }

    /**
     * 修改商家直接给客户开发票
     */
    @PreAuthorize("@ss.hasPermi('system:invoiceOther:edit')")
    @Log(title = "商家直接给客户开发票", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody InvoiceOther invoiceOther)
    {
        return toAjax(invoiceOtherService.updateInvoiceOther(invoiceOther));
    }

    /**
     * 删除商家直接给客户开发票
     */
    @PreAuthorize("@ss.hasPermi('system:invoiceOther:remove')")
    @Log(title = "商家直接给客户开发票", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(invoiceOtherService.deleteInvoiceOtherByIds(ids));
    }
}
