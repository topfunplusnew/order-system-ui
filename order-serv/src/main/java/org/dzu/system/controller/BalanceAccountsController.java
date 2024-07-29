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
import org.dzu.system.domain.BalanceAccounts;
import org.dzu.system.service.IBalanceAccountsService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 平账信息Controller
 * 
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/BalanceAccounts")
public class BalanceAccountsController extends BaseController
{
    @Autowired
    private IBalanceAccountsService balanceAccountsService;

    /**
     * 查询平账信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:BalanceAccounts:list')")
    @GetMapping("/list")
    public TableDataInfo list(BalanceAccounts balanceAccounts)
    {
        startPage();
        List<BalanceAccounts> list = balanceAccountsService.selectBalanceAccountsList(balanceAccounts);
        return getDataTable(list);
    }

    /**
     * 导出平账信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:BalanceAccounts:export')")
    @Log(title = "平账信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, BalanceAccounts balanceAccounts)
    {
        List<BalanceAccounts> list = balanceAccountsService.selectBalanceAccountsList(balanceAccounts);
        ExcelUtil<BalanceAccounts> util = new ExcelUtil<BalanceAccounts>(BalanceAccounts.class);
        util.exportExcel(response, list, "平账信息数据");
    }

    /**
     * 获取平账信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:BalanceAccounts:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(balanceAccountsService.selectBalanceAccountsById(id));
    }

    /**
     * 新增平账信息
     */
    @PreAuthorize("@ss.hasPermi('system:BalanceAccounts:add')")
    @Log(title = "平账信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody BalanceAccounts balanceAccounts)
    {
        return toAjax(balanceAccountsService.insertBalanceAccounts(balanceAccounts));
    }

    /**
     * 修改平账信息
     */
    @PreAuthorize("@ss.hasPermi('system:BalanceAccounts:edit')")
    @Log(title = "平账信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody BalanceAccounts balanceAccounts)
    {
        return toAjax(balanceAccountsService.updateBalanceAccounts(balanceAccounts));
    }

    /**
     * 删除平账信息
     */
    @PreAuthorize("@ss.hasPermi('system:BalanceAccounts:remove')")
    @Log(title = "平账信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(balanceAccountsService.deleteBalanceAccountsByIds(ids));
    }
}
