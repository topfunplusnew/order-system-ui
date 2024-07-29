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
import org.dzu.system.domain.BankAcceptance;
import org.dzu.system.service.IBankAcceptanceService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 商业票据、银行承兑Controller
 * 
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/bankAcceptance")
public class BankAcceptanceController extends BaseController
{
    @Autowired
    private IBankAcceptanceService bankAcceptanceService;

    /**
     * 查询商业票据、银行承兑列表
     */
    @PreAuthorize("@ss.hasPermi('system:bankAcceptance:list')")
    @GetMapping("/list")
    public TableDataInfo list(BankAcceptance bankAcceptance)
    {
        startPage();
        List<BankAcceptance> list = bankAcceptanceService.selectBankAcceptanceList(bankAcceptance);
        return getDataTable(list);
    }

    /**
     * 导出商业票据、银行承兑列表
     */
    @PreAuthorize("@ss.hasPermi('system:bankAcceptance:export')")
    @Log(title = "商业票据、银行承兑", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, BankAcceptance bankAcceptance)
    {
        List<BankAcceptance> list = bankAcceptanceService.selectBankAcceptanceList(bankAcceptance);
        ExcelUtil<BankAcceptance> util = new ExcelUtil<BankAcceptance>(BankAcceptance.class);
        util.exportExcel(response, list, "商业票据、银行承兑数据");
    }

    /**
     * 获取商业票据、银行承兑详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:bankAcceptance:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(bankAcceptanceService.selectBankAcceptanceById(id));
    }

    /**
     * 新增商业票据、银行承兑
     */
    @PreAuthorize("@ss.hasPermi('system:bankAcceptance:add')")
    @Log(title = "商业票据、银行承兑", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody BankAcceptance bankAcceptance)
    {
        return toAjax(bankAcceptanceService.insertBankAcceptance(bankAcceptance));
    }

    /**
     * 修改商业票据、银行承兑
     */
    @PreAuthorize("@ss.hasPermi('system:bankAcceptance:edit')")
    @Log(title = "商业票据、银行承兑", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody BankAcceptance bankAcceptance)
    {
        return toAjax(bankAcceptanceService.updateBankAcceptance(bankAcceptance));
    }

    /**
     * 删除商业票据、银行承兑
     */
    @PreAuthorize("@ss.hasPermi('system:bankAcceptance:remove')")
    @Log(title = "商业票据、银行承兑", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(bankAcceptanceService.deleteBankAcceptanceByIds(ids));
    }
}
