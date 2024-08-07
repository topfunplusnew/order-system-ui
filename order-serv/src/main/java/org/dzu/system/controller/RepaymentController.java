package org.dzu.system.controller;

import org.dzu.common.annotation.Log;
import org.dzu.common.core.controller.BaseController;
import org.dzu.common.core.domain.AjaxResult;
import org.dzu.common.core.page.TableDataInfo;
import org.dzu.common.enums.BusinessType;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.system.domain.Repayment;
import org.dzu.system.service.IRepaymentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 贷款还款信息Controller
 * 
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/repayment")
public class RepaymentController extends BaseController
{
    @Autowired
    private IRepaymentService repaymentService;

    /**
     * 查询贷款还款信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:repayment:list')")
    @GetMapping("/list")
    public TableDataInfo list(Repayment repayment)
    {
        startPage();
        List<Repayment> list = repaymentService.selectRepaymentList(repayment);
        return getDataTable(list);
    }

    /**
     * 导出贷款还款信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:repayment:export')")
    @Log(title = "贷款还款信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Repayment repayment)
    {
        List<Repayment> list = repaymentService.selectRepaymentList(repayment);
        ExcelUtil<Repayment> util = new ExcelUtil<Repayment>(Repayment.class);
        util.exportExcel(response, list, "贷款还款信息数据");
    }

    /**
     * 获取贷款还款信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:repayment:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(repaymentService.selectRepaymentById(id));
    }

    /**
     * 获取贷款还款信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:repayment:query')")
    @GetMapping(value = "/loanNo/{uuid}")
    public AjaxResult getInfoByLoanNo(@PathVariable("uuid") String  id)
    {
        return success(repaymentService.selectRepaymentByLoanNo(id));
    }

    /**
     * 新增贷款还款信息
     */
    @PreAuthorize("@ss.hasPermi('system:repayment:add')")
    @Log(title = "贷款还款信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody Repayment repayment)
    {
        return toAjax(repaymentService.insertRepayment(repayment));
    }

    /**
     * 修改贷款还款信息
     */
    @PreAuthorize("@ss.hasPermi('system:repayment:edit')")
    @Log(title = "贷款还款信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody Repayment repayment)
    {
        return toAjax(repaymentService.updateRepayment(repayment));
    }

    /**
     * 删除贷款还款信息
     */
    @PreAuthorize("@ss.hasPermi('system:repayment:remove')")
    @Log(title = "贷款还款信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(repaymentService.deleteRepaymentByIds(ids));
    }
}
