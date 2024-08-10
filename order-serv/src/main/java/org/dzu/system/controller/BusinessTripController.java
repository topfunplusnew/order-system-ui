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
import org.dzu.system.domain.BusinessTrip;
import org.dzu.system.service.IBusinessTripService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 出差Controller
 * 
 * @author ml
 * @date 2024-08-10
 */
@RestController
@RequestMapping("/system/BusinessTrip")
public class BusinessTripController extends BaseController
{
    @Autowired
    private IBusinessTripService businessTripService;

    /**
     * 查询出差列表
     */
    @PreAuthorize("@ss.hasPermi('system:BusinessTrip:list')")
    @GetMapping("/list")
    public TableDataInfo list(BusinessTrip businessTrip)
    {
        startPage();
        List<BusinessTrip> list = businessTripService.selectBusinessTripList(businessTrip);
        return getDataTable(list);
    }

    /**
     * 导出出差列表
     */
    @PreAuthorize("@ss.hasPermi('system:BusinessTrip:export')")
    @Log(title = "出差", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, BusinessTrip businessTrip)
    {
        List<BusinessTrip> list = businessTripService.selectBusinessTripList(businessTrip);
        ExcelUtil<BusinessTrip> util = new ExcelUtil<BusinessTrip>(BusinessTrip.class);
        util.exportExcel(response, list, "出差数据");
    }

    /**
     * 获取出差详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:BusinessTrip:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(businessTripService.selectBusinessTripById(id));
    }

    /**
     * 新增出差
     */
    @PreAuthorize("@ss.hasPermi('system:BusinessTrip:add')")
    @Log(title = "出差", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody BusinessTrip businessTrip)
    {
        return toAjax(businessTripService.insertBusinessTrip(businessTrip));
    }

    /**
     * 修改出差
     */
    @PreAuthorize("@ss.hasPermi('system:BusinessTrip:edit')")
    @Log(title = "出差", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody BusinessTrip businessTrip)
    {
        return toAjax(businessTripService.updateBusinessTrip(businessTrip));
    }

    /**
     * 删除出差
     */
    @PreAuthorize("@ss.hasPermi('system:BusinessTrip:remove')")
    @Log(title = "出差", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(businessTripService.deleteBusinessTripByIds(ids));
    }
}
