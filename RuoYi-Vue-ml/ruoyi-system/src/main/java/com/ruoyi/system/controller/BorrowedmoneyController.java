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
import com.ruoyi.system.domain.Borrowedmoney;
import com.ruoyi.system.service.IBorrowedmoneyService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 借入金钱Controller
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
@RestController
@RequestMapping("/system/borrowedmoney")
public class BorrowedmoneyController extends BaseController
{
    @Autowired
    private IBorrowedmoneyService borrowedmoneyService;

    /**
     * 查询借入金钱列表
     */
    @PreAuthorize("@ss.hasPermi('system:borrowedmoney:list')")
    @GetMapping("/list")
    public TableDataInfo list(Borrowedmoney borrowedmoney)
    {
        startPage();
        List<Borrowedmoney> list = borrowedmoneyService.selectBorrowedmoneyList(borrowedmoney);
        return getDataTable(list);
    }

    /**
     * 导出借入金钱列表
     */
    @PreAuthorize("@ss.hasPermi('system:borrowedmoney:export')")
    @Log(title = "借入金钱", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Borrowedmoney borrowedmoney)
    {
        List<Borrowedmoney> list = borrowedmoneyService.selectBorrowedmoneyList(borrowedmoney);
        ExcelUtil<Borrowedmoney> util = new ExcelUtil<Borrowedmoney>(Borrowedmoney.class);
        util.exportExcel(response, list, "借入金钱数据");
    }

    /**
     * 获取借入金钱详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:borrowedmoney:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(borrowedmoneyService.selectBorrowedmoneyById(id));
    }

    /**
     * 新增借入金钱
     */
    @PreAuthorize("@ss.hasPermi('system:borrowedmoney:add')")
    @Log(title = "借入金钱", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Borrowedmoney borrowedmoney)
    {
        return toAjax(borrowedmoneyService.insertBorrowedmoney(borrowedmoney));
    }

    /**
     * 修改借入金钱
     */
    @PreAuthorize("@ss.hasPermi('system:borrowedmoney:edit')")
    @Log(title = "借入金钱", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Borrowedmoney borrowedmoney)
    {
        return toAjax(borrowedmoneyService.updateBorrowedmoney(borrowedmoney));
    }

    /**
     * 删除借入金钱
     */
    @PreAuthorize("@ss.hasPermi('system:borrowedmoney:remove')")
    @Log(title = "借入金钱", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(borrowedmoneyService.deleteBorrowedmoneyByIds(ids));
    }
}
