package org.dzu.system.controller;

import org.dzu.common.annotation.Log;
import org.dzu.common.core.controller.BaseController;
import org.dzu.common.core.domain.AjaxResult;
import org.dzu.common.core.page.TableDataInfo;
import org.dzu.common.enums.BusinessType;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.system.domain.ProductLevel;
import org.dzu.system.service.impl.ProductLevelServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 产品级别Controller
 * 
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/productLevel")
public class ProductLevelController extends BaseController
{
    @Autowired
    private ProductLevelServiceImpl productLevelService;

    /**
     * 查询产品级别列表
     */
    @PreAuthorize("@ss.hasPermi('system:productlevel:list')")
    @GetMapping("/list")
    public TableDataInfo list(ProductLevel productLevel)
    {
        startPage();
        List<ProductLevel> list = productLevelService.selectProductLevelList(productLevel);
        return getDataTable(list);
    }

    /**
     * 导出产品级别列表
     */
    @PreAuthorize("@ss.hasPermi('system:productlevel:export')")
    @Log(title = "产品级别", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, ProductLevel productLevel)
    {
        List<ProductLevel> list = productLevelService.selectProductLevelList(productLevel);
        ExcelUtil<ProductLevel> util = new ExcelUtil<ProductLevel>(ProductLevel.class);
        util.exportExcel(response, list, "产品级别数据");
    }

    /**
     * 获取产品级别详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:productlevel:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(productLevelService.selectProductLevelById(id));
    }

    /**
     * 新增产品级别
     */
    @PreAuthorize("@ss.hasPermi('system:productlevel:add')")
    @Log(title = "产品级别", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody ProductLevel productLevel)
    {
        return toAjax(productLevelService.insertProductLevel(productLevel));
    }

    /**
     * 修改产品级别
     */
    @PreAuthorize("@ss.hasPermi('system:productlevel:edit')")
    @Log(title = "产品级别", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody ProductLevel productLevel)
    {
        return toAjax(productLevelService.updateProductLevel(productLevel));
    }

    /**
     * 删除产品级别
     */
    @PreAuthorize("@ss.hasPermi('system:productlevel:remove')")
    @Log(title = "产品级别", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(productLevelService.deleteProductLevelByIds(ids));
    }
}
