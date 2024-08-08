package org.dzu.system.mapper;


import org.apache.ibatis.annotations.Mapper;
import org.dzu.system.domain.AllInvoice;

import java.util.List;

/**
 * 票点总台账Mapper接口
 *
 * @author ml
 * @date 2024-08-01
 */
public interface AllInvoiceMapper {


    /**
     * 汇总三个票点表的数据，统一筛查
     * @param allInvoice
     * @return
     */
    public List<AllInvoice> selectInvoices(AllInvoice allInvoice);
}
