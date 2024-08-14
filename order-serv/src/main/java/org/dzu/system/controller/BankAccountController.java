package org.dzu.system.controller;

import org.dzu.common.annotation.Log;
import org.dzu.common.core.controller.BaseController;
import org.dzu.common.core.domain.AjaxResult;
import org.dzu.common.core.page.TableDataInfo;
import org.dzu.common.enums.BusinessType;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.system.domain.BankAccount;
import org.dzu.system.domain.vo.TranseferMoney;
import org.dzu.system.service.IBankAccountService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 银行账号Controller
 * 
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/bankAccount")
public class BankAccountController extends BaseController
{
    @Autowired
    private IBankAccountService bankAccountService;

    /**
     * 查询银行账号列表
     */
    @PreAuthorize("@ss.hasPermi('system:bankaccount:list')")
    @GetMapping("/list")
    public TableDataInfo list(BankAccount bankAccount)
    {
        startPage();
        List<BankAccount> list = bankAccountService.selectBankAccountList(bankAccount);
        return getDataTable(list);
    }

    /**
     * 导出银行账号列表
     */
    @PreAuthorize("@ss.hasPermi('system:bankaccount:export')")
    @Log(title = "银行账号", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, BankAccount bankAccount)
    {
        List<BankAccount> list = bankAccountService.selectBankAccountList(bankAccount);
        ExcelUtil<BankAccount> util = new ExcelUtil<BankAccount>(BankAccount.class);
        util.exportExcel(response, list, "银行账号数据");
    }

    /**
     * 获取银行账号详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:bankaccount:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(bankAccountService.selectBankAccountById(id));
    }

    /**
     * 新增银行账号
     */
    @PreAuthorize("@ss.hasPermi('system:bankaccount:add')")
    @Log(title = "银行账号", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody BankAccount bankAccount)
    {
        return toAjax(bankAccountService.insertBankAccount(bankAccount));
    }

    /**
     * 修改银行账号
     */
    @PreAuthorize("@ss.hasPermi('system:bankaccount:edit')")
    @Log(title = "银行账号", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody BankAccount bankAccount)
    {
        return toAjax(bankAccountService.updateBankAccount(bankAccount));
    }

    /**
     * 删除银行账号
     */
    @PreAuthorize("@ss.hasPermi('system:bankaccount:remove')")
    @Log(title = "银行账号", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(bankAccountService.deleteBankAccountByIds(ids));
    }

    /**
     *  两张卡之间进行转账
     */
    @PreAuthorize("@ss.hasPermi('system:bankaccount:edit')")
    @Log(title = "银行账号", businessType = BusinessType.UPDATE)
    @PostMapping("/transfer")
    public AjaxResult transfer(@Validated @RequestBody TranseferMoney transeferMoney)
    {
        return success(bankAccountService.transferMoney(transeferMoney));
    }
}
