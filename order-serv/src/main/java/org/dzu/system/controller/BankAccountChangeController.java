package org.dzu.system.controller;

import org.dzu.common.annotation.Log;
import org.dzu.common.core.controller.BaseController;
import org.dzu.common.core.domain.AjaxResult;
import org.dzu.common.core.page.TableDataInfo;
import org.dzu.common.enums.BusinessType;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.system.domain.BankAccountChange;
import org.dzu.system.service.IBankAccountChangeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 银行账号变动流水Controller
 * 
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/bankAccountChange")
public class BankAccountChangeController extends BaseController
{
    @Autowired
    private IBankAccountChangeService bankAccountChangeService;

    /**
     * 查询银行账号变动流水列表
     */
    @PreAuthorize("@ss.hasPermi('system:bankaccountchange:list')")
    @GetMapping("/list")
    public TableDataInfo list(BankAccountChange bankAccountChange)
    {
        startPage();
        List<BankAccountChange> list = bankAccountChangeService.selectBankAccountChangeList(bankAccountChange);
        return getDataTable(list);
    }

    /**
     * 导出银行账号变动流水列表
     */
    @PreAuthorize("@ss.hasPermi('system:bankaccountchange:export')")
    @Log(title = "银行账号变动流水", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, BankAccountChange bankAccountChange)
    {
        List<BankAccountChange> list = bankAccountChangeService.selectBankAccountChangeList(bankAccountChange);
        ExcelUtil<BankAccountChange> util = new ExcelUtil<BankAccountChange>(BankAccountChange.class);
        util.exportExcel(response, list, "银行账号变动流水数据");
    }

    /**
     * 获取银行账号变动流水详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:bankaccountchange:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(bankAccountChangeService.selectBankAccountChangeById(id));
    }

    /**
     * 新增银行账号变动流水
     */
    @PreAuthorize("@ss.hasPermi('system:bankaccountchange:add')")
    @Log(title = "银行账号变动流水", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody BankAccountChange bankAccountChange)
    {
        return toAjax(bankAccountChangeService.insertBankAccountChange(bankAccountChange));
    }

    /**
     * 修改银行账号变动流水
     */
    @PreAuthorize("@ss.hasPermi('system:bankaccountchange:edit')")
    @Log(title = "银行账号变动流水", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody BankAccountChange bankAccountChange)
    {
        return toAjax(bankAccountChangeService.updateBankAccountChange(bankAccountChange));
    }

    /**
     * 删除银行账号变动流水
     */
    @PreAuthorize("@ss.hasPermi('system:bankaccountchange:remove')")
    @Log(title = "银行账号变动流水", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(bankAccountChangeService.deleteBankAccountChangeByIds(ids));
    }
}
