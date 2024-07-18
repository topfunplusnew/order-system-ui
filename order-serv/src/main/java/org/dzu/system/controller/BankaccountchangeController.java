package org.dzu.system.controller;

import org.dzu.common.annotation.Log;
import org.dzu.common.core.controller.BaseController;
import org.dzu.common.core.domain.AjaxResult;
import org.dzu.common.core.page.TableDataInfo;
import org.dzu.common.enums.BusinessType;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.system.domain.Bankaccountchange;
import org.dzu.system.service.IBankaccountchangeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 银行账号变更Controller
 * 
 * @author ml
 * @date 2024-07-18
 */
@RestController
@RequestMapping("/system/bankaccountchange")
public class BankaccountchangeController extends BaseController
{
    @Autowired
    private IBankaccountchangeService bankaccountchangeService;

    /**
     * 查询银行账号变更列表
     */
    @PreAuthorize("@ss.hasPermi('system:bankaccountchange:list')")
    @GetMapping("/list")
    public TableDataInfo list(Bankaccountchange bankaccountchange)
    {
        startPage();
        List<Bankaccountchange> list = bankaccountchangeService.selectBankaccountchangeList(bankaccountchange);
        return getDataTable(list);
    }

    /**
     * 导出银行账号变更列表
     */
    @PreAuthorize("@ss.hasPermi('system:bankaccountchange:export')")
    @Log(title = "银行账号变更", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Bankaccountchange bankaccountchange)
    {
        List<Bankaccountchange> list = bankaccountchangeService.selectBankaccountchangeList(bankaccountchange);
        ExcelUtil<Bankaccountchange> util = new ExcelUtil<Bankaccountchange>(Bankaccountchange.class);
        util.exportExcel(response, list, "银行账号变更数据");
    }

    /**
     * 获取银行账号变更详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:bankaccountchange:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(bankaccountchangeService.selectBankaccountchangeById(id));
    }

    /**
     * 新增银行账号变更
     */
    @PreAuthorize("@ss.hasPermi('system:bankaccountchange:add')")
    @Log(title = "银行账号变更", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Bankaccountchange bankaccountchange)
    {
        return toAjax(bankaccountchangeService.insertBankaccountchange(bankaccountchange));
    }

    /**
     * 修改银行账号变更
     */
    @PreAuthorize("@ss.hasPermi('system:bankaccountchange:edit')")
    @Log(title = "银行账号变更", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Bankaccountchange bankaccountchange)
    {
        return toAjax(bankaccountchangeService.updateBankaccountchange(bankaccountchange));
    }

    /**
     * 删除银行账号变更
     */
    @PreAuthorize("@ss.hasPermi('system:bankaccountchange:remove')")
    @Log(title = "银行账号变更", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(bankaccountchangeService.deleteBankaccountchangeByIds(ids));
    }
}
