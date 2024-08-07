package org.dzu.system.controller;

import org.dzu.common.annotation.Log;
import org.dzu.common.core.controller.BaseController;
import org.dzu.common.core.domain.AjaxResult;
import org.dzu.common.core.page.TableDataInfo;
import org.dzu.common.enums.BusinessType;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.system.domain.OilCard;
import org.dzu.system.service.IOilCardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 加油卡信息Controller
 * 
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/oilCard")
public class OilCardController extends BaseController
{
    @Autowired
    private IOilCardService oilCardService;

    /**
     * 查询加油卡信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:oilcard:list')")
    @GetMapping("/list")
    public TableDataInfo list(OilCard oilCard)
    {
        startPage();
        List<OilCard> list = oilCardService.selectOilCardList(oilCard);
        return getDataTable(list);
    }

    /**
     * 导出加油卡信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:oilcard:export')")
    @Log(title = "加油卡信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, OilCard oilCard)
    {
        List<OilCard> list = oilCardService.selectOilCardList(oilCard);
        ExcelUtil<OilCard> util = new ExcelUtil<OilCard>(OilCard.class);
        util.exportExcel(response, list, "加油卡信息数据");
    }

    /**
     * 获取加油卡信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:oilcard:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(oilCardService.selectOilCardById(id));
    }

    /**
     * 新增加油卡信息
     */
    @PreAuthorize("@ss.hasPermi('system:oilcard:add')")
    @Log(title = "加油卡信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody OilCard oilCard)
    {
        return toAjax(oilCardService.insertOilCard(oilCard));
    }

    /**
     * 修改加油卡信息
     */
    @PreAuthorize("@ss.hasPermi('system:oilcard:edit')")
    @Log(title = "加油卡信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody OilCard oilCard)
    {
        return toAjax(oilCardService.updateOilCard(oilCard));
    }

    /**
     * 删除加油卡信息
     */
    @PreAuthorize("@ss.hasPermi('system:oilcard:remove')")
    @Log(title = "加油卡信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(oilCardService.deleteOilCardByIds(ids));
    }
}
