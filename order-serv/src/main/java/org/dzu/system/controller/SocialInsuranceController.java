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
import org.dzu.system.domain.SocialInsurance;
import org.dzu.system.service.ISocialInsuranceService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 社保基金Controller
 * 
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/socialInsurance")
public class SocialInsuranceController extends BaseController
{
    @Autowired
    private ISocialInsuranceService socialInsuranceService;

    /**
     * 查询社保基金列表
     */
    @PreAuthorize("@ss.hasPermi('system:socialInsurance:list')")
    @GetMapping("/list")
    public TableDataInfo list(SocialInsurance socialInsurance)
    {
        startPage();
        List<SocialInsurance> list = socialInsuranceService.selectSocialInsuranceList(socialInsurance);
        return getDataTable(list);
    }

    /**
     * 导出社保基金列表
     */
    @PreAuthorize("@ss.hasPermi('system:socialInsurance:export')")
    @Log(title = "社保基金", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, SocialInsurance socialInsurance)
    {
        List<SocialInsurance> list = socialInsuranceService.selectSocialInsuranceList(socialInsurance);
        ExcelUtil<SocialInsurance> util = new ExcelUtil<SocialInsurance>(SocialInsurance.class);
        util.exportExcel(response, list, "社保基金数据");
    }

    /**
     * 获取社保基金详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:socialInsurance:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(socialInsuranceService.selectSocialInsuranceById(id));
    }

    /**
     * 新增社保基金
     */
    @PreAuthorize("@ss.hasPermi('system:socialInsurance:add')")
    @Log(title = "社保基金", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody SocialInsurance socialInsurance)
    {
        return toAjax(socialInsuranceService.insertSocialInsurance(socialInsurance));
    }

    /**
     * 修改社保基金
     */
    @PreAuthorize("@ss.hasPermi('system:socialInsurance:edit')")
    @Log(title = "社保基金", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody SocialInsurance socialInsurance)
    {
        return toAjax(socialInsuranceService.updateSocialInsurance(socialInsurance));
    }

    /**
     * 删除社保基金
     */
    @PreAuthorize("@ss.hasPermi('system:socialInsurance:remove')")
    @Log(title = "社保基金", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(socialInsuranceService.deleteSocialInsuranceByIds(ids));
    }
}
