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
import org.dzu.system.domain.Balanceaccounts;
import org.dzu.system.service.IBalanceaccountsService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 平账Controller
 * 
 * @author ml
 * @date 2024-07-19
 */
@RestController
@RequestMapping("/system/balanceaccounts")
public class BalanceaccountsController extends BaseController
{
    @Autowired
    private IBalanceaccountsService balanceaccountsService;

    /**
     * 查询平账列表
     */
    @PreAuthorize("@ss.hasPermi('system:balanceaccounts:list')")
    @GetMapping("/list")
    public TableDataInfo list(Balanceaccounts balanceaccounts)
    {
        startPage();
        List<Balanceaccounts> list = balanceaccountsService.selectBalanceaccountsList(balanceaccounts);
        return getDataTable(list);
    }

    /**
     * 导出平账列表
     */
    @PreAuthorize("@ss.hasPermi('system:balanceaccounts:export')")
    @Log(title = "平账", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Balanceaccounts balanceaccounts)
    {
        List<Balanceaccounts> list = balanceaccountsService.selectBalanceaccountsList(balanceaccounts);
        ExcelUtil<Balanceaccounts> util = new ExcelUtil<Balanceaccounts>(Balanceaccounts.class);
        util.exportExcel(response, list, "平账数据");
    }

    /**
     * 获取平账详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:balanceaccounts:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(balanceaccountsService.selectBalanceaccountsById(id));
    }

    /**
     * 新增平账
     */
    @PreAuthorize("@ss.hasPermi('system:balanceaccounts:add')")
    @Log(title = "平账", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Balanceaccounts balanceaccounts)
    {
        return toAjax(balanceaccountsService.insertBalanceaccounts(balanceaccounts));
    }

    /**
     * 修改平账
     */
    @PreAuthorize("@ss.hasPermi('system:balanceaccounts:edit')")
    @Log(title = "平账", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Balanceaccounts balanceaccounts)
    {
        return toAjax(balanceaccountsService.updateBalanceaccounts(balanceaccounts));
    }

    /**
     * 删除平账
     */
    @PreAuthorize("@ss.hasPermi('system:balanceaccounts:remove')")
    @Log(title = "平账", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(balanceaccountsService.deleteBalanceaccountsByIds(ids));
    }
}
