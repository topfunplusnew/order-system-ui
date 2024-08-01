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
import org.dzu.system.domain.Auditflow;
import org.dzu.system.service.IAuditflowService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 审核流程Controller
 * 
 * @author ml
 * @date 2024-08-01
 */
@RestController
@RequestMapping("/system/auditflow")
public class AuditflowController extends BaseController
{
    @Autowired
    private IAuditflowService auditflowService;

    /**
     * 查询审核流程列表
     */
    @PreAuthorize("@ss.hasPermi('system:auditflow:list')")
    @GetMapping("/list")
    public TableDataInfo list(Auditflow auditflow)
    {
        startPage();
        List<Auditflow> list = auditflowService.selectAuditflowList(auditflow);
        return getDataTable(list);
    }

    /**
     * 导出审核流程列表
     */
    @PreAuthorize("@ss.hasPermi('system:auditflow:export')")
    @Log(title = "审核流程", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Auditflow auditflow)
    {
        List<Auditflow> list = auditflowService.selectAuditflowList(auditflow);
        ExcelUtil<Auditflow> util = new ExcelUtil<Auditflow>(Auditflow.class);
        util.exportExcel(response, list, "审核流程数据");
    }

    /**
     * 获取审核流程详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:auditflow:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(auditflowService.selectAuditflowById(id));
    }

    /**
     * 新增审核流程
     */
    @PreAuthorize("@ss.hasPermi('system:auditflow:add')")
    @Log(title = "审核流程", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody Auditflow auditflow)
    {
        return toAjax(auditflowService.insertAuditflow(auditflow));
    }

    /**
     * 修改审核流程
     */
    @PreAuthorize("@ss.hasPermi('system:auditflow:edit')")
    @Log(title = "审核流程", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody Auditflow auditflow)
    {
        return toAjax(auditflowService.updateAuditflow(auditflow));
    }

    /**
     * 删除审核流程
     */
    @PreAuthorize("@ss.hasPermi('system:auditflow:remove')")
    @Log(title = "审核流程", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(auditflowService.deleteAuditflowByIds(ids));
    }
}
