package org.dzu.system.controller;

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
import org.dzu.common.annotation.Log;
import org.dzu.common.core.controller.BaseController;
import org.dzu.common.core.domain.AjaxResult;
import org.dzu.common.enums.BusinessType;
import org.dzu.system.domain.OrderdetailBack;
import org.dzu.system.service.IOrderdetailBackService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 订单详情备份Controller
 * 
 * @author ml
 * @date 2024-07-19
 */
@RestController
@RequestMapping("/system/orderdetailback")
public class OrderdetailBackController extends BaseController
{
    @Autowired
    private IOrderdetailBackService orderdetailBackService;

    /**
     * 查询订单详情备份列表
     */
    @PreAuthorize("@ss.hasPermi('system:back:list')")
    @GetMapping("/list")
    public TableDataInfo list(OrderdetailBack orderdetailBack)
    {
        startPage();
        List<OrderdetailBack> list = orderdetailBackService.selectOrderdetailBackList(orderdetailBack);
        return getDataTable(list);
    }

    /**
     * 导出订单详情备份列表
     */
    @PreAuthorize("@ss.hasPermi('system:back:export')")
    @Log(title = "订单详情备份", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, OrderdetailBack orderdetailBack)
    {
        List<OrderdetailBack> list = orderdetailBackService.selectOrderdetailBackList(orderdetailBack);
        ExcelUtil<OrderdetailBack> util = new ExcelUtil<OrderdetailBack>(OrderdetailBack.class);
        util.exportExcel(response, list, "订单详情备份数据");
    }

    /**
     * 获取订单详情备份详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:back:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(orderdetailBackService.selectOrderdetailBackById(id));
    }

    /**
     * 新增订单详情备份
     */
    @PreAuthorize("@ss.hasPermi('system:back:add')")
    @Log(title = "订单详情备份", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody OrderdetailBack orderdetailBack)
    {
        return toAjax(orderdetailBackService.insertOrderdetailBack(orderdetailBack));
    }

    /**
     * 修改订单详情备份
     */
    @PreAuthorize("@ss.hasPermi('system:back:edit')")
    @Log(title = "订单详情备份", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody OrderdetailBack orderdetailBack)
    {
        return toAjax(orderdetailBackService.updateOrderdetailBack(orderdetailBack));
    }

    /**
     * 删除订单详情备份
     */
    @PreAuthorize("@ss.hasPermi('system:back:remove')")
    @Log(title = "订单详情备份", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(orderdetailBackService.deleteOrderdetailBackByIds(ids));
    }
}
