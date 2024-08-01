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
import org.dzu.system.domain.AuditInfo;
import org.dzu.system.service.IAuditInfoService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 审核流程Controller
 * 
 * @author ml
 * @date 2024-08-01
 */
@RestController
@RequestMapping("/system/auditInfo")
public class AuditInfoController extends BaseController
{
    @Autowired
    private IAuditInfoService auditInfoService;

    /**
     * 查询审核流程列表
     */
    @PreAuthorize("@ss.hasPermi('system:auditInfo:list')")
    @GetMapping("/list")
    public TableDataInfo list(AuditInfo auditInfo)
    {
        startPage();
        List<AuditInfo> list = auditInfoService.selectAuditInfoList(auditInfo);
        return getDataTable(list);
    }

    /**
     * 导出审核流程列表
     */
    @PreAuthorize("@ss.hasPermi('system:auditInfo:export')")
    @Log(title = "审核流程", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, AuditInfo auditInfo)
    {
        List<AuditInfo> list = auditInfoService.selectAuditInfoList(auditInfo);
        ExcelUtil<AuditInfo> util = new ExcelUtil<AuditInfo>(AuditInfo.class);
        util.exportExcel(response, list, "审核流程数据");
    }

    /**
     * 获取审核流程详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:auditInfo:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(auditInfoService.selectAuditInfoById(id));
    }

    /**
     * 新增审核流程
     */
    @PreAuthorize("@ss.hasPermi('system:auditInfo:add')")
    @Log(title = "审核流程", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody AuditInfo auditInfo)
    {
        return toAjax(auditInfoService.insertAuditInfo(auditInfo));
    }

    /**
     * 修改审核流程
     */
    @PreAuthorize("@ss.hasPermi('system:auditInfo:edit')")
    @Log(title = "审核流程", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody AuditInfo auditInfo)
    {
        return toAjax(auditInfoService.updateAuditInfo(auditInfo));
    }

    /**
     * 删除审核流程
     */
    @PreAuthorize("@ss.hasPermi('system:auditInfo:remove')")
    @Log(title = "审核流程", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(auditInfoService.deleteAuditInfoByIds(ids));
    }
}
