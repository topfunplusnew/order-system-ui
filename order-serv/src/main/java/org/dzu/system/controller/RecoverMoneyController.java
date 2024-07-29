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
import org.dzu.system.domain.RecoverMoney;
import org.dzu.system.service.IRecoverMoneyService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 借出款收回信息Controller
 * 
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/recoverMoney")
public class RecoverMoneyController extends BaseController
{
    @Autowired
    private IRecoverMoneyService recoverMoneyService;

    /**
     * 查询借出款收回信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:recoverMoney:list')")
    @GetMapping("/list")
    public TableDataInfo list(RecoverMoney recoverMoney)
    {
        startPage();
        List<RecoverMoney> list = recoverMoneyService.selectRecoverMoneyList(recoverMoney);
        return getDataTable(list);
    }

    /**
     * 导出借出款收回信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:recoverMoney:export')")
    @Log(title = "借出款收回信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, RecoverMoney recoverMoney)
    {
        List<RecoverMoney> list = recoverMoneyService.selectRecoverMoneyList(recoverMoney);
        ExcelUtil<RecoverMoney> util = new ExcelUtil<RecoverMoney>(RecoverMoney.class);
        util.exportExcel(response, list, "借出款收回信息数据");
    }

    /**
     * 获取借出款收回信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:recoverMoney:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(recoverMoneyService.selectRecoverMoneyById(id));
    }

    /**
     * 新增借出款收回信息
     */
    @PreAuthorize("@ss.hasPermi('system:recoverMoney:add')")
    @Log(title = "借出款收回信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody RecoverMoney recoverMoney)
    {
        return toAjax(recoverMoneyService.insertRecoverMoney(recoverMoney));
    }

    /**
     * 修改借出款收回信息
     */
    @PreAuthorize("@ss.hasPermi('system:recoverMoney:edit')")
    @Log(title = "借出款收回信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody RecoverMoney recoverMoney)
    {
        return toAjax(recoverMoneyService.updateRecoverMoney(recoverMoney));
    }

    /**
     * 删除借出款收回信息
     */
    @PreAuthorize("@ss.hasPermi('system:recoverMoney:remove')")
    @Log(title = "借出款收回信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(recoverMoneyService.deleteRecoverMoneyByIds(ids));
    }
}
