package org.dzu.system.controller;

import java.util.List;
import javax.servlet.http.HttpServletResponse;

import org.dzu.common.utils.SecurityUtils;
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
import org.dzu.system.domain.PaymentApply;
import org.dzu.system.service.IPaymentApplyService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 付款信息Controller
 * 
 * @author ml
 * @date 2024-08-01
 */
@RestController
@RequestMapping("/system/paymentApply")
public class PaymentApplyController extends BaseController
{
    @Autowired
    private IPaymentApplyService paymentApplyService;

    /**
     * 查询付款信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:paymentapply:list')")
    @GetMapping("/list")
    public TableDataInfo list(PaymentApply paymentApply)
    {
        startPage();
        List<PaymentApply> list = paymentApplyService.selectPaymentApplyList(paymentApply);
        return getDataTable(list);
    }

    /**
     * 导出付款信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:paymentapply:export')")
    @Log(title = "付款信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, PaymentApply paymentApply)
    {
        List<PaymentApply> list = paymentApplyService.selectPaymentApplyList(paymentApply);
        ExcelUtil<PaymentApply> util = new ExcelUtil<PaymentApply>(PaymentApply.class);
        util.exportExcel(response, list, "付款信息数据");
    }

    /**
     * 获取付款信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:paymentapply:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(paymentApplyService.selectPaymentApplyById(id));
    }

    /**
     * 新增付款信息
     */
    @PreAuthorize("@ss.hasPermi('system:paymentapply:add')")
    @Log(title = "付款信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody PaymentApply paymentApply)
    {
        return toAjax(paymentApplyService.insertPaymentApply(paymentApply));
    }

    /**
     * 删除付款信息
     */
    @PreAuthorize("@ss.hasPermi('system:paymentapply:remove')")
    @Log(title = "付款信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(paymentApplyService.deletePaymentApplyByIds(ids));
    }
}
