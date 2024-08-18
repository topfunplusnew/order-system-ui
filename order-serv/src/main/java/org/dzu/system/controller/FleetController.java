package org.dzu.system.controller;

import org.dzu.common.annotation.Log;
import org.dzu.common.core.controller.BaseController;
import org.dzu.common.core.domain.AjaxResult;
import org.dzu.common.core.page.TableDataInfo;
import org.dzu.common.enums.BusinessType;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.system.domain.Fleet;
import org.dzu.system.service.impl.FleetServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 车队Controller
 * 
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/fleet")
public class FleetController extends BaseController
{
    @Autowired
    private FleetServiceImpl fleetService;

    /**
     * 查询车队列表
     */
    @PreAuthorize("@ss.hasPermi('system:fleet:list')")
    @GetMapping("/list")
    public TableDataInfo list(Fleet fleet)
    {
        startPage();
        List<Fleet> list = fleetService.selectFleetList(fleet);
        return getDataTable(list);
    }

    /**
     * 导出车队列表
     */
    @PreAuthorize("@ss.hasPermi('system:fleet:export')")
    @Log(title = "车队", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Fleet fleet)
    {
        List<Fleet> list = fleetService.selectFleetList(fleet);
        ExcelUtil<Fleet> util = new ExcelUtil<Fleet>(Fleet.class);
        util.exportExcel(response, list, "车队数据");
    }

    /**
     * 获取车队详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:fleet:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(fleetService.selectFleetById(id));
    }

    /**
     * 新增车队
     */
    @PreAuthorize("@ss.hasPermi('system:fleet:add')")
    @Log(title = "车队", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody Fleet fleet)
    {
        return toAjax(fleetService.insertFleet(fleet));
    }

    /**
     * 修改车队
     */
    @PreAuthorize("@ss.hasPermi('system:fleet:edit')")
    @Log(title = "车队", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody Fleet fleet)
    {
        return toAjax(fleetService.updateFleet(fleet));
    }

    /**
     * 删除车队
     */
    @PreAuthorize("@ss.hasPermi('system:fleet:remove')")
    @Log(title = "车队", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(fleetService.deleteFleetByIds(ids));
    }
}
