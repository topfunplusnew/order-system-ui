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
import org.dzu.system.domain.CustomerVisit;
import org.dzu.system.service.ICustomerVisitService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 走访记录Controller
 * 
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/CustomerVisit")
public class CustomerVisitController extends BaseController
{
    @Autowired
    private ICustomerVisitService customerVisitService;

    /**
     * 查询走访记录列表
     */
    @PreAuthorize("@ss.hasPermi('system:customervisit:list')")
    @GetMapping("/list")
    public TableDataInfo list(CustomerVisit customerVisit)
    {
        startPage();
        List<CustomerVisit> list = customerVisitService.selectCustomerVisitList(customerVisit);
        return getDataTable(list);
    }

    /**
     * 导出走访记录列表
     */
    @PreAuthorize("@ss.hasPermi('system:customervisit:export')")
    @Log(title = "走访记录", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, CustomerVisit customerVisit)
    {
        List<CustomerVisit> list = customerVisitService.selectCustomerVisitList(customerVisit);
        ExcelUtil<CustomerVisit> util = new ExcelUtil<CustomerVisit>(CustomerVisit.class);
        util.exportExcel(response, list, "走访记录数据");
    }

    /**
     * 获取走访记录详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:customervisit:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(customerVisitService.selectCustomerVisitById(id));
    }

    /**
     * 新增走访记录
     */
    @PreAuthorize("@ss.hasPermi('system:customervisit:add')")
    @Log(title = "走访记录", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody CustomerVisit customerVisit)
    {
        return toAjax(customerVisitService.insertCustomerVisit(customerVisit));
    }

    /**
     * 修改走访记录
     */
    @PreAuthorize("@ss.hasPermi('system:customervisit:edit')")
    @Log(title = "走访记录", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody CustomerVisit customerVisit)
    {
        return toAjax(customerVisitService.updateCustomerVisit(customerVisit));
    }

    /**
     * 删除走访记录
     */
    @PreAuthorize("@ss.hasPermi('system:customervisit:remove')")
    @Log(title = "走访记录", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(customerVisitService.deleteCustomerVisitByIds(ids));
    }
}
