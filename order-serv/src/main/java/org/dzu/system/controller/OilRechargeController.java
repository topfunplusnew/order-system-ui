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
import org.dzu.system.domain.OilRecharge;
import org.dzu.system.service.IOilRechargeService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 加油卡充值信息Controller
 * 
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/oilRecharge")
public class OilRechargeController extends BaseController
{
    @Autowired
    private IOilRechargeService oilRechargeService;

    /**
     * 查询加油卡充值信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:oilRecharge:list')")
    @GetMapping("/list")
    public TableDataInfo list(OilRecharge oilRecharge)
    {
        startPage();
        List<OilRecharge> list = oilRechargeService.selectOilRechargeList(oilRecharge);
        return getDataTable(list);
    }

    /**
     * 导出加油卡充值信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:oilRecharge:export')")
    @Log(title = "加油卡充值信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, OilRecharge oilRecharge)
    {
        List<OilRecharge> list = oilRechargeService.selectOilRechargeList(oilRecharge);
        ExcelUtil<OilRecharge> util = new ExcelUtil<OilRecharge>(OilRecharge.class);
        util.exportExcel(response, list, "加油卡充值信息数据");
    }

    /**
     * 获取加油卡充值信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:oilRecharge:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(oilRechargeService.selectOilRechargeById(id));
    }

    /**
     * 新增加油卡充值信息
     */
    @PreAuthorize("@ss.hasPermi('system:oilRecharge:add')")
    @Log(title = "加油卡充值信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody OilRecharge oilRecharge)
    {
        return toAjax(oilRechargeService.insertOilRecharge(oilRecharge));
    }

    /**
     * 修改加油卡充值信息
     */
    @PreAuthorize("@ss.hasPermi('system:oilRecharge:edit')")
    @Log(title = "加油卡充值信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody OilRecharge oilRecharge)
    {
        return toAjax(oilRechargeService.updateOilRecharge(oilRecharge));
    }

    /**
     * 删除加油卡充值信息
     */
    @PreAuthorize("@ss.hasPermi('system:oilRecharge:remove')")
    @Log(title = "加油卡充值信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(oilRechargeService.deleteOilRechargeByIds(ids));
    }
}
