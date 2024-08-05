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
import org.dzu.system.domain.BorrowedMoney;
import org.dzu.system.service.IBorrowedMoneyService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 从外部借款信息Controller
 * 
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/borrowedMoney")
public class BorrowedMoneyController extends BaseController
{
    @Autowired
    private IBorrowedMoneyService borrowedMoneyService;

    /**
     * 查询从外部借款信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:borrowedmoney:list')")
    @GetMapping("/list")
    public TableDataInfo list(BorrowedMoney borrowedMoney)
    {
        startPage();
        List<BorrowedMoney> list = borrowedMoneyService.selectBorrowedMoneyList(borrowedMoney);
        return getDataTable(list);
    }

    /**
     * 导出从外部借款信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:borrowedmoney:export')")
    @Log(title = "从外部借款信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, BorrowedMoney borrowedMoney)
    {
        List<BorrowedMoney> list = borrowedMoneyService.selectBorrowedMoneyList(borrowedMoney);
        ExcelUtil<BorrowedMoney> util = new ExcelUtil<BorrowedMoney>(BorrowedMoney.class);
        util.exportExcel(response, list, "从外部借款信息数据");
    }

    /**
     * 获取从外部借款信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:borrowedmoney:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(borrowedMoneyService.selectBorrowedMoneyById(id));
    }

    /**
     * 新增从外部借款信息
     */
    @PreAuthorize("@ss.hasPermi('system:borrowedmoney:add')")
    @Log(title = "从外部借款信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody BorrowedMoney borrowedMoney)
    {
        return toAjax(borrowedMoneyService.insertBorrowedMoney(borrowedMoney));
    }

    /**
     * 修改从外部借款信息
     */
    @PreAuthorize("@ss.hasPermi('system:borrowedmoney:edit')")
    @Log(title = "从外部借款信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody BorrowedMoney borrowedMoney)
    {
        return toAjax(borrowedMoneyService.updateBorrowedMoney(borrowedMoney));
    }

    /**
     * 删除从外部借款信息
     */
    @PreAuthorize("@ss.hasPermi('system:borrowedmoney:remove')")
    @Log(title = "从外部借款信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(borrowedMoneyService.deleteBorrowedMoneyByIds(ids));
    }
}
