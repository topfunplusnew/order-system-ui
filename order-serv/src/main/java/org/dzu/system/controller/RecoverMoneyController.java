package org.dzu.system.controller;

import org.dzu.common.annotation.Log;
import org.dzu.common.core.controller.BaseController;
import org.dzu.common.core.domain.AjaxResult;
import org.dzu.common.core.page.TableDataInfo;
import org.dzu.common.enums.BusinessType;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.system.domain.RecoverMoney;
import org.dzu.system.service.IRecoverMoneyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 借出款收回信息Controller
 *
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/recoverMoney")
public class RecoverMoneyController extends BaseController {
    @Autowired
    private IRecoverMoneyService recoverMoneyService;

    /**
     * 查询借出款收回信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:recovermoney:list')")
    @GetMapping("/list")
    public TableDataInfo list(RecoverMoney recoverMoney) {
        startPage();
        List<RecoverMoney> list = recoverMoneyService.selectRecoverMoneyList(recoverMoney);
        return getDataTable(list);
    }

    /**
     * 导出借出款收回信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:recovermoney:export')")
    @Log(title = "借出款收回信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, RecoverMoney recoverMoney) {
        List<RecoverMoney> list = recoverMoneyService.selectRecoverMoneyList(recoverMoney);
        ExcelUtil<RecoverMoney> util = new ExcelUtil<RecoverMoney>(RecoverMoney.class);
        util.exportExcel(response, list, "借出款收回信息数据");
    }

    /**
     * 获取借出款收回信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:recovermoney:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id) {
        return success(recoverMoneyService.selectRecoverMoneyById(id));
    }

    /**
     * 根据UUID获取借出款收回信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:recovermoney:query')")
    @GetMapping(value = "/futuresNO/{uuid}")
    public AjaxResult getInfoByUUID(@PathVariable("uuid") String uuid) {
        return success(recoverMoneyService.selectRecoverMoneyByFuturesNO(uuid));
    }

    /**
     * 新增借出款收回信息
     */
    @PreAuthorize("@ss.hasPermi('system:recovermoney:add')")
    @Log(title = "借出款收回信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody RecoverMoney recoverMoney) {
        return toAjax(recoverMoneyService.insertRecoverMoney(recoverMoney));
    }

    /**
     * 修改借出款收回信息
     */
    @PreAuthorize("@ss.hasPermi('system:recovermoney:edit')")
    @Log(title = "借出款收回信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody RecoverMoney recoverMoney) {
        return toAjax(recoverMoneyService.updateRecoverMoney(recoverMoney));
    }

    /**
     * 删除借出款收回信息
     */
    @PreAuthorize("@ss.hasPermi('system:recovermoney:remove')")
    @Log(title = "借出款收回信息", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids) {
        return toAjax(recoverMoneyService.deleteRecoverMoneyByIds(ids));
    }
}
