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
import org.dzu.system.domain.Cars;
import org.dzu.system.service.ICarsService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 车辆管理Controller
 * 
 * @author ml
 * @date 2024-07-19
 */
@RestController
@RequestMapping("/system/cars")
public class CarsController extends BaseController
{
    @Autowired
    private ICarsService carsService;

    /**
     * 查询车辆管理列表
     */
    @PreAuthorize("@ss.hasPermi('system:cars:list')")
    @GetMapping("/list")
    public TableDataInfo list(Cars cars)
    {
        startPage();
        List<Cars> list = carsService.selectCarsList(cars);
        return getDataTable(list);
    }

    /**
     * 导出车辆管理列表
     */
    @PreAuthorize("@ss.hasPermi('system:cars:export')")
    @Log(title = "车辆管理", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Cars cars)
    {
        List<Cars> list = carsService.selectCarsList(cars);
        ExcelUtil<Cars> util = new ExcelUtil<Cars>(Cars.class);
        util.exportExcel(response, list, "车辆管理数据");
    }

    /**
     * 获取车辆管理详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:cars:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(carsService.selectCarsById(id));
    }

    /**
     * 新增车辆管理
     */
    @PreAuthorize("@ss.hasPermi('system:cars:add')")
    @Log(title = "车辆管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Cars cars)
    {
        return toAjax(carsService.insertCars(cars));
    }

    /**
     * 修改车辆管理
     */
    @PreAuthorize("@ss.hasPermi('system:cars:edit')")
    @Log(title = "车辆管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Cars cars)
    {
        return toAjax(carsService.updateCars(cars));
    }

    /**
     * 删除车辆管理
     */
    @PreAuthorize("@ss.hasPermi('system:cars:remove')")
    @Log(title = "车辆管理", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(carsService.deleteCarsByIds(ids));
    }
}
