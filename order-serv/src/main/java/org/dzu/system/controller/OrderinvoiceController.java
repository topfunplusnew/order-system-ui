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
import org.dzu.system.domain.Orderinvoice;
import org.dzu.system.service.IOrderinvoiceService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 订单发票Controller
 * 
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/orderinvoice")
public class OrderinvoiceController extends BaseController
{
    @Autowired
    private IOrderinvoiceService orderinvoiceService;

    /**
     * 查询订单发票列表
     */
    @PreAuthorize("@ss.hasPermi('system:orderinvoice:list')")
    @GetMapping("/list")
    public TableDataInfo list(Orderinvoice orderinvoice)
    {
        startPage();
        List<Orderinvoice> list = orderinvoiceService.selectOrderinvoiceList(orderinvoice);
        return getDataTable(list);
    }

    /**
     * 导出订单发票列表
     */
    @PreAuthorize("@ss.hasPermi('system:orderinvoice:export')")
    @Log(title = "订单发票", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Orderinvoice orderinvoice)
    {
        List<Orderinvoice> list = orderinvoiceService.selectOrderinvoiceList(orderinvoice);
        ExcelUtil<Orderinvoice> util = new ExcelUtil<Orderinvoice>(Orderinvoice.class);
        util.exportExcel(response, list, "订单发票数据");
    }

    /**
     * 获取订单发票详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:orderinvoice:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(orderinvoiceService.selectOrderinvoiceById(id));
    }

    /**
     * 新增订单发票
     */
    @PreAuthorize("@ss.hasPermi('system:orderinvoice:add')")
    @Log(title = "订单发票", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody Orderinvoice orderinvoice)
    {
        return toAjax(orderinvoiceService.insertOrderinvoice(orderinvoice));
    }

    /**
     * 修改订单发票
     */
    @PreAuthorize("@ss.hasPermi('system:orderinvoice:edit')")
    @Log(title = "订单发票", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody Orderinvoice orderinvoice)
    {
        return toAjax(orderinvoiceService.updateOrderinvoice(orderinvoice));
    }

    /**
     * 删除订单发票
     */
    @PreAuthorize("@ss.hasPermi('system:orderinvoice:remove')")
    @Log(title = "订单发票", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(orderinvoiceService.deleteOrderinvoiceByIds(ids));
    }
}
