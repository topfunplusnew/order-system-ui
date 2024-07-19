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
import org.dzu.system.domain.Tableeditmessage;
import org.dzu.system.service.ITableeditmessageService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 变动日志信息Controller
 * 
 * @author ml
 * @date 2024-07-19
 */
@RestController
@RequestMapping("/system/tableeditmessage")
public class TableeditmessageController extends BaseController
{
    @Autowired
    private ITableeditmessageService tableeditmessageService;

    /**
     * 查询变动日志信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:tableeditmessage:list')")
    @GetMapping("/list")
    public TableDataInfo list(Tableeditmessage tableeditmessage)
    {
        startPage();
        List<Tableeditmessage> list = tableeditmessageService.selectTableeditmessageList(tableeditmessage);
        return getDataTable(list);
    }

    /**
     * 导出变动日志信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:tableeditmessage:export')")
    @Log(title = "变动日志信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Tableeditmessage tableeditmessage)
    {
        List<Tableeditmessage> list = tableeditmessageService.selectTableeditmessageList(tableeditmessage);
        ExcelUtil<Tableeditmessage> util = new ExcelUtil<Tableeditmessage>(Tableeditmessage.class);
        util.exportExcel(response, list, "变动日志信息数据");
    }

    /**
     * 获取变动日志信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:tableeditmessage:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(tableeditmessageService.selectTableeditmessageById(id));
    }

    /**
     * 新增变动日志信息
     */
    @PreAuthorize("@ss.hasPermi('system:tableeditmessage:add')")
    @Log(title = "变动日志信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Tableeditmessage tableeditmessage)
    {
        return toAjax(tableeditmessageService.insertTableeditmessage(tableeditmessage));
    }

    /**
     * 修改变动日志信息
     */
    @PreAuthorize("@ss.hasPermi('system:tableeditmessage:edit')")
    @Log(title = "变动日志信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Tableeditmessage tableeditmessage)
    {
        return toAjax(tableeditmessageService.updateTableeditmessage(tableeditmessage));
    }

    /**
     * 删除变动日志信息
     */
    @PreAuthorize("@ss.hasPermi('system:tableeditmessage:remove')")
    @Log(title = "变动日志信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(tableeditmessageService.deleteTableeditmessageByIds(ids));
    }
}
