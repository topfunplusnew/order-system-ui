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
import org.dzu.system.domain.TableEditMessage;
import org.dzu.system.service.ITableEditMessageService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 编辑原因Controller
 * 
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/tableEditMessage")
public class TableEditMessageController extends BaseController
{
    @Autowired
    private ITableEditMessageService tableEditMessageService;

    /**
     * 查询编辑原因列表
     */
    @PreAuthorize("@ss.hasPermi('system:tableeditmessage:list')")
    @GetMapping("/list")
    public TableDataInfo list(TableEditMessage tableEditMessage)
    {
        startPage();
        List<TableEditMessage> list = tableEditMessageService.selectTableEditMessageList(tableEditMessage);
        return getDataTable(list);
    }

    /**
     * 导出编辑原因列表
     */
    @PreAuthorize("@ss.hasPermi('system:tableeditmessage:export')")
    @Log(title = "编辑原因", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, TableEditMessage tableEditMessage)
    {
        List<TableEditMessage> list = tableEditMessageService.selectTableEditMessageList(tableEditMessage);
        ExcelUtil<TableEditMessage> util = new ExcelUtil<TableEditMessage>(TableEditMessage.class);
        util.exportExcel(response, list, "编辑原因数据");
    }

    /**
     * 获取编辑原因详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:tableeditmessage:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(tableEditMessageService.selectTableEditMessageById(id));
    }

    /**
     * 新增编辑原因
     */
    @PreAuthorize("@ss.hasPermi('system:tableeditmessage:add')")
    @Log(title = "编辑原因", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody TableEditMessage tableEditMessage)
    {
        return toAjax(tableEditMessageService.insertTableEditMessage(tableEditMessage));
    }

    /**
     * 修改编辑原因
     */
    @PreAuthorize("@ss.hasPermi('system:tableeditmessage:edit')")
    @Log(title = "编辑原因", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody TableEditMessage tableEditMessage)
    {
        return toAjax(tableEditMessageService.updateTableEditMessage(tableEditMessage));
    }

    /**
     * 删除编辑原因
     */
    @PreAuthorize("@ss.hasPermi('system:tableeditmessage:remove')")
    @Log(title = "编辑原因", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(tableEditMessageService.deleteTableEditMessageByIds(ids));
    }
}
