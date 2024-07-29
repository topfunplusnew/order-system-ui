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
import org.dzu.system.domain.OilCardConsume;
import org.dzu.system.service.IOilCardConsumeService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 加油卡消费信息Controller
 * 
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/OilCardConsume")
public class OilCardConsumeController extends BaseController
{
    @Autowired
    private IOilCardConsumeService oilCardConsumeService;

    /**
     * 查询加油卡消费信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:OilCardConsume:list')")
    @GetMapping("/list")
    public TableDataInfo list(OilCardConsume oilCardConsume)
    {
        startPage();
        List<OilCardConsume> list = oilCardConsumeService.selectOilCardConsumeList(oilCardConsume);
        return getDataTable(list);
    }

    /**
     * 导出加油卡消费信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:OilCardConsume:export')")
    @Log(title = "加油卡消费信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, OilCardConsume oilCardConsume)
    {
        List<OilCardConsume> list = oilCardConsumeService.selectOilCardConsumeList(oilCardConsume);
        ExcelUtil<OilCardConsume> util = new ExcelUtil<OilCardConsume>(OilCardConsume.class);
        util.exportExcel(response, list, "加油卡消费信息数据");
    }

    /**
     * 获取加油卡消费信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:OilCardConsume:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(oilCardConsumeService.selectOilCardConsumeById(id));
    }

    /**
     * 新增加油卡消费信息
     */
    @PreAuthorize("@ss.hasPermi('system:OilCardConsume:add')")
    @Log(title = "加油卡消费信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody OilCardConsume oilCardConsume)
    {
        return toAjax(oilCardConsumeService.insertOilCardConsume(oilCardConsume));
    }

    /**
     * 修改加油卡消费信息
     */
    @PreAuthorize("@ss.hasPermi('system:OilCardConsume:edit')")
    @Log(title = "加油卡消费信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody OilCardConsume oilCardConsume)
    {
        return toAjax(oilCardConsumeService.updateOilCardConsume(oilCardConsume));
    }

    /**
     * 删除加油卡消费信息
     */
    @PreAuthorize("@ss.hasPermi('system:OilCardConsume:remove')")
    @Log(title = "加油卡消费信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(oilCardConsumeService.deleteOilCardConsumeByIds(ids));
    }
}
