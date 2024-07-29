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
import org.dzu.system.domain.Oilcardmain;
import org.dzu.system.service.IOilcardmainService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 基础信息-加油卡主卡登记Controller
 * 
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/oilcardmain")
public class OilcardmainController extends BaseController
{
    @Autowired
    private IOilcardmainService oilcardmainService;

    /**
     * 查询基础信息-加油卡主卡登记列表
     */
    @PreAuthorize("@ss.hasPermi('system:oilcardmain:list')")
    @GetMapping("/list")
    public TableDataInfo list(Oilcardmain oilcardmain)
    {
        startPage();
        List<Oilcardmain> list = oilcardmainService.selectOilcardmainList(oilcardmain);
        return getDataTable(list);
    }

    /**
     * 导出基础信息-加油卡主卡登记列表
     */
    @PreAuthorize("@ss.hasPermi('system:oilcardmain:export')")
    @Log(title = "基础信息-加油卡主卡登记", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Oilcardmain oilcardmain)
    {
        List<Oilcardmain> list = oilcardmainService.selectOilcardmainList(oilcardmain);
        ExcelUtil<Oilcardmain> util = new ExcelUtil<Oilcardmain>(Oilcardmain.class);
        util.exportExcel(response, list, "基础信息-加油卡主卡登记数据");
    }

    /**
     * 获取基础信息-加油卡主卡登记详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:oilcardmain:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(oilcardmainService.selectOilcardmainById(id));
    }

    /**
     * 新增基础信息-加油卡主卡登记
     */
    @PreAuthorize("@ss.hasPermi('system:oilcardmain:add')")
    @Log(title = "基础信息-加油卡主卡登记", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody Oilcardmain oilcardmain)
    {
        return toAjax(oilcardmainService.insertOilcardmain(oilcardmain));
    }

    /**
     * 修改基础信息-加油卡主卡登记
     */
    @PreAuthorize("@ss.hasPermi('system:oilcardmain:edit')")
    @Log(title = "基础信息-加油卡主卡登记", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody Oilcardmain oilcardmain)
    {
        return toAjax(oilcardmainService.updateOilcardmain(oilcardmain));
    }

    /**
     * 删除基础信息-加油卡主卡登记
     */
    @PreAuthorize("@ss.hasPermi('system:oilcardmain:remove')")
    @Log(title = "基础信息-加油卡主卡登记", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(oilcardmainService.deleteOilcardmainByIds(ids));
    }
}
