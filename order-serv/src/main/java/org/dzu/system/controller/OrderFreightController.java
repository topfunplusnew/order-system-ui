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
import org.dzu.system.domain.OrderFreight;
import org.dzu.system.service.IOrderFreightService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 订单运费Controller
 * 
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/orderFreight")
public class OrderFreightController extends BaseController
{
    @Autowired
    private IOrderFreightService orderFreightService;

    /**
     * 查询订单运费列表
     */
    @PreAuthorize("@ss.hasPermi('system:orderfreight:list')")
    @GetMapping("/list")
    public TableDataInfo list(OrderFreight orderFreight)
    {
        startPage();
        List<OrderFreight> list = orderFreightService.selectOrderFreightList(orderFreight);
        return getDataTable(list);
    }

    /**
     * 导出订单运费列表
     */
    @PreAuthorize("@ss.hasPermi('system:orderfreight:export')")
    @Log(title = "订单运费", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, OrderFreight orderFreight)
    {
        List<OrderFreight> list = orderFreightService.selectOrderFreightList(orderFreight);
        ExcelUtil<OrderFreight> util = new ExcelUtil<OrderFreight>(OrderFreight.class);
        util.exportExcel(response, list, "订单运费数据");
    }

    /**
     * 获取订单运费详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:orderfreight:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(orderFreightService.selectOrderFreightById(id));
    }

    /**
     * 新增订单运费
     */
    @PreAuthorize("@ss.hasPermi('system:orderfreight:add')")
    @Log(title = "订单运费", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody OrderFreight orderFreight)
    {
        return toAjax(orderFreightService.insertOrderFreight(orderFreight));
    }

    /**
     * 修改订单运费
     */
    @PreAuthorize("@ss.hasPermi('system:orderfreight:edit')")
    @Log(title = "订单运费", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody OrderFreight orderFreight)
    {
        return toAjax(orderFreightService.updateOrderFreight(orderFreight));
    }

    /**
     * 删除订单运费
     */
    @PreAuthorize("@ss.hasPermi('system:orderfreight:remove')")
    @Log(title = "订单运费", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(orderFreightService.deleteOrderFreightByIds(ids));
    }
}
