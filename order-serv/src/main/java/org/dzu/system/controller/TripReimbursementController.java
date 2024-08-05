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
import org.dzu.system.domain.TripReimbursement;
import org.dzu.system.service.ITripReimbursementService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 出差报销Controller
 * 
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/tripReimbursement")
public class TripReimbursementController extends BaseController
{
    @Autowired
    private ITripReimbursementService tripReimbursementService;

    /**
     * 查询出差报销列表
     */
    @PreAuthorize("@ss.hasPermi('system:tripreimbursement:list')")
    @GetMapping("/list")
    public TableDataInfo list(TripReimbursement tripReimbursement)
    {
        startPage();
        List<TripReimbursement> list = tripReimbursementService.selectTripReimbursementList(tripReimbursement);
        return getDataTable(list);
    }

    /**
     * 导出出差报销列表
     */
    @PreAuthorize("@ss.hasPermi('system:tripreimbursement:export')")
    @Log(title = "出差报销", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, TripReimbursement tripReimbursement)
    {
        List<TripReimbursement> list = tripReimbursementService.selectTripReimbursementList(tripReimbursement);
        ExcelUtil<TripReimbursement> util = new ExcelUtil<TripReimbursement>(TripReimbursement.class);
        util.exportExcel(response, list, "出差报销数据");
    }

    /**
     * 获取出差报销详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:tripreimbursement:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(tripReimbursementService.selectTripReimbursementById(id));
    }

    /**
     * 新增出差报销
     */
    @PreAuthorize("@ss.hasPermi('system:tripreimbursement:add')")
    @Log(title = "出差报销", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody TripReimbursement tripReimbursement)
    {
        return toAjax(tripReimbursementService.insertTripReimbursement(tripReimbursement));
    }

    /**
     * 修改出差报销
     */
    @PreAuthorize("@ss.hasPermi('system:tripreimbursement:edit')")
    @Log(title = "出差报销", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody TripReimbursement tripReimbursement)
    {
        return toAjax(tripReimbursementService.updateTripReimbursement(tripReimbursement));
    }

    /**
     * 删除出差报销
     */
    @PreAuthorize("@ss.hasPermi('system:tripreimbursement:remove')")
    @Log(title = "出差报销", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(tripReimbursementService.deleteTripReimbursementByIds(ids));
    }
}
