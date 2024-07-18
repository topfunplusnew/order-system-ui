package org.dzu.system.controller;

import org.dzu.common.annotation.Log;
import org.dzu.common.core.controller.BaseController;
import org.dzu.common.core.domain.AjaxResult;
import org.dzu.common.core.page.TableDataInfo;
import org.dzu.common.enums.BusinessType;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.system.domain.Orderdetail;
import org.dzu.system.service.IOrderdetailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 订单详情Controller
 * 
 * @author ml
 * @date 2024-07-18
 */
@RestController
@RequestMapping("/system/orderdetail")
public class OrderdetailController extends BaseController
{
    @Autowired
    private IOrderdetailService orderdetailService;

    /**
     * 查询订单详情列表
     */
    @PreAuthorize("@ss.hasPermi('system:orderdetail:list')")
    @GetMapping("/list")
    public TableDataInfo list(Orderdetail orderdetail)
    {
        startPage();
        List<Orderdetail> list = orderdetailService.selectOrderdetailList(orderdetail);
        return getDataTable(list);
    }

    /**
     * 导出订单详情列表
     */
    @PreAuthorize("@ss.hasPermi('system:orderdetail:export')")
    @Log(title = "订单详情", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Orderdetail orderdetail)
    {
        List<Orderdetail> list = orderdetailService.selectOrderdetailList(orderdetail);
        ExcelUtil<Orderdetail> util = new ExcelUtil<Orderdetail>(Orderdetail.class);
        util.exportExcel(response, list, "订单详情数据");
    }

    /**
     * 获取订单详情详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:orderdetail:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(orderdetailService.selectOrderdetailById(id));
    }

    /**
     * 新增订单详情
     */
    @PreAuthorize("@ss.hasPermi('system:orderdetail:add')")
    @Log(title = "订单详情", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Orderdetail orderdetail)
    {
        return toAjax(orderdetailService.insertOrderdetail(orderdetail));
    }

    /**
     * 修改订单详情
     */
    @PreAuthorize("@ss.hasPermi('system:orderdetail:edit')")
    @Log(title = "订单详情", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Orderdetail orderdetail)
    {
        return toAjax(orderdetailService.updateOrderdetail(orderdetail));
    }

    /**
     * 删除订单详情
     */
    @PreAuthorize("@ss.hasPermi('system:orderdetail:remove')")
    @Log(title = "订单详情", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(orderdetailService.deleteOrderdetailByIds(ids));
    }
}
