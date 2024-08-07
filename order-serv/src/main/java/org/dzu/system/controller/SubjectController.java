package org.dzu.system.controller;

import org.dzu.common.annotation.Log;
import org.dzu.common.core.controller.BaseController;
import org.dzu.common.core.domain.AjaxResult;
import org.dzu.common.enums.BusinessType;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.system.domain.Subject;
import org.dzu.system.service.ISubjectService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 科目Controller
 * 
 * @author ml
 * @date 2024-08-02
 */
@RestController
@RequestMapping("/system/subject")
public class SubjectController extends BaseController
{
    @Autowired
    private ISubjectService subjectService;

    /**
     * 查询科目列表
     */
    @PreAuthorize("@ss.hasPermi('system:subject:list')")
    @GetMapping("/list")
    public AjaxResult list(Subject subject)
    {
        List<Subject> list = subjectService.selectSubjectList(subject);
        return success(list);
    }

    /**
     * 导出科目列表
     */
    @PreAuthorize("@ss.hasPermi('system:subject:export')")
    @Log(title = "科目", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Subject subject)
    {
        List<Subject> list = subjectService.selectSubjectList(subject);
        ExcelUtil<Subject> util = new ExcelUtil<Subject>(Subject.class);
        util.exportExcel(response, list, "科目数据");
    }

    /**
     * 获取科目详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:subject:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(subjectService.selectSubjectById(id));
    }

    /**
     * 新增科目
     */
    @PreAuthorize("@ss.hasPermi('system:subject:add')")
    @Log(title = "科目", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody Subject subject)
    {
        return toAjax(subjectService.insertSubject(subject));
    }

    /**
     * 修改科目
     */
    @PreAuthorize("@ss.hasPermi('system:subject:edit')")
    @Log(title = "科目", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody Subject subject)
    {
        return toAjax(subjectService.updateSubject(subject));
    }

    /**
     * 删除科目
     */
    @PreAuthorize("@ss.hasPermi('system:subject:remove')")
    @Log(title = "科目", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(subjectService.deleteSubjectByIds(ids));
    }
}
