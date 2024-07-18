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
import org.dzu.system.domain.Bankacceptance;
import org.dzu.system.service.IBankacceptanceService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 银行承兑Controller
 * 
 * @author ml
 * @date 2024-07-18
 */
@RestController
@RequestMapping("/system/bankacceptance")
public class BankacceptanceController extends BaseController
{
    @Autowired
    private IBankacceptanceService bankacceptanceService;

    /**
     * 查询银行承兑列表
     */
    @PreAuthorize("@ss.hasPermi('system:bankacceptance:list')")
    @GetMapping("/list")
    public TableDataInfo list(Bankacceptance bankacceptance)
    {
        startPage();
        List<Bankacceptance> list = bankacceptanceService.selectBankacceptanceList(bankacceptance);
        return getDataTable(list);
    }

    /**
     * 导出银行承兑列表
     */
    @PreAuthorize("@ss.hasPermi('system:bankacceptance:export')")
    @Log(title = "银行承兑", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Bankacceptance bankacceptance)
    {
        List<Bankacceptance> list = bankacceptanceService.selectBankacceptanceList(bankacceptance);
        ExcelUtil<Bankacceptance> util = new ExcelUtil<Bankacceptance>(Bankacceptance.class);
        util.exportExcel(response, list, "银行承兑数据");
    }

    /**
     * 获取银行承兑详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:bankacceptance:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(bankacceptanceService.selectBankacceptanceById(id));
    }

    /**
     * 新增银行承兑
     */
    @PreAuthorize("@ss.hasPermi('system:bankacceptance:add')")
    @Log(title = "银行承兑", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Bankacceptance bankacceptance)
    {
        return toAjax(bankacceptanceService.insertBankacceptance(bankacceptance));
    }

    /**
     * 修改银行承兑
     */
    @PreAuthorize("@ss.hasPermi('system:bankacceptance:edit')")
    @Log(title = "银行承兑", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Bankacceptance bankacceptance)
    {
        return toAjax(bankacceptanceService.updateBankacceptance(bankacceptance));
    }

    /**
     * 删除银行承兑
     */
    @PreAuthorize("@ss.hasPermi('system:bankacceptance:remove')")
    @Log(title = "银行承兑", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(bankacceptanceService.deleteBankacceptanceByIds(ids));
    }
}
