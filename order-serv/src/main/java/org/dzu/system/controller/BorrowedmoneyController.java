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
import org.dzu.system.domain.Borrowedmoney;
import org.dzu.system.service.IBorrowedmoneyService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 从外部借入款、贷款Controller
 * 
 * @author ml
 * @date 2024-07-19
 */
@RestController
@RequestMapping("/system/borrowedmoney")
public class BorrowedmoneyController extends BaseController
{
    @Autowired
    private IBorrowedmoneyService borrowedmoneyService;

    /**
     * 查询从外部借入款、贷款列表
     */
    @PreAuthorize("@ss.hasPermi('system:borrowedmoney:list')")
    @GetMapping("/list")
    public TableDataInfo list(Borrowedmoney borrowedmoney)
    {
        startPage();
        List<Borrowedmoney> list = borrowedmoneyService.selectBorrowedmoneyList(borrowedmoney);
        return getDataTable(list);
    }

    /**
     * 导出从外部借入款、贷款列表
     */
    @PreAuthorize("@ss.hasPermi('system:borrowedmoney:export')")
    @Log(title = "从外部借入款、贷款", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Borrowedmoney borrowedmoney)
    {
        List<Borrowedmoney> list = borrowedmoneyService.selectBorrowedmoneyList(borrowedmoney);
        ExcelUtil<Borrowedmoney> util = new ExcelUtil<Borrowedmoney>(Borrowedmoney.class);
        util.exportExcel(response, list, "从外部借入款、贷款数据");
    }

    /**
     * 获取从外部借入款、贷款详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:borrowedmoney:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(borrowedmoneyService.selectBorrowedmoneyById(id));
    }

    /**
     * 新增从外部借入款、贷款
     */
    @PreAuthorize("@ss.hasPermi('system:borrowedmoney:add')")
    @Log(title = "从外部借入款、贷款", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Borrowedmoney borrowedmoney)
    {
        return toAjax(borrowedmoneyService.insertBorrowedmoney(borrowedmoney));
    }

    /**
     * 修改从外部借入款、贷款
     */
    @PreAuthorize("@ss.hasPermi('system:borrowedmoney:edit')")
    @Log(title = "从外部借入款、贷款", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Borrowedmoney borrowedmoney)
    {
        return toAjax(borrowedmoneyService.updateBorrowedmoney(borrowedmoney));
    }

    /**
     * 删除从外部借入款、贷款
     */
    @PreAuthorize("@ss.hasPermi('system:borrowedmoney:remove')")
    @Log(title = "从外部借入款、贷款", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(borrowedmoneyService.deleteBorrowedmoneyByIds(ids));
    }
}
