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
import org.dzu.system.domain.CarApply;
import org.dzu.system.service.ICarApplyService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 车辆使用申请Controller
 * 
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/carApply")
public class CarApplyController extends BaseController
{
    @Autowired
    private ICarApplyService carApplyService;

    /**
     * 查询车辆使用申请列表
     */
    @PreAuthorize("@ss.hasPermi('system:carapply:list')")
    @GetMapping("/list")
    public TableDataInfo list(CarApply carApply)
    {
        startPage();
        List<CarApply> list = carApplyService.selectCarApplyList(carApply);
        return getDataTable(list);
    }

    /**
     * 导出车辆使用申请列表
     */
    @PreAuthorize("@ss.hasPermi('system:carapply:export')")
    @Log(title = "车辆使用申请", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, CarApply carApply)
    {
        List<CarApply> list = carApplyService.selectCarApplyList(carApply);
        ExcelUtil<CarApply> util = new ExcelUtil<CarApply>(CarApply.class);
        util.exportExcel(response, list, "车辆使用申请数据");
    }

    /**
     * 获取车辆使用申请详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:carapply:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(carApplyService.selectCarApplyById(id));
    }

    /**
     * 新增车辆使用申请
     */
    @PreAuthorize("@ss.hasPermi('system:carapply:add')")
    @Log(title = "车辆使用申请", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody CarApply carApply)
    {
        return toAjax(carApplyService.insertCarApply(carApply));
    }

    /**
     * 修改车辆使用申请
     */
    @PreAuthorize("@ss.hasPermi('system:carapply:edit')")
    @Log(title = "车辆使用申请", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody CarApply carApply)
    {
        return toAjax(carApplyService.updateCarApply(carApply));
    }

    /**
     * 删除车辆使用申请
     */
    @PreAuthorize("@ss.hasPermi('system:carapply:remove')")
    @Log(title = "车辆使用申请", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(carApplyService.deleteCarApplyByIds(ids));
    }
}
