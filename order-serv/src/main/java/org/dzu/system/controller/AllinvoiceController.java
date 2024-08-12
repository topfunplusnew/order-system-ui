package org.dzu.system.controller;


import org.dzu.common.core.controller.BaseController;
import org.dzu.common.core.page.TableDataInfo;
import org.dzu.system.domain.AllInvoice;
import org.dzu.system.service.impl.AllinvoiceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 票点台账Controller
 *
 * @author ml
 * @date 2024-08-01
 */
@RestController
@RequestMapping("/system/allinvoice")
public class AllinvoiceController extends BaseController {

    @Autowired
    private AllinvoiceService allinvoiceService;

    /**
     * 查询票点台账总数居
     */
    @PreAuthorize("@ss.hasPermi('system:auditflow:list')")
    @GetMapping("/list")
    public TableDataInfo list(AllInvoice allInvoice)
    {
        startPage();
        List<AllInvoice> list = allinvoiceService.selectInvoices(allInvoice);
        return getDataTable(list);
    }


}
