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
import org.dzu.system.domain.Customervisit;
import org.dzu.system.service.ICustomervisitService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 走访记录Controller
 * 
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/customervisit")
public class CustomervisitController extends BaseController
{
    @Autowired
    private ICustomervisitService customervisitService;

    /**
     * 查询走访记录列表
     */
    @PreAuthorize("@ss.hasPermi('system:customervisit:list')")
    @GetMapping("/list")
    public TableDataInfo list(Customervisit customervisit)
    {
        startPage();
        List<Customervisit> list = customervisitService.selectCustomervisitList(customervisit);
        return getDataTable(list);
    }

    /**
     * 导出走访记录列表
     */
    @PreAuthorize("@ss.hasPermi('system:customervisit:export')")
    @Log(title = "走访记录", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Customervisit customervisit)
    {
        List<Customervisit> list = customervisitService.selectCustomervisitList(customervisit);
        ExcelUtil<Customervisit> util = new ExcelUtil<Customervisit>(Customervisit.class);
        util.exportExcel(response, list, "走访记录数据");
    }

    /**
     * 获取走访记录详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:customervisit:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(customervisitService.selectCustomervisitById(id));
    }

    /**
     * 新增走访记录
     */
    @PreAuthorize("@ss.hasPermi('system:customervisit:add')")
    @Log(title = "走访记录", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody Customervisit customervisit)
    {
        return toAjax(customervisitService.insertCustomervisit(customervisit));
    }

    /**
     * 修改走访记录
     */
    @PreAuthorize("@ss.hasPermi('system:customervisit:edit')")
    @Log(title = "走访记录", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody Customervisit customervisit)
    {
        return toAjax(customervisitService.updateCustomervisit(customervisit));
    }

    /**
     * 删除走访记录
     */
    @PreAuthorize("@ss.hasPermi('system:customervisit:remove')")
    @Log(title = "走访记录", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(customervisitService.deleteCustomervisitByIds(ids));
    }
}
