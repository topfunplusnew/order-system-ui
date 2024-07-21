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
import com.ruoyi.system.domain.Goodsorder;
import com.ruoyi.system.service.IGoodsorderService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 货物订单Controller
 * 
 * @author ruoyi
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
