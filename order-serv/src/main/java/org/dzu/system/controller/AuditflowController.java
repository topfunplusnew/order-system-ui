package org.dzu.system.controller;

import org.dzu.common.annotation.Log;
import org.dzu.common.core.controller.BaseController;
import org.dzu.common.core.domain.AjaxResult;
import org.dzu.common.core.page.TableDataInfo;
import org.dzu.common.enums.BusinessType;
import org.dzu.system.domain.Auditflow;
import org.dzu.system.service.IAuditflowService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

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
     * 获取审核流程详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:auditflow:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(auditflowService.selectAuditflowById(id));
    }

    /**
     * 修改审核流程
     */
    @PreAuthorize("@ss.hasPermi('system:auditflow:edit')")
    @Log(title = "审核流程", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult put(@Validated @RequestBody List<Auditflow> auditflow)
    {
        return toAjax(auditflowService.put(auditflow));
    }
}
