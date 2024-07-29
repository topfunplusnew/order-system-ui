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
import org.dzu.system.domain.OilCardFundTransfer;
import org.dzu.system.service.IOilCardFundTransferService;
import org.dzu.common.utils.poi.ExcelUtil;
import org.dzu.common.core.page.TableDataInfo;

/**
 * 加油卡圈存Controller
 * 
 * @author ml
 * @date 2024-07-29
 */
@RestController
@RequestMapping("/system/oilCardFundTransfer")
public class OilCardFundTransferController extends BaseController
{
    @Autowired
    private IOilCardFundTransferService oilCardFundTransferService;

    /**
     * 查询加油卡圈存列表
     */
    @PreAuthorize("@ss.hasPermi('system:oilCardFundTransfer:list')")
    @GetMapping("/list")
    public TableDataInfo list(OilCardFundTransfer oilCardFundTransfer)
    {
        startPage();
        List<OilCardFundTransfer> list = oilCardFundTransferService.selectOilCardFundTransferList(oilCardFundTransfer);
        return getDataTable(list);
    }

    /**
     * 导出加油卡圈存列表
     */
    @PreAuthorize("@ss.hasPermi('system:oilCardFundTransfer:export')")
    @Log(title = "加油卡圈存", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, OilCardFundTransfer oilCardFundTransfer)
    {
        List<OilCardFundTransfer> list = oilCardFundTransferService.selectOilCardFundTransferList(oilCardFundTransfer);
        ExcelUtil<OilCardFundTransfer> util = new ExcelUtil<OilCardFundTransfer>(OilCardFundTransfer.class);
        util.exportExcel(response, list, "加油卡圈存数据");
    }

    /**
     * 获取加油卡圈存详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:oilCardFundTransfer:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(oilCardFundTransferService.selectOilCardFundTransferById(id));
    }

    /**
     * 新增加油卡圈存
     */
    @PreAuthorize("@ss.hasPermi('system:oilCardFundTransfer:add')")
    @Log(title = "加油卡圈存", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody OilCardFundTransfer oilCardFundTransfer)
    {
        return toAjax(oilCardFundTransferService.insertOilCardFundTransfer(oilCardFundTransfer));
    }

    /**
     * 修改加油卡圈存
     */
    @PreAuthorize("@ss.hasPermi('system:oilCardFundTransfer:edit')")
    @Log(title = "加油卡圈存", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody OilCardFundTransfer oilCardFundTransfer)
    {
        return toAjax(oilCardFundTransferService.updateOilCardFundTransfer(oilCardFundTransfer));
    }

    /**
     * 删除加油卡圈存
     */
    @PreAuthorize("@ss.hasPermi('system:oilCardFundTransfer:remove')")
    @Log(title = "加油卡圈存", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(oilCardFundTransferService.deleteOilCardFundTransferByIds(ids));
    }
}
