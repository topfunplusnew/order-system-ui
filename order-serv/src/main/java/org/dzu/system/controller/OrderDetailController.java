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
import org.dzu.system.domain.OrderDetail;
import org.dzu.system.service.IOrderDetailService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 订单详情Controller
 * 
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/orderDetail")
public class OrderDetailController extends BaseController
{
    @Autowired
    private IOrderDetailService orderDetailService;

    /**
     * 查询订单详情列表
     */
    @PreAuthorize("@ss.hasPermi('system:orderdetail:list')")
    @GetMapping("/list")
    public TableDataInfo list(OrderDetail orderDetail)
    {
        startPage();
        List<OrderDetail> list = orderDetailService.selectOrderDetailList(orderDetail);
        return getDataTable(list);
    }

    /**
     * 导出订单详情列表
     */
    @PreAuthorize("@ss.hasPermi('system:orderdetail:export')")
    @Log(title = "订单详情", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, OrderDetail orderDetail)
    {
        List<OrderDetail> list = orderDetailService.selectOrderDetailList(orderDetail);
        ExcelUtil<OrderDetail> util = new ExcelUtil<OrderDetail>(OrderDetail.class);
        util.exportExcel(response, list, "订单详情数据");
    }

    /**
     * 获取订单详情详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:orderdetail:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(orderDetailService.selectOrderDetailById(id));
    }

    /**
     * 新增订单详情
     */
    @PreAuthorize("@ss.hasPermi('system:orderdetail:add')")
    @Log(title = "订单详情", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody OrderDetail orderDetail)
    {
        return toAjax(orderDetailService.insertOrderDetail(orderDetail));
    }

    /**
     * 修改订单详情
     */
    @PreAuthorize("@ss.hasPermi('system:orderdetail:edit')")
    @Log(title = "订单详情", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody OrderDetail orderDetail)
    {
        return toAjax(orderDetailService.updateOrderDetail(orderDetail));
    }

    /**
     * 删除订单详情
     */
    @PreAuthorize("@ss.hasPermi('system:orderdetail:remove')")
    @Log(title = "订单详情", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(orderDetailService.deleteOrderDetailByIds(ids));
    }
}
