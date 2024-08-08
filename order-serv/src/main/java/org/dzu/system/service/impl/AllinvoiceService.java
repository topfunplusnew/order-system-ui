package org.dzu.system.service.impl;


import org.dzu.system.domain.AllInvoice;
import org.dzu.system.mapper.AllInvoiceMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 统一票点台账Service业务层处理
 *
 * @author ml
 * @date 2024-08-08
 */
@Service
public class AllinvoiceService {

    @Autowired
    private AllInvoiceMapper allInvoiceMapper;

    public List<AllInvoice> selectInvoices(AllInvoice allInvoice) {
        return allInvoiceMapper.selectInvoices(allInvoice);
    }
}
