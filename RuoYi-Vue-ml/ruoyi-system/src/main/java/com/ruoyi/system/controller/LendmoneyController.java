package com.ruoyi.system.controller;

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
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.Lendmoney;
import com.ruoyi.system.service.ILendmoneyService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 借贷Controller
 * 
 * @author ruoyi
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
