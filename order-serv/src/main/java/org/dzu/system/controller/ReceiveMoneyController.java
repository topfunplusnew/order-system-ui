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
import org.dzu.system.domain.ReceiveMoney;
import org.dzu.system.service.IReceiveMoneyService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 收款信息Controller
 * 
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/receiveMoney")
public class ReceiveMoneyController extends BaseController
{
    @Autowired
    private IReceiveMoneyService receiveMoneyService;

    /**
     * 查询收款信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:receiveMoney:list')")
    @GetMapping("/list")
    public TableDataInfo list(ReceiveMoney receiveMoney)
    {
        startPage();
        List<ReceiveMoney> list = receiveMoneyService.selectReceiveMoneyList(receiveMoney);
        return getDataTable(list);
    }

    /**
     * 导出收款信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:receiveMoney:export')")
    @Log(title = "收款信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, ReceiveMoney receiveMoney)
    {
        List<ReceiveMoney> list = receiveMoneyService.selectReceiveMoneyList(receiveMoney);
        ExcelUtil<ReceiveMoney> util = new ExcelUtil<ReceiveMoney>(ReceiveMoney.class);
        util.exportExcel(response, list, "收款信息数据");
    }

    /**
     * 获取收款信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:receiveMoney:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(receiveMoneyService.selectReceiveMoneyById(id));
    }

    /**
     * 根据UUID获取收款信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:receiveMoney:query')")
    @GetMapping(value = "/receiveNO/{uuid}")
    public AjaxResult getInfo(@PathVariable("uuid") String  uuid){
        return success(receiveMoneyService.selectReceiveMoneyByReceiveNO(uuid));
    }
    /**
     * 新增收款信息
     */
    @PreAuthorize("@ss.hasPermi('system:receiveMoney:add')")
    @Log(title = "收款信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody ReceiveMoney receiveMoney)
    {
        return toAjax(receiveMoneyService.insertReceiveMoney(receiveMoney));
    }

    /**
     * 修改收款信息
     */
    @PreAuthorize("@ss.hasPermi('system:receiveMoney:edit')")
    @Log(title = "收款信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody ReceiveMoney receiveMoney)
    {
        return toAjax(receiveMoneyService.updateReceiveMoney(receiveMoney));
    }

    /**
     * 删除收款信息
     */
    @PreAuthorize("@ss.hasPermi('system:receiveMoney:remove')")
    @Log(title = "收款信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(receiveMoneyService.deleteReceiveMoneyByIds(ids));
    }
}
