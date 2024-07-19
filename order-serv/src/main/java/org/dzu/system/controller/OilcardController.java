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
import org.dzu.system.domain.Oilcard;
import org.dzu.system.service.IOilcardService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 加油卡Controller
 * 
 * @author ml
 * @date 2024-07-19
 */
@RestController
@RequestMapping("/system/oilcard")
public class OilcardController extends BaseController
{
    @Autowired
    private IOilcardService oilcardService;

    /**
     * 查询加油卡列表
     */
    @PreAuthorize("@ss.hasPermi('system:oilcard:list')")
    @GetMapping("/list")
    public TableDataInfo list(Oilcard oilcard)
    {
        startPage();
        List<Oilcard> list = oilcardService.selectOilcardList(oilcard);
        return getDataTable(list);
    }

    /**
     * 导出加油卡列表
     */
    @PreAuthorize("@ss.hasPermi('system:oilcard:export')")
    @Log(title = "加油卡", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Oilcard oilcard)
    {
        List<Oilcard> list = oilcardService.selectOilcardList(oilcard);
        ExcelUtil<Oilcard> util = new ExcelUtil<Oilcard>(Oilcard.class);
        util.exportExcel(response, list, "加油卡数据");
    }

    /**
     * 获取加油卡详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:oilcard:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(oilcardService.selectOilcardById(id));
    }

    /**
     * 新增加油卡
     */
    @PreAuthorize("@ss.hasPermi('system:oilcard:add')")
    @Log(title = "加油卡", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Oilcard oilcard)
    {
        return toAjax(oilcardService.insertOilcard(oilcard));
    }

    /**
     * 修改加油卡
     */
    @PreAuthorize("@ss.hasPermi('system:oilcard:edit')")
    @Log(title = "加油卡", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Oilcard oilcard)
    {
        return toAjax(oilcardService.updateOilcard(oilcard));
    }

    /**
     * 删除加油卡
     */
    @PreAuthorize("@ss.hasPermi('system:oilcard:remove')")
    @Log(title = "加油卡", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(oilcardService.deleteOilcardByIds(ids));
    }
}
