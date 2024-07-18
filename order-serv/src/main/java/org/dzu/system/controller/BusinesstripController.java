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
import org.dzu.system.domain.Businesstrip;
import org.dzu.system.service.IBusinesstripService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 出差记录Controller
 * 
 * @author ml
 * @date 2024-07-18
 */
@RestController
@RequestMapping("/system/businesstrip")
public class BusinesstripController extends BaseController
{
    @Autowired
    private IBusinesstripService businesstripService;

    /**
     * 查询出差记录列表
     */
    @PreAuthorize("@ss.hasPermi('system:businesstrip:list')")
    @GetMapping("/list")
    public TableDataInfo list(Businesstrip businesstrip)
    {
        startPage();
        List<Businesstrip> list = businesstripService.selectBusinesstripList(businesstrip);
        return getDataTable(list);
    }

    /**
     * 导出出差记录列表
     */
    @PreAuthorize("@ss.hasPermi('system:businesstrip:export')")
    @Log(title = "出差记录", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Businesstrip businesstrip)
    {
        List<Businesstrip> list = businesstripService.selectBusinesstripList(businesstrip);
        ExcelUtil<Businesstrip> util = new ExcelUtil<Businesstrip>(Businesstrip.class);
        util.exportExcel(response, list, "出差记录数据");
    }

    /**
     * 获取出差记录详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:businesstrip:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(businesstripService.selectBusinesstripById(id));
    }

    /**
     * 新增出差记录
     */
    @PreAuthorize("@ss.hasPermi('system:businesstrip:add')")
    @Log(title = "出差记录", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Businesstrip businesstrip)
    {
        return toAjax(businesstripService.insertBusinesstrip(businesstrip));
    }

    /**
     * 修改出差记录
     */
    @PreAuthorize("@ss.hasPermi('system:businesstrip:edit')")
    @Log(title = "出差记录", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Businesstrip businesstrip)
    {
        return toAjax(businesstripService.updateBusinesstrip(businesstrip));
    }

    /**
     * 删除出差记录
     */
    @PreAuthorize("@ss.hasPermi('system:businesstrip:remove')")
    @Log(title = "出差记录", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(businesstripService.deleteBusinesstripByIds(ids));
    }
}
