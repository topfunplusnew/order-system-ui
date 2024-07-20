package org.dzu.system.controller;

import java.util.List;
import javax.servlet.http.HttpServletResponse;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
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
import org.dzu.system.domain.Productlevel;
import org.dzu.system.service.IProductlevelService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 产品级别管理Controller
 * 
 * @author ml
 * @date 2024-07-19
 */
@RestController
@RequestMapping("/system/productlevel")
public class ProductlevelController extends BaseController
{
    @Autowired
    private IProductlevelService productlevelService;

    /**
     * 查询产品级别管理列表
     */
    @PreAuthorize("@ss.hasPermi('system:productlevel:list')")
    @GetMapping("/list")
    public TableDataInfo list(Productlevel productlevel)
    {
        startPage();
        List<Productlevel> list = productlevelService.selectProductlevelList(productlevel);
        return getDataTable(list);
    }

    /**
     * 导出产品级别管理列表
     */
    @PreAuthorize("@ss.hasPermi('system:productlevel:export')")
    @Log(title = "产品级别管理", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Productlevel productlevel)
    {
        List<Productlevel> list = productlevelService.selectProductlevelList(productlevel);
        ExcelUtil<Productlevel> util = new ExcelUtil<Productlevel>(Productlevel.class);
        util.exportExcel(response, list, "产品级别管理数据");
    }

    /**
     * 获取产品级别管理详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:productlevel:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(productlevelService.selectProductlevelById(id));
    }

    /**
     * 新增产品级别管理
     */
    @PreAuthorize("@ss.hasPermi('system:productlevel:add')")
    @Log(title = "产品级别管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody Productlevel productlevel)
    {
        return toAjax(productlevelService.insertProductlevel(productlevel));
    }

    /**
     * 修改产品级别管理
     */
    @PreAuthorize("@ss.hasPermi('system:productlevel:edit')")
    @Log(title = "产品级别管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody Productlevel productlevel)
    {
        return toAjax(productlevelService.updateProductlevel(productlevel));
    }

    /**
     * 删除产品级别管理
     */
    @PreAuthorize("@ss.hasPermi('system:productlevel:remove')")
    @Log(title = "产品级别管理", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(productlevelService.deleteProductlevelByIds(ids));
    }
}
