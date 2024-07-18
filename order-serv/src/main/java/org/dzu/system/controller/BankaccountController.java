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
import org.dzu.system.domain.Bankaccount;
import org.dzu.system.service.IBankaccountService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 银行账户Controller
 * 
 * @author ml
 * @date 2024-07-18
 */
@RestController
@RequestMapping("/system/bankaccount")
public class BankaccountController extends BaseController
{
    @Autowired
    private IBankaccountService bankaccountService;

    /**
     * 查询银行账户列表
     */
    @PreAuthorize("@ss.hasPermi('system:bankaccount:list')")
    @GetMapping("/list")
    public TableDataInfo list(Bankaccount bankaccount)
    {
        startPage();
        List<Bankaccount> list = bankaccountService.selectBankaccountList(bankaccount);
        return getDataTable(list);
    }

    /**
     * 导出银行账户列表
     */
    @PreAuthorize("@ss.hasPermi('system:bankaccount:export')")
    @Log(title = "银行账户", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Bankaccount bankaccount)
    {
        List<Bankaccount> list = bankaccountService.selectBankaccountList(bankaccount);
        ExcelUtil<Bankaccount> util = new ExcelUtil<Bankaccount>(Bankaccount.class);
        util.exportExcel(response, list, "银行账户数据");
    }

    /**
     * 获取银行账户详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:bankaccount:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(bankaccountService.selectBankaccountById(id));
    }

    /**
     * 新增银行账户
     */
    @PreAuthorize("@ss.hasPermi('system:bankaccount:add')")
    @Log(title = "银行账户", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Bankaccount bankaccount)
    {
        return toAjax(bankaccountService.insertBankaccount(bankaccount));
    }

    /**
     * 修改银行账户
     */
    @PreAuthorize("@ss.hasPermi('system:bankaccount:edit')")
    @Log(title = "银行账户", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Bankaccount bankaccount)
    {
        return toAjax(bankaccountService.updateBankaccount(bankaccount));
    }

    /**
     * 删除银行账户
     */
    @PreAuthorize("@ss.hasPermi('system:bankaccount:remove')")
    @Log(title = "银行账户", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(bankaccountService.deleteBankaccountByIds(ids));
    }
}
