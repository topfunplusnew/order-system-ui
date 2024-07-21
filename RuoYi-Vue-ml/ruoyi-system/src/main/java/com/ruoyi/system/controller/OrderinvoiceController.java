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
import com.ruoyi.system.domain.Orderinvoice;
import com.ruoyi.system.service.IOrderinvoiceService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 订单发票信息Controller
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
@RestController
@RequestMapping("/system/orderinvoice")
public class OrderinvoiceController extends BaseController
{
    @Autowired
    private IOrderinvoiceService orderinvoiceService;

    /**
     * 查询订单发票信息列表
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
     * 导出订单发票信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:orderinvoice:export')")
    @Log(title = "订单发票信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Orderinvoice orderinvoice)
    {
        List<Orderinvoice> list = orderinvoiceService.selectOrderinvoiceList(orderinvoice);
        ExcelUtil<Orderinvoice> util = new ExcelUtil<Orderinvoice>(Orderinvoice.class);
        util.exportExcel(response, list, "订单发票信息数据");
    }

    /**
     * 获取订单发票信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:orderinvoice:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(orderinvoiceService.selectOrderinvoiceById(id));
    }

    /**
     * 新增订单发票信息
     */
    @PreAuthorize("@ss.hasPermi('system:orderinvoice:add')")
    @Log(title = "订单发票信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Orderinvoice orderinvoice)
    {
        return toAjax(orderinvoiceService.insertOrderinvoice(orderinvoice));
    }

    /**
     * 修改订单发票信息
     */
    @PreAuthorize("@ss.hasPermi('system:orderinvoice:edit')")
    @Log(title = "订单发票信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Orderinvoice orderinvoice)
    {
        return toAjax(orderinvoiceService.updateOrderinvoice(orderinvoice));
    }

    /**
     * 删除订单发票信息
     */
    @PreAuthorize("@ss.hasPermi('system:orderinvoice:remove')")
    @Log(title = "订单发票信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(orderinvoiceService.deleteOrderinvoiceByIds(ids));
    }
}
