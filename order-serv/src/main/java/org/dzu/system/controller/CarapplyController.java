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
import org.dzu.system.domain.Carapply;
import org.dzu.system.service.ICarapplyService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 车辆派出管理Controller
 * 
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/carapply")
public class CarapplyController extends BaseController
{
    @Autowired
    private ICarapplyService carapplyService;

    /**
     * 查询车辆派出管理列表
     */
    @PreAuthorize("@ss.hasPermi('system:carapply:list')")
    @GetMapping("/list")
    public TableDataInfo list(Carapply carapply)
    {
        startPage();
        List<Carapply> list = carapplyService.selectCarapplyList(carapply);
        return getDataTable(list);
    }

    /**
     * 导出车辆派出管理列表
     */
    @PreAuthorize("@ss.hasPermi('system:carapply:export')")
    @Log(title = "车辆派出管理", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Carapply carapply)
    {
        List<Carapply> list = carapplyService.selectCarapplyList(carapply);
        ExcelUtil<Carapply> util = new ExcelUtil<Carapply>(Carapply.class);
        util.exportExcel(response, list, "车辆派出管理数据");
    }

    /**
     * 获取车辆派出管理详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:carapply:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(carapplyService.selectCarapplyById(id));
    }

    /**
     * 新增车辆派出管理
     */
    @PreAuthorize("@ss.hasPermi('system:carapply:add')")
    @Log(title = "车辆派出管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody Carapply carapply)
    {
        return toAjax(carapplyService.insertCarapply(carapply));
    }

    /**
     * 修改车辆派出管理
     */
    @PreAuthorize("@ss.hasPermi('system:carapply:edit')")
    @Log(title = "车辆派出管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody Carapply carapply)
    {
        return toAjax(carapplyService.updateCarapply(carapply));
    }

    /**
     * 删除车辆派出管理
     */
    @PreAuthorize("@ss.hasPermi('system:carapply:remove')")
    @Log(title = "车辆派出管理", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(carapplyService.deleteCarapplyByIds(ids));
    }
}
