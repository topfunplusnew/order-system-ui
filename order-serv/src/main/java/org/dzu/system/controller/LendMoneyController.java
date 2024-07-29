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
import org.dzu.system.domain.LendMoney;
import org.dzu.system.service.ILendMoneyService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 向外部借出款信息Controller
 * 
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/lendMoney")
public class LendMoneyController extends BaseController
{
    @Autowired
    private ILendMoneyService lendMoneyService;

    /**
     * 查询向外部借出款信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:lendMoney:list')")
    @GetMapping("/list")
    public TableDataInfo list(LendMoney lendMoney)
    {
        startPage();
        List<LendMoney> list = lendMoneyService.selectLendMoneyList(lendMoney);
        return getDataTable(list);
    }

    /**
     * 导出向外部借出款信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:lendMoney:export')")
    @Log(title = "向外部借出款信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, LendMoney lendMoney)
    {
        List<LendMoney> list = lendMoneyService.selectLendMoneyList(lendMoney);
        ExcelUtil<LendMoney> util = new ExcelUtil<LendMoney>(LendMoney.class);
        util.exportExcel(response, list, "向外部借出款信息数据");
    }

    /**
     * 获取向外部借出款信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:lendMoney:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(lendMoneyService.selectLendMoneyById(id));
    }

    /**
     * 新增向外部借出款信息
     */
    @PreAuthorize("@ss.hasPermi('system:lendMoney:add')")
    @Log(title = "向外部借出款信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody LendMoney lendMoney)
    {
        return toAjax(lendMoneyService.insertLendMoney(lendMoney));
    }

    /**
     * 修改向外部借出款信息
     */
    @PreAuthorize("@ss.hasPermi('system:lendMoney:edit')")
    @Log(title = "向外部借出款信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody LendMoney lendMoney)
    {
        return toAjax(lendMoneyService.updateLendMoney(lendMoney));
    }

    /**
     * 删除向外部借出款信息
     */
    @PreAuthorize("@ss.hasPermi('system:lendMoney:remove')")
    @Log(title = "向外部借出款信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(lendMoneyService.deleteLendMoneyByIds(ids));
    }
}
