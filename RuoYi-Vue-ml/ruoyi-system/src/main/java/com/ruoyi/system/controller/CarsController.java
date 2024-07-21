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
import com.ruoyi.system.domain.Cars;
import com.ruoyi.system.service.ICarsService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 汽车信息Controller
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
@RestController
@RequestMapping("/system/cars")
public class CarsController extends BaseController
{
    @Autowired
    private ICarsService carsService;

    /**
     * 查询汽车信息列表
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
     * 导出汽车信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:cars:export')")
    @Log(title = "汽车信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Cars cars)
    {
        List<Cars> list = carsService.selectCarsList(cars);
        ExcelUtil<Cars> util = new ExcelUtil<Cars>(Cars.class);
        util.exportExcel(response, list, "汽车信息数据");
    }

    /**
     * 获取汽车信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:cars:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(carsService.selectCarsById(id));
    }

    /**
     * 新增汽车信息
     */
    @PreAuthorize("@ss.hasPermi('system:cars:add')")
    @Log(title = "汽车信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Cars cars)
    {
        return toAjax(carsService.insertCars(cars));
    }

    /**
     * 修改汽车信息
     */
    @PreAuthorize("@ss.hasPermi('system:cars:edit')")
    @Log(title = "汽车信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Cars cars)
    {
        return toAjax(carsService.updateCars(cars));
    }

    /**
     * 删除汽车信息
     */
    @PreAuthorize("@ss.hasPermi('system:cars:remove')")
    @Log(title = "汽车信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(carsService.deleteCarsByIds(ids));
    }
}
