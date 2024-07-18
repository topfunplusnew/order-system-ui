package org.dzu.system.controller;

import org.dzu.common.annotation.Log;
import org.dzu.common.core.controller.BaseController;
import org.dzu.common.core.domain.AjaxResult;
import org.dzu.common.core.page.TableDataInfo;
import org.dzu.common.enums.BusinessType;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.system.domain.Lendmoney;
import org.dzu.system.service.ILendmoneyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 借贷Controller
 * 
 * @author ml
 * @date 2024-07-18
 */
@RestController
@RequestMapping("/system/lendmoney")
public class LendmoneyController extends BaseController
{
    @Autowired
    private ILendmoneyService lendmoneyService;

    /**
     * 查询借贷列表
     */
    @PreAuthorize("@ss.hasPermi('system:lendmoney:list')")
    @GetMapping("/list")
    public TableDataInfo list(Lendmoney lendmoney)
    {
        startPage();
        List<Lendmoney> list = lendmoneyService.selectLendmoneyList(lendmoney);
        return getDataTable(list);
    }

    /**
     * 导出借贷列表
     */
    @PreAuthorize("@ss.hasPermi('system:lendmoney:export')")
    @Log(title = "借贷", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Lendmoney lendmoney)
    {
        List<Lendmoney> list = lendmoneyService.selectLendmoneyList(lendmoney);
        ExcelUtil<Lendmoney> util = new ExcelUtil<Lendmoney>(Lendmoney.class);
        util.exportExcel(response, list, "借贷数据");
    }

    /**
     * 获取借贷详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:lendmoney:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(lendmoneyService.selectLendmoneyById(id));
    }

    /**
     * 新增借贷
     */
    @PreAuthorize("@ss.hasPermi('system:lendmoney:add')")
    @Log(title = "借贷", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Lendmoney lendmoney)
    {
        return toAjax(lendmoneyService.insertLendmoney(lendmoney));
    }

    /**
     * 修改借贷
     */
    @PreAuthorize("@ss.hasPermi('system:lendmoney:edit')")
    @Log(title = "借贷", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Lendmoney lendmoney)
    {
        return toAjax(lendmoneyService.updateLendmoney(lendmoney));
    }

    /**
     * 删除借贷
     */
    @PreAuthorize("@ss.hasPermi('system:lendmoney:remove')")
    @Log(title = "借贷", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(lendmoneyService.deleteLendmoneyByIds(ids));
    }
}
