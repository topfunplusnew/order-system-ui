package org.dzu.system.controller;

import org.dzu.common.annotation.Log;
import org.dzu.common.core.controller.BaseController;
import org.dzu.common.core.domain.AjaxResult;
import org.dzu.common.core.page.TableDataInfo;
import org.dzu.common.enums.BusinessType;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.system.domain.GoodsorderBack;
import org.dzu.system.service.IGoodsorderBackService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 订单备份Controller
 * 
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/goodsOrderBack")
public class GoodsorderBackController extends BaseController
{
    @Autowired
    private IGoodsorderBackService goodsorderBackService;

    /**
     * 查询订单备份列表
     */
    @PreAuthorize("@ss.hasPermi('system:back:list')")
    @GetMapping("/list")
    public TableDataInfo list(GoodsorderBack goodsorderBack)
    {
        startPage();
        List<GoodsorderBack> list = goodsorderBackService.selectGoodsorderBackList(goodsorderBack);
        return getDataTable(list);
    }

    /**
     * 导出订单备份列表
     */
    @PreAuthorize("@ss.hasPermi('system:back:export')")
    @Log(title = "订单备份", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, GoodsorderBack goodsorderBack)
    {
        List<GoodsorderBack> list = goodsorderBackService.selectGoodsorderBackList(goodsorderBack);
        ExcelUtil<GoodsorderBack> util = new ExcelUtil<GoodsorderBack>(GoodsorderBack.class);
        util.exportExcel(response, list, "订单备份数据");
    }

    /**
     * 获取订单备份详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:back:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(goodsorderBackService.selectGoodsorderBackById(id));
    }

    /**
     * 新增订单备份
     */
    @PreAuthorize("@ss.hasPermi('system:back:add')")
    @Log(title = "订单备份", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody GoodsorderBack goodsorderBack)
    {
        return toAjax(goodsorderBackService.insertGoodsorderBack(goodsorderBack));
    }

    /**
     * 修改订单备份
     */
    @PreAuthorize("@ss.hasPermi('system:back:edit')")
    @Log(title = "订单备份", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody GoodsorderBack goodsorderBack)
    {
        return toAjax(goodsorderBackService.updateGoodsorderBack(goodsorderBack));
    }

    /**
     * 删除订单备份
     */
    @PreAuthorize("@ss.hasPermi('system:back:remove')")
    @Log(title = "订单备份", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(goodsorderBackService.deleteGoodsorderBackByIds(ids));
    }
}
