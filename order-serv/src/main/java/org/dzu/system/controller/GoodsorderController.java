package org.dzu.system.controller;

import org.dzu.common.annotation.Log;
import org.dzu.common.core.controller.BaseController;
import org.dzu.common.core.domain.AjaxResult;
import org.dzu.common.core.page.TableDataInfo;
import org.dzu.common.enums.BusinessType;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.system.domain.Goodsorder;
import org.dzu.system.service.IGoodsorderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 货物订单Controller
 * 
 * @author ml
 * @date 2024-07-18
 */
@RestController
@RequestMapping("/system/goodsorder")
public class GoodsorderController extends BaseController
{
    @Autowired
    private IGoodsorderService goodsorderService;

    /**
     * 查询货物订单列表
     */
    @PreAuthorize("@ss.hasPermi('system:goodsorder:list')")
    @GetMapping("/list")
    public TableDataInfo list(Goodsorder goodsorder)
    {
        startPage();
        List<Goodsorder> list = goodsorderService.selectGoodsorderList(goodsorder);
        return getDataTable(list);
    }

    /**
     * 导出货物订单列表
     */
    @PreAuthorize("@ss.hasPermi('system:goodsorder:export')")
    @Log(title = "货物订单", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Goodsorder goodsorder)
    {
        List<Goodsorder> list = goodsorderService.selectGoodsorderList(goodsorder);
        ExcelUtil<Goodsorder> util = new ExcelUtil<Goodsorder>(Goodsorder.class);
        util.exportExcel(response, list, "货物订单数据");
    }

    /**
     * 获取货物订单详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:goodsorder:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(goodsorderService.selectGoodsorderById(id));
    }

    /**
     * 新增货物订单
     */
    @PreAuthorize("@ss.hasPermi('system:goodsorder:add')")
    @Log(title = "货物订单", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Goodsorder goodsorder)
    {
        return toAjax(goodsorderService.insertGoodsorder(goodsorder));
    }

    /**
     * 修改货物订单
     */
    @PreAuthorize("@ss.hasPermi('system:goodsorder:edit')")
    @Log(title = "货物订单", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Goodsorder goodsorder)
    {
        return toAjax(goodsorderService.updateGoodsorder(goodsorder));
    }

    /**
     * 删除货物订单
     */
    @PreAuthorize("@ss.hasPermi('system:goodsorder:remove')")
    @Log(title = "货物订单", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(goodsorderService.deleteGoodsorderByIds(ids));
    }
}
