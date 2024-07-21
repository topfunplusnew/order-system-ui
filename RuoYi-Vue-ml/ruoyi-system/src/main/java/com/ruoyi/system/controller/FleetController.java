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
import com.ruoyi.system.domain.Fleet;
import com.ruoyi.system.service.IFleetService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 车队信息Controller
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
@RestController
@RequestMapping("/system/fleet")
public class FleetController extends BaseController
{
    @Autowired
    private IFleetService fleetService;

    /**
     * 查询车队信息列表
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
     * 导出车队信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:fleet:export')")
    @Log(title = "车队信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Fleet fleet)
    {
        List<Fleet> list = fleetService.selectFleetList(fleet);
        ExcelUtil<Fleet> util = new ExcelUtil<Fleet>(Fleet.class);
        util.exportExcel(response, list, "车队信息数据");
    }

    /**
     * 获取车队信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:fleet:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(fleetService.selectFleetById(id));
    }

    /**
     * 新增车队信息
     */
    @PreAuthorize("@ss.hasPermi('system:fleet:add')")
    @Log(title = "车队信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Fleet fleet)
    {
        return toAjax(fleetService.insertFleet(fleet));
    }

    /**
     * 修改车队信息
     */
    @PreAuthorize("@ss.hasPermi('system:fleet:edit')")
    @Log(title = "车队信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Fleet fleet)
    {
        return toAjax(fleetService.updateFleet(fleet));
    }

    /**
     * 删除车队信息
     */
    @PreAuthorize("@ss.hasPermi('system:fleet:remove')")
    @Log(title = "车队信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(fleetService.deleteFleetByIds(ids));
    }
}
