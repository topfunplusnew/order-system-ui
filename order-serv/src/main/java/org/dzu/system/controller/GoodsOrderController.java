package org.dzu.system.controller;

import org.dzu.common.annotation.Log;
import org.dzu.common.core.controller.BaseController;
import org.dzu.common.core.domain.AjaxResult;
import org.dzu.common.core.page.TableDataInfo;
import org.dzu.common.enums.BusinessType;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.system.domain.GoodsOrder;
import org.dzu.system.service.IGoodsOrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 订单Controller
 *
 * @author ml
 * @date 2024-08-02
 */
@RestController
@RequestMapping("/system/goodsOrder")
public class GoodsOrderController extends BaseController {
    @Autowired
    private IGoodsOrderService goodsOrderService;

    /**
     * 查询订单列表
     */
    @PreAuthorize("@ss.hasPermi('system:goodsorder:list')")
    @GetMapping("/list")
    public TableDataInfo list(GoodsOrder goodsOrder) {
        startPage();
        List<GoodsOrder> list = goodsOrderService.selectGoodsOrderList(goodsOrder);
        return getDataTable(list);
    }

    /**
     * 导出订单列表
     */
    @PreAuthorize("@ss.hasPermi('system:goodsorder:export')")
    @Log(title = "订单", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, GoodsOrder goodsOrder) {
        List<GoodsOrder> list = goodsOrderService.selectGoodsOrderList(goodsOrder);
        ExcelUtil<GoodsOrder> util = new ExcelUtil<GoodsOrder>(GoodsOrder.class);
        util.exportExcel(response, list, "订单数据");
    }

    /**
     * 获取订单详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:goodsorder:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id) {
        return success(goodsOrderService.selectGoodsOrderById(id));
    }

    /**
     * 新增订单
     */
    @PreAuthorize("@ss.hasPermi('system:goodsorder:add')")
    @Log(title = "订单", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody GoodsOrder goodsOrder) {
        return toAjax(goodsOrderService.insertGoodsOrder(goodsOrder));
    }

    /**
     * 修改订单
     */
    @PreAuthorize("@ss.hasPermi('system:goodsorder:edit')")
    @Log(title = "订单", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody GoodsOrder goodsOrder) {
        return toAjax(goodsOrderService.updateGoodsOrder(goodsOrder));
    }

    /**
     * 审核订单
     */
    @PreAuthorize("@ss.hasPermi('system:goodsorder:audit')")
    @Log(title = "订单", businessType = BusinessType.UPDATE)
    @PutMapping("/audit")
    public AjaxResult audit(@RequestParam Long id, @RequestParam boolean isaudit) {
        return toAjax(goodsOrderService.auditGoodsOrder(id,isaudit));
    }


    /**
     * 调整订单
     */
    @PreAuthorize("@ss.hasPermi('system:goodsorder:edit')")
    @Log(title = "订单", businessType = BusinessType.UPDATE)
    @PutMapping("/adjust")
    public AjaxResult adjust(@Validated @RequestBody GoodsOrder goodsOrder) {
        return toAjax(goodsOrderService.adjustGoodsOrder(goodsOrder));
    }


    /**
     * 删除订单
     */
    @PreAuthorize("@ss.hasPermi('system:goodsorder:remove')")
    @Log(title = "订单", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids) {
        return toAjax(goodsOrderService.deleteGoodsOrderByIds(ids));
    }
}
