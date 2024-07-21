package com.ruoyi.system.controller;

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
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.Payment;
import com.ruoyi.system.service.IPaymentService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 收付款信息Controller
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
@RestController
@RequestMapping("/system/payment")
public class PaymentController extends BaseController
{
    @Autowired
    private IPaymentService paymentService;

    /**
     * 查询收付款信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:payment:list')")
    @GetMapping("/list")
    public TableDataInfo list(Payment payment)
    {
        startPage();
        List<Payment> list = paymentService.selectPaymentList(payment);
        return getDataTable(list);
    }

    /**
     * 导出收付款信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:payment:export')")
    @Log(title = "收付款信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Payment payment)
    {
        List<Payment> list = paymentService.selectPaymentList(payment);
        ExcelUtil<Payment> util = new ExcelUtil<Payment>(Payment.class);
        util.exportExcel(response, list, "收付款信息数据");
    }

    /**
     * 获取收付款信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:payment:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(paymentService.selectPaymentById(id));
    }

    /**
     * 新增收付款信息
     */
    @PreAuthorize("@ss.hasPermi('system:payment:add')")
    @Log(title = "收付款信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Payment payment)
    {
        return toAjax(paymentService.insertPayment(payment));
    }

    /**
     * 修改收付款信息
     */
    @PreAuthorize("@ss.hasPermi('system:payment:edit')")
    @Log(title = "收付款信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Payment payment)
    {
        return toAjax(paymentService.updatePayment(payment));
    }

    /**
     * 删除收付款信息
     */
    @PreAuthorize("@ss.hasPermi('system:payment:remove')")
    @Log(title = "收付款信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(paymentService.deletePaymentByIds(ids));
    }
}
