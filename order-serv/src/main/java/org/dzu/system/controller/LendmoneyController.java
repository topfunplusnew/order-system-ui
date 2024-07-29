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
import org.dzu.system.domain.Lendmoney;
import org.dzu.system.service.ILendmoneyService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 资金借出（期货）Controller
 * 
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/lendmoney")
public class LendmoneyController extends BaseController
{
    @Autowired
    private ILendmoneyService lendmoneyService;

    /**
     * 查询资金借出（期货）列表
     */
    @PreAuthorize("@ss.hasPermi('system:lendmoney:list')")
    @GetMapping("/list")
    public TableDataInfo list(Lendmoney lendmoney)
    {
        startPage();
        List<Lendmoney> list = lendmoneyService.selectLendmoneyList(lendmoney);
        return getDataTable(list);
    }

    /**
     * 导出资金借出（期货）列表
     */
    @PreAuthorize("@ss.hasPermi('system:lendmoney:export')")
    @Log(title = "资金借出（期货）", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Lendmoney lendmoney)
    {
        List<Lendmoney> list = lendmoneyService.selectLendmoneyList(lendmoney);
        ExcelUtil<Lendmoney> util = new ExcelUtil<Lendmoney>(Lendmoney.class);
        util.exportExcel(response, list, "资金借出（期货）数据");
    }

    /**
     * 获取资金借出（期货）详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:lendmoney:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(lendmoneyService.selectLendmoneyById(id));
    }

    /**
     * 新增资金借出（期货）
     */
    @PreAuthorize("@ss.hasPermi('system:lendmoney:add')")
    @Log(title = "资金借出（期货）", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody Lendmoney lendmoney)
    {
        return toAjax(lendmoneyService.insertLendmoney(lendmoney));
    }

    /**
     * 修改资金借出（期货）
     */
    @PreAuthorize("@ss.hasPermi('system:lendmoney:edit')")
    @Log(title = "资金借出（期货）", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody Lendmoney lendmoney)
    {
        return toAjax(lendmoneyService.updateLendmoney(lendmoney));
    }

    /**
     * 删除资金借出（期货）
     */
    @PreAuthorize("@ss.hasPermi('system:lendmoney:remove')")
    @Log(title = "资金借出（期货）", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(lendmoneyService.deleteLendmoneyByIds(ids));
    }
}
