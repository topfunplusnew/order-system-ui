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
import org.dzu.system.domain.Liabilities;
import org.dzu.system.service.ILiabilitiesService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 负债信息Controller
 * 
 * @author ml
 * @date 2024-07-18
 */
@RestController
@RequestMapping("/system/liabilities")
public class LiabilitiesController extends BaseController
{
    @Autowired
    private ILiabilitiesService liabilitiesService;

    /**
     * 查询负债信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:liabilities:list')")
    @GetMapping("/list")
    public TableDataInfo list(Liabilities liabilities)
    {
        startPage();
        List<Liabilities> list = liabilitiesService.selectLiabilitiesList(liabilities);
        return getDataTable(list);
    }

    /**
     * 导出负债信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:liabilities:export')")
    @Log(title = "负债信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Liabilities liabilities)
    {
        List<Liabilities> list = liabilitiesService.selectLiabilitiesList(liabilities);
        ExcelUtil<Liabilities> util = new ExcelUtil<Liabilities>(Liabilities.class);
        util.exportExcel(response, list, "负债信息数据");
    }

    /**
     * 获取负债信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:liabilities:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(liabilitiesService.selectLiabilitiesById(id));
    }

    /**
     * 新增负债信息
     */
    @PreAuthorize("@ss.hasPermi('system:liabilities:add')")
    @Log(title = "负债信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Liabilities liabilities)
    {
        return toAjax(liabilitiesService.insertLiabilities(liabilities));
    }

    /**
     * 修改负债信息
     */
    @PreAuthorize("@ss.hasPermi('system:liabilities:edit')")
    @Log(title = "负债信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Liabilities liabilities)
    {
        return toAjax(liabilitiesService.updateLiabilities(liabilities));
    }

    /**
     * 删除负债信息
     */
    @PreAuthorize("@ss.hasPermi('system:liabilities:remove')")
    @Log(title = "负债信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(liabilitiesService.deleteLiabilitiesByIds(ids));
    }
}
