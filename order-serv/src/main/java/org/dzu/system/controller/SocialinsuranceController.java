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
import org.dzu.system.domain.Socialinsurance;
import org.dzu.system.service.ISocialinsuranceService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 社会保险信息Controller
 * 
 * @author ml
 * @date 2024-07-18
 */
@RestController
@RequestMapping("/system/socialinsurance")
public class SocialinsuranceController extends BaseController
{
    @Autowired
    private ISocialinsuranceService socialinsuranceService;

    /**
     * 查询社会保险信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:socialinsurance:list')")
    @GetMapping("/list")
    public TableDataInfo list(Socialinsurance socialinsurance)
    {
        startPage();
        List<Socialinsurance> list = socialinsuranceService.selectSocialinsuranceList(socialinsurance);
        return getDataTable(list);
    }

    /**
     * 导出社会保险信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:socialinsurance:export')")
    @Log(title = "社会保险信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Socialinsurance socialinsurance)
    {
        List<Socialinsurance> list = socialinsuranceService.selectSocialinsuranceList(socialinsurance);
        ExcelUtil<Socialinsurance> util = new ExcelUtil<Socialinsurance>(Socialinsurance.class);
        util.exportExcel(response, list, "社会保险信息数据");
    }

    /**
     * 获取社会保险信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:socialinsurance:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(socialinsuranceService.selectSocialinsuranceById(id));
    }

    /**
     * 新增社会保险信息
     */
    @PreAuthorize("@ss.hasPermi('system:socialinsurance:add')")
    @Log(title = "社会保险信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Socialinsurance socialinsurance)
    {
        return toAjax(socialinsuranceService.insertSocialinsurance(socialinsurance));
    }

    /**
     * 修改社会保险信息
     */
    @PreAuthorize("@ss.hasPermi('system:socialinsurance:edit')")
    @Log(title = "社会保险信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Socialinsurance socialinsurance)
    {
        return toAjax(socialinsuranceService.updateSocialinsurance(socialinsurance));
    }

    /**
     * 删除社会保险信息
     */
    @PreAuthorize("@ss.hasPermi('system:socialinsurance:remove')")
    @Log(title = "社会保险信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(socialinsuranceService.deleteSocialinsuranceByIds(ids));
    }
}
